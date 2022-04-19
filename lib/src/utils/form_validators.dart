String? Function(String?) hasTextValidator(value) => (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    };
