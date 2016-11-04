From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 06:20:14 +0200
Message-ID: <20161104042014.GN3617@leon.nu>
References: <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
 <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org>
 <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu>
 <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rTTzD97p2CCc/LGU"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161103180006.GL3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--rTTzD97p2CCc/LGU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 03, 2016 at 08:00:06PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 01, 2016 at 04:33:23PM +0530, Parav Pandit wrote:
> > So my opinion is:
> > (a) Let cgroup define the current standard objects and new reasonable
> > set of vendor specific objects in future.
> > (b) Add new rdma.percentage parameter so that any new standard object
> > or vendor specific object can be abstracted from average end user and
> > applications which are yet to catch up.
> > I believe this takes care of your point (1), (3), (4)?
>
> We (Tejun, Christoph, Matan and me) had a face-to-face talk during
> KS/LPC and decided that the best way to move forward is to export to
> user one object (global HCA like) only and don't export anything else.
>
> All internal calculations will be based on this percentage.

In order to simplify for users and developers more, this global cgroup
object should be not based on percentage, but on actual number of objects
units. While declaration of object unit is object which consumes IDR.

The IDR consumers can be of any type. Such simplification will give
excellent scalability to the cgroup without sacrificing user experience.

>
> Once the cgroups users will come with reasonable justification why they
> need to configure different unexposed objects, we will expose them.



--rTTzD97p2CCc/LGU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYHAx+AAoJEORje4g2clinj7kQAJ4gBqXiuEeojaSO2YU+UWFq
/lY7njWBsMzFJYDokuedgra0Vhw24ui6/GCjHXrrQKicynrBQkHiQF2x6kx4vcT5
BHHuyWSvNwty5sIU/2GtrDAVG6fR4haMs1zdMmwGce37RlmMDy2EFXO1KAxVhG04
n7gYa41QP2esIl7emi5MOf59ZeTq36kvDj6llFxfSulxf/h+wJBDOSQ+/mGprK4Q
qPGpgVQ9Emnf0cX2piCI6XDMR6QCPmCVe3eqac33vTYi4JcDAqsV9gJNRA3WeV0a
Lfu7PSbU7zAthnI/TbAH0cSsMrmb8S8V+g2d2o6x3StvcJCrgP4LbvHD9smyvDTh
ItXKQmREpIwVVkAk3J/qO7nhTknVcqiVcobE5TCafKEfSLWKyOGiHgrMOi/pdVen
TsG8b4BKEIQy9IOe85geBvZMT0nEnHWhG/jBqI/KgBKUFaAdbLMceJjSPQKrD6tC
DzemnCU13KN6EyzUwX8RXCggl+gtalNBrnGrBKYsBku4bdpOlfB6bBSLbuoQQALa
8t/8UFsHNiSzpvS4plCK3O14wzTmsgA1ryjkPdLBP6W1WYvGBvTvlcE9WTcQqAcN
hLaDq3cmkx9mA8Jc/3dFnWEJW1v6TzQWKTL6UUaNjolgMVO5WGMleNGYaEVOMpHg
BBgRg4dPGiOt+wA6m8Ei
=N+A2
-----END PGP SIGNATURE-----

--rTTzD97p2CCc/LGU--
