From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 18:38:37 +0200
Message-ID: <20161110163837.GE28957@leon.nu>
References: <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu>
 <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZRyEpB+iJ+qUx0kp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--ZRyEpB+iJ+qUx0kp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 10, 2016 at 01:11:18PM +0530, Parav Pandit wrote:
> Hi Leon, Tejun, Christoph, Liran,  Doug, Matan,
>
> So are you ok with below proposal?

I'm fine with it and it looks like very clean approach
to solve our multi-object future.

>
> 1. Define two resources by rdmacg.
> (a) hca_handles (covers doorbell pages)
> (b) hca_resources (mr, pd, qp, srq, vendor defined, all consolidated count)
> Both cannot be combined as explained in [1].
>
> 2. User configures absolute count for above two resources (similar to
> today's file descriptors, pid cgroup controller max limit)
>
> Leon,
> Let us know if you have any further discussions during LPC on
> questions of [2] in using percentage based scheme or otherwise.

No, we didn't have.

>
> Parav
>
> [1] https://www.spinics.net/lists/linux-rdma/msg42771.html
> [2] https://www.spinics.net/lists/linux-rdma/msg42768.html
>
>
>
> On Tue, Nov 8, 2016 at 1:42 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >> From: Parav Pandit [mailto:pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> >
> >> >
> >> > Hmm..
> >> > I guess that you are right.
> >> >
> >> > So we can add another count for "HCA handles",
> >> I prefer this. This keeps it vendor agnostic and clean if we don't go percentage
> >> route.
> >
> > OK; let's do it.
> >
> >> Would indirection table also fall in this category?
> >>
> >
> > No. It's just another HCA resource...
> >
> >> > or alternatively, each provider will restrict the number of handles
> >> > per device to a reasonable small number (which won't be treated as one of the
> >> "HCA resources").
> >> This would require vendor drivers to get the understanding of cgroup object
> >> and pid and that breaks the modular approach. I like to avoid this.
> >>
> >> > Typically, a process shouldn't need to open more than a single handle...
> >> Right. well behaved application won't do multiple handles.

--ZRyEpB+iJ+qUx0kp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJKKNAAoJEORje4g2clin0gEQAM+mbzJCErSu4fqp02TAiqDd
jP1ubrKtE2Pg9QR05vFwvFlB/62R+xpr8dApAokGk2XaJWAVoSd11I7dNrFac9OP
Qr+gztkUAT6IN754P+7SxQNuBig+zX1cOHy6sZX18A4tSruPk8YGZ4uj7/v4Mv7y
Fw/JYLHjzxlOkzsdFDaHH3wFBoo5/ThHFpoX+0SCf3I/O7ZtjYcwhiBmyKCagqbP
13K9R9q6XlkJObvDNLCz84asqV7tAmbDsiuYFqvYqVxun88Fag67F7acUs3BUNIz
BbnPkeVAwh6lwwqlpmqZOw6edkGCW3FD4/L+LbVNxdPUNNhF8deakOixJKXYAo2v
D1sy0vmnBLVgpjudlXYHGdCkl5ctM+QjvAZBDCPYR2032iKr3NRXD/8jhJQ/JSoU
2pcAHNGM/cKkreZWT3f70RMz9+twuGAfmHFEsHCRZy0Rv7aTyyX2zahkyjyb6Qa6
aN7Z3PeCRfPx10XA/nPrQGxaVlnsWe/si9d88jVT8nZ1MU219SyFdbM4NsqsIdHO
j0JKF5kSoHaPmrnPvFXiETrymZ5EUpk8dZjrSZjdrTpdnimFZ8ju+76XFPr0yGlg
VoOundnJXC8wdSJiEjK3psF4ZwD4+C+cp2Y1RmVnQD2ccMq1RYG3a/YwWsdFkKLm
REdJPO8H7t7uPGH8vdeS
=wq4a
-----END PGP SIGNATURE-----

--ZRyEpB+iJ+qUx0kp--
