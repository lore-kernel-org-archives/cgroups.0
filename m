Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA623290DE;
	Thu, 18 Jun 2026 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814481; cv=none; b=CO854zxXbaWV3oLgEuZ6A7b4Gt1OoUGGk9B6Ow/ntdiQGRHvFWDUIEz4h1wkIKyA+xDt9weDGcMVjWFjzsXgpTXgd0S6bYZ/GAw4u+9YnxoHJjfoonunH+p6+vrbOIPQ3c2Twa+68FaoTHN3sJ8BmPCxXVAp3RN8r1cRIuox1rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814481; c=relaxed/simple;
	bh=JE9bLz8q+YgYkpzi5RozpGo7znDZKsyGOIQvg+AlWiY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d0FefuOKY8Iuj2gMmvooNp+XnBAavSkSzZgZuTN778GrWEd3Cj4HCkAZESsAjSpUIfzpxbQ0hG80RMl0ak9dNi0rp44NxlGy6oVbzuf+SdvM89HuPUyZLFDFBDgu33659xtx9rHCqeMSXqSCk5Jqv//1xhQRZCPj5Do40vjrwRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goFIbsBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goFIbsBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B681F000E9;
	Thu, 18 Jun 2026 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781814479;
	bh=X48Gmr9S1KfjbyN+geiyJIMuY9WSGb3lDLM0H2bkygU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=goFIbsBeYR5smMMQqwCyBtCwQV8wAQNjq+hhXQdVN67DkwxyuaODCbHmgVcovnQoK
	 a2O5hX3wlIWAcXhd8m8k2/imx4YvOgemexLEtsN/IX506wxgG24dg7FqkTmgaTUFRP
	 aodt83hfp+kFvkQ9MxniE9Yf/gUFhC1qQh8IoM8dHu85/nDqcOpLoETMXyHrPT1ll7
	 KVH8aWGAwNL1ZmWuIIrZ/x/Ys9MIbi43kVCsinMpaoONSHuTYNBqrUiDvN+As/qJWU
	 En4ziIT6aVRsA943XaRg3EmcXzUqNcKbPqJT9L33lEdwlShp8ylvc19a0NIFhXTbj7
	 5FO/VxlSFXnVg==
From: Thomas Gleixner <tglx@kernel.org>
To: Jing Wu <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>, Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Jing Wu <realwujing@gmail.com>, Qiliang
 Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v3 08/13] genirq: Add explicit housekeeping callback for
 managed IRQ migration
In-Reply-To: <20260618-wujing-dhm-v3-8-28f1a4d83b68@gmail.com>
References: <20260618-wujing-dhm-v3-0-28f1a4d83b68@gmail.com>
 <20260618-wujing-dhm-v3-8-28f1a4d83b68@gmail.com>
