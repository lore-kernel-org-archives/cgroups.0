From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Mon, 31 Jan 2022 11:53:19 -0500
Message-ID: <YfgT/9tEREQNiiAN@cmpxchg.org>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kCLY9awXUZ+VaBKEx7Kf5fe8lUKb+8FACIctpfMa/JA=;
        b=vcKL8lE+2CbEB7y6dB2JbuBXT040U9YHCdWxDounbU74q0EijmUnVJ989O7FOH2YfG
         sIyFOWWg/pJqWPPaxxt4JSHVuQrwqNVtNr6SLvVBRxJ2NihBphaaUXwhHi7Ps8gRoRK+
         hzBa0M0K2TBF6HlXg8gEU+nnS0Yyt9XDisazb66sFWHRm9yfzCdH7T+KJNyBdXsyUGB/
         mqaAFN+OPNz38LWlbBIEICRfpAHOdAE93OghZ77qivsyHj6bsGl4RPvxQEouzM+j0agZ
         /MoQ4WH1Jcb20Hbor6rBTGTmrsKgI/wQqvx93dKfYMhQuxtvtGBmRAVxhFhWaFchsH5E
         mpYw==
Content-Disposition: inline
In-Reply-To: <YfeuK5j7cbgM+Oo+-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 31, 2022 at 10:38:51AM +0100, Michal Hocko wrote:
> On Sat 29-01-22 15:53:15, Waiman Long wrote:
> > It was found that a number of offlined memcgs were not freed because
> > they were pinned by some charged pages that were present. Even "echo
> > 1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
> > offlined but not freed memcgs tend to increase in number over time with
> > the side effect that percpu memory consumption as shown in /proc/meminfo
> > also increases over time.
> > 
> > In order to find out more information about those pages that pin
> > offlined memcgs, the page_owner feature is extended to dump memory
> > cgroup information especially whether the cgroup is offlined or not.
> 
> It is not really clear to me how this is supposed to be used. Are you
> really dumping all the pages in the system to find out offline memcgs?
> That looks rather clumsy to me. I am not against adding memcg
> information to the page owner output. That can be useful in other
> contexts.

We've sometimes done exactly that in production, but with drgn
scripts. It's not very common, so it doesn't need to be very efficient
either. Typically, we'd encounter a host with an unusual number of
dying cgroups, ssh in and poke around with drgn to figure out what
kind of objects are still pinning the cgroups in question.

This patch would make that process a little easier, I suppose.
