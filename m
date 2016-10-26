From: Jann Horn <jann@thejh.net>
Subject: Re: [RFC v4 00/18] Landlock LSM: Unprivileged sandboxing
Date: Wed, 26 Oct 2016 16:52:07 +0200
Message-ID: <20161026145207.GM3334@pc.thejh.net>
References: <20161026065654.19166-1-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaap9KN+GmBP785v"
Return-path: <kernel-hardening-return-5047-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thejh.net; s=s2016;
	t=1477493529; bh=MWuIXamZRxF4wgkHUuYuz4TvPUpgmIDU51JVu0QFWmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0DQLORE1S9EySlJ5ceMe7JhfNV//t47kKVvSrTtyGlgwCSVwwmA//w9uWT0D2xpf
	 WSMyIW+cULD7dJTMyePc3ewntMpZowVP9SfsHfR1STBmK75FtxjGaOoOhk+oL5MFj2
	 xjEKvROefvvgOaoM7rKk8t+hwIuw55sv9sjH/mngnlzrz1JDL8t91YByrWE+J2E7Y4
	 L4PNFoHGq9tY1HkLeXK4ewmEY7kWXe9vZ6r6L0AyLz2yOq32vuwciQrIVAXu58g7EK
	 kdOXg9mquxkW/HoSCeXZuCZXgk3KurJ4dq1lv3zlMDEnw0wCgZuxyR/6GjTwifx3c6
	 ZrJGyckvLPnsw==
Content-Disposition: inline
In-Reply-To: <20161026065654.19166-1-mic@digikod.net>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org, cgroups@vger.kernel.org


--yaap9KN+GmBP785v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2016 at 08:56:36AM +0200, Micka=EBl Sala=FCn wrote:
> The loaded Landlock eBPF programs can be triggered by a seccomp filter
> returning RET_LANDLOCK. In addition, a cookie (16-bit value) can be passe=
d from
> a seccomp filter to eBPF programs. This allow flexible security policies
> between seccomp and Landlock.

Is this still up to date, or was that removed in v3?

--yaap9KN+GmBP785v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEMMXAAoJED4KNFJOeCOonusQAM5j2Ow/y58PGiGJA7wIc6Cn
QaKfhNQ94fZ6c3jA63hsTT0Ojd4TWUyFwlX23GDPOmIEhEDYZhz56eE7Yn5nnF24
F0joLIR0v1ONtZEIm6830MzkTtyT4YY9H2Fu00xRIZ6ZGM2IyRe9Il/X8/ZZ9L3t
2Nl0KYiIhO37DDh5sCE64U094jdLkhoWKiN1mYenRm7ScyvI4lnhdvhm7wyhSiE4
oL5HBaAArwvYoydag6zUWEjUOguFelNzCcoA1dRhqllhkDrgSSceTv34xXLOjeVM
Umb8CVjdmm3vM3lxl2eZHIkR/Lz6dyFoUNJZuVBZ9A9U3yv5glpeuPhEyUISD4Ii
hZpne98TxDZeOCNN8EbKhDXrsAYe/9M2Cy+853ns0ZUdFX/mxfADROjmd1Ev3EpF
KG9TsYi4M28BB0OUJta/rcEM3wDHhSjBGF5TTMpOoYL3DgjRm7jxbemxkpDdlrOn
YUO/9iBnaWyf6ZqJm1RspcIo+iosBtKFXAZCLm39xmwRxWyCpbPfsPa36QA6CdB5
WBNpvrbrnY6Dnayj6ZNDWEgusuIxoABplvG9N7p8t1yHwZkVs2Ak7ZyvaHS8Gx32
HIhHXXQjrLqQXPK5sxrI+RU5ThJFXCHiTnCGOWw3OkW/pezPjYGY7xgUnmHHFTZk
3ZyIbEzOKKzhXWYG1Alv
=QX63
-----END PGP SIGNATURE-----

--yaap9KN+GmBP785v--
