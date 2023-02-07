From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Tue, 7 Feb 2023 13:16:47 +0100
Message-ID: <Y+JBL3HZ4ahRSEis@lothringen>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-3-frederic@kernel.org>
 <0f388863-9498-e61e-e2dc-965654544489@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675772210;
        bh=2JXiT/NDBiJUjJkNFjkNT8IoqvYyB9wj9pr5FrsMNEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNl1ztfy4YwyRJx/Nz+Yol0AJxjcjfDDMG2DxzVQoqNwGsBar8AZF6/RTi8x0IzRA
         Ae7c3GBPt5/qN0tVSJnsAyQdKrMP5/xXUnjSF56Y0zXteDiYcmc8ibaGwTKLI55leZ
         51P4LXuWGWv59+2n9H/jZYqDAm5KAMrKQy/O1/d6bf7ZP5lqUUNjTocb/hm/G6qxxL
         HSIlCvzdoi3SjdSq8LpeO4y9z+RN1Sa+52YrjIi+eOjRZFdIA879OYH103BVdMKleo
         rCpqVoHihTVP4ehCvUIYd8ibub1lgD4oU6TG1GjNBmOF2tlV/hrgSQfcF5BSMcX8Rx
         Z0FiDMsBm+JbA==
Content-Disposition: inline
In-Reply-To: <0f388863-9498-e61e-e2dc-965654544489-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Feb 03, 2023 at 10:53:46PM -0500, Waiman Long wrote:
> On 2/3/23 18:24, Frederic Weisbecker wrote:
> > Provide this new API to check if a CPU has been isolated either through
> > isolcpus= or nohz_full= kernel parameter.
> > 
> > It aims at avoiding kernel load deemed to be safely spared on CPUs
> > running sensitive workload that can't bear any disturbance, such as
> > pcp cache draining.
> > 
> > Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >   include/linux/sched/isolation.h | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> > index b645cc81fe01..088672f08469 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -53,4 +53,10 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
> >   	return true;
> >   }
> > +static inline bool cpu_is_isolated(int cpu)
> > +{
> > +	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> > +		 !housekeeping_test_cpu(cpu, HK_TYPE_KERNEL_NOISE);
> > +}
> > +
> >   #endif /* _LINUX_SCHED_ISOLATION_H */
> 
> CPUs in an isolated cpuset partition is similar to HK_TYPE_DOMAIN CPUs as
> load balancing is disabled. I can add an API to access the cpumask and add
> to this API. However, that list is dynamic as it can be changed at run time.
> Will that be a problem? Or should that be used separately?

So that's what I intended first but the dynamic part of cpuset made me
postpone that to better days.

But yes ideally it should look like:

static inline bool cpu_is_isolated(int cpu)
{
    return !housekeeping_test_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
           on_null_domain(cpu_rq(cpu));
}

And there should be a hook in something like detach_destroy_domains()
to flush the pcp cache when a CPU is attached to a NULL domain.

All that with proper RCU synchronization:

       UPDATE                                          READER
       ------                                          ------
       rcu_assign_pointer(cpu_rq(cpu)->sd, NULL);      rcu_read_lock();
       synchronize_rcu();                              if (!cpu_is_isolated(cpu))
       stock = &per_cpu(memcg_stock, cpu);                 schedule_work_on(cpu, &stock->work);
       flush_work(&stock->work);                       rcu_read_unlock()

Thanks.
