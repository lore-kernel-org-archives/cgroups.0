From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: calling reclaim_high(GFP_KERNEL) in GFP_NOFS
 context deadlocks
Date: Mon, 3 Oct 2022 17:08:36 +0200
Message-ID: <Yzr69M9MtNYIKPBx@blackbook>
References: <20220929215440.1967887-1-david@fromorbit.com>
 <20220929222006.GI3600936@dread.disaster.area>
 <YzbesGeUkX3qwqj8@blackbook>
 <20220930220834.GK3600936@dread.disaster.area>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OOHJpowuF7rqPJPU"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664809717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aytUdXlGSVAVAW293DkhDivkGR0N7fkvULdwZOjcsOA=;
        b=n/FrNF6zgz6jZFmZnlJOWIbrGzQYXL6yM0mJ/jc+QIH1ww+yX9V1b8JfTsKpXG0QyYRZmf
        gIWbP1pq/MTUlu8K1wfZh8MsW1LfrK7LvQVeKNgMVX51MimhtIJL5YlF+de/kXp+5BF+0J
        Pnl3KLp1HBlbjwAkHetW094SQIHonQM=
Content-Disposition: inline
In-Reply-To: <20220930220834.GK3600936-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--OOHJpowuF7rqPJPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 01, 2022 at 08:08:34AM +1000, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> You might be right in that c9afe31ec443 exposed the issue, but it's
> not the root cause. I think c9afe31ec443 just a case of a
> new caller of mem_cgroup_handle_over_high() stepping on the landmine
> left by b3ff92916af3 adding an unconditional GFP_KERNEL direct
> reclaim deep in the guts of the memcg code.

It's specific of the memory.high induced reclaim that it happens out of
sensitive paths (as was with exit to usermode or workqueue), so there'd
be no explicit flags to pass through, hence the unconditional
GFP_KERNEL.

> So what's the real root cause of the issue - the commit that stepped
> on the landmine, or the commit that placed the landmine?

My preference here is slighty on the newer commit but feel free to
reference both.

> Either way, if anyone backports b3ff92916af3 or has a kernel with
> b3ff92916af3 and not c9afe31ec443, they still need to know
> about the landmine in b3ff92916af3....

To be on the same page -- having just b3ff92916af3 won't lead to the
described cycle when FS code reclaims without GFP_NOFS? (IOW, how would
the fix look like fix without c9afe31ec443?)

Thanks,
Michal

--OOHJpowuF7rqPJPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYzr68gAKCRAkDQmsBEOq
uShAAP4nCUb/8BBe0G5NPxDTfRtDkhqnQSLtUqP1SheQihbQ8AEA08BzlyOuRTWH
DwghMoqgqag9V2P98YpcCDpA2R/KvwA=
=/1mZ
-----END PGP SIGNATURE-----

--OOHJpowuF7rqPJPU--
