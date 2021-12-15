From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH-next v3] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Tue, 14 Dec 2021 20:36:57 -0800
Message-ID: <20211215043657.ngmxlk6rgc2ysbmz@offworld>
References: <20211214144412.447035-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211214144412.447035-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Tue, 14 Dec 2021, Waiman Long wrote:

>@@ -2189,7 +2194,7 @@ static void drain_local_stock(struct work_struct *dummy)
>	 * drain_stock races is that we always operate on local CPU stock
>	 * here with IRQ disabled
>	 */
>-	local_irq_save(flags);
>+	local_lock_irqsave(&memcg_stock.lock, flags);
>
>	stock = this_cpu_ptr(&memcg_stock);
>	drain_obj_stock(&stock->irq_obj);

So here there is still the problem that you can end up taking sleeping locks
with irqs disabled via obj_cgroup_put() >> obj_cgroup_release() - ie: the
percpu_ref_switch_lock and css_set_lock. It had occurred to me to promote
the former to a raw spinlock, but doubt we can get away with the latter.

Thanks,
Davidlohr
