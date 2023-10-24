import 'dart:math';

void main() {
  // Generate RSA keys
  final rsaKeyPair = generateRSAKeyPair(2048); // You can adjust the key size

  // Message to be encrypted
  const plainText = 'Hello, RSA Encryption!';

  // Encrypt and decrypt the message
  final encryptedText = encryptRSA(plainText, rsaKeyPair.publicKey);
  final decryptedText = decryptRSA(encryptedText, rsaKeyPair.privateKey);

  print('Original text: $plainText');
  print('Encrypted text: $encryptedText');
  print('Decrypted text: $decryptedText');
}

class RSAKeyPair {
  final RSAPrivateKey privateKey;
  final RSAPublicKey publicKey;

  RSAKeyPair(this.privateKey, this.publicKey);
}

class RSAPublicKey {
  final BigInt modulus;
  final BigInt exponent;

  RSAPublicKey(this.modulus, this.exponent);
}

class RSAPrivateKey {
  final BigInt modulus;
  final BigInt privateExponent;

  RSAPrivateKey(this.modulus, this.privateExponent);
}

RSAKeyPair generateRSAKeyPair(int keySize) {
  final random = Random.secure();
  final p = generatePrime(keySize ~/ 2, random);
  final q = generatePrime(keySize ~/ 2, random);

  final modulus = p * q;
  final phi = (p - BigInt.one) * (q - BigInt.one);

  final publicExponent = BigInt.from(65537); // Common public exponent

  final privateExponent = calculatePrivateExponent(publicExponent, phi);

  final publicKey = RSAPublicKey(modulus, publicExponent);
  final privateKey = RSAPrivateKey(modulus, privateExponent);

  return RSAKeyPair(privateKey, publicKey);
}

BigInt generatePrime(int bits, Random random) {
  while (true) {
    final candidate = BigInt.from(random.nextInt(1 << (bits - 1)));
    if (candidate.isEven) {
      continue; // Skip even numbers
    }
    if (isProbablyPrime(candidate)) {
      return candidate;
    }
  }
}

bool isProbablyPrime(BigInt n) {
  if (n <= BigInt.one) {
    return false;
  }
  if (n <= BigInt.from(3)) {
    return true;
  }
  if (n.isEven) {
    return false;
  }

  const k = 5; // Number of tests, increase for higher confidence

  for (int i = 0; i < k; i++) {
    final a = BigInt.from(2 + Random.secure().nextInt(n.toInt() - 2));
    if (calculateModularExponentiation(a, n - BigInt.one, n) != BigInt.one) {
      return false; // Definitely composite
    }
  }

  return true; // Probably prime
}

BigInt calculateModularExponentiation(
    BigInt base, BigInt exponent, BigInt modulus) {
  BigInt result = BigInt.one;

  while (exponent > BigInt.zero) {
    if (exponent.isOdd) {
      result = (result * base) % modulus;
    }
    base = (base * base) % modulus;
    exponent >>= 1;
  }

  return result;
}

BigInt calculatePrivateExponent(BigInt publicExponent, BigInt phi) {
  return modularInverse(publicExponent, phi);
}

BigInt modularInverse(BigInt a, BigInt m) {
  if (m == BigInt.one) {
    return BigInt.zero;
  }

  BigInt m0 = m;
  BigInt x0 = BigInt.zero;
  BigInt x1 = BigInt.one;

  while (a > BigInt.one) {
    // q is the quotient
    BigInt q = a ~/ m;
    BigInt t = m;

    // m is the remainder
    m = a % m;
    a = t;
    t = x0;

    x0 = x1 - q * x0;
    x1 = t;
  }

  // Ensure x1 is positive
  if (x1 < BigInt.zero) {
    x1 += m0;
  }

  return x1;
}

String encryptRSA(String plainText, RSAPublicKey publicKey) {
  final modulus = publicKey.modulus;
  final exponent = publicKey.exponent;
  final message = BigInt.from(plainText.runes.first);

  final encryptedMessage =
      calculateModularExponentiation(message, exponent, modulus);
  return encryptedMessage.toString();
}

String decryptRSA(String encryptedText, RSAPrivateKey privateKey) {
  final modulus = privateKey.modulus;
  final privateExponent = privateKey.privateExponent;
  final encryptedMessage = BigInt.parse(encryptedText);

  final decryptedMessage = calculateModularExponentiation(
      encryptedMessage, privateExponent, modulus);
  return String.fromCharCode(decryptedMessage.toInt());
}
