From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 11/13] cgroup/drm: Introduce weight based drm cgroup control
Date: Mon, 28 Nov 2022 09:50:52 -1000
Message-ID: <Y4URHHISpZaFQmj6@slm.duckdns.org>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
 <20221109161141.2987173-12-tvrtko.ursulin@linux.intel.com>
 <Y30/MIsLmVAZ7pQi@slm.duckdns.org>
 <30f42096-3f42-594e-8ff1-c09341925518@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcEtc6FEdThSJ79tsOLA2O9TxilKdXYytFRNDoxtA04=;
        b=Aw1VZ/t2cZu24hm4yg+tGuPK2iELH1xl3jtew5qH7h9YSqh8iFmCHquLUDH54gKQN4
         0afy7+2/I6ibVLxwN3XVSKTzJ5VDAv9OvhaQADeaGwNZxXa6Pijl1R1Uj3Y2qnn6qRmU
         uj5EshG1kfx+RglivS+2KsjQn+Be/uKUDHdqcfPpf/3QITRA1xPky2V2nfIpZBSs5n1D
         DdI0yI7hyJ6Pub4pQwX5Z1GsGnaot0QNT/CopFyGT4GBwjQ3pq2QJ5MSV3J/N0gjKh+L
         GAxgrtiTXbX7z3RLpRp6qNGiHAICpzqZijAeBzN5/Rd/KtVTHB7aBHWT9OT72ZNZiq3K
         nS3g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <30f42096-3f42-594e-8ff1-c09341925518-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Thu, Nov 24, 2022 at 02:32:25PM +0000, Tvrtko Ursulin wrote:
> > Soft limits is a bit of misnomer and can be confused with best-effort limits
> > such as memory.high. Prolly best to not use the term.
> 
> Are you suggesting "best effort limits" or "best effort <something>"? It
> would sounds good to me if we found the right <something>. Best effort
> budget perhaps?

A more conventional name would be hierarchical weighted distribution.

> Also, when you mention scalability you are concerned about multiple tree
> walks I have per iteration? I wasn't so much worried about that, definitely
> not for the RFC, but even in general due relatively low frequency of
> scanning and a good amount of less trivial cost being outside the actual
> tree walks (drm client walks, GPU utilisation calculations, maybe more). But
> perhaps I don't have the right idea on how big cgroups hierarchies can be
> compared to number of drm clients etc.

It's just a better way doing this kind of weight based scheduling. It's
simpler, more scalable and easier to understand how things are working. The
basic idea is pretty simple - each schedulable entity gets assigned a
timestamp and whenever it consumes the target resource, its time is wound
forward by the consumption amount divided by its absolute share - e.g. if
cgroup A deserves 25% of the entire thing and it ran for 1s, its time is
wound forward by 1s / 0.25 == 4s. There's a rbtree keyed by these timestamps
and anything wanting to consume gets put on that tree and whatever is at the
head of the tree is the next thing to run.

Thanks.

-- 
tejun
