From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 08:25:29 -0800
Message-ID: <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LvDXexURC7JDXtx8bhwlzEV40rN1puHR+/+gNK58vJE=;
        b=V7BxuBmDWakSa2+zGHLwmteCApPcPjLgSrRaw4oHnEWl0xgIuDq5bWKa+MLoHQfmZa
         Eqf0u4C1mpVU3D4SF6vUbM1tYDFaWrO1NjUAsTtKsIGKZcrWBH8/T6DgxzBj59MRd+D4
         jS6eV8YGQ6IxAqjDr4Ibsbp153cY7RNbToyMuGeJpZ3ZK7CWeNf7DwHT3M/CKkN8LsOB
         cMwM4gcLAb2wm4DDZwX6FW3Ai9ysAPJCq6UmoD0UFXVUHutQ0mLZCWhQfa8WTc48OfOI
         cGISfKkDHkHh5it1ERt+LuCblgYjpkPKFm81BKcYN89fkY7sHCE/6141J96eBfe+RBVC
         DfKQ==
Content-Disposition: inline
In-Reply-To: <20181117003830.15344-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Nov 16, 2018 at 04:38:27PM -0800, Roman Gushchin wrote:
> +void cgroup_freezer_migrate_task(struct task_struct *task,
> +				 struct cgroup *src, struct cgroup *dst)
> +{
> +	lockdep_assert_held(&css_set_lock);
> +
> +	/*
> +	 * Kernel threads are not supposed to be frozen at all.
> +	 */
> +	if (task->flags & PF_KTHREAD)
> +		return;
> +
> +	/*
> +	 * Adjust counters of freezing and frozen tasks.
> +	 */
> +	if (test_bit(CGRP_FREEZE, &src->flags)) {
> +		src->freezer.nr_tasks_to_freeze--;
> +		WARN_ON_ONCE(src->freezer.nr_tasks_to_freeze < 0);
> +	}
> +
> +	/*
> +	 * If the task is frozen, let's bump nr_tasks_to_freeze even
> +	 * if the target cgroup isn't frozen: the counter will be decreased
> +	 * in cgroup_leave_frozen().
> +	 */
> +	if (test_bit(CGRP_FREEZE, &dst->flags) || task->frozen)
> +		dst->freezer.nr_tasks_to_freeze++;
> +
> +	if (task->frozen) {
> +		src->freezer.nr_frozen_tasks--;
> +		dst->freezer.nr_frozen_tasks++;
> +		WARN_ON_ONCE(src->freezer.nr_frozen_tasks < 0);
> +		WARN_ON_ONCE(dst->freezer.nr_frozen_tasks >
> +			     dst->freezer.nr_tasks_to_freeze);
> +	}

If a non-frozen task is being moved into a frozen cgroup, shouldn't
that also trigger frozen state update?

Thanks.

-- 
tejun
