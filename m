From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm/memcg: Add a local_lock_t for IRQ and TASK object.
Date: Tue, 1 Feb 2022 16:29:35 +0100
Message-ID: <YflR3/RuGjYuQZPH@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-4-bigeasy@linutronix.de>
 <YfFmxH1IXeegNOa9@dhcp22.suse.cz>
 <YfKHxKda7bGJmrLJ@linutronix.de>
 <YfkhsiWHzsyQSBfl@dhcp22.suse.cz>
 <Yfkjjamj09lZn4sA@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643729375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zSBg3nPWuNIwbLhGHez+BKTr0BYdn5qn2z9ShJZjgw8=;
        b=r9uApZUC2gSP8IWVhMEXOBCd81yy+Rrx+VyO5jX55MI1A0eqMr6RgEcnASEW/oOxPXo0dy
        Os/1BBc6LyHfW8ISc8Oc1cDkOi5TC+kFpwKWio/8eOK8RocMKYsP3j6FqFwH6X/0HljnYc
        YnP3+cnHuO5EXywFEEZEJsBTfBd4eIQ=
Content-Disposition: inline
In-Reply-To: <Yfkjjamj09lZn4sA-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 01-02-22 13:11:57, Sebastian Andrzej Siewior wrote:
> On 2022-02-01 13:04:02 [+0100], Michal Hocko wrote:
> > 
> > Thanks! This gives us some picture from the microbenchmark POV. I was
> > more interested in some real life representative benchmarks. In other
> > words does the optimization from Weiman make any visible difference for
> > any real life workload?
> 
> my understanding is that this was micro-benchmark driven.

Weiman was this driven by any real world workload?

> > Sorry, I know that this all is not really related to your work but if
> > the original optimization is solely based on artificial benchmarks then
> > I would rather drop it and also make your RT patchset easier.
> 
> Do you have any real-world benchmark in mind? Like something that is
> already used for testing/ benchmarking and would fit here?

Anything that even remotely resembles a real allocation heavy workload.

-- 
Michal Hocko
SUSE Labs
