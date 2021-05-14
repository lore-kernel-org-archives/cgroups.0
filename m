From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Fri, 14 May 2021 13:41:54 +0200
Message-ID: <YJ5iAvqAmIhzJRot@hirez.programming.kicks-ass.net>
References: <20210513175349.959661-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MdMngczTJp2eNddFPzOfewyFvaPceCIk8FSUZMqbx7M=; b=WN+214LIDtc7IWUZgPQNZg3gUP
        RY4WgyT2H0dzxNMPtxc4w8KBdHZfYXR47ILnkCX/saycrkY9wM5X9dkOc9L72VwTJ9COZ8DV9XzXq
        39ZMwGyAxW1fwscIu/6IoNIIbDO6T6BArFj/+rY7i3w4hWF5wnAfz/7hym5GbV2zEIzJcBq45ZXvv
        8KFnZkcldbr+cJ7P3sfNJ71Qm/Gr7QfLIVRqeRcFkuKrb6J0G2T8dWp6/NSmgavSHY3H6KYzLKXTe
        PaeBZdBQr6ZgdkiCy+qfgRc4Wwjg7ZZI/GR+XJTApBu0DnqosdTpnTLVjSM9vhoHiwhxccaCdzSjS
        Kck9YCrw==;
Content-Disposition: inline
In-Reply-To: <20210513175349.959661-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, May 13, 2021 at 10:53:49AM -0700, Suren Baghdasaryan wrote:

> +bool cgroup_psi_enabled(void)
> +{
> +	return (cgroup_feature_disable_mask & (1 << OPT_FEATURE_PRESSURE)) == 0;
> +}

> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index cc25a3cff41f..c73efd7d4fba 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -747,9 +747,12 @@ static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
>  #ifdef CONFIG_CGROUPS
>  	struct cgroup *cgroup = NULL;
>  
> -	if (!*iter)
> +	if (!*iter) {
> +		/* Skip to psi_system if per-cgroup accounting is disabled */
> +		if (!cgroup_psi_enabled())
> +			goto update_sys;
>  		cgroup = task->cgroups->dfl_cgrp;
> -	else if (*iter == &psi_system)
> +	} else if (*iter == &psi_system)
>  		return NULL;
>  	else
>  		cgroup = cgroup_parent(*iter);
> @@ -758,6 +761,7 @@ static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
>  		*iter = cgroup;
>  		return cgroup_psi(cgroup);
>  	}
> +update_sys:
>  #else
>  	if (*iter)
>  		return NULL;

I'm confused; shouldn't that do the same as that #else branch? Also, can
you pretty please make cgroup_psi_enabled() a static_key ?
