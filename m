From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Allow non-top parent partition root
 to distribute out all CPUs
Date: Wed, 16 Jun 2021 16:57:48 -0400
Message-ID: <YMplzNzg7mMCU4JJ@slm.duckdns.org>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0iilFTHgmXaTXAf6PQ61qLrXDecfzvIQCA1PI6ZGIUk=;
        b=oyRewv+gWuxpGQqbIhsiFhNSMFx6Xkb/xzs5BOkb6l2nIp9JNBfojd/BzYFbariNjU
         VrAVVfRYwnapm+gqPr9j190GX/pRQrtENyn+vfWbzcuC/H+E4DuhyU25h2vW0cfZFsmO
         C+5XADaN8bc1nLLsL+rmeWvciuy42OJwFRC9cKoPDgRfF55b4v51bi7tivO3FyFRqvhJ
         EpfIhumP5stdswSGz6ZQcou99fKE6MAqohAMMDUJMlslhnAZZnihoSYx34VcBPB/dKf6
         BzGvgnP7+BujnS2mL/lHYx6axjpjgFjXX7UEB9Ur4M0YsellXNx1AvuKz/pDjscG7wyu
         Reyg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210603212416.25934-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Jun 03, 2021 at 05:24:14PM -0400, Waiman Long wrote:
> @@ -2181,6 +2192,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
>  		goto out_unlock;
>  
> +	/*
> +	 * On default hierarchy, task cannot be moved to a cpuset with empty
> +	 * effective cpus.
> +	 */
> +	if (is_in_v2_mode() && cpumask_empty(cs->effective_cpus))
> +		goto out_unlock;
> +

This is inconsistent with how other events which leave a root partition
empty is handled. Woudln't it be more consistent to switch the parent to
PRS_ERROR and behave accordingly but allow it to have valid child roots?

Thanks.

-- 
tejun