Date: Thu, 18 Jun 2026 22:27:57 +0200
Message-ID: <87cxxnegqa.ffs@fw13>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jun 18 2026 at 11:11, Jing Wu wrote:
> +
> +/*
> + * Managed IRQ housekeeping callback: iterate all managed IRQs and ask

S/IRQ/interrupt/ 

> + * the chip to move them off CPUs newly removed from HK_TYPE_MANAGED_IRQ.

Also this doesn't ask the chip to move it.

> + */
> +static void irq_hk_apply(enum hk_type type)
> +{
> +	cpumask_var_t hk_mask;
> +	struct irq_desc *desc;
> +	unsigned int irq;
> +
> +	if (!alloc_cpumask_var(&hk_mask, GFP_KERNEL))
> +		return;
> +
> +	/*
> +	 * Snapshot the new HK_TYPE_MANAGED_IRQ mask under an RCU read lock
> +	 * before iterating IRQ descriptors.  The lockdep annotation in
> +	 * housekeeping_cpumask() requires an RCU read-side critical section
> +	 * for runtime-mutable types.
> +	 */
> +	rcu_read_lock();
> +	cpumask_copy(hk_mask, housekeeping_cpumask_rcu(HK_TYPE_MANAGED_IRQ));
> +	rcu_read_unlock();

Same comments as in the nohz patch.

> +
> +	irq_lock_sparse();
> +
> +	for_each_active_irq(irq) {
> +		desc = irq_to_desc(irq);
> +		if (!desc || !desc->action)
> +			continue;
> +

	for (unsigned int irq = 0; irq < total_nr_irqs; irq++) {
                struct irq_desc *desc;

                 scoped_guard(rcu)
                 	desc = irq_find_desc_at_or_after(irq);
                 ....

> +		/*
> +		 * Only managed interrupts are selected: they have
> +		 * IRQF_AFFINITY_MANAGED set, meaning the kernel owns their
> +		 * affinity.  User-controlled IRQs are intentionally skipped.
> +		 *
> +		 * When the intersection of the current affinity mask and the
> +		 * new housekeeping mask is non-empty, re-apply the restricted
> +		 * affinity to migrate the IRQ away from newly isolated CPUs.
> +		 * If the intersection is empty (all serving CPUs are now
> +		 * isolated), the IRQ is left on its current CPU temporarily;
> +		 * handling that case (IRQ shutdown / re-startup) is left for
> +		 * a follow-up.

Oh well...

> +		 */
> +		if (irqd_affinity_is_managed(&desc->irq_data)) {

So you set the affinity even on an interrupt which is shutdown?

> +			const struct cpumask *mask;
> +			struct cpumask *tmp = this_cpu_ptr(&__tmp_mask);
> +
> +			raw_spin_lock_irq(&desc->lock);

                        guard()

> +			mask = irq_data_get_affinity_mask(&desc->irq_data);
> +			cpumask_and(tmp, mask, hk_mask);
> +			if (cpumask_intersects(tmp, cpu_online_mask))
> +				irq_do_set_affinity(&desc->irq_data, tmp, false);

That's completely broken. You _cannot_ change the affinity mask of a
managed interrupt. The mask itself is immutable.

The effective affinity can be changed by invoking the affinity setter
with the original unmodified mask. irq_do_set_affinity() already deals
with the housekeeping mask.

Also invoking irq_do_set_affinity() directly here is just wrong. It
breaks interrupts which cannot be moved in process context.

But even if that is fixed, then there is zero coordination with the
affected drivers/subsystems. Managed interrupts are related to device
and block queues and you cannot change one without the other. Neither
can you stop managed interrupts without quiescing the related device
queue. Starting them up requires also to reenable the device queue.

This problem needs to be fixed no matter what. See below.

> +static int irq_hk_validate(enum hk_type type,
> +			   const struct cpumask *cur_mask,
> +			   const struct cpumask *new_mask)
> +{
> +	if (!IS_ENABLED(CONFIG_SMP))
> +		return -EOPNOTSUPP;
> +	return 0;

Seriously? Why is this stuff even built when CONFIG_SMP=n?

So these validate callback seem to be just another voodoo container for
no value.

While this series might work for you by some definition of "works", it's
broken beyond repair and it's really annoying that I explained all of it
to the other people who try to solve that very same problem. Of course
you did not read any of that otherwise you would have CC'ed them.

     https://lore.kernel.org/lkml/87o6jcb84w.ffs@tglx

Trying to do that without taking the CPUs mostly offline and bringing
them online again is not going to work and there is zero benefit trying
to avoid that. First of all changing the isolation is not a hotpath
operation. Doing it one by one without bringing the CPU completely down
as I outlined in the above linked mail is not much more disruptive than
trying to do all of this on the fly. If you isolate a CPU then the tasks
on that CPU which do not belong to the isolation set need to get off the
CPU anyway. If you unisolate a CPU then it's really not a problem
whether the non-isolated tasks can move on it 10 milliseconds earlier or
later.

If you want to solve all the problems related to NOHZ, managed
interrupts, RCU etc. without the hotplug machinery then you end up
replicating half of it. Don't even try to think about it, that's a
complete waste of time and won't go anywhere.

Fix the few issues which are related to hotplug that I described in the
above linked mail and use the fully correct and tested common code for
your isolation muck. Please coordinate with Waiman or whoever is working
on it at RH right now.

Thanks,

        tglx
