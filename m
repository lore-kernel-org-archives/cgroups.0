From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date: Mon, 6 Feb 2023 09:14:02 -0400
Message-ID: <Y+D9Gkuo1/l0Ty9W@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com>
 <87pmawz2ma.fsf@nvidia.com>
 <878rhbflcs.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCVb2MCW9ACGLt45F4faDfRuz+QD/Q3J00b9Ajq9X/0=;
 b=WN3W9culXiSgH8Hi9GEOn2N4O9/VA9C8nSbibbgf9Uh6fHfM5Bj9Yj2qG/8BGJMbr2jOgaMMWtOCYgMXJcSbd47VDwnRi0G4cquOd0ALyNwM7c4iv9gKq1lmgPlzY7B4713jz4fVjT27kWdllX78/rP+1HbRMZbA562ZKAZgHIJZQqeKcdNYSWJyiK460SdPeIMmGPjtxXUt+bG1UUUrZOllqfYRhQSZs1Oe5IpobxA6wpAl9pnICrfQkr2NLwNbhGsej7f9wTAWRmwHanCPbNl4b2202MYZFyqHsBfPm7O1m9eGSRCBpCE3e6IWhFKLwMEKRK1RbTVt9SwPsahGrg==
Content-Disposition: inline
In-Reply-To: <878rhbflcs.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

On Mon, Feb 06, 2023 at 03:36:49PM +1100, Alistair Popple wrote:

> >> But then I don't really know how RDS works, Santos?
> >>
> >> Regardless, maybe the vm_account should be stored in the
> >> rds_msg_zcopy_info ?
> >
> > On first glance that looks like a better spot. Thanks for the
> > idea.
> 
> That works fine for RDS but not for skbuff. 

I would definately put the RDS stuff like that..

> We still need a vm_account in the struct sock or somewhere else for
> that. For example in msg_zerocopy_realloc() we only have a struct
> ubuf_info_msgzc available. We can't add a struct vm_account field to
> that because ultimately it is stored in struct sk_buff->ck[] which
> is not large enough to contain ubuf_info_msgzc + vm_account.

Well, AFAICT this is using iov_iter to get the pages and in general
iov_iter - eg as used for O_DIRECT - doesn't charge anything.

If this does somehow allow a userspace to hold pin a page for a long
time then it is already technically wrong because it doesn't use
FOLL_LONGTERM.

Arguably FOLL_LONGTERM should be the key precondition to require
accounting.

So I wonder if it should just be deleted?

Jason
