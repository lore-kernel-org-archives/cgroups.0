From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 09:49:00 -0400
Message-ID: <20200818134900.GA829964@cmpxchg.org>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818100516.GO28270@dhcp22.suse.cz>
 <20200818101844.GO2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i3gzOAPUdUUgkW+MfJiRBZzylD1SwKDup35ranLTE+8=;
        b=gFo2tdrjm1qkUJWuDiFskzbeO0w5LJx6dyzsZOPwPfOmHDSXzdBGEcXIwDX7whrNV9
         JEgVlPiTxZyMBirBuYCHGck9cYWCBQmt5ny0jayeNQ6gfZp4LNLHaLYVZRHrSHKeUY6e
         uRSpvrjdgx5mqhJbaHjlzb+ptaePm6k7omgqsuP3hL/1RmdPdVTPoALIZZdr5eyJ54WL
         dsftHxbUTIR9tXIDvqG8jN4H2/lH+Rf1hR50Z0vtfC6A7sLoLgtiM/v15If1BpTZRwDI
         SAX24oCanz2Ny6U8qxDU6UGtpXs/jD/FGeqLm7SIrw5GSVnzTYUHBo7UfMACrG1lFPPe
         a1mA==
Content-Disposition: inline
In-Reply-To: <20200818101844.GO2674-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Aug 18, 2020 at 12:18:44PM +0200, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> What you need is a feeback loop against the rate of freeing pages, and
> when you near the saturation point, the allocation rate should exactly
> match the freeing rate.

IO throttling solves a slightly different problem.

IO occurs in parallel to the workload's execution stream, and you're
trying to take the workload from dirtying at CPU speed to rate match
to the independent IO stream.

With memory allocations, though, freeing happens from inside the
execution stream of the workload. If you throttle allocations, you're
most likely throttling the freeing rate as well. And you'll slow down
reclaim scanning by the same amount as the page references, so it's
not making reclaim more successful either. The alloc/use/free
(im)balance is an inherent property of the workload, regardless of the
speed you're executing it at.

So the goal here is different. We're not trying to pace the workload
into some form of sustainability. Rather, it's for OOM handling. When
we detect the workload's alloc/use/free pattern is unsustainable given
available memory, we slow it down just enough to allow userspace to
implement OOM policy and job priorities (on containerized hosts these
tend to be too complex to express in the kernel's oom scoring system).

The exponential curve makes it look like we're trying to do some type
of feedback system, but it's really only to let minor infractions pass
and throttle unsustainable expansion ruthlessly. Drop-behind reclaim
can be a bit bumpy because we batch on the allocation side as well as
on the reclaim side, hence the fuzz factor there.
