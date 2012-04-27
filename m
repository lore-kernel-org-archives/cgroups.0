From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
Date: Fri, 27 Apr 2012 12:39:29 +0200
Message-ID: <20120427103927.GA3514@somewhere.redhat.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A366E.9020307@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5tiPaDdahaRWdwCakssQSjrMHFTCP4EhN9Qq5Er59TI=;
        b=oFHXMnWUptYesUErMA6T2URYUkgBBTs81Wu6n74f+ywC9kyJVBnobOqANQNCaF6oKF
         AmYvqHkrZHHHY4cvEU/eQhdpMBstQ2Dwch/2zBRLJ7YJbIos4yJB9Qa/6oKHoD83k/zt
         OD+owJKYV++pX7o4B3Uz4FETIChi+lMqUWvd/EGEEyoqD8luH4nmSd1QytgPz6T9y9+c
         tMCW+Ql/mo7b7d2XEFC4a1Ox+AVOfh/AGqkYdYiudxVlHIbRNVwfz+O6K1Ux6/aSSMb0
         8LKb8Op1o3h5jtyzJXf572P5QYajtGA9kgPgKKmvj1bec8QTAeGxrBUFxO9grLpLbBYg
         GAdw==
Content-Disposition: inline
In-Reply-To: <4F9A366E.9020307@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com

On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
> attach_task() is done under cgroup_mutex() but ->pre_destroy() callback
> in rmdir() isn't called under cgroup_mutex().
> 
> It's better to avoid attaching a task to a cgroup which
> is under pre_destroy(). Considering memcg, the attached task may
> increase resource usage after memcg's pre_destroy() confirms that
> memcg is empty. This is not good.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/cgroup.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ad8eae5..7a3076b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1953,6 +1953,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  	if (cgrp == oldcgrp)
>  		return 0;
>  
> +	if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
> +		return -EBUSY;
> +

You probably need to update cgroup_attach_proc() as well?

>  	tset.single.task = tsk;
>  	tset.single.cgrp = oldcgrp;
>  
> @@ -4181,7 +4184,6 @@ again:
>  		mutex_unlock(&cgroup_mutex);
>  		return -EBUSY;
>  	}
> -	mutex_unlock(&cgroup_mutex);
>  
>  	/*
>  	 * In general, subsystem has no css->refcnt after pre_destroy(). But
> @@ -4193,6 +4195,7 @@ again:
>  	 * and css_tryget() and cgroup_wakeup_rmdir_waiter() implementation.
>  	 */
>  	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> +	mutex_unlock(&cgroup_mutex);
>  
>  	/*
>  	 * Call pre_destroy handlers of subsys. Notify subsystems
> -- 
> 1.7.4.1
> 
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
