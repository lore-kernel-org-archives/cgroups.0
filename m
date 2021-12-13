From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 2/7] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Mon, 13 Dec 2021 10:45:33 -1000
Message-ID: <Ybew7d2oE2gLcLNO@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+kGkjmCClJZHQUuipZquM0wxRHxRZ1CYDc4rEqsGfmo=;
        b=Dc24nUO7obHKfEHi+3eu4hhPs6pC5ekbvfg6/fWWuMendLFNP/aD3vLwBMsHt2VawN
         65DTUGFRXitGu39c94BMAfKQsI8UfXTySofOZ9aBfUJoCQ9p7VFDtSa15skRYg7omKr5
         KdjwUjY8khI+bAkd1TXtrpsH4ElcQnOCyRGAJ3dzrakcKEw34dsnGuUSxxDFeLak/iq8
         IlvW99cvvRUK7Ok1QKBqJuceEQliZ/A3W1EJEpQYq5lxAljWkERflfsUEhAysxqJMY54
         /zwdsdRHMRP45MEbZ/kXiGH03I5m2CLNYauI4avPu3xs9iECZgOtDZxfKxkl039E39XL
         eLZg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211205183220.818872-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Sun, Dec 05, 2021 at 01:32:15PM -0500, Waiman Long wrote:
>  	adding = deleting = false;
>  	old_prs = new_prs = cpuset->partition_root_state;
>  	if (cmd == partcmd_enable) {
> +		/*
> +		 * Enabling partition root is not allowed if not all the CPUs
> +		 * can be granted from parent's effective_cpus.
> +		 */
> +		if (!cpumask_subset(cpuset->cpus_allowed, parent->effective_cpus))
> +			return -EINVAL;
> +
> +		/*
> +		 * A parent can be left with no CPU as long as there is no
> +		 * task directly associated with the parent partition. For
> +		 * such a parent, no new task can be moved into it.
> +		 */
> +		if (partition_is_populated(parent, cpuset) &&
> +		    cpumask_equal(cpuset->cpus_allowed, parent->effective_cpus))
> +			return -EINVAL;

So, given that this only happens with threaded domains, can we just not
allow partitions within threaded domains? The combination doesn't make whole
lot of sense to me anyway.

> +	/*
> +	 * On default hierarchy, task cannot be moved to a cpuset with empty
> +	 * effective cpus.
> +	 */
> +	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
> +		goto out_unlock;

And then we can avoid this extra restriction too, right?

Thanks.

-- 
tejun
