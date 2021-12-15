From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v9 3/7] cgroup/cpuset: Refining features and constraints
 of a partition
Date: Wed, 15 Dec 2021 15:49:44 +0100
Message-ID: <20211215144944.GE16798@blackbody.suse.cz>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639579785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=euooVMEZrx6lIqaC7AMmnzXnheQmRgVNrxBqLKPSDeo=;
        b=aeZp5/6ZBT1NQPyhZwdCBE9p7ifowhSb5Hl3nbSP98JM2lL79llq1iWlF6SyW8eDoL1JAE
        ENZAWU9w2b1dAX4LN6zUnritfxHJIXjDC9LjsCUO2sl/hJRZdOntrqINvCU530pRSSnWxE
        gtvstSGrCMdd159A9k7YD3+lqDybexg=
Content-Disposition: inline
In-Reply-To: <20211205183220.818872-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On Sun, Dec 05, 2021 at 01:32:16PM -0500, Waiman Long <longman@redhat.com> wrote:
> @@ -1455,34 +1450,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
>  			switch (parent->partition_root_state) {
> [...]
> -
>  			case PRS_ENABLED:
> -				if (update_parent_subparts_cpumask(cp, partcmd_update, NULL, tmp))
> -					update_tasks_cpumask(parent);
> +				update_parent = true;
> [...]
> +		if (update_parent) {
> +			if (update_parent_subparts_cpumask(cp, partcmd_update, NULL, tmp))
> +				update_tasks_cpumask(parent);
> +			/*
> +			 * The cpuset partition_root_state may be changed
> +			 * to PRS_ERROR. Capture it.
> +			 */
> +			new_prs = cp->partition_root_state;
> +		}

IIUC, this ensures that when a parent becomes partition root again, this
would propagate downwards to invalidated children. 

However, the documentation says:

> +       Changing a partition root (valid or invalid) to "member" is
> +       always allowed.  If there are child partition roots underneath
> +       it, they will become invalid and unrecoverable.  So care must
> +       be taken to double check for this condition before disabling
> +       a partition root.

I.e. it suggests a child can be trapped in the unrecoverable state (i.e.
not fixable by writing into cpuset.cpus.partition).
But this does not happen, right?

Michal
