From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Date: Wed, 30 Jun 2021 17:10:36 +0100
Message-ID: <20210630161036.GA43693@sirena.org.uk>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
 <YMoXdljfOFjoVO93@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625069464;
        bh=M8ldAZIlZPdkE4DDxEruz+BeSbuNAZmJGY4VXeQhPbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIjuafd9ucIniC22otKPC7dmUd41/MK9JTkA5XhaP2hGAPC8vMIPbB/Iu1OSSc2dk
         DxfvR+O3ck+BZSti2bbWuzQrwEvWclOyEQKty9sFsjxFBs62NQgBRmu6gcwAMcIpEm
         mvajycTioH9jrZ/J9T1KeSnToXafODz5fWYHIW8ZalubsHD0Izbws22VHEhEFfBrWF
         Iz9RHbV4c/1RNTeK7ppH+8PpS1DtpefTIshaALX4o1ThUlajT7qcVQy/nRccFwVEBq
         tijIGsoeqDQa29G9WhnITxk2L8aEzcoly2Cj1/zbnFkQaMtVDPkRBAn0Td4vfEMQa0
         l+wAGTzJlqLjg==
Content-Disposition: inline
In-Reply-To: <YMoXdljfOFjoVO93@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org, Richard Purdie <richard.purdie@linuxfoundation.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2021 at 11:23:34AM -0400, Tejun Heo wrote:
> On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:

> > A fix would be to not leave the stale reference in fc->root as follows:

> >    --------------
> >   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dput(fc->root);
> >   +               fc->root =3D NULL;
> >   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deactivate_locked_sup=
er(sb);
> >    --------------

> > ...but then we are just open-coding a duplicate of fc_drop_locked() so =
we
> > simply use that instead.

> As this is unlikely to be a real-world problem both in probability and
> circumstances, I'm applying this to cgroup/for-5.14 instead of
> cgroup/for-5.13-fixes.

FWIW at Arm we've started seeing what appears to be this issue blow up
very frequently in some of our internal LTP CI runs against -next, seems
to be mostly on lower end platforms.  We seem to have started finding it
at roughly the same time that the Yocto people did, I guess some other
change made it more likely to trigger.  Not exactly real world usage
obviously but it's creating quite a bit of noise in testing which is
disruptive so it'd be good to get it into -next as a fix.

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDcl3sACgkQJNaLcl1U
h9DHcgf/cG+zirVPNAyg/RyU6eO8RRZ/Fsde5H0M1tr3tybVB/GuciKOhNSBdU8p
MEnEvuPHRVsq8o5KTMvo+lxmNdBy/OHVK/LnU6CyqkDaU9l5a9+JOc+N+Ljn9JyJ
wBzeFmiAeMdcnCzaPYCGHXzgILY8j0vs2agj/hI3sdP/GNMMQ3URQmKeTsB1YtCO
GICcKyAPHeVy5GZwfaWDJGEJhFXOIW7d20+cuKpx335WsTg+aORft+rwPDHvfH6+
mJF34H7wfckprBzWdA8v+fPrYINjeiLFSWJsXLdWHfy6F3BAAiDKxT0Pm9fVwZ5Q
e0VJUxXvl2KHT//hLYrTSETDFuiMwg==
=vGg1
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
