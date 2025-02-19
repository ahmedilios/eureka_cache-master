# eureka_cache

Cache para aplicativos Flutter baseada no SQLite.

## Como utilizar?

### `pubspec.yaml`

```
dependencies:
  eureka_cache:
    git:
      url: ssh://git@gitlab.eurekalabs.com.br:2222/flutter/eureka_cache.git
```

**É necessário configurar acesso por SSH ao GitLab.**

### Código

Para utilizar as funções, basta instanciar um objeto `Cache`.

As funções de leitura e escrita são assíncronas.

``` dart
final cache = Cache();

final key = ...;
final value = ...;

// Remove todas as chaves.
await cache.clean();

// Adicionar uma chave na cache com o valor especificado.
await cache.set(key: key, value: value);

// Obter um valor da cache com a chave especificada.
await cache.get();

// Adicionar uma chave na cache com o valor especificado.
await cache.set(key: key, value: value);

// Obter um valor da cache com a chave especificada.
await cache.get();

// Remove a chave especificada e seu valor.
await cache.delete(key: key);
```
