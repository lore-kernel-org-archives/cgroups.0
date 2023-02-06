From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Mon, 6 Feb 2023 17:18:43 +0100
Message-ID: <20230206161843.GD21332@blackbody.suse.cz>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
 <CAJD7tkaCpD0LpzdA+NsZj2WK=iQCLn7RS9qc7K53Qonxhp4TgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675700324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDZV3mvNGQ6bQlUZNt+pm2+TOpLBe+J478jwvr5iYPs=;
        b=hQO7lfu/O7FHy0nrH+ZhkVayWc951N8vQUFqsqBQVt4PbLGzLrGPHE0FDkfgw6DtmqrQPF
        qa2n3gEEry2sT6DZB/Rg+HdMe6NO7pTxDB6Xavt7nlAC7Uxskyt7xQPfC/06rlzBMBlBxC
        3x3/WqSPCBN2XPQ1ctlHBSeoxXMyGEg=
Content-Disposition: inline
In-Reply-To: <CAJD7tkaCpD0LpzdA+NsZj2WK=iQCLn7RS9qc7K53Qonxhp4TgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2023 at 10:30:40AM -0800, Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> > b) Only count cgroup swap events when they are actually due to a
> >    cgroup's own limit. Exclude failures that are due to physical swap
> >    shortage or other system-level conditions (like !THP_SWAP). Also
> >    count them at the level where the limit is configured, which may be
> >    above the local cgroup that holds the page-to-be-swapped.
> >
> >    This is in line with how memory.swap.high, memory.high and
> >    memory.max events are counted.
> >
> >    However, it's a change in documented behavior.
>=20
> This option makes sense to me, but I can't speak to the change of
> documented behavior. However, looking at the code, it seems like if we do=
 this
> the "max" & "fail" counters become effectively the same. "fail" would
> not provide much value then.
>=20
> I wonder if it makes sense to have both, and clarify that "fail" -
> "max" would be non-limit based failures (e.g. ran out of swap space),
> or would this cause confusion as to whether those non-limit failures
> were transient (THP fallback) or eventual?

I somewhat second this.

Perhaps, could the patch (and arguments) be split in two:
1) count .max events on respective limit's level (other limits consistency),
2) redefine (remove?) memory.swap.fail events?

Michal

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+EoYQAKCRAkDQmsBEOq
uXuJAQCRA9+UXkEzfVoUWjltXKLdc9vqvH0D5zne/GZdvubZBwEAoxc1UQlw1YcL
8fUMQsShXoCJhwMdfV5kVkrsg1du8ww=
=agtq
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
