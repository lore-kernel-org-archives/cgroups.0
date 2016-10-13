From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 13 Oct 2016 13:34:30 +0300
Message-ID: <20161013103430.GB9282@leon.nu>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu>
 <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org>
 <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org>
 <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sP1A+UbkWBB0qc5v"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--sP1A+UbkWBB0qc5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 10, 2016 at 07:02:11PM +0530, Parav Pandit wrote:
> Hi Tejun,
>
> On Mon, Oct 10, 2016 at 6:50 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Hello, Parav.
> >
> > On Mon, Oct 10, 2016 at 06:43:59PM +0530, Parav Pandit wrote:
> >> > Also, I don't get what you mean by using percentage and when people
> >> > brought up this idea, it always has been stemming from
> >> > misunderstanding.  Can you please elaborate how percentage based
> >> > proportional control would work?  What would 100% mean when cgroups
> >> > can come and go?
> >>
> >> When 100% is given to one cgroup, all resources of all type can be
> >> charged by processes of that cgroup.
> >> Resources are stateful resource. So when cgroup goes away, they go
> >> back to global pool (or hw).
> >> Giving 100% to two cgroups is configuration error anyway (or without config).
> >
> > That isn't proportional control.  That's using percentage as the unit
> > to implement absolute limits.  Proportional control implies work
> > conservation.
> >
> >> As you know weight configuration allows automatic increase/decrease of
> >> resource to other cgroups when one of them go away, as opposed to
> >> absolute value. How this is going to work in exact terms for stateful
> >
> > Hmm.... so are you saying that ti'd be work-conserving?
> They cannot be work conversing.
>
> > But what does
> > it mean to say "30%" and then have it all resources when there are no
> > other users.  Also, is it even possible to take back what have already
> > been allocated and are in use?
> >
> Most resources that I know of, and whats described in current
> cgroup_rdma.h are not work conversing, therefore it cannot be taken
> back.
>
> >> Nop. Thats not true.
> >> (a) Every new resource has to be defined in cgroup_rdma.h
> >> (b) charge()/uncharge() has to happen by the cgroup for each.
> >> (c) Letting drivers do will make things fall apart. There are no APIs
> >> exposed either to let drivers know process cgroup either. There is no
> >> intention either.
> >>
> >> (d) ratio means -if adapter has
> >> 100 resources of type - A,
> >> 80 resource of type - B,
> >>
> >> 10% for cgroup-1 means,
> >> 10 resource of type - A
> >> 8 resource of type - B
> >
> > So, this is not work-conserving.  There's too much confusion here.
>
> Give me some more time, I will think more and take feeback from Leon
> and others on
> (a) how can we implement or want to implement weight like
> functionality for non-work-conversing resource

I'm not fully understand the question. RDMA resources are static and
won't be recalculated dynamically for running cgroups consumers while
new cgroup is started. In this situation, weights and percentages are
the same.

> (b) what could be its acceptable limitations of that interface would be
> before we propose you.

More easy is to summarize requirements:
1. It needs to be convenient for users.
2. It can limit any future objects without change in user tools.

>
> At minimum we would need to expose actual value in rdma.max in
> subsequent patch, instead of exposing just "max" string. I don't want
> to complicate this discussion but similar functionality is needed for
> pid controller as well to expose actual value.
>
> >
> > Thanks.
> >
> > --
> > tejun

--sP1A+UbkWBB0qc5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/2M2AAoJEORje4g2clinkOIP/0p7+4FKFCCSvcriTJD/0Nwr
wFgvVdB5k/HJmWonEbP13CVVp8LzrkuZd4YgKLDV6SAybMva9hcW4Se60Wfdv4ql
RozfAsoNnoxCC5Bvkx29uf64IcdDcyfQAXRbUZaJiEYJaDRZOtnWEUAhEveAmTqY
FEQFvM+AY2jigJR0gQAB5dL3C/KoujAAAsJYKGAaOJ+wvJatjyiof9ch0yv7w8uL
LuXtB2wpX+N0RuZo6j9OqgYYLuA+MnDoIFCsC3tNqrF67ovhamFM3JHXDqyS6dW+
2BWdjdQmYNvv4teUwXiYzFN76NeTHIbtPEdVo/lmH/tFTKe4Bpbgn8MTPJ/oUYT5
/+sKmG1JFmF+FUZYiVo0iKx8Cjb3vveySrX4OgAuBnsN4XAUhxEFbyIgkImPdl0S
85pVyWR38Y6T7csNwwVzzoC8XmPgvwjiIAfusCmJFX2rQIrV2KfsLr6MgFQhwJCc
b2Drse+f6zEyMynLRKSbMnRPaqtFYHuftjzdgEWA8oTX7WIKeh4jlUBqAQx5ptbY
K1NYlq0A5VIaK+/pZenJp/7jjTsmQhomVJEku8XgGiHN31jdkWO2i571g8WexyNh
/T5IBdhcV6AJ7wOF6jSAvWEAn+BGvJsYgzwZoAGQtAlyPQtnGCuHHqv9IhLVIylv
wmV696y0XcEesR/8WVeT
=RJPG
-----END PGP SIGNATURE-----

--sP1A+UbkWBB0qc5v--
