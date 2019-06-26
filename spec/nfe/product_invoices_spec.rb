require_relative "../rspec_helper"

describe Nfe::ProductInvoice do
  before(:each) do
    Nfe.api_key("e12cmDevG5iLhSd9Y7BOpxynL86Detjd2R1D5jsP5UGXA8gwxug0Vojl3H9TIzBpbhI")
    # Nfe.api_key("KmIHYECkaOBITaMDDepx92KhBOqeG0zh9z9SUE5DPPBhN0iFeVdiNl16kr7RpXvYdIy")

    Nfe::ProductInvoice.company_id("5c98f9b312708e0eccc14c0a")
    # Nfe::ProductInvoice.company_id("09993376e0ee451482d94fbafbac33ed")

  end

  # it "should create a ProductInvoice" do
  #   customer_params = {
  #     consumerType: "finalConsumer",
  #     presenceType: "internet",
  #     buyer: {
  #       federalTaxNumber: 1946377198,
  #       name: "Ricardo Caldeira",
  #       email: "ricardo.nezz@mailinator.com",
  #       address: {
  #         phone: "11987654321",
  #         postalCode: "44850000",
  #         street: "Rua Do Cliente",
  #         number: "1310",
  #         additionalInformation: "AP 202",
  #         district: "Centro",
  #         city: {
  #           code: "3304557",
  #           name: "Rio de Janeiro"
  #         },
  #         state: "RJ"
  #       },
  #       type: "customer",
  #       stateTaxNumberIndicator: "nonTaxPayer"
  #     }
  #   }
  #
  #   product_params = {
  #     items: [
  #       {
  #         code: "123",
  #         description: "Produto de Teste",
  #         ncm: "00000000",
  #         cfop: 5101,
  #         unit: "UN",
  #         codeGTIN: "SEM GTIN",
  #         CodeTaxGTIN: "SEM GTIN",
  #         quantity: 1.0,
  #         unitAmount: 120.00,
  #         discountAmount: 20.00,
  #         cest: "0000000",
  #         tax: {
  #           totalTax: 0,
  #           icms: {
  #             origin: "0",
  #             csosn: "102"
  #           },
  #           pis: {
  #             cst: "01"
  #           },
  #           cofins: {
  #             cst: "01"
  #           }
  #         }
  #       }
  #     ]
  #   }
  #
  #   VCR.use_cassette("product_invoice/create") do
  #     invoice_params = customer_params.merge(product_params)
  #
  #     nfe = Nfe::ProductInvoice.create(invoice_params)
  #
  #     expect(nfe["buyer"]["name"]).to eq("Ricardo Caldeira")
  #     expect(nfe["buyer"]["email"]).to eq("ricardo.nezz@mailinator.com")
  #     expect(nfe["buyer"]["federalTaxNumber"]).to eq(1946377198)
  #     expect(nfe["id"]).to eq("75e916d92a3c4f01add57c06d12a0683")
  #   end
  # end

  it "should list all product invoices" do
    skip "List not implemented on server side"
    # VCR.use_cassette("product_invoice/list_all") do
    #   product_invoices_list = Nfe::ProductInvoice.list_all
    #   expect(product_invoices_list["totalResults"]).to be >= 1
    #   expect(product_invoices_list["serviceInvoices"].size).to be >= 1
    # end
  end

  it "should list product invoices by page" do
    skip "List not implemented on server side"
    # VCR.use_cassette("product_invoice/list_all_pagination") do
    #   product_invoices_list = Nfe::ProductInvoice.list_all(pageCount: 5, pageIndex: 2)
    #   expect(product_invoices_list["totalResults"]).to be >= 1
    #   expect(product_invoices_list["totalPages"]).to be >= 1
    #   expect(product_invoices_list["page"]).to eq(2)
    #   expect(product_invoices_list["serviceInvoices"].size).to be >= 1
    # end
  end

  # it "should retrieve a ProductInvoice" do
  #   VCR.use_cassette("product_invoice/retrieve") do
  #     product_invoice = Nfe::ProductInvoice.retrieve("9c2309920d4242d08284fd28fc0d384c")
  #     expect(product_invoice["id"]).to eq("9c2309920d4242d08284fd28fc0d384c")
  #     expect(product_invoice["status"]).to eq("Issued")
  #     expect(product_invoice["operationType"]).to eq("Outgoing")
  #     expect(product_invoice["environmentType"]).to eq("Test")
  #   end
  # end

  # it "should cancel a ProductInvoice" do
  #   VCR.use_cassette("product_invoice/cancel") do
  #     product_invoices_list = Nfe::ProductInvoice.list_all
  #     product_invoice = product_invoices_list["serviceInvoices"].first
  #     response = Nfe::ProductInvoice.cancel(product_invoice["id"])
  #     expect(response["id"]).to eq(product_invoice["id"])
  #     expect(response["flowStatus"]).to eq("WaitingSendCancel")
  #   end
  # end

  # it "should send a email to Tomador" do
  #   skip "To be implemented"
  # end

  it "should retrieve a URI to ProductInvoice XML file" do
    VCR.use_cassette("product_invoice/xml_file") do
      response = Nfe::ProductInvoice.download("9c2309920d4242d08284fd28fc0d384c", :xml)

      expect(response).to be_a Hash
      expect(response["uri"]).to match(/https:\/\/nfeprodproductinvoice\.blob\.core\.windows\.net\/.*\.xml\?.*/i)
    end
  end

  it "should retrieve a ProductInvoice PDF file" do
    VCR.use_cassette("product_invoice/pdf_file") do
      response = Nfe::ProductInvoice.download("9c2309920d4242d08284fd28fc0d384c", :pdf)

      expect(response).to be_a Hash
      expect(response["uri"]).to match(/https:\/\/nfeprodproductinvoice\.blob\.core\.windows\.net\/.*\.pdf\?.*/i)
    end
  end

  # it "should not retrieve a ProductInvoice PDF file when API Key is not valid" do
  #   VCR.use_cassette("product_invoice/pdf_file_invalid_api_key") do
  #     product_invoices_list = Nfe::ProductInvoice.list_all
  #     product_invoice_params = product_invoices_list["serviceInvoices"].first
  #
  #     Nfe.api_key("not_valid_api_keycont")
  #     expect {
  #       Nfe::ProductInvoice.download(product_invoice_params["id"], :pdf)
  #     }.to raise_error(Nfe::NfeError)
  #   end
  # end

  # it "should not retrieve a ProductInvoice XML file when API Key is not valid" do
  #   VCR.use_cassette("product_invoice/xml_file_invalid_api_key") do
  #     product_invoices_list = Nfe::ProductInvoice.list_all
  #     product_invoice_params = product_invoices_list["serviceInvoices"].first
  #
  #     Nfe.api_key("not_valid_api_keycont")
  #     expect {
  #       Nfe::ProductInvoice.download(product_invoice_params["id"], :xml)
  #     }.to raise_error(Nfe::NfeError)
  #   end
  # end

  # it "should retrieve ProductInvoices from Prefeitura" do
  #   skip "To be implemented"
  # end
end
