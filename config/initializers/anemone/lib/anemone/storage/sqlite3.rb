module Anemone
  module Storage
    # Override SQLite3 for alias_method.
    class SQLite3
      # rubocop:disable PredicateName, Style/StringLiterals
      def has_key?(url)
        !!@db.get_first_value('SELECT id FROM anemone_storage WHERE key = ?', url.to_s)
      end
      # rubocop:enable PredicateName
      alias_method :key?, :has_key?
    end
  end
end
