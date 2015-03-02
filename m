From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroups: add an nproc subsystem
Date: Mon, 2 Mar 2015 10:22:05 -0500
Message-ID: <20150302152205.GC17694@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=t/SoBRJvZYYwAoeqddCb5YmrYtnw6lCYdAh0lMlOXNM=;
        b=RL9B03mmFrrFu1O1rQMldynvLk298DW6UYBMOKIVUsB2TawfunGeHnm4t0oWJ0Km4c
         zpk0zpry/N7V1IlFllrCNPk4yKO1ttSrcitTnNHThJDPq/hlfm92JeT/7XN8EAMrTD+Y
         IhNFaEMx2cjVdT4RgeHmpVReLdLb6gTPffmEwcDp1qRVTMzJurT4nvAVmwyo0v3JZgUL
         hRXMcYTcBbUAgyGnofCgESZHeH2DXOyxvwu5dd9As2qh/eU990v7dAc+Sa+sgQvwubl6
         QoAyDeyllTOVvSKiiJ6TYlDECv6C3xLiU4vcNfHTQHsEWTMvMJellioPY1Ntd/HAdJ6u
         bSsw==
Content-Disposition: inline
In-Reply-To: <1425010639-16492-3-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Feb 27, 2015 at 03:17:19PM +1100, Aleksa Sarai wrote:
> +config CGROUP_NPROC
> +	bool "Process number limiting on cgroups"
> +	depends on PAGE_COUNTER
> +	help
> +	  This options enables the setting of process number limits in the scope
> +	  of a cgroup. Any attempt to fork more processes than is allowed in the
> +	  cgroup will fail. This allows for more basic resource limitation that
> +	  applies to a cgroup, similar to RLIMIT_NPROC (except that instead of
> +	  applying to a process tree it applies to a cgroup).

Please reflect the rationale from this discussion thread in the commit
message and help text.  Also, I'd much prefer to name it pids
controller after the resource it's controlling.

> +struct nproc {
> +	struct page_counter		proc_counter;

I don't think it's a good idea to use page_counter outside memcg.
This is pretty much an implementation detail of memcg.  The only
reason that file is out there is because of the wacky tcp controller
which is somewhat part of memcg (and to be replaced by proper kmemcg).
Either use plain atomic_t or percpu_counter with controlled batch
value (e.g. upto 10% deviation allowed from the target or sth).  Given
that fork/exit is pretty heavy path, just plain atomic_t is prolly
enough.

> +static int nproc_can_attach(struct cgroup_subsys_state *css,
> +			    struct cgroup_taskset *tset)
> +{
> +	struct nproc *nproc = css_nproc(css);
> +	unsigned long num_tasks = 0;
> +	struct task_struct *task;
> +
> +	cgroup_taskset_for_each(task, tset)
> +		num_tasks++;
> +
> +	return nproc_add_procs(nproc, num_tasks);
> +}

can_attach() can't fail in the unified hierarchy.  Circumvention of
configuration by moving processes to children is prevented through
hierarchical limit enforcement.

> +static int nproc_write_limit(struct cgroup_subsys_state *css,
> +			     struct cftype *cft, u64 val)
> +{
> +	struct nproc *nproc = css_nproc(css);
> +
> +	return page_counter_limit(&nproc->proc_counter, val);
> +}

Please make it handle "max".

> +static u64 nproc_read_limit(struct cgroup_subsys_state *css,
> +			    struct cftype *cft)
> +{
> +	struct nproc *nproc = css_nproc(css);
> +
> +	return nproc->proc_counter.limit;
> +}

Ditto when reading back.

> +static u64 nproc_read_max_limit(struct cgroup_subsys_state *css,
> +				       struct cftype *cft)
> +{
> +	return PAGE_COUNTER_MAX;
> +}

And drop this file.

> +static u64 nproc_read_usage(struct cgroup_subsys_state *css,
> +			    struct cftype *cft)
> +{
> +	struct nproc *nproc = css_nproc(css);
> +
> +	return page_counter_read(&nproc->proc_counter);
> +}
> +
> +static struct cftype files[] = {
> +	{
> +		.name = "limit",
> +		.write_u64 = nproc_write_limit,
> +		.read_u64 = nproc_read_limit,
> +	},

pids.max

> +	{
> +		.name = "max_limit",
> +		.read_u64 = nproc_read_max_limit,
> +	},
> +	{
> +		.name = "usage",
> +		.read_u64 = nproc_read_usage,
> +	},

pids.current

Thanks.

-- 
tejun
