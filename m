From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT
Date: Thu, 23 Dec 2021 11:01:37 -0500
Message-ID: <407858bc-a5ad-c17c-3f8b-ac65dc912990@redhat.com>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-2-bigeasy@linutronix.de>
 <bdfc9791-4af2-f4fb-9ef5-dab1e2e3ff89@redhat.com>
 <YcQme8BPFl7P9T02@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640275303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+x9d3eMLDnOzojapyWMBgtJ2Do86y7jIA1pTdOWS/vg=;
        b=gNA589Y55py55zeCMG2Dv8LaDMuTdCcwZhAQ7E2TFA34tePQn/zRwC8IDitf+CWuDg8OyP
        QTeuja6evGmxs+peJjRZBlzMffgHaoSXIAtqnjbIczBN0yDNUk0AvQXiME5tgtlFOZa1Fm
        ohJJx1Wz8KRM5S3Th+eKktWeUIAtc/Y=
Content-Language: en-US
In-Reply-To: <YcQme8BPFl7P9T02-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 12/23/21 02:34, Sebastian Andrzej Siewior wrote:
> On 2021-12-22 21:31:36 [-0500], Waiman Long wrote:
>> On 12/22/21 06:41, Sebastian Andrzej Siewior wrote:
>>> The per-CPU counter are modified with the non-atomic modifier. The
>>> consistency is ensure by disabling interrupts for the update.
>>> This breaks on PREEMPT_RT because some sections additionally
>>> acquire a spinlock_t lock (which becomes sleeping and must not be
>>> acquired with disabled interrupts). Another problem is that
>>> mem_cgroup_swapout() expects to be invoked with disabled interrupts
>>> because the caller has to acquire a spinlock_t which is acquired with
>>> disabled interrupts. Since spinlock_t never disables interrupts on
>>> PREEMPT_RT the interrupts are never disabled at this point.
>>>
>>> The code is never called from in_irq() context on PREEMPT_RT therefore
>> How do you guarantee that these percpu update functions won't be called in
>> in_irq() context for PREEMPT_RT? Do you think we should add a
>> WARN_ON_ONCE(in_irq()) just to be sure?
> There are no invocations to the memory allocator (neither malloc() nor
> free()) on RT and the memory allocator itself (SLUB and the
> page-allocator so both) has sleeping locks. That means invocations
> in_atomic() are bad. All interrupt handler are force-threaded. Those
> which are not (like timer, per-CPU interrupts or those which explicitly
> asked not to be force threaded) are limited in their doing as they can't
> invoke anything that has a sleeping lock. Lockdep or
> CONFIG_DEBUG_ATOMIC_SLEEP will yell here.
> The other counter are protected the same way, see
>    c68ed7945701a ("mm/vmstat: protect per cpu variables with preempt disable on RT")

Thanks for the explanation as I am less familiar with other PREEMPT_RT 
specific changes.

Cheers,
Longman

