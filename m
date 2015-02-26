From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Thu, 26 Feb 2015 19:05:57 +0800
Message-ID: <54EEFE15.3010005@huawei.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-3-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424882288-2910-3-git-send-email-riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> +static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
> +{
> +	cpumask_var_t my_isolated_cpus;
> +
> +	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
> +		return;
> +

Make it return -ENOMEM ? Or make it a global variable and allocate memory for it
in cpuset_init().

> +	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
> +
> +	seq_printf(sf, "%*pbl\n", nodemask_pr_args(my_isolated_cpus));
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
> 
