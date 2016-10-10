From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 09:20:14 -0400
Message-ID: <20161010132014.GD29742@mtj.duckdns.org>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu>
 <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org>
 <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S4vb4Mi+f5K5FS89Arpfwc25B/7HGXBHyuXO6EKbOew=;
        b=mFKckj4NeRGo+eFGBfC/4HqgFp6lioqOA4I/XlpWQhmODn1Xc8UYOlEFcROvyZ7r4G
         6LLykdSPtiCQ0zr4YsIrnbaymIK2/l8t3SuP+kKCqYW3ds2Bi4+T4JX0Ewidk+g6HuMT
         F7NY+QreazGN8TbGclbDDI6zMhk6ElxBKiaJKSQpCAquJ7LiB74uqerQogfsGkMRpeP2
         vaMwUhDykRW1LWM3/SEesTzyCgb6yX1mVKq2UFFHi+WM0Ndkx49QhdL0pLBLjGQaaoWp
         biQgVXJdMKti4Djldm+Ug0GzDQganCxtOnCmlB5ZpLLXSwCunzoIDtWx8VglLl+2UUjh
         IC/Q==
Content-Disposition: inline
In-Reply-To: <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Mon, Oct 10, 2016 at 06:43:59PM +0530, Parav Pandit wrote:
> > Also, I don't get what you mean by using percentage and when people
> > brought up this idea, it always has been stemming from
> > misunderstanding.  Can you please elaborate how percentage based
> > proportional control would work?  What would 100% mean when cgroups
> > can come and go?
>
> When 100% is given to one cgroup, all resources of all type can be
> charged by processes of that cgroup.
> Resources are stateful resource. So when cgroup goes away, they go
> back to global pool (or hw).
> Giving 100% to two cgroups is configuration error anyway (or without config).

That isn't proportional control.  That's using percentage as the unit
to implement absolute limits.  Proportional control implies work
conservation.

> As you know weight configuration allows automatic increase/decrease of
> resource to other cgroups when one of them go away, as opposed to
> absolute value. How this is going to work in exact terms for stateful

Hmm.... so are you saying that ti'd be work-conserving?  But what does
it mean to say "30%" and then have it all resources when there are no
other users.  Also, is it even possible to take back what have already
been allocated and are in use?

> Nop. Thats not true.
> (a) Every new resource has to be defined in cgroup_rdma.h
> (b) charge()/uncharge() has to happen by the cgroup for each.
> (c) Letting drivers do will make things fall apart. There are no APIs
> exposed either to let drivers know process cgroup either. There is no
> intention either.
> 
> (d) ratio means -if adapter has
> 100 resources of type - A,
> 80 resource of type - B,
> 
> 10% for cgroup-1 means,
> 10 resource of type - A
> 8 resource of type - B

So, this is not work-conserving.  There's too much confusion here.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
