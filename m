From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Tue, 21 Jun 2016 13:12:12 -0400
Message-ID: <20160621171212.GL3262@mtj.duckdns.org>
References: <20160621163402.GI3262@mtj.duckdns.org>
 <1466528198-3416939-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7Azy0e6LShE2fSl7J7FZxOactGHM9QMnkY2PWHq9bns=;
        b=0S3xibg3zv4fIRbJZosmVmDAwZY80lQAtfxD9Dn/kEQmwncG4EnXN1h4LiqVZAz72T
         1JVOxpvzAVUY790Vsj9wSB4uk7LEiaQkshab24oSjbwJFmqX9J/8T4ha4UcFJFQy86Kd
         dLdysjHbvT05rDR+JJJi0wJ4EfwTOsmXvSF7WeqisEyHCxbSzzS7dSWu3wFcBedj/KBL
         ebkKn7Qi0WomA9RY/B0GM+Lz2ub00qwzoncZhb8gkM2SmBZmdXA/XjCbtH8eCzsGxoEA
         82xVEtI96SRIXXIhcENDzKHxaU89NDhRWMgv8NHlwPsvKQoGdlQtUXIsusbWIDoAzBb4
         XHnw==
Content-Disposition: inline
In-Reply-To: <1466528198-3416939-1-git-send-email-kennyyu-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

Just a couple nits.

On Tue, Jun 21, 2016 at 09:56:38AM -0700, Kenny Yu wrote:
> Summary:

No need for "Summary:" tag.

> This patch adds more visibility into the pids controller when the controller
> rejects a fork request. Whenever fork fails because the limit on the number of
> pids in the cgroup is reached, the controller will log this and also notify the
> newly added cgroups events file. The `max` key in the events file represents
> the number of times fork failed because of the pids controller.
> 
> This change also adds an atomic boolean to prevent logging too much (e.g. a fork
> bomb). The message is logged once per cgroup until the next time the pids limit
> changes.

The above paragraph isn't uptodate anymore.

> @@ -213,10 +220,23 @@ static int pids_can_fork(struct task_struct *task)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct pids_cgroup *pids;
> +	int err;
> +	int events_limit;
>  
>  	css = task_css_check(current, pids_cgrp_id, true);
>  	pids = css_pids(css);
> -	return pids_try_charge(pids, 1);
> +	err = pids_try_charge(pids, 1);
> +	if (err) {
> +		events_limit = atomic64_inc_return(&pids->events_limit);
> +		cgroup_file_notify(&pids->events_file);
> +		/* Only log the first time events_limit is incremented. */
> +		if (events_limit == 1) {
> +			pr_info("cgroup: fork rejected by pids controller in ");
> +			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
> +			pr_cont("\n");
> +		}
> +	}
> +	return err;
>  }

It'd be better to use atomic64_inc_and_test() instead.

	if (err) {
		if (atomic64_inc_and_test()) {
			pr_xxx...;
		}
		cgroup_file_notify(&pids->events_file);
	}

Thanks.

-- 
tejun
