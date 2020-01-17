//
//  TestVerify.m
//  ANXOpenSSLTest
//
//  Created by Max Rozdobudko on 17.01.2020.
//

#import "TestVerify.h"

@implementation TestVerify

+ (void)test_ane {
    const char cert[] = "-----BEGIN CERTIFICATE-----" "\n"
    "MIIEpjCCAo6gAwIBAgIILWICwQ33zowwDQYJKoZIhvcNAQELBQAwKDESMBAGA1UE" "\n"
    "ChMJQUNNRSBJbmMuMRIwEAYDVQQDEwlBQ01FIEluYy4wHhcNMTkxMjA1MDgwOTAw" "\n"
    "WhcNMjQxMjA1MDgwOTAwWjB3MRIwEAYDVQQKEwlBQ01FIEluYy4xEDAOBgNVBAMT" "\n"
    "B1NlcnZlcjExGTAXBggrBgEEAeA5ARMLMTkyLjE2OC40LjExNDAyBggrBgEEAeA6" "\n"
    "ARMmMjAwMTpkYjg6MTAwMDoxMDAwOmIyNGU6MjZmZjpmZTRlOjEyMDUwggEiMA0G" "\n"
    "CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDKuo/6lh5AsemGAnVNV0jZBbs6b6RZ" "\n"
    "8eXUVLQiRqbekmknFnyHMwk3rH+r7Bf2YljAskUTtEa8r8xlIrQP4xnXM2fsiAwJ" "\n"
    "afJZtnCx05shyQk5CIZqcaGJPUD7iDIJD3Qw9prKxxEK6IVUiMGMB4oDNr0zB4Fs" "\n"
    "FGOis/7K28FoiIuph+NXTmRj+kW4cJbA6n8RuMMmz/B9+FDd8CZlE92BcRCIOeSW" "\n"
    "PNKwpFHNgTE4ylUdHsBuxa/F9rNpqu4NU8ylYnpZaOZG1C9iG+lL7YKFm45tUwoS" "\n"
    "ey40LF2NTU1n/RTUyh+vADJjZN7D4z2v2CR0BVQVNYtSCxrZTHHcw3fPAgMBAAGj" "\n"
    "gYQwgYEwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUeGxvo0hRdo1RQPRRceKv0G4A" "\n"
    "8Z4wCwYDVR0PBAQDAgM4MBIGA1UdEQQLMAmCB1NlcnZlcjEwEQYJYIZIAYb4QgEB" "\n"
    "BAQDAgZAMB4GCWCGSAGG+EIBDQQRFg94Y2EgY2VydGlmaWNhdGUwDQYJKoZIhvcN" "\n"
    "AQELBQADggIBAF5wRrNlfJMd2eWcq4NFl0uEZsZnilvOrY3geSjT2f4WXFdnr/9w" "\n"
    "YMmAjApJL+LugIbcErvrjgwmCIRjCnuI47zkoFjQQAy51z2IBM+3ru8qT9hDLDdG" "\n"
    "+nNx3r3r3PUxupfouJRoJd9xgfQgq+ptEWmwOM4YXoayX0HSi+UNVEd+3r3kU2IS" "\n"
    "nwTRs0IRexk5u+8j56Gh/q1qQIcP+sdTfnALcphWRjafOvHFSQKYzZIo+lUaTW3Y" "\n"
    "OYRuijvfpF9BU7Ew+PfvGaJIVzc9JAWs/GC96MOSmo8DMGxAm+kRmjfse6rDVyT/" "\n"
    "6j8pj/hN0HqIVazOUmL1TXRynSgmQKAHE46TRKAneRo/mYAnN8A/uhdQS6YOOvYC" "\n"
    "6XdaeLGLbLPfmF2zJfdEYMcWOedVGqSiUYs7QdnWDZrTqe8/MgfP+zjm/k5BYqLV" "\n"
    "5vQ8tMXsLXbvOTJ6Sdv3lTJIZDMnBEk8C/YlZyhRZRli2PKXBnXTe32aGJm6avR7" "\n"
    "DOgcQcmYwUr9rvs5f0l0s3UxD61izFMcvn/sfcjKAvPcTyCRqlMzqMtqxQSYzjFU" "\n"
    "6Czf568PgkiqwhufpYtJQpQMuQrAeX95j6hzf49o9srzyMN/fXwVptYWHB4450bK" "\n"
    "boSi/fa7MRjhwij7LhKOm2qjFPruSwYNnVoXo50QCNlV87Jfyykyesuw" "\n"
    "-----END CERTIFICATE-----";

    const char fake_cert[] = "-----BEGIN CERTIFICATE-----" "\n"
    "MIIErjCCApagAwIBAgIIGvGaY1g9kHAwDQYJKoZIhvcNAQELBQAwMDESMBAGA1UE" "\n"
    "ChMJQUNNRSBJbmMuMRowGAYDVQQDExFGQUtFIEFDTUUgSW5jLiBDQTAeFw0xOTEy" "\n"
    "MDUwODI1MDBaFw0yNDEyMDUwODI1MDBaMHcxEjAQBgNVBAoTCUFDTUUgSW5jLjEQ" "\n"
    "MA4GA1UEAxMHU2VydmVyMTEZMBcGCCsGAQQB4DkBEwsxOTIuMTY4LjQuMTE0MDIG" "\n"
    "CCsGAQQB4DoBEyYyMDAxOmRiODoxMDAwOjEwMDA6YjI0ZToyNmZmOmZlNGU6MTIw" "\n"
    "NTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALWfiSQaHDIU2C7u2/aN" "\n"
    "mnqt3IKCkvWQ2nbVvroUE2cClY2QUu4QTzSMVUQGryutrtULf5W3lE9L3OjRtQzX" "\n"
    "NFCo0ikjKi+CagU7S+h/n5s4FiyWrpC+ZkUt0vkjbXpHqoTl4zcKpuTcx1Q1Z/DZ" "\n"
    "0+kgK1W41a3hlkjT/1mlNgtv883ACEDV+RYG/7qwj1UxprA1naTKgDNIVak8gAcH" "\n"
    "5VzHIyX4FGzzsJViOnA8g60FNF9iWC2uM+aGHy8eQSYLtXO4tlhlsGs71h9VIO/v" "\n"
    "8dxFPDZMQXWImCmuEAUDNNY3IU9whL2aBVISJEc4+BmpBbB3k1PNjAm4UehhLjXo" "\n"
    "U2ECAwEAAaOBhDCBgTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQiAoGQY59x6nnu" "\n"
    "wH2JP/Bdr1DPGTALBgNVHQ8EBAMCAzgwEgYDVR0RBAswCYIHU2VydmVyMTARBglg" "\n"
    "hkgBhvhCAQEEBAMCBkAwHgYJYIZIAYb4QgENBBEWD3hjYSBjZXJ0aWZpY2F0ZTAN" "\n"
    "BgkqhkiG9w0BAQsFAAOCAgEALyenuXfk7MIDkLX/vANAu+JoHy9mmn7BJOq+K6sq" "\n"
    "sxuMepaWhkYoEjxgpK1Of3nuhmsX5FsE2e/V1nCf6uLACFbdweHnpO7wjzEG4KOP" "\n"
    "OIyGZopVnSqLagCkAucZvLN9AFYxL3kjr7eeYX5pehBoFIAnSeos/YhvrVAN0Q1B" "\n"
    "UKdL3GWE2r+mnB91487DKA/nkKDCspzFwxsRfRoQnIrX3J72R7JN+DAAGB6vQh7m" "\n"
    "ELQnrWaBoE/aKjjg6YaW2H73oSLBZMZInCjXmNKAXXfwk4QjAeufSULpzdNdUWUs" "\n"
    "LDLfOkmVdhv+B/O4PKK+TurCQAhM3HGsLsupXXvd2ws3GAnky7M6Ih3RPc2OgVJ7" "\n"
    "4O5FK+ubTwDJTSzjLnbCw2VjHTBx9yqJfrdcvplVXZMk/YZXw0i2glqDCfaPtYmq" "\n"
    "P2inlWWc5OUq2VqDOR9vWm2OcNzrfIx6mWEEv2eLgAanXE8L48Rv4o1z78EjlzJO" "\n"
    "ywHxY42EqHqstp2Dlp8NjYQolHb8Ulka8I4gYWX12OjaL6CTGdaSxzbygvcFmtJ6" "\n"
    "PrkBFRZcdMkksl0rHwPCsOvBcjnV/8gY35XUC67WVvwo8b7+CM5Cvdk2qthNpkQ8" "\n"
    "ZhxQMs1ijGi+z8ECWEzeRGYk/OpZSXfUd7BgNO4TSdSwXwHpIoERt62v0JlUyxKh" "\n"
    "A94=" "\n"
    "-----END CERTIFICATE-----";

    const char intermediate[] = "-----BEGIN CERTIFICATE-----" "\n"
    "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" "\n"
    "MtCnKf0DZ4M=" "\n"
    "-----END CERTIFICATE-----";

    NSLog(@"valid = %i", [ANXOpenSSL.sharedInstance verifyCertificate:fake_cert withCertificateAuthorityCertificate:intermediate]);
}

@end
