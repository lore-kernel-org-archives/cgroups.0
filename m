From: Pavel Machek <pavel@ucw.cz>
Subject: -next-20190607 kernel: oopses on bootup or shutdown
Date: Tue, 11 Jun 2019 10:57:53 +0200
Message-ID: <20190611085753.GA12364@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

It failed to boot three times; now it booted but failed on shutdown.

Hardware is thinkpad X60 (32bit x86), and I'm copying oops by hand.

EIP: exit_creds+0x1a
Call Trace:
 __put_task_struct
 css_task_iter_end
 cgroup_pidlist_start
 cgroup_seqfile_start
 kernfs_seq_start
 seq_read
 ? kernfs_fop_write
 ...
 sys_read

Kernel panic - not syncing: Attempted to kill init

Any ideas?
							Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz/bREACgkQMOfwapXb+vJMyQCdETJGv9ZLT5dkhTw6BfKL+eoN
/8AAn3VDLp02ZpYszETZXN+9zkdE8pAB
=ay6w
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
