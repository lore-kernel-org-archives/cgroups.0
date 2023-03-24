From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/1] mm: memcontrol: fix vmstats_percpu state incorrect
 subtraction after reparent
Date: Fri, 24 Mar 2023 18:11:14 +0100
Message-ID: <20230324171114.32oru5sdubfsfvgi@blackpad>
References: <20230320030648.50663-1-caixinchen1@huawei.com>
 <20230320030648.50663-2-caixinchen1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zdhfeu2yhc5s3ooc"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679677876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tWmn6S5YIs367DkBrcliyowrdz09FT4jicvN67WVd1Q=;
        b=Eku5Ernzy7mmNguDiowGGaJXYc7ZQ2vU1KA46inl7ZfH1RKMVqbk8gnL3KMsKyAYqEMkRf
        2Om7zsa2zVwanBak0bzaUtO90jxztxVY5c1O9xoFBMa4ej1q6pdLlSZYzj4RAjiYcBxMmD
        v7hqcgJV90Eh9vjW41I6rIxVrngWD6Q=
Content-Disposition: inline
In-Reply-To: <20230320030648.50663-2-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mpenttil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--zdhfeu2yhc5s3ooc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Mon, Mar 20, 2023 at 03:06:48AM +0000, Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> When memcg C is offllined, its pages are reparented to memcg P,
> so far P->vmstats (hierarchical) have those pages, and
> P->vmstats_percpu (non-hierarchical) don't. When those pages get
> uncharged, P->vmstats (hierachical) decreases, which is correct,
> but P->vmstats_percpu (non-hierarchical) also decreases, which
> is wrong, as those stats were never added to P->vmstats_percpu to
> begin with.

I was wondering why ->vmstats_percpu matters (in the end all is summed
in ->vmstats) -- do you mean this is a cgroup v1 only issue? As only
that exposes the non-hieararchical stats.

Thanks,
Michal

--zdhfeu2yhc5s3ooc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZB3ZsAAKCRAkDQmsBEOq
ubgvAP0S0+i6gFMj+uLkO7p+vwL0oN12X2x0vhGGOkGva271GAD/RP/Nz+EJ6cb5
hc9lBjB3CbP+EKpYGdVof3rKoyv4Wws=
=uY3T
-----END PGP SIGNATURE-----

--zdhfeu2yhc5s3ooc--
