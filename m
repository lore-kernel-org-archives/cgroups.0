From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 20 Oct 2016 00:33:53 +0530
Message-ID: <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
References: <20161010044623.GI9282@leon.nu> <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org> <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org> <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
 <20161013231413.GA32534@mtj.duckdns.org> <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org> <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=JigqPBucuOb5iFORo+qpbeUsiYyZTO/+CrWNSWHwUzk=;
        b=Cha24bxghXH/GuG2cVRxXM+wGU6bNH5t7q48rTs3Dy/JgybrxSx7EMuCmAORchk0Pi
         nWUFQnZKvM4/ZRKnmOtdyDeqPPw+2wUvynXIe7EE7BIrRA40NVx5a781v7mf3gyornHJ
         Hn8pvogG2XTU9fjNZl1oA4AlaF8W7m6Qy6xc2i7fS6OKW9e+eoKiRLDszGuIMwRkqdw3
         pBOAVQtL/Fvx+7E/In4CcTS3T3SnpI1If3HLECV67sA6kL9gNN7eBNhYIzjqvHKslcDO
         VnjVjyy9uyuqO1kkt3/07GWD8qWZQAkV+UWb26QWOekCg/FvHlIvMjMoXj+p582Rlx88
         gdvw==
In-Reply-To: <20161019143345.GA18532-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

On Wed, Oct 19, 2016 at 8:03 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Oct 19, 2016 at 03:04:52PM +0530, Parav Pandit wrote:
>> > Heh, we can go for per-mil and use %0 as the suffix if absolutely
>> > necessary but is this a real issue?
>>
>> We need to provide current version to exceed the 100 containers limit first. :-)
>> Please let me know if such user interface already exist as reference point.
>> I prefer to avoid introducing such configuration.
>
> We don't have such usage yet.  rdmacg would be the first one doing
> something like this.
>
>> > I think it's a lot more consistent to implement all absoulte limits
>> > through max.
>>
>> I agree. I will implement reporting actual max values instead of
>> reporting "max" string so that percentage configuration can be done by
>> the user space tools.
>> (post merging of v12).
>> Waiting for direction from Doug.
>
> That doesn't sound like a good idea.  What happens when the amount of
> available resources changes either through underlying resource changes

To my knowledge device configuration cannot change on the fly while
its still active.
PCIe SR-IOV VF might be able to do so. In that case we might need to
introduce event notifier framework.
This can be possibility regardless of percentage configuration if such
device comes up.
However this appears far fetched.

> or config changes in one of the ancestors?  What "max" means is "no
> limit is imposed" which is different from "limit it to 100% of what's
> currently available".
Charging is hierarchical for rdmacg too.
rdma.max configuration exist at all the levels so ancestors change
won't affect its children.
rdma.max absolute (or future percentage) value is with reference to
the total device resources.


> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
