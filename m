From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Wed, 16 Jun 2021 16:47:40 -0400
Message-ID: <YMpjbCWpSDIz4bHt@slm.duckdns.org>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hsHB5m77MIVRrUwCHcRGhZDai+vzsMMYW8wAwWykDx0=;
        b=CeHzZu1qNvVzLHiwRr09PcbJ2FXOFkn3h4H4zk5Lr4sOgvjZTBM1CbbnsmSyjAgpcd
         HIYQNcZdYumMOPW7O5/hMqw6lqFgw57+yAL7bm2+CXXEQszbcZSdOQ2qhHB4wC0f7iv9
         Zh2hOG3W6RF8Lw8MCCoQQfi/VYZOMbhTwpMDxVp/hhqaILJnn96p/AULQOeyibkUQfwg
         QyS5MfUD/H6vyfOFJHvQRWNxfZEdq5nT4XPhsQ7PGmQALBer36I0gtBtaCyg8pnfv4Z6
         O4J7sl4DtmofagCfny86mI1bvuutN1bmqWA7/KXBzvWNBnQu4DCrYIV8w74+iVBWe5QZ
         fdrw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210603212416.25934-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

Hello,

Generally looks fine to me.

On Thu, Jun 03, 2021 at 05:24:13PM -0400, Waiman Long wrote:
> @@ -1984,12 +1987,31 @@ static int update_prstate(struct cpuset *cs, int val)
>  			goto out;
>  
>  		err = update_parent_subparts_cpumask(cs, partcmd_enable,
> -						     NULL, &tmp);
> +						     NULL, &tmpmask);
> +
>  		if (err) {
>  			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
>  			goto out;
> +		} else if (new_prs == PRS_ENABLED_NOLB) {
> +			/*
> +			 * Disable the load balance flag should not return an

                                 ^ing

and "else if" after "if (err) goto out" block is weird. The two conditions
don't need to be tied together.

> @@ -2518,6 +2547,9 @@ static int sched_partition_show(struct seq_file *seq, void *v)
>  	case PRS_ENABLED:
>  		seq_puts(seq, "root\n");
>  		break;
> +	case PRS_ENABLED_NOLB:
> +		seq_puts(seq, "root-nolb\n");
> +		break;
>  	case PRS_DISABLED:
>  		seq_puts(seq, "member\n");
>  		break;
> @@ -2544,6 +2576,8 @@ static ssize_t sched_partition_write(struct kernfs_open_file *of, char *buf,
>  		val = PRS_ENABLED;
>  	else if (!strcmp(buf, "member"))
>  		val = PRS_DISABLED;
> +	else if (!strcmp(buf, "root-nolb"))
> +		val = PRS_ENABLED_NOLB;
>  	else
>  		return -EINVAL;

I wonder whether there's a better name than "root-nolb" because nolb isn't
the most readable and we are using space as the delimiter for other names.
Would something like "isolated" work?

Thanks.

-- 
tejun
