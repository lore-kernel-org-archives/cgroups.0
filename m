From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] mm: kmem: add direct objcg pointer to task_struct
Date: Thu, 22 Dec 2022 14:50:44 +0100
Message-ID: <20221222135044.GB20830@blackbody.suse.cz>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev>
 <20221220182745.1903540-3-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671717046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dKCiYQ23O3uBl9KybsaGHQdKwg661OuoQvd3fEpwuvo=;
        b=M08TLcqeLRGth27rtQLEqHTEGmfzGkrqCZ28m6wQlz4q5subWsUifO6MKgLung/h4RS3BB
        P5H7klPHvF5K/SUmOS5SqH4qKAEn2djJ0sBN8Hs22P5KNCpHvI90xMQc+6tYJHw5YkbVVz
        NshLbpDNi5HYwlu2rdu7WSWw4CZfKS8=
Content-Disposition: inline
In-Reply-To: <20221220182745.1903540-3-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 20, 2022 at 10:27:45AM -0800, Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> To charge a freshly allocated kernel object to a memory cgroup, the
> kernel needs to obtain an objcg pointer. Currently it does it
> indirectly by obtaining the memcg pointer first and then calling to
> __get_obj_cgroup_from_memcg().

Jinx [1].

You report additional 7% improvement with this patch (focused on
allocations only). I didn't see impressive numbers (different benchmark
in [1]), so it looked as a microoptimization without big benefit to me.

My 0.02=E2=82=AC to RFC,
Michal


[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D216038#c5

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY6RgsgAKCRAkDQmsBEOq
uee9AP0XW2wd7WEaYeLk8NGJ88vIfhH8dybRnl5vWnQZqfHw9AEA1OHVGGFOMlz6
lYuj11/kUl2A4R6elqCcLj9yPsw26QY=
=OHxW
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
