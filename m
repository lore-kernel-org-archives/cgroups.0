From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on
 cgroup1
Date: Thu, 7 Sep 2023 16:41:04 +0200
Message-ID: <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lpqfbqf66cnxpfb6"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694097665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7/GWuQ82O0cqDWnLwHLamdkhZxjacO2j0BJIXilWXjc=;
        b=G8pcgQbRkAoNq1GD1BaIXvsUmciVqLKZ3+J18kyYCXaPXMgaX402fFxyOzzZx6Xl6D4t86
        mtFn0VpJdohH5CoNYW+E4K2M7VvAyKbz/BZEUjXCvJVeDURLzRTuxjrsZoohKBdPmwScJY
        5M00egnTaoz2lhQm/wCP5NCYQESf9mY=
Content-Disposition: inline
In-Reply-To: <20230903142800.3870-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--lpqfbqf66cnxpfb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Yafang.

On Sun, Sep 03, 2023 at 02:27:55PM +0000, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> In our specific use case, we intend to use bpf_current_under_cgroup() to
> audit whether the current task resides within specific containers.

I wonder -- how does this work in practice?

If it's systemd hybrid setup, you can get the information from the
unified hierarchy which represents the container membership.

If it's a setup without the unified hierarchy, you have to pick one
hieararchy as a representation of the membership. Which one will it be?

> Subsequently, we can use this information to create distinct ACLs within
> our LSM BPF programs, enabling us to control specific operations performed
> by these tasks.

If one was serious about container-based ACLs, it'd be best to have a
dedicated and maintained hierarchy for this (I mean a named v1
hiearchy). But your implementation omits this, so this hints to me that
this scenario may already be better covered with querying the unified
hierarchy.

> Considering the widespread use of cgroup1 in container environments,
> coupled with the considerable time it will take to transition to cgroup2,
> implementing this change will significantly enhance the utility of BPF
> in container scenarios.

If a change like this is not accepted, will it make the transition
period shorter? (As written above, the unified hierarchy seems a better
fit for your use case.)

Thanks,
Michal

--lpqfbqf66cnxpfb6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPng7wAKCRAGvrMr/1gc
juZAAQCCMKwWVeLjjokOs8ldESgvMuN/3xsmMmJaDv8ZAb2i4wD/VRDN7bDKUdMi
1L4tP03C2+tFBp0Y/7+DtsLxIGHuYQw=
=zosN
-----END PGP SIGNATURE-----

--lpqfbqf66cnxpfb6--
