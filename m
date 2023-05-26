From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Fri, 26 May 2023 23:11:40 +0200
Message-ID: <wrk7xlexb4kt7zlsqaubmc7ifig2fg6kkeuulfsc4u5xeubrck@pa3okxj3sor4>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
 <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
 <3ej42djuuzwx36yf2yeo5ggyrvogeaguos5jtve2bvuaejnwff@fak3yjwe2fbi>
 <8f56f60f-8dd3-d798-3d81-6ccbb185465d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2lov5w6hllmz7efr"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685135502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GTCdMXnNw/we7gpWUIpXMsOp9HhjiCEV541QuBvZbyI=;
        b=nGFZHAxje2bQi5OKTGrbsgUMwcORsIAPWM0/azph8zJ/82STCr0zqq7OJskz3qFrMTvnm8
        8XShV3U1AYBeAbz5WvKd78glx2fuXqUWgSOB06tmBe4FuBqYbhe3JlbJ8zTde0afM1Nayn
        O0e+anTuA/QQKFYJZWvWvafOIk7vykE=
Content-Disposition: inline
In-Reply-To: <8f56f60f-8dd3-d798-3d81-6ccbb185465d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


--2lov5w6hllmz7efr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 25, 2023 at 11:25:05AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Since the percpu blkg_iostat_set's that are linked in the lockless list will
> be freed if the corresponding blkcg_gq is freed, we need to flush the
> lockless list to avoid potential use-after-free in a future
> cgroup_rstat_flush*() call.

Ah, so that was meant to the situation post-patch (that removes refcnt
of entries on list lockless).

(It sounded like an answer to Yosry's question about
cgroup_rstat_flush in offline_css in pre-patch version. Nevermind, this
would need other adjustments.)

Thanks,
Michal

--2lov5w6hllmz7efr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZHEgigAKCRAkDQmsBEOq
uWtDAP9qS2v1mJD+JAJWF4NNLRntYEptKWXuYC5WuXbwLeHXVgEAv+bVtSIdoISo
P9lLBk2p49pDqTse3bR1E50c/pTTQgU=
=Aa81
-----END PGP SIGNATURE-----

--2lov5w6hllmz7efr--
