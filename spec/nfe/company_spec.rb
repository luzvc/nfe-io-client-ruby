require_relative '../rspec_helper'

describe Nfe::Company do
  before(:each) do
    Nfe.api_key('e12cmDevG5iLhSd9Y7BOpxynL86Detjd2R1D5jsP5UGXA8gwxug0Vojl3H9TIzBpbhI')
  end

  let(:company_params) do
    { id: "55df4dc6b6cd9007e4f13ee8", federaltaxnumber: "25953366000106", name: "Empresa de Teste"}
  end

  it 'should create a Company' do
    company_params = {
      company: {
        name: "Empresa de Teste",
        tradeName: "Teste co.",
        federalTaxNumber: 54458287000127,
        taxRegime: "SimplesNacional",
        address: {
          state: "RJ",
          city: {
            code: "3304557",
            name: "Rio de Janeiro"
          },
          district: "Botafogo",
          additionalInformation: "17o andar",
          street: "Rua Sao Clemente",
          number: "155",
          postalCode: "22260-003",
          country: "Brasil"
        }
      }
    }

    VCR.use_cassette("company/create") do
      company = Nfe::Company.create(company_params)

      expect(company.name).to eq('Empresa de Teste')
      expect(company.federalTaxNumber).to eq(54458287000127)
      expect(company.taxRegime).to eq('SimplesNacional')
    end
  end

  it 'should list all active companies' do
    VCR.use_cassette("company/list_all") do
      company_list = Nfe::Company.list_all
      expect(company_list.object).to eq('list')
      expect(company_list.data.size).to be >= 1
    end
  end

  it 'should retrieve a company by id' do
    VCR.use_cassette("company/retrieve_by_id") do
      company = Nfe::Company.retrieve(company_params[:id])
      expect(company.id).to eq(company_params[:id])
      expect(company.name).to eq(company_params[:name])
    end
  end

  it 'should delete a company' do
    skip "Recurso não está sendo deletado na API"
    company_params = {name: 'Company Teste',
                      federaltaxnumber: 32657522000157,
                      email: 'empresa@teste.com.br',
                      openningdate: '21/02/2005',
                      taxregime: 'LucroReal',
                      legalnature: 'EmpresaPublica',
                      municipaltaxnumber: 2}
    response = {"companies"=>{"id"=>"55e9a4cf440c3b0b84ceace6", "name"=>"Company Teste", "federalTaxNumber"=>32657522000157,
                              "email"=>"empresa@teste.com.br", "taxRegime"=>"LucroReal", "legalNature"=>"EmpresaPublica",
                              "economicActivities"=>[], "municipalTaxNumber"=>2, "rpsSerialNumber"=>"IO", "rpsNumber"=>0,
                              "environment"=>"Development", "fiscalStatus"=>"Pending", "certificate"=>{"status"=>"Pending"},
                              "createdOn"=>"2015-09-03T19:43:05.3772349+00:00", "modifiedOn"=>"2015-09-03T19:43:05.3772349+00:00"}}
    allow(Nfe::Company).to receive(:api_request).and_return(response)
    company = Nfe::Company.create(company_params)
    deleted_company = company.delete('55e9a4cf440c3b0b84ceace6')
    expect(deleted_company).to eq('teste')
  end

  it 'should update a company' do
    skip "Recurso retorna 0 para atributos (taxRegime e legalNature)"
    company = Nfe::Company.retrieve(company_params[:id])
    company.name = "New Company Name"
    company.save
    company_updated = Nfe::Company.retrieve(company_params[:id])
    expect(company.name).to eq(company_updated.name)
    expect(company.name).to eq("New Company Name")
    expect(company_updated.name).to eq("New Company Name")
  end

  it 'should set digital certificate to a company' do
    skip "To be implemented"
  end
end
