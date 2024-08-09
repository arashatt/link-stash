### authorization
>[!note] for serialization you can import serde with derive feature
>```toml
>serde = {version = "*", features = ["derive"]}
>```

as a matter of fact, it's not impportant what valuse you put in your Claims struct, as long as the backend logic of your program can map it the correct user.
```rust
//first you need to have a structure to hold your claims.
//claims should impl Json Serialization

#[derive(Debug, Serialization, Deserialization)]
struct Claims{
id: u32,
ati: usize,
exp: usize,
}
```
now use **encode** function inside jsonwebtoken crate to get a validated JWT token:
```rust
encode(&Header::default(), &my_claim, &EncodingKey::from_secret("secret code".as_ref()));
```
the output of this function is `Result<String>`, which is the encoded JWT you can send it to client.
then for decoding the JWT you need three arguments:
```rust
let token_message = decode::<Claims>(&token, &DecodingKey::from_secret("secret".as_ref()), &Validation::new(Algorithm::HS256));
```
the output of this function is Result of TokenData<T> over some generic T which implements[DeserializeOwned(https://docs.rs/serde/1.0.193/serde/de/trait.DeserializeOwned.html)
> DeserializedOwned can be Deserialized without borrowing any data from the deserialized
---

### Database
