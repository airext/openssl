/**
 * Created by max.rozdobudko@gmail.com on 24.02.2020.
 */
package com.github.airext.openssl.test.data {
public class Expectation {

    private var _input: Object;
    public function get input(): Object {
        return _input;
    }

    private var _expected: Object;
    public function get expected(): Object {
        return _expected;
    }

    public function Expectation(input: Object, expected: Object) {
        super();
        _input = input;
        _expected = expected;
    }
}
}
