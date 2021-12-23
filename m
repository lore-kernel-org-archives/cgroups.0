From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Wed, 22 Dec 2021 21:31:36 -0500
Message-ID: <bdfc9791-4af2-f4fb-9ef5-dab1e2e3ff89@redhat.com>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640226701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ndDsEl87XhT/7c03RwGZ3BUnuqirZACHRsfL75QimI4=;
        b=bbwNGcwXFMSx3M8piN8CZy1Jtfy09LSAB44oWBnJIh85iN3QYokhcUQdaMCvnW3JrMvezk
        eFFigbMQn6eJ7RKAxRFBJDWzTv712qIPD52kVKiHN8/gdBHWO1OXArNL1Jvz5yFIOyQ5Vs
        Yiq8aK0rHdT//0lRrjL0DO1fhgIXA1M=
Content-Language: en-US
In-Reply-To: <20211222114111.2206248-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 12/22/21 06:41, Sebastian Andrzej Siewior wrote:
> The per-CPU counter are modified with the non-atomic modifier. The
> consistency is ensure by disabling interrupts for the update.
> This breaks on PREEMPT_RT because some sections additionally
> acquire a spinlock_t lock (which becomes sleeping and must not be
> acquired with disabled interrupts). Another problem is that
> mem_cgroup_swapout() expects to be invoked with disabled interrupts
> because the caller has to acquire a spinlock_t which is acquired with
> disabled interrupts. Since spinlock_t never disables interrupts on
> PREEMPT_RT the interrupts are never disabled at this point.
>
> The code is never called from in_irq() context on PREEMPT_RT therefore

How do you guarantee that these percpu update functions won't be called 
in in_irq() context for PREEMPT_RT? Do you think we should add a 
WARN_ON_ONCE(in_irq()) just to be sure?

Cheers,
Longman

