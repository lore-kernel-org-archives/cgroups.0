From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Tue, 11 Aug 2020 19:36:26 +0200
Message-ID: <20200811173626.GA58879@blackbook>
References: <20200702152222.2630760-1-shakeelb@google.com>
 <20200703063548.GM18446@dhcp22.suse.cz>
 <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
 <20200707121422.GP5913@dhcp22.suse.cz>
 <CALvZod5ty=piw6czyVyMhxQMBWGghC3ujxbrkVPr0fzwqogwrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod5ty=piw6czyVyMhxQMBWGghC3ujxbrkVPr0fzwqogwrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shakeel.

On Tue, Jul 07, 2020 at 10:02:50AM -0700, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> > Well, I was talkingg about memory.low. It is not meant only to protect
> > from the global reclaim. It can be used for balancing memory reclaim
> > from _any_ external memory pressure source. So it is somehow related to
> > the usecase you have mentioned.
> >
>=20
> For the uswapd use-case, I am not concerned about the external memory
> pressure source but the application hitting its own memory.high limit
> and getting throttled.
FTR, you can transform own memory.high into "external" pressure with a
hierarchy such as

  limit-group			memory.high=3DN+margin memory.low=3D0
  `- latency-sensitive-group	memory.low=3DN
  `- regular-group		memory.low=3D0

Would that ensure the latency targets?

Michal

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl8y1xcACgkQia1+riC5
qShqhw//YT26h60lQF35uV5/xyJu8L4l+X7FL+ZZjsTqvY/lPSVgvrRzv3zb2h4B
ocoUY0cjJ4JatVY9uurZJAMEbGd9Iww8UmPaZAvCb8VPssWTHFgSbD1Eb+RAi4py
zEBPLd1JMZ4IeI7FmjGfZHk1/2Qr7nle3KPhHSZKrc83t0tDF6DTTYLOkWBTm+bS
JL56nLcXOb8Gm3kOkhLhseffcaWhBKYBzn3GzBXHYfbwX0Ba1I/OX6YrJD649vvc
xsmlJc9YfMVixDEatA4Vzt3Pi9ZhpsdfbqMrgHeVA1p81MoA3q8Sk7q9Oz1mze7p
aZbmCnl7t04NW7quKmqqqeMG91u+76KpmdGP/T+xpgXu2F8yLDGxzlfgbftb6wVr
LhcqYd9SXnX5fy/A0rV4tKAOXTqEpSY9/gEhnBwptwI2KO8VIiFo4a0dKKZ/9K9F
yREd3aoKMyad5E99i0N8ZJloo0X42sRdnVoc5SGV0Lj30Wp660IMEO/atRP0Z2+1
SgQmD9VTbsU4wBb2LcaCEz4P83keWm1oMfqdZ7EuGXzvmRT0FOMWvXAQ17RxYBtG
DjA+HOCeP9EuHXyefUA2DxsVRbK7Yn0Zb79nOkitb0oXrJuKTFlIW0qQ8oYmmrY8
gsOblNPf1DI2gLr+Wqh58u8/vER3NRgGv77xs/R39KeDh9DMz6Q=
=ODBM
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
