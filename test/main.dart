void main() {
  bool debug0() {
    bool debug = false;
    assert(debug = true);
    return debug;
  }

  print("debug: ${debug0()}");
}
