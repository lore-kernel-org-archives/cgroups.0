From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 4/8] memcg: replace stats_flush_lock with an atomic
Date: Tue, 4 Apr 2023 18:52:58 +0200
Message-ID: <20230404165258.ie6ttxobbmgn62hs@blackpad>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pchdddtux2qbf53z"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680627180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J++lSR0qBN+0TGvxu6lzekTohutLNFEkeNAdPcqtrMc=;
        b=qOluMdxPHhvtFQLCFpQe1/5GzQwfB/aZnibvtGxy2cJj/GyfWJ5wH4U5vkOgOM4tLtt1Nu
        Zvy2ZDtEOpyTBqcaT3xmplxiRScoHOSM7b0DIGYzfo+dy8TIFtXcIJ/kmtMwDURxu6+1hO
        2swLdLqT2gFMWpUe1QczgdY8wOiZM5Q=
Content-Disposition: inline
In-Reply-To: <20230330191801.1967435-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>


--pchdddtux2qbf53z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Thu, Mar 30, 2023 at 07:17:57PM +0000, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>  static void __mem_cgroup_flush_stats(void)
>  {
> -	unsigned long flag;
> -
> -	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
> +	/*
> +	 * We always flush the entire tree, so concurrent flushers can just
> +	 * skip. This avoids a thundering herd problem on the rstat global lock
> +	 * from memcg flushers (e.g. reclaim, refault, etc).
> +	 */
> +	if (atomic_read(&stats_flush_ongoing) ||
> +	    atomic_xchg(&stats_flush_ongoing, 1))
>  		return;

I'm curious about why this instead of

	if (atomic_xchg(&stats_flush_ongoing, 1))
		return;

Is that some microarchitectural cleverness?

Thanks,
Michal

--pchdddtux2qbf53z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZCxV6AAKCRAkDQmsBEOq
ucctAP0QF3CXk51W8Pmcc0e8ZfVGikqKVH42APSyMXgCLEw4twD/ajlglQ+6Jt7N
Lf+TNXVTCA0s8f9NI8huIwxn6NR+XQc=
=Q0r7
-----END PGP SIGNATURE-----

--pchdddtux2qbf53z--
