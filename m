From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: drains percpu charge caches in
 memory.reclaim
Date: Fri, 11 Nov 2022 11:08:44 +0100
Message-ID: <20221111100843.GG20455@blackbody.suse.cz>
References: <20221110065316.67204-1-lujialin4@huawei.com>
 <20221110144243.GA10562@blackbody.suse.cz>
 <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668161325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Njy+9VQDA2x8k6xdte7NdH5PI4Y0RD6JCuHPbQ59y9Y=;
        b=mij2Vx3pVUYxoFhx5V9lxpwv4DvmeN9TvBH9YYtc49WknJbIUyktZGk10aPTQ00zdKLPWO
        oRNWMZr/dcvxJ9hSlakB50Gl5mCTfCJ9KpdDzJshteaGX5hubk+5tcRdYPupAw3AilLiXV
        oqBZSAgliR2auCbW9y5N0bPQIGDv7fg=
Content-Disposition: inline
In-Reply-To: <CAJD7tkat6QAJkPJ-of0xYGbKJ1CyXeC0cMh+U9Nzmddm4pOZ9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 10, 2022 at 11:35:34AM -0800, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> OTOH, it will reduce the page counters, so if userspace is relying on
> memory.current to gauge how much reclaim they want to do, it will make
> it "appear" like the usage dropped.

Assuming memory.current is used to drive the proactive reclaim, then
this patch makes some sense (and is slightly better than draining upon
every memory.current read(2)).

I just think the commit message should explain the real mechanics of
this.

> The difference in perceived usage coming from draining the stock IIUC
> has an upper bound of 63 * PAGE_SIZE (< 256 KB with 4KB pages), I
> wonder if this is really significant anyway.

times nr_cpus (if memcg had stocks all over the place).

Michal

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY24fFAAKCRAkDQmsBEOq
uQqYAP43Vb8o2c74sobuMNtlWw1gCKYZQ/J7GQSxdpVrnAcQdgEAwVkZvEqxNW26
8VIva1cppj+dAzB+o1VI3+WkrJk8uw8=
=Z1CV
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
