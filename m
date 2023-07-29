From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v3 11/28] x85/sgx: Return the number of EPC pages that
 were successfully reclaimed
Date: Sat, 29 Jul 2023 14:47:51 +0200
Message-ID: <ZMUKd7KY6Kquubjf@duo.ucw.cz>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-12-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R7yJGefVtKAYCwSn"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1690634872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RAsNUQf+00oUuts2a7jrozlCZl17QKNd69lxBxURL3g=;
        b=YnoqXcg30UY3MdSapkyH4rKRfmwItAMk6U74tP90L8di9bpTuUvR+jkWhqxdB2I7RIHOy5
        mR6SxYFrOmWaY2DdCamfRajqHtno/aufJelCtXKvOF5UfLS4TthIpDWJWR0gQT4LtQVJwM
        MMzRIAcVkPw2y5cposyyuIyaGkkZ2nk=
Content-Disposition: inline
In-Reply-To: <20230712230202.47929-12-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
To: Haitao Huang <haitao.huang@linux.intel.com>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kai.huang@intel.com, reinette.chatre@intel.com, Sean Christopherson <sean.j.christopherson@intel.com>, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com


--R7yJGefVtKAYCwSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
> cgroup will use the result to track the success rate of its reclaim
> calls, e.g. to escalate to a more forceful reclaiming mode if
> necessary.

Subject says x85. While some would love to see support of Linux on
Intel 8085, I guess it should be x86.

Best regards,
								Pavel
							=09
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--R7yJGefVtKAYCwSn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZMUKdwAKCRAw5/Bqldv6
8hyIAKC6e4rHUDwLQThZHsYgsxUnrEcKQQCfXT0HVDxSw+VWX7v8QzRcoZQ5q/I=
=C2G9
-----END PGP SIGNATURE-----

--R7yJGefVtKAYCwSn--
