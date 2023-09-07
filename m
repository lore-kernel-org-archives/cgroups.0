From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Thu, 7 Sep 2023 17:57:27 +0200
Message-ID: <zqgnootbsjyj7wq5ayiallz4m2bz7ad6w67t24peglhc5v6ern@4pfqlshgpnie>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <lqcl5cblo3s45afvtgqjkbz2an3zwccsckglhpe3ufyffqavjk@ui45m6itz4ne>
 <236f84be-26b0-758d-3d3f-380e536f72c2@amazon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ibi6d2k6h7vappp"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694102248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UnG3kyHx/yySq1uQAqm63aAFoe+tK7nrYedgBgmw3Sk=;
        b=qNG59kr3JPMUSa7aErahyZeWVgBZ/LFmTUWjofl1Ge+sd8TgCYFmeGfGN+Mcm7CcLguLwN
        /dOcb3nSK9p7Tw6Q1dzdWC6bpyE8JLbQiNbaE7ObOW/zO5WOkvPGP+GQuE3b6/fOFgykRw
        GnvMh13oE1m8dySb2Ffu6QFcmZbX4EI=
Content-Disposition: inline
In-Reply-To: <236f84be-26b0-758d-3d3f-380e536f72c2@amazon.com>
List-ID: <cgroups.vger.kernel.org>
To: Luiz Capitulino <luizcap@amazon.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, longman@redhat.com, lcapitulino@gmail.com


--7ibi6d2k6h7vappp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 07, 2023 at 11:16:41AM -0400, Luiz Capitulino <luizcap@amazon.c=
om> wrote:
> Yeah, this works for cgroup v2 but my understanding is that cgroup v1
> doesn't support changing flags in remount, take a look at
> cgroup1_reconfigure().

Ah, didn't notice.
Alhtough -- there seems to be a deeper issue -- the mount option doesn't
have a per-root semantics. There is only a single
cgroup_threadgroup_rwsem afterall.

Even with your cmdline option, you may loose the behavior after
unmounting any of the v1 hierarchies (cgroup_destroy_root()
unconditionally disables it).

Or you could still achieve the result by mounting cgroup2 hierarchy with
favordynmods. (And unmount it, default root is not ever released.)

Maybe it would be the best to have this controllable only via v2
hierarchy (as it's the only documented).
(And maybe v1s should not show the option at all.)

My 0.02=E2=82=AC,
Michal

--7ibi6d2k6h7vappp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPny4gAKCRAGvrMr/1gc
jqjdAQCR/eGLDLOEDNOiaj8HrKSt34AoCZ11IrxIBd136Vqe0gD9FLcG+ak0oijQ
u/PovQBg+jQA2Hax7qFMyjarQs33IwQ=
=BLiB
-----END PGP SIGNATURE-----

--7ibi6d2k6h7vappp--
