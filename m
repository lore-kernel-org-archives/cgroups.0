From: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>
Subject: ps stuck on cmdline reading
Date: Wed, 21 Jan 2015 10:58:08 +0100
Message-ID: <20150121095808.GA18656@gandi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I am sometines triggering an issue on a v3.14.x (v3.14.18 here) where
the `ps auxwwf` is stuck.
The setup is several containers which own several process and with
memory limit on each cgroup.
A strace reveals the `ps` command is stuck on a read of a cmdline
file. The concerned process itself is on a non-interruptible IO state.
The ps command is executed in the global cgroup.

I also had a similar issue on a 3.10.x some months ago where ps was
stuck; the reason was the memory limit of the cgroup was reached and I
only had to add some pages available to the conatiner in order to
unlock the ps command.
But in my case the cgroups which own the pid has still lots of memory
available and I did not found a way to unlock the process.

I don't know how to reproduce the issue but I am sometimes triggering
it.

Does someone has some hint? How can I get more debug info about it?

Thanks,
--=20
William

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlS/eDAACgkQ1I6eqOUidQHB9QCghFdug/nSzM7n7SctzT8fFCr5
e34An3ABD+HX1r98bNLblYPOkbEEjqee
=0lQp
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
