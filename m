From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] mm: multi-gen LRU: working set extensions
Date: Wed, 11 Jan 2023 15:17:17 +0100
Message-ID: <20230111141716.GA14685@blackbody.suse.cz>
References: <20221214225123.2770216-1-yuanchu@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673446639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0sVrq4Dniw5KnDcNZ1C6CZNPXzD9gn2lEBhnqlgUWQg=;
        b=EXtg4ez0ch4jeVKmyNXeCXnuQie+WMbN7uTHT/Spqz9Lhu82IcRtoMI7K5IzlqjRl53JvS
        lX9U23sleXpjF1VHRMIjz8XuTjeI6ptzTin6V3ueNjB8Fe/HltDjp6Dvx/uso5a3AEEKdW
        WhWP6WtVCkCyZYq9t2oINfZk5XlclYI=
Content-Disposition: inline
In-Reply-To: <20221214225123.2770216-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 14, 2022 at 02:51:21PM -0800, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
> that's frequently used. The only missing pieces between MGLRU
> generations and working set estimation are a consistent aging cadence
> and an interface; we introduce the two additions.
>=20
> Periodic aging
> =3D=3D=3D=3D=3D=3D
> MGLRU Aging is currently driven by reclaim, so the amount of time
> between generations is non-deterministic. With memcgs being aged
> regularly, MGLRU generations become time-based working set information.

Is this periodic aging specific to memcgs? IOW, periodic aging isn't
needed without memcgs (~with root only)
(Perhaps similar question to Aneeh's.)

> Use case: proactive reclaimer
> =3D=3D=3D=3D=3D=3D
> The proactive reclaimer sets the aging interval, and periodically reads
> the page idle age stats, forming a working set estimation, which it then
> calculates an amount to write to memory.reclaim.
>=20
> With the page idle age stats, a proactive reclaimer could calculate a
> precise amount of memory to reclaim without continuously probing and
> inducing reclaim.

Could the aging be also made per-memcg? (Similar to memory.reclaim,
possibly without the new kthread (if global reclaim's aging is enough).)

Thanks,
Michal


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY77E6gAKCRAkDQmsBEOq
ufzXAP9oSegjiyAMqSaGyInbRBFZQWAgWZSfIZLFLnPaHnPLewD/abXGqTRB65aj
qyqWc5cOAqYeuzRkjwwaFp6QKtrImwE=
=Jo1y
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
