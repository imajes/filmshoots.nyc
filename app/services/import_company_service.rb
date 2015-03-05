class ImportCompanyService

  attr_reader :company

  def initialize(name)
    @company = Company.where(common_name: common_name(name)).first_or_create!
    @company.name = name if company.name.blank?
    @company.original_names = name
    @company.save
  end

  def common_name(name)
    name = name.downcase.strip

    # remove chars we don't need/care for
    name.gsub!(/[^a-z0-9_'\ ]/, ' ')

    # rename common shortcuts to expanded versions
    map = {
      'bros' => 'brothers',
      'tv'   => 'television',
    }
    map.each_pair { |from, to| name.gsub!(/(^| )#{from}( |$)/, " #{to} ") }

    #normalize name
    rejected_terms = [
      /production(s?)/,
      /corp|corporation/,
      /co|company/,
      /inc|incorporated/,
      'the',
      'llc',
      'ltd'
    ]

    rejected_terms.each { |term| name.gsub!(kill_word(term), ' ') }

    # trim excess whitespace
    name.gsub(/\s+/, ' ').strip
  end

  def kill_word(w)
    /((^| )#{w}( |$))/
  end

end
