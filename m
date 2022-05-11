From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Wed, 11 May 2022 09:13:23 +0200
Message-ID: <YntiE+qNnHQBV4zE@dhcp22.suse.cz>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652253204; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v3MEE3PCAin488+Sg3Y+cPevPCOC3na5cXBSCbF/tME=;
        b=hii84q44ZpbI1s2/MUpEY3XkgMdDGRV2xp78zOJXyihOgzmQEi+DNBtqkYvHwDXFUJNOsW
        3r6eitcIEOKRtc3ctO4Z6BS337p/XjSUR88unGCHvAeKx1SdDBlKwRliO8LTFlHDwyg9YF
        t3j9/HCDO2FZ4TvAUwSTCh49OYvHv1U=
Content-Disposition: inline
In-Reply-To: <20220507050916.GA13577-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 06-05-22 22:09:16, Ganesan Rajagopal wrote:
> We run a lot of automated tests when building our software and run into
> OOM scenarios when the tests run unbounded. v1 memcg exports
> memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> metric to heuristically limit the number of tests that can run in
> parallel based on per test historical data.
> 
> This metric is currently not exported for v2 memcg and there is no
> other easy way of getting this information. getrusage() syscall returns
> "ru_maxrss" which can be used as an approximation but that's the max
> RSS of a single child process across all children instead of the
> aggregated max for all child processes. The only work around is to
> periodically poll "memory.current" but that's not practical for
> short-lived one-off cgroups.
> 
> Hence, expose memcg->watermark as "memory.peak" for v2 memcg.

Yes, I can imagine that a very short lived process can easily escape
from the monitoring. The memory consumption can be still significant
though.

The v1 interface allows to reset the value by writing to the file. Have
you considered that as well?
 
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
>  mm/memcontrol.c                         | 13 +++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 69d7a6983f78..828ce037fb2a 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1208,6 +1208,13 @@ PAGE_SIZE multiple when read back.
>  	high limit is used and monitored properly, this limit's
>  	utility is limited to providing the final safety net.
>  
> +  memory.peak
> +	A read-only single value file which exists on non-root
> +	cgroups.
> +
> +	The max memory usage recorded for the cgroup and its
> +	descendants since the creation of the cgroup.
> +
>    memory.oom.group
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default value is "0".
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 725f76723220..88fa70b5d8af 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6098,6 +6098,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
>  	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
>  }
>  
> +static u64 memory_peak_read(struct cgroup_subsys_state *css,
> +			    struct cftype *cft)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +	return (u64)memcg->memory.watermark * PAGE_SIZE;
> +}
> +
>  static int memory_min_show(struct seq_file *m, void *v)
>  {
>  	return seq_puts_memcg_tunable(m,
> @@ -6361,6 +6369,11 @@ static struct cftype memory_files[] = {
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.read_u64 = memory_current_read,
>  	},
> +	{
> +		.name = "peak",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.read_u64 = memory_peak_read,
> +	},
>  	{
>  		.name = "min",
>  		.flags = CFTYPE_NOT_ON_ROOT,
> -- 
> 2.28.0

-- 
Michal Hocko
SUSE Labs
