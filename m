From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Tue, 7 Dec 2021 11:55:38 -0500
Message-ID: <Ya+SCkLOLBVN/kiY@cmpxchg.org>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jBIRb58Y6btL+TAXKBtqGWyLSLmb/GcxbXs8B9okoJI=;
        b=xVie4c8Jj9A8d6UbzG2D4i8Nvmdt8QlQvLgRCKAHD0yC9kTB2O9kIE+hhm7KY3Dm75
         ah5bV+hSCiX04qN/2IR96z3IsKqa4ziG2K1mYHVCveyzJZBvuwNBRm3DnF0g3d5emx1Z
         2yc9H4rHwU8lLtJs6wHrpSLCv9NY8zhv31ZF3/UhvqukVcCbjKD9+Eoeo50rxWwlVozJ
         h8uQAdPtl0qp4dmuVcV0ts5oYWQY7wusgeEbP9Y+6rt6pL5B4BHgvtiG5LIUqY31aof3
         pY0C8UK3RS5LBPrnCFuA9LMp8pIC4Tue6Jfz+oMmvliC3aAdw7AbunTRstt3Tnl8a1Ul
         5juw==
Content-Disposition: inline
In-Reply-To: <20211207155208.eyre5svucpg7krxe-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Dec 07, 2021 at 04:52:08PM +0100, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> 
> MEMCG has a few constructs which are not compatible with PREEMPT_RT's
> requirements. This includes:
> - relying on disabled interrupts from spin_lock_irqsave() locking for
>   something not related to lock itself (like the per-CPU counter).

If memory serves me right, this is the VM_BUG_ON() in workingset.c:

	VM_WARN_ON_ONCE(!irqs_disabled());  /* For __inc_lruvec_page_state */

This isn't memcg specific. This is the serialization model of the
generic MM page counters. They can be updated from process and irq
context, and need to avoid preemption (and corruption) during RMW.

!CONFIG_MEMCG:

static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
					 int val)
{
	struct page *page = virt_to_head_page(p);

	mod_node_page_state(page_pgdat(page), idx, val);
}

which does:

void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
					long delta)
{
	unsigned long flags;

	local_irq_save(flags);
	__mod_node_page_state(pgdat, item, delta);
	local_irq_restore(flags);
}

If this breaks PREEMPT_RT, it's broken without memcg too.

> - explicitly disabling interrupts and acquiring a spinlock_t based lock
>   like in memcg_check_events() -> eventfd_signal().

Similar problem to the above: we disable interrupts to protect RMW
sequences that can (on non-preemptrt) be initiated through process
context as well as irq context.

IIUC, the PREEMPT_RT construct for handling exactly that scenario is
the "local lock". Is that correct?

It appears Ingo has already fixed the LRU cache, which for non-rt also
relies on irq disabling:

commit b01b2141999936ac3e4746b7f76c0f204ae4b445
Author: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Wed May 27 22:11:15 2020 +0200

    mm/swap: Use local_lock for protection

The memcg charge cache should be fixable the same way.

Likewise, if you fix the generic vmstat counters like this, the memcg
implementation can follow suit.
