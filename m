From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 4/7] cgroup: cgroup v2 freezer
Date: Mon, 3 Dec 2018 15:49:06 +0100
Message-ID: <20181203144906.GE31795@redhat.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130234745.6756-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On 11/30, Roman Gushchin wrote:
>
> +void cgroup_enter_frozen(void)
> +{
> +	if (!current->frozen) {
> +		struct cgroup *cgrp;
> +
> +		spin_lock_irq(&css_set_lock);
> +		current->frozen = true;
> +		cgrp = task_dfl_cgroup(current);
> +		cgrp->freezer.nr_frozen_tasks++;
> +		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
> +			     cgrp->freezer.nr_tasks_to_freeze);
> +		cgroup_update_frozen(cgrp, true);
> +		spin_unlock_irq(&css_set_lock);
> +	}
> +
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	schedule();
> +	__set_current_state(TASK_RUNNING);

forgot to mention, schedule() always returns in TASK_RUNNING, so the 2nd
__set_current_state() is pointless.

Oleg.

