From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 10 Oct 2016 08:25:45 -0400
Message-ID: <20161010122545.GA27360@mtj.duckdns.org>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu>
 <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uYOBbbNpzbMTS2wMt+HnZycMyku+R+xnJxWXEM0I9hc=;
        b=zdWPx3/l85Sx+LaQmnUph55cbYbGQC0u9Q2srPK67563c8MVCc0i7rFZVkCey/raMG
         sY8e+f+isUmx7PdianHcG089uOYbPjA0ZXcl99s0XQACRTr1BpQ386B6QMZh0rZ0aWfM
         tbTjHbdk9c4A8/C0RoJiwUDwz7Dutyu3EG1m5w9HIKFI9MgPXLquow8rhjj37MiTingJ
         pvx2ygYxYb5sGjdeEehdbDAyb1PE51E0fH2DCGoWUpPlbx0tMtevWEIxmlwIDhCjcbkS
         qzbQcwFGGEuBimLlD7fw22nNySvzcRzyI042fOexTQrzP3mCpSZdd+hx6XvFi10WbaAm
         WFqA==
Content-Disposition: inline
In-Reply-To: <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Mon, Oct 10, 2016 at 11:59:45AM +0530, Parav Pandit wrote:
> >> Weight can be in range of 1 to 10,000 similar to cpu cgroup.
> >
> > This is exactly what I don't like, the percentage will remove from the
> > user the translation needs between weight and actual limitation.
> >
> > IMHO CPU used weights because everything there is in weights :).
>
> I admit weight are not very intuitive, I was aligning to the existing
> other cgroup interfaces which achieves similar functionality.
> I will let Tejun approve the "percentage" or "ratio" new file
> interface as its little different than weight.

So, if there is gonna be a proportional control mechanism, it should
use the same interface convention as other proportional controls.
Also, I don't get what you mean by using percentage and when people
brought up this idea, it always has been stemming from
misunderstanding.  Can you please elaborate how percentage based
proportional control would work?  What would 100% mean when cgroups
can come and go?

If you're suggesting expressing absolute limits in terms of
percentage, that is not proportional control.  That's just using a
different unit for absolute resource limits and it must not be called
weight.

> weight or percentage helps in abstracting as starting point. So I like
> to add it too.

Way back, when rdmacg was proposed first, I asked the same question -
whether there can be a higher level abstraction for rdma resources,
and, IIRC, the collective answer was that the there can be no
universal measure of resources in the kernel because a large part of
resource management actually takes place in userspace.

If I misunderstood, please correct me but what's being suggested here
seems to be implementing the knob in rdamcg and letting the specific
drivers worry about the actual resource provisioning and even then
there doesn't seem to be a clear way of semantically defining what
ratios would mean.

Let's please first establish what the resource control would exactly
mean.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
