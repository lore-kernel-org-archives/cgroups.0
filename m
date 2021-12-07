From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Tue, 7 Dec 2021 11:00:14 -0500
Message-ID: <281a5c45-388f-203e-3c5e-146a85328c78@redhat.com>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638892823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6jwf6epYrICYcmePyRn09ib6008dY63VibUD3hoHT0=;
        b=Hlv2gxBSGvI5YUmPvs+90Iv8HP6knQQ2IPI3l9ZJspytft7TBqa/PRXp6HQBWfk5uVdZ3O
        VDMSkIy/Xn1GufwYJdg1PCrqSyq1NJS5RlL5DmS3KI9piD/r6GU+SlJ/g++NKEV3Mqkna6
        gjv0JNC7Hm3pnbM0kZXWw6Sh8xkuL8I=
Content-Language: en-US
In-Reply-To: <20211207155208.eyre5svucpg7krxe-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 12/7/21 10:52, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>
> MEMCG has a few constructs which are not compatible with PREEMPT_RT's
> requirements. This includes:
> - relying on disabled interrupts from spin_lock_irqsave() locking for
>    something not related to lock itself (like the per-CPU counter).
>
> - explicitly disabling interrupts and acquiring a spinlock_t based lock
>    like in memcg_check_events() -> eventfd_signal().
>
> - explicitly disabling interrupts and freeing memory like in
>    drain_obj_stock() -> obj_cgroup_put() -> obj_cgroup_release() ->
>    percpu_ref_exit().
>
> Commit 559271146efc ("mm/memcg: optimize user context object stock
> access") continued to optimize for the CPU local access which
> complicates the PREEMPT_RT locking requirements further.
>
> Disable MEMCG on PREEMPT_RT until the whole situation can be evaluated
> again.

Disabling MEMCG for PREEMPT_RT may be too drastic a step to take. For 
commit 559271146efc ("mm/memcg: optimize user context object stock 
access"), I can modify it to disable the optimization for PREEMPT_RT.

Cheers,
Longman


> [ bigeasy: commit description. ]
>
> Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> ---
>   init/Kconfig |    1 +
>   1 file changed, 1 insertion(+)
>
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -943,6 +943,7 @@ config PAGE_COUNTER
>   
>   config MEMCG
>   	bool "Memory controller"
> +	depends on !PREEMPT_RT
>   	select PAGE_COUNTER
>   	select EVENTFD
>   	help
>

