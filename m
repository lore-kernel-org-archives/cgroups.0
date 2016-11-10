From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 10 Nov 2016 12:32:17 -0500
Message-ID: <20161110173217.GD26105@htj.duckdns.org>
References: <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu>
 <20161110164638.GC26105@htj.duckdns.org>
 <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=duNqVGwO6UKTjCFc2rFjhF0Kmc30Lr7vHCm8M6r4Dq4=;
        b=rlGgTHKM5gNQSW1ZLaQl33bhacwp8clADpvevXsfPp9nO4hpcwOdpUBMN1CcMbMK9K
         9VMTnirUB3chcv4lNeQntTBpTxALDhSc7rHaV7hsbjskJoUAKbZRt02mUt9amtBRhcI4
         Bc969ZRJfc3zQemqPmanyhi9BUHY/gvPXlArivncdT55Sgs6N3NEeZO3ZQQhxPxeddTA
         rQ20x43tCnMel8+xzJ2/IG6f8Jo/0ZOmHXbjZnH4FFw/yCbpQVo9SlzNnZR8Ko/MqsHN
         cN96YItrV+GX7DgO+VhH8KdXYvJ6hLgi6Nym01lXZZMi2x6Vrl36lSuiKn6KUy18KAEV
         6FdA==
Content-Disposition: inline
In-Reply-To: <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Thu, Nov 10, 2016 at 10:34:44PM +0530, Parav Pandit wrote:
> user-kernel interface:
> ---------------------------
> (a) rdma.current - Will continue to report resource count.
> (b) rdma.max - will continue to accept hca_handles, and hca_objects as
> absolute number.
> 
> Instead of mr, pd, qp, ah, srq entries of patch_v12, it will have just
> two entries for each device.
> (1) hca_handles, (2) hca_objects.
> 
> rdmacg - IB stack interface:
> --------------------------------
> cgroup_rdma.h will have two enum entries.
> 
> RDMACG_RESOURCE_HCA_HANDLE
> RDMACG_RESOURCE_OBJECT
> 
> IB stack will charge either of the object.
> When HCA handles are allocated/freed IB core will request charge/uncharge.
> When standard verb resources such as PD, MR, CQ, QP, SRQ are
> allocated/freed IB core will request for XX_OBJECT charge/uncharge.
> 
> Currently defined APIs and interfaces just remains same.

That looks great to me from cgroup side.  Do you have plans for
exposing the maximum numbers available?

Thanks.

-- 
tejun
