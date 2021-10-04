From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: optimize flush through speculative test
Date: Mon, 4 Oct 2021 07:44:24 -1000
Message-ID: <YVs9eJnNJYwF/3f3@slm.duckdns.org>
References: <20210929235936.2859271-1-shakeelb@google.com>
 <YVszNI97NAAYpHpm@slm.duckdns.org>
 <CALvZod5OKz=7pFpxCt1CONPyJO4wR5t+PH0nzdbFBT1SYpjrsg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GlP8WaB0zRZgpiKdt/BSMoK6ihgOV+T5zAu0xpLxZyQ=;
        b=MrX57fwHmCyrgUKhL9es+GURrgy7bi5kQGDxIwCkl/coK/2RZmEGBuZqtlgxCmVqaB
         uzqBtWgowXjuQRyRlJVYwDRdEJfkE1/MSIM/+EvBZoCemlBJCMW2Qv4PtgHAHXssT5aP
         SKBBWXGjLZ+uQM6T35vAGDIxPKQr7EeyhcZDwKMVxCcGaf+nzpvl1HDMRFPR1nhteoTH
         j33ozfp/gml4Fy2CPQ0RSY/5HyZ4uWzgUb2TMxSXMpsvN8UvfjFK7rJrb20juqnzkT+9
         FXTdO9B8WR2O8ZIpKjcHY7p+18d2PiA2ECq2gNUDUOO95wuHitclGuSVWLBNpMDEqG6s
         sFgw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod5OKz=7pFpxCt1CONPyJO4wR5t+PH0nzdbFBT1SYpjrsg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Oct 04, 2021 at 10:25:12AM -0700, Shakeel Butt wrote:
> > > To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
> > > a system with swap-on-zram and the file was pushed to swap through
> > > memory.force_empty interface. On reading the whole file, the memcg stat
> > > flush in the refault code path is triggered. With this patch, we
> > > observed 38% reduction in the read time of 8 GiB file.
> >
> > The patch looks fine to me but that's a lot of reduction in read time. Can
> > you elaborate a bit on why this makes such a huge difference? Who's hitting
> > on that lock so hard?
> 
> It was actually due to machine size. I ran a single threaded workload
> without any interference on a 112 cpus machine. So, most of the time
> the flush was acquiring and releasing the per-cpu rstat lock for empty
> trees.

Sorry for being so slow but can you point to the exact call path which gets
slowed down so significantly? I'm mostly wondering whether we need some sort
of time-batched flushes because even with lock avoidance the flush path
really isn't great when called frequently. We can mitigate it further if
necessary - e.g. by adding an "updated" bitmap so that the flusher doesn't
have to go around touching the cachelines for all the cpus.

Thanks.

-- 
tejun
