From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 04:20:29 +0000
Message-ID: <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
References: <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WPAW5OT5aQGqhVqgbp+cQXKRqqTylsnYGW610rCCO18=;
 b=hq8ew5LTxXGPrj6jvVZezUecHsPsdSnmeCR3j60EarDPj9mIkgKaudIBIADFicbdU+t0wBVe272dRb/WKzvTZydt3HC72y2lYqDvXFBD9ZIPeGwKLufiu4S2voC2YFxqPCMc3DLP3VKDV78SfHYxY3P1RSGIZmGUNg0ZxD9aToE=
In-Reply-To: <20161103180006.GL3617-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]

> We (Tejun, Christoph, Matan and me) had a face-to-face talk during KS/LPC=
 and
> decided that the best way to move forward is to export to user one object
> (global HCA like) only and don't export anything else.
>=20
> All internal calculations will be based on this percentage.
>=20
> Once the cgroups users will come with reasonable justification why they n=
eed to
> configure different unexposed objects, we will expose them.

A global HCA metric is indeed in the right direction.
However, rethinking this, I think that we should specify the metric in term=
s of RDMA objects rather than percentage.
Basically, any resource that consumes an IDR is charged.

The reasons are:
- Some HCAs can have a huge amount of resources (millions of objects), of w=
hich even a small percentage may consume a considerable amount of kernel me=
mory.
- We follow the same notion as FD limits, which accounts for numerous resou=
rce types that consume file objects in the kernel (files, pipes, sockets)
- The namespaces for RDMA resources are large (usually 24 bits). So even la=
rge resource counts won't come nowhere close in depleting the namespace. (C=
ompare that to the mere 64K socket port space...)
- The metric measures the actual application usage of resources, rather tha=
n proportional to the resources of a given HCA adapter.
- We can continue to use the cgroup mechanism for charging (just as in the =
original proposal)

I have discussed this matter with Doug and Matan, and it seems like this is=
 the right direction.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
