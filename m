From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/memcg: Allow the task_obj optimization only
 on non-PREEMPTIBLE kernels.
Date: Mon, 3 Jan 2022 15:44:43 +0100
Message-ID: <YdML2zaU17clEZgt@linutronix.de>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-4-bigeasy@linutronix.de>
 <f6bb93c8-3940-6141-d0e0-50144549a4f5@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1641221085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MMUvJRIkEcl/HJeYgUz7jPr4JCoO6K1Up59xnJmJgyk=;
        b=yGq7pCT9OQF2OULtqlUID71JjXUJRRIthcE3nLvs3IsuEMDmm7DKB6BwqR4feaD0QBdqJ6
        9+CnBU37MXDi5u+P8dBMjQ52TujOG/k0wD6fJ9ty2CyVFJ0/t1H75r7XosdVhTDGQZyvDI
        PIwNhBd3XbVr1m43ohKrl2OgtoiaTnXryWDXwzpKEhsMrJtRn5hZv6iVSxgHhpflcddZe2
        vYJ7lfVDp26v45pbMY8WxDdXzSFu+mBw0PqZ36lc1CQLixFDcsZTkpTBRO81wjAN7XxoUt
        tC4CshvqEhjxTRbAIWDjJGeEMrKSZVdzxXWT2z5klLBvclteEdxUQbx9CqLA+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1641221085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MMUvJRIkEcl/HJeYgUz7jPr4JCoO6K1Up59xnJmJgyk=;
        b=hYVBfawsiIaUZryqk/cOnDY1U28vyW23NzoboozVAU01QeqNXSM4bL0gqFY70HduRTVSkY
        SAC66k1iOvK0NbCA==
Content-Disposition: inline
In-Reply-To: <f6bb93c8-3940-6141-d0e0-50144549a4f5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2021-12-23 16:48:41 [-0500], Waiman Long wrote:
> On 12/22/21 06:41, Sebastian Andrzej Siewior wrote:
> > Based on my understanding the optimisation with task_obj for in_task()
> > mask sense on non-PREEMPTIBLE kernels because preempt_disable()/enable()
> > is optimized away. This could be then restricted to !CONFIG_PREEMPTION kernel
> > instead to only PREEMPT_RT.
> > With CONFIG_PREEMPT_DYNAMIC a non-PREEMPTIBLE kernel can also be
> > configured but these kernels always have preempt_disable()/enable()
> > present so it probably makes no sense here for the optimisation.
> > 
> > Restrict the optimisation to !CONFIG_PREEMPTION kernels.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> 
> If PREEMPT_DYNAMIC is selected, PREEMPTION will also be set. My
> understanding is that some distros are going to use PREEMPT_DYNAMIC, but
> default to PREEMPT_VOLUNTARY. So I don't believe it is a good idea to
> disable the optimization based on PREEMPTION alone.

So there is a benefit to this even if preempt_disable() is not optimized
away? My understanding was that this depends on preempt_disable() being
optimized away.
Is there something you recommend as a benchmark where I could get some
numbers?

> Regards,
> Longman

Sebastian
