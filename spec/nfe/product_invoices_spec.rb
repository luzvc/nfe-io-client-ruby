require_relative '../rspec_helper'

describe Nfe::ProductInvoice do
  before(:each) do
    Nfe.api_key('e12cmDevG5iLhSd9Y7BOpxynL86Detjd2R1D5jsP5UGXA8gwxug0Vojl3H9TIzBpbhI')
    Nfe::ProductInvoice.company_id("5c98f9b312708e0eccc14c0a")
  end

  it 'should create a ProductInvoice' do
    customer_params = {
      borrower: {
        federalTaxNumber: '01946377198',
        name: 'Ricardo Caldeira',
        email: 'ricardo.nezz@mailinator.com',
        address: {
          country: 'BRA',
          postalCode: '22231110',
          street: 'Rua Do Cliente',
          number: '1310',
          additionalInformation: 'AP 202',
          district: 'Centro',
          city: {
            code: 4204202,
            name: 'Chapecó'
          },
          state: 'SC'
        }
      }
    }

    VCR.use_cassette("product_invoice/create") do
      product_params = {}
      nfe = Nfe::ProductInvoice.create(customer_params.merge(product_params))

      expect(nfe["environment"]).to eq('Development')
      expect(nfe["borrower"]["name"]).to eq('Ricardo Caldeira')
    end
  end

  it 'should list all product invoices' do
    VCR.use_cassette("product_invoice/list_all") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      expect(product_invoices_list["totalResults"]).to be >= 1
      expect(product_invoices_list["serviceInvoices"].size).to be >= 1
    end
  end

  it 'should list product invoices by page' do
    VCR.use_cassette("product_invoice/list_all_pagination") do
      product_invoices_list = Nfe::ProductInvoice.list_all(pageCount: 5, pageIndex: 2)
      expect(product_invoices_list["totalResults"]).to be >= 1
      expect(product_invoices_list["totalPages"]).to be >= 1
      expect(product_invoices_list["page"]).to eq(2)
      expect(product_invoices_list["serviceInvoices"].size).to be >= 1
    end
  end

  it 'should retrieve a ProductInvoice' do
    VCR.use_cassette("product_invoice/retrieve") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice_params = product_invoices_list["serviceInvoices"].first
      product_invoice = Nfe::ProductInvoice.retrieve(product_invoice_params["id"])
      expect(product_invoice["id"]).to eq(product_invoice_params["id"])
      expect(product_invoice["rpsStatus"]).to eq("Normal")
    end
  end

  it 'should cancel a ProductInvoice' do
    VCR.use_cassette("product_invoice/cancel") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice = product_invoices_list["serviceInvoices"].first
      response = Nfe::ProductInvoice.cancel(product_invoice["id"])
      expect(response["id"]).to eq(product_invoice["id"])
      expect(response["flowStatus"]).to eq("WaitingSendCancel")
    end
  end

  it 'should send a email to Tomador' do
    skip "To be implemented"
  end

  it 'should retrieve a ProductInvoice XML file' do
    VCR.use_cassette("product_invoice/xml_file") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice_params = product_invoices_list["serviceInvoices"].first

      response = Nfe::ProductInvoice.download(product_invoice_params["id"], :xml)

      expect(response.headers[:content_type]).to eq("application/xml")
      expect(response.headers[:content_length].size).to be >= 1
      expect(response.size).to be >= 1
    end
  end

  it 'should retrieve a ProductInvoice PDF file' do
    VCR.use_cassette("product_invoice/pdf_file") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice_params = product_invoices_list["serviceInvoices"].first

      response = Nfe::ProductInvoice.download(product_invoice_params["id"], :pdf)

      expect(response.headers[:content_type]).to eq("application/pdf")
      expect(response.headers[:content_length].size).to be >= 1
      expect(response.size).to be >= 1
    end
  end

  it 'should not retrieve a ProductInvoice PDF file when API Key is not valid' do
    VCR.use_cassette("product_invoice/pdf_file_invalid_api_key") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice_params = product_invoices_list["serviceInvoices"].first

      Nfe.api_key('not_valid_api_keycont')
      expect {
        Nfe::ProductInvoice.download(product_invoice_params["id"], :pdf)
      }.to raise_error(Nfe::NfeError)
    end
  end

  it 'should not retrieve a ProductInvoice XML file when API Key is not valid' do
    VCR.use_cassette("product_invoice/xml_file_invalid_api_key") do
      product_invoices_list = Nfe::ProductInvoice.list_all
      product_invoice_params = product_invoices_list["serviceInvoices"].first

      Nfe.api_key('not_valid_api_keycont')
      expect {
        Nfe::ProductInvoice.download(product_invoice_params["id"], :xml)
      }.to raise_error(Nfe::NfeError)
    end
  end

  it 'should retrieve ProductInvoices from Prefeitura' do
    skip "To be implemented"
  end
end
