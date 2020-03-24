<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress-admin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', '0.0.0.0:2000' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '-*roj1GP]a&s4NBYg~|N1!>:T(|hVRjb$m0K^Dq!{i@>?OQuFAqTSp2 |]wd`C`|');
define('SECURE_AUTH_KEY',  '(dW#3KW$/+KKWW@/u C%.Ma4w6OjftV1Mq9>R?S(@}M7ewGS`;b|]r`{?o~:tsyG');
define('LOGGED_IN_KEY',    '/%)cm^fr>[H84#U_ &aF*Uf|,X!5U1iRRHrgT7G[?2f88my|RSNq2!8M*TZR1<K,');
define('NONCE_KEY',        'S|cI=%W0(;oC)lNYI?! f1iFrRk@vl|u_~FjcZJrk$9=rz|J/6}SyF!$OS:5mfHl');
define('AUTH_SALT',        '{i?3&RCsE<$&S+*c1)ikS@6FOR4%E;Q%-.x3J(!twiN|[:V{|dn#rcIWtq73HFaR');
define('SECURE_AUTH_SALT', 'BD9iTz`%TJf=[_=O(L]y>RWxm[?h^z7GDOl+4>3>n5UIY}D2sSz)>]*6:jWqK&%u');
define('LOGGED_IN_SALT',   'i^e+?+br5EB|JwphED/]~=K@BK+u@jBz9YzI&J<!a]`|.GJEy,^Sft XKg+2Uu=R');
define('NONCE_SALT',       'u(2=Wag3x(+W628vO2P6EC`vu35(jmmUQ|Nz|aDG2eV:kJ0[DIRQqx$p>YswzBe!');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );

define('FS_METHOD', 'direct');