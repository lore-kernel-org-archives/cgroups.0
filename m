From: Ben Hutchings <ben@decadent.org.uk>
Subject: Bug#931111: linux-image-4.9.0-9: Memory "leak" caused by CGroup as used by pam_systemd
Date: Tue, 23 Jul 2019 23:03:54 +0100
Message-ID: <aa31aa4f4f6c05df3f52f4bd99ceb6f0341ff482.camel@decadent.org.uk>
References: <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de>  <ad0222ca-5fb0-4177-dc82-ca63f079e942@univention.de> <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de>
Reply-To: Ben Hutchings <ben@decadent.org.uk>, 931111@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yZ+Vo01prkMNSDxK2b5f"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist2=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.931111.B931111.15639194427012@bugs.debian.org>
In-Reply-To: <ad0222ca-5fb0-4177-dc82-ca63f079e942@univention.de>
List-Id: <cgroups.vger.kernel.org>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Philipp Hahn <hahn@univention.de>, 931111@bugs.debian.org, cgroups@vger.kernel.org, systemd-devel@lists.freedesktop.org
Cc: Roman Gushchin <guro@fb.com>, =?UTF-8?Q?=E6=AE=B5=E7=86=8A=E6=98=A5?= <duanxiongchun@bytedance.com>


--=-yZ+Vo01prkMNSDxK2b5f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-23 at 15:56 +0200, Philipp Hahn wrote:
[...]
> - when the job / session terminates, the directory is deleted by
> pam_systemd.
>=20
> - but the Linux kernel still uses the CGroup to track kernel internal
> memory (SLAB objects, pending cache pages, ...?)
>=20
> - inside the kernel the CGroup is marked as "dying", but it is only
> garbage collected very later on
[...]
> I do not know who is at fault here, if it is
> - the Linux kernel for not freeing those resources earlier
> - systemd for using CGs in a broken way
> - someone others fault.
[...]

I would say this is a kernel bug.  I think it's the same problem that
this patch series is trying to solve:
https://lwn.net/ml/linux-kernel/20190611231813.3148843-1-guro@fb.com/

Does the description there seem to match what you're seeing?

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?


--=-yZ+Vo01prkMNSDxK2b5f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl03hEoACgkQ57/I7JWG
EQk9KBAAwmnCCQnclud/sOw0BZ9io4wuVC/FUj1KWYUTbBGoE2bDFVluYJFDUG/F
Mh/PU8Xj5xd/C4bgyQYTtSyhxxgUu8hVCUgdGMtml1T/j1XMpdYOceH1kd5M0N5i
+uyIitcufzmPTFoP9nCLKWnReexlRoF/VN1X9gU3sVX5NGlzB3YT/U0iTkpHJJwa
5d0fFG1CHbbcXAZY3CghkYRM6mWQEVQZmt9gnZBJhLGP7RVzL/X2kdEUMp+Vl+xd
HAk6qmlHmkvW+GOpTN2p+QFit90G5nmSypFiF1954fYfiiD3enWn3mHIE/JAz/RV
PJqLf4TaF17ul1hU3FMbvKAixL+QJtCM4TLe+UuyZWa1oI4sbnWmvfkOy6ZL/36b
WLJNlWDNkUTXZrTiglQPTo/qXK9DuWGc7Xh0f93L02wbXVR5yCtB21MC8MT1+Qhz
nes1OzYypGyS+ui5x48kwB6ckis88g1tQ4a4aVlTM7z5MemCNoP7v/XU2PX+ZRaq
AE7ghicBKqTpLAe6HuG471omK6Mep8UO8mGbZ79+bauQlCzDxVRorQIsEWE+6dGg
7a7UZ2yj3xX9yyBJlbGSvO+xrxBB3dLSk722Pmg+K/EtAM6IFEdMCESGubN4wXRY
LxRHq8ca5/MhwLminZlGlSNRsCTX5d0/2AvMobyMVxJgFZ3uSKs=
=Qyoj
-----END PGP SIGNATURE-----

--=-yZ+Vo01prkMNSDxK2b5f--

