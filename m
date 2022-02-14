From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] mm/memcg: Revert ("mm/memcg: optimize user
 context object stock access")
Date: Mon, 14 Feb 2022 11:23:33 -0500
Message-ID: <YgqCBU4mVwkgnBi2@cmpxchg.org>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x0S57OtD5YWbc+A1GxyslYvaWYv57bktzT6DJRKKi4o=;
        b=2KF50jQJOk201/VzTxLzvo9tjknPWNwu2jq/ZfgmRAUVpqtndEci1YGElVvMe9FLtS
         GEfQPmOnDIboOy2xW5TOVpQM9OThMYIKu5l0KeXWoW30aMdjupqwujmJ/pRkgFCbrWBn
         XGeLik/uEYbK2QO5lhy251iXcjVaIbny5gymo5CB+wGit2CHhHKfqyIToIviWlzyTrsA
         cilVLQw40SsmdtHZq73lUfhv3Skge2BiknSX0i4YI+KGEoZpL78HoSL1R3ahdQrq/c4D
         JtVmvLR3+a2yrPHIUSb0QlGWoNa9y33b+j8jakbnOySnimEPhzB0aqbdWYdq9UM1buCZ
         BJ2w==
Content-Disposition: inline
In-Reply-To: <20220211223537.2175879-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Fri, Feb 11, 2022 at 11:35:34PM +0100, Sebastian Andrzej Siewior wrote:
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> The optimisation is based on a micro benchmark where local_irq_save() is
> more expensive than a preempt_disable(). There is no evidence that it is
> visible in a real-world workload and there are CPUs where the opposite is
> true (local_irq_save() is cheaper than preempt_disable()).
> 
> Based on micro benchmarks, the optimisation makes sense on PREEMPT_NONE
> where preempt_disable() is optimized away. There is no improvement with
> PREEMPT_DYNAMIC since the preemption counter is always available.
> 
> The optimization makes also the PREEMPT_RT integration more complicated
> since most of the assumption are not true on PREEMPT_RT.
> 
> Revert the optimisation since it complicates the PREEMPT_RT integration
> and the improvement is hardly visible.
> 
> [ bigeasy: Patch body around Michal's diff ]
> 
> Link: https://lore.kernel.org/all/YgOGkXXCrD%2F1k+p4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
> Link: https://lkml.kernel.org/r/YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
