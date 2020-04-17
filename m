From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Fri, 17 Apr 2020 12:23:55 -0400
Message-ID: <20200417162355.GA43469@mtj.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
 <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D81ZHtrbqiwN618Bg4B7aPUCBzzVXf/vmH57VSxsIY4=;
        b=aiPTtHFEp4KVgthHvdAD03AyuQ9cu09DZc3IgvSIUb2DOuuWxUTORySKuFjXakFqHn
         BIhCvxgrp4gmwHUqZL/slxGBP+DEGbPGufukryYKxB8hbxsQZMbKLhd6IS9tP6bXnGei
         W0bR5Lt/w0vPxbT7PhW8AozoqUmDO5NCxBZR+oW2fcuwkzZJ15phuOfjCUduUMxyzLTl
         MlHjMCOdpZGLpxfjXgp+k/x6bDLwl6kxUPsq3Ih8ehx/Wkvonm0IyCX9QRMyLVFEUSV4
         BmbXWZBT/vbTuyHUl3L9AO/ak6pHiaif/8DvuXzZsnH1ew4BGz4v1lgOnEx2eDoE3HyV
         idiw==
Content-Disposition: inline
In-Reply-To: <CALvZod78ZUhU+yr2x1h_gv+VgVGTPnSSGKh_+fd+MeiAKreJvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Apr 17, 2020 at 09:11:33AM -0700, Shakeel Butt wrote:
> On Thu, Apr 16, 2020 at 6:06 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Tejun describes the problem as follows:
> >
> > When swap runs out, there's an abrupt change in system behavior -
> > the anonymous memory suddenly becomes unmanageable which readily
> > breaks any sort of memory isolation and can bring down the whole
> > system.
> 
> Can you please add more info on this abrupt change in system behavior
> and what do you mean by anon memory becoming unmanageable?

In the sense that anonymous memory becomes essentially memlocked.

> Once the system is in global reclaim and doing swapping the memory
> isolation is already broken. Here I am assuming you are talking about

There currently are issues with anonymous memory management which makes them
different / worse than page cache but I don't follow why swapping
necessarily means that isolation is broken. Page refaults don't indicate
that memory isolation is broken after all.

> memcg limit reclaim and memcg limits are overcommitted. Shouldn't
> running out of swap will trigger the OOM earlier which should be
> better than impacting the whole system.

The primary scenario which was being considered was undercommitted
protections but I don't think that makes any relevant differences.

This is exactly similar to delay injection for memory.high. What's desired
is slowing down the workload as the available resource is depleted so that
the resource shortage presents as gradual degradation of performance and
matching increase in resource PSI. This allows the situation to be detected
and handled from userland while avoiding sudden and unpredictable behavior
changes.

Thanks.

-- 
tejun
