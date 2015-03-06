class ImportCompanyService

  attr_reader :company, :proposed_name

  def initialize(name)
    @proposed_name = name
  end

  def process!
    company.name = @proposed_name if company.name.blank?
    company.original_names = @proposed_name
    company.save
  end

  def company
    @company ||=
      Company.where(common_name: common_name(@proposed_name)).first_or_initialize
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
