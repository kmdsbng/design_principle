# -*- encoding: utf-8 -*-

class CustomerBeforeRefactoring
  attr_reader :first_name, :last_name, :postal_code, :city, :address, :telephone, :mail_address, :telephone_not_preferred

  def initialize(first_name, last_name, postal_code, city, address, telephone, mail_address, telephone_not_preferred)
    @first_name              = first_name
    @last_name               = last_name
    @postal_code             = postal_code
    @city                    = city
    @address                 = address
    @telephone               = telephone
    @mail_address            = mail_address
    @telephone_not_preferred = telephone_not_preferred
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

class PersonName < Struct.new(:first_name, :last_name)
  def initialize(*args)
    super
    freeze
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Address < Struct.new(:postal_code, :city, :address)
  def initialize(*args)
    super
    freeze
  end
end

class ContactMethod < Struct.new(:telephone, :mail_address, :telephone_not_preferred)
  def initialize(*args)
    super
    freeze
  end
end

class Customer
  attr_reader :person_name, :address, :contact_method

  def initialize(person_name, address, contact_method)
    @person_name = person_name
    @address = address
    @contacct_method = contact_method
  end
end

def main
  customer = CustomerBeforeRefactoring.new(
    'John',
    'Smith',
    '001-0002',
    'Kyoto',
    'Pontocho 2-3-4',
    '070-000-0000',
    'dummy@example.com',
    true
  )
  puts customer.full_name

  new_customer = Customer.new(
    @person_name = PersonName.new('John', 'Smith'),
    @address = Address.new('001-0002', 'Kyoto', 'Pontocho 2-3-4'),
    @contacct_method = ContactMethod.new('070-000-0000', 'dummy@example.com', true)
  )
  puts new_customer.person_name.full_name


end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
  # {spec of the implementation}
end

# >> John Smith
# >> John Smith
