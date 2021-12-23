From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/memcg: Allow the task_obj optimization only on
 non-PREEMPTIBLE kernels.
Date: Thu, 23 Dec 2021 16:48:41 -0500
Message-ID: <f6bb93c8-3940-6141-d0e0-50144549a4f5@redhat.com>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640296130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8aOo+PkY5S4h+Nfs7B8aAFLKqPmDvtOJfX8JOA95JqA=;
        b=WzHw8uXVCFI0EEXgSUYeXPoomqlPWLFfFpZi8Ez4aX1a39pGpg4TNhTcv/JudN/CMlEkg9
        a28WyYraaZd2PfwhoXqGTWSpS/Q1pm5oBIxWB5WYJ+lJQ5iE5m0B7cA5anf8uINTgiVWEB
        xgHZyjDKEKpREhc3QYR8U5HYhHUKdlE=
Content-Language: en-US
In-Reply-To: <20211222114111.2206248-4-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 12/22/21 06:41, Sebastian Andrzej Siewior wrote:
> Based on my understanding the optimisation with task_obj for in_task()
> mask sense on non-PREEMPTIBLE kernels because preempt_disable()/enable()
> is optimized away. This could be then restricted to !CONFIG_PREEMPTION kernel
> instead to only PREEMPT_RT.
> With CONFIG_PREEMPT_DYNAMIC a non-PREEMPTIBLE kernel can also be
> configured but these kernels always have preempt_disable()/enable()
> present so it probably makes no sense here for the optimisation.
>
> Restrict the optimisation to !CONFIG_PREEMPTION kernels.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

If PREEMPT_DYNAMIC is selected, PREEMPTION will also be set. My 
understanding is that some distros are going to use PREEMPT_DYNAMIC, but 
default to PREEMPT_VOLUNTARY. So I don't believe it is a good idea to 
disable the optimization based on PREEMPTION alone.

Regards,
Longman

