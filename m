From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/5] mm/memcg: Revert ("mm/memcg: optimize user context
 object stock access")
Date: Fri, 18 Feb 2022 08:09:36 -0800
Message-ID: <CALvZod5FdXwim6ftgBqQRiXw6exv-Jj9ey+awkVDC1F8YTOBMQ@mail.gmail.com>
References: <20220217094802.3644569-1-bigeasy@linutronix.de> <20220217094802.3644569-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8gUAABA3j3f1FRh38YxGuqY86VzPDifyEVw8iwRRkpw=;
        b=cyWkAO0iWWXZ5RX3hmvLYfEnD4qtbZcgGTUs/I4Eg1grFIrrB5/Wd595bPPNN8gV75
         4uLVzqdO6mgrPtNahiDzECg+2hz2mpA/jll0Uz1e9vE3/dEfS2cHeJ7a6ELdiCq72hDx
         gBhiBpg+mRkGjwza4EY6K7UOBZ7+u69+V0AUR9zA02dO0T0bJB2yvtXHpZGOfELslWYp
         Jqzrp1aTYcHK5wKyzEHcIraox5zejrYEfvGtu64Lluf3xQcg3piCrWRqWf56z/DTi0f8
         VKyGAm8RBs2yYcH8wVnBOGwrQZiC8x90T/EmeljJ9eCVe24yF5+2EKiUZuBwMHqhtcB/
         TQzg==
In-Reply-To: <20220217094802.3644569-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Feb 17, 2022 at 1:48 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
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
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
