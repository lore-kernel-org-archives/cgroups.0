From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus in
 cpuset
Date: Wed, 25 Feb 2015 13:09:24 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1502251254110.18097@chino.kir.corp.google.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-3-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=kikXT95O0usSi6VAFPisChzlPWNSND9h+WxTN3YFaHc=;
        b=VVxFaGuJcWBUtWAI/9kmQHxJdK/cNfYgRNALB3i9tXxusSVrURelwFtx0hhWSf5Acp
         ZIFS+q0AH0PkYrNEZf3gcuLGFQfAoQ58fFL/3BjgLNVrxY8ibJ7cIyCL3u0PN90h17OF
         91KYymgzEhhx6XaYdIwNHfuaa4F+xjSwfq+HFfSfdwBGyyQEzAQIsVhlrbvCr7Q2zD7D
         Ck1f5dLX8vQWPd75N6TmzGhYNW325GQPv2yIq821s/cFyahpP8eSTsL1L7zAB61nyhLW
         yiUHUS+HgvPHiGQDbzksAGOipqEmJMdHa0JYWBQrkdaNuVFuoPmRU7qsF+4S/t75YGUB
         xZwQ==
In-Reply-To: <1424882288-2910-3-git-send-email-riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 25 Feb 2015, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:

> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index b544e5229d99..94bf59588e23 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1563,6 +1563,7 @@ typedef enum {
>  	FILE_MEMORY_PRESSURE,
>  	FILE_SPREAD_PAGE,
>  	FILE_SPREAD_SLAB,
> +	FILE_ISOLCPUS,
>  } cpuset_filetype_t;
>  
>  static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
> @@ -1704,6 +1705,20 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>  	return retval ?: nbytes;
>  }
>  
> +static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
> +{
> +	cpumask_var_t my_isolated_cpus;
> +
> +	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
> +		return;
> +
> +	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
> +
> +	seq_printf(sf, "%*pbl\n", nodemask_pr_args(my_isolated_cpus));

That unfortunately won't output anything, it needs to be 
cpumask_pr_args().  After that's fixed, feel free to add my

	Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> +
> +	free_cpumask_var(my_isolated_cpus);
> +}
> +
>  /*
>   * These ascii lists should be read in a single call, by using a user
>   * buffer large enough to hold the entire map.  If read in smaller
> @@ -1733,6 +1748,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
>  	case FILE_EFFECTIVE_MEMLIST:
>  		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
>  		break;
> +	case FILE_ISOLCPUS:
> +		cpuset_seq_print_isolcpus(sf, cs);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> @@ -1893,6 +1911,12 @@ static struct cftype files[] = {
>  		.private = FILE_MEMORY_PRESSURE_ENABLED,
>  	},
>  
> +	{
> +		.name = "isolcpus",
> +		.seq_show = cpuset_common_seq_show,
> +		.private = FILE_ISOLCPUS,
> +	},
> +
>  	{ }	/* terminate */
>  };
>  
