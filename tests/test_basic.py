"""
Testes para a aplicação OrsaCusto.

Os testes serão expandidos conforme as funcionalidades forem implementadas.
"""

import unittest
import sys
import os

# Adiciona o diretório src ao path para importações
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))


class TestOrsaCusto(unittest.TestCase):
    """Testes básicos para verificar a estrutura do projeto."""

    def test_import_main(self):
        """Testa se o módulo principal pode ser importado."""
        try:
            import main
            self.assertTrue(hasattr(main, 'main'))
        except ImportError:
            self.fail("Não foi possível importar o módulo main")

    def test_version(self):
        """Testa se a versão está definida."""
        import __init__ as orsacusto
        self.assertTrue(hasattr(orsacusto, '__version__'))
        self.assertIsInstance(orsacusto.__version__, str)


if __name__ == '__main__':
    unittest.main()
