/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */

import globals from 'globals';
import jest from 'eslint-plugin-jest';
import pluginJs from '@eslint/js';
import tseslint from 'typescript-eslint';
import tsParser from '@typescript-eslint/parser';

/** @type { import('eslint').Linter.FlatConfig[] } */
export default [
  ...tseslint.configs.recommendedTypeChecked,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    files: [
      '**/*.{js,mjs,cjs,ts}',
    ],
    ignores: [
      '**/.angular/',
      '**/dist/',
      '**/node_modules/',
    ],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaFeatures: { modules: true },
        ecmaVersion: 'latest',
        project: './tsconfig.json',
      },
    },
    rules: {},
    name: `[ESlint]: TypeScript and project's files`,
  },
  {
    files: [
      '**/*.js',
    ],
    ...tseslint.configs.disableTypeChecked,
    name: '[ESlint]: JavaScript',
  },
  {
    ...jest.configs['flat/recommended'],
    files: [
      '**/*.spec.ts',
    ],
    rules: {
      ...jest.configs['flat/recommended'].rules,
    },
    languageOptions: {
      globals: jest.environments.globals.globals, // FIXME: da fuk?
    },
    name: '[ESlint]: Jest',
  },
  {
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.browser,
      }
    },
    name: '[ESlint]: Globals',
  },
  pluginJs.configs.recommended,
];
