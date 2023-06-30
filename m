From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] nvmet: allow associating port to a cgroup via configfs
Date: Fri, 30 Jun 2023 20:26:45 +0200
Message-ID: <vjb27jezj3j45l4gwcgge54st32xfoduvam6lu2irdg7xligea@erxg5rhvklr3>
References: <20230627100215.1206008-1-ofir.gal@volumez.com>
 <30d03bba-c2e1-7847-f17e-403d4e648228@grimberg.me>
 <90150ffd-ba2d-6528-21b7-7ea493cd2b9a@nvidia.com>
 <79894bd9-03c7-8d27-eb6a-5e1336550449@volumez.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vsldarc2hw5fdqjn"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688149606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JjudmYc+t4AhUeg8M5MES9aRhblFwTPNdMxP3nSzsE4=;
        b=jHBqhOoevdO4MK0tHEKrzcIFh/sNfQ/P1KGheod6Yvsqv2GYsCqzjwN0rRx9aS/Yol9wU2
        fHkniBSsYGU5FLUKRiUpwOdL1eF0SMh5eb9MSZ4u7sL3NQUwhpWx7QJUP+CVHoHJQjQUIQ
        zxwIDZ5XAnzUu7wL37HeFXtVz5eZUgs=
Content-Disposition: inline
In-Reply-To: <79894bd9-03c7-8d27-eb6a-5e1336550449-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>
Cc: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org


--vsldarc2hw5fdqjn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Thu, Jun 29, 2023 at 06:21:34PM +0300, Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org> w=
rote:
> >>> Currently there is no way to throttle nvme targets with cgroup v2.
> >>
> >> How do you do it with v1?
> With v1 I would add a blkio rule at the cgroup root level. The bio's
> that the nvme target submits aren't associated to a specific cgroup,
> which makes them follow the rules of the cgroup root level.
>=20
> V2 doesn't allow to set rules at the root level by design.

I think you want to add a per-nvme port (device?) throttled-bandwidth
attribute (instead of param_associated_cgroup) to control this on the
client (whole host) side -- even without cgroups.
Associating ports with cgroups and then bios with cgroups looks
superfluous.
(But it is understandably tempting because then IO controller's
throttling implementaion may be reused.)


How are the nvmet_bdev_execute_rw() et al functions called? (Only via
kthreads without (uspace) process context? Or can the reqs be traced to
a user space process?)

Thanks,
Michal

--vsldarc2hw5fdqjn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZJ8eYwAKCRAGvrMr/1gc
jhfgAP9NUZ0UHO1rcdmDFFxkaXaqqbBN5FcUsYD34VDU684djwD/RL9E71JMN1Fd
E1uJRAC4up2kwbfgkuuCGPhA2jx5nAE=
=+Y3/
-----END PGP SIGNATURE-----

--vsldarc2hw5fdqjn--
