From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: + memcg-do-not-report-racy-no-eligible-oom-tasks.patch added to
 -mm tree
Date: Fri, 25 Jan 2019 11:56:24 -0500
Message-ID: <20190125165624.GA17719@cmpxchg.org>
References: <20190109190306.rATpT%akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RNchuqr3adsTArnI0ZEntYHozJYWxyEQo/SnVvUtVNc=;
        b=uIIoysv+H0D8F8n6fbuqAaCugVthDdjFx3BGz3Q/i0kCjWNLsFDyRt4QyJTmW+MJoI
         hlkkG0VoFp67FGmCBF+IDnT7DMHQLVolbwhaWNj/bSpXJGG3WUTU7BggZuuoeoVxHj4r
         XbFMWUT5Lxzp+UJhZa85SWO/4ZB0qNvzJhvXTseOeH/jND0qyo5RGgPYvHeXxsDEUoQ5
         JI0wg8e78izosTtI38FdP+KKcMONfflsl0/HLPGYFY+Rsg5u3eavtLsPx3/u5mMd2tjM
         OoYIi50y34FwpcXVeR3msE3n9vvsgFP+XWcE47HJue02u3LtgOwVQz+MVVsJ7t4wv4Sl
         Ud0Q==
Content-Disposition: inline
In-Reply-To: <20190109190306.rATpT%akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Jan 09, 2019 at 11:03:06AM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: memcg: do not report racy no-eligible OOM tasks
> has been added to the -mm tree.  Its filename is
>      memcg-do-not-report-racy-no-eligible-oom-tasks.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/memcg-do-not-report-racy-no-eligible-oom-tasks.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-report-racy-no-eligible-oom-tasks.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Michal Hocko <mhocko@suse.com>
> Subject: memcg: do not report racy no-eligible OOM tasks
> 
> Tetsuo has reported [1] that a single process group memcg might easily
> swamp the log with no-eligible oom victim reports due to race between the
> memcg charge and oom_reaper
> 
> Thread 1		Thread2				oom_reaper
> try_charge		try_charge
> 			  mem_cgroup_out_of_memory
> 			    mutex_lock(oom_lock)
>   mem_cgroup_out_of_memory
>     mutex_lock(oom_lock)
> 			      out_of_memory
> 			        select_bad_process
> 				oom_kill_process(current)
> 				  wake_oom_reaper
> 							  oom_reap_task
> 							  MMF_OOM_SKIP->victim
> 			    mutex_unlock(oom_lock)
>     out_of_memory
>       select_bad_process # no task
> 
> If Thread1 didn't race it would bail out from try_charge and force the
> charge.  We can achieve the same by checking tsk_is_oom_victim inside the
> oom_lock and therefore close the race.
> 
> [1] http://lkml.kernel.org/r/bb2074c0-34fe-8c2c-1c7d-db71338f1e7f@i-love.sakura.ne.jp
> Link: http://lkml.kernel.org/r/20190107143802.16847-3-mhocko@kernel.org
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

It looks like this problem is happening in production systems:

https://www.spinics.net/lists/cgroups/msg21268.html

where the threads don't exit because they are trapped writing out the
oom messages to a slow console (running the reproducer from this email
thread triggers the oom flooding).

So IMO we should put this into 5.0 and add:

Fixes: 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the charge path")
Fixes: 3100dab2aa09 ("mm: memcontrol: print proper OOM header when no eligible victim left")
Cc: stable@kernel.org # 4.19+

> --- a/mm/memcontrol.c~memcg-do-not-report-racy-no-eligible-oom-tasks
> +++ a/mm/memcontrol.c
> @@ -1387,10 +1387,22 @@ static bool mem_cgroup_out_of_memory(str
>  		.gfp_mask = gfp_mask,
>  		.order = order,
>  	};
> -	bool ret;
> +	bool ret = true;

Should this be false if skip the oom kill, btw? Either will result in
a forced charge - false will do so right away, true will retry once
and then trigger the victim check in try_charge().

It's just weird to return true when we didn't do what the caller asked
us to do.

>  	mutex_lock(&oom_lock);
> +
> +	/*
> +	 * multi-threaded tasks might race with oom_reaper and gain
> +	 * MMF_OOM_SKIP before reaching out_of_memory which can lead
> +	 * to out_of_memory failure if the task is the last one in
> +	 * memcg which would be a false possitive failure reported
> +	 */
> +	if (tsk_is_oom_victim(current))
> +		goto unlock;
> +
>  	ret = out_of_memory(&oc);
> +
> +unlock:
>  	mutex_unlock(&oom_lock);
>  	return ret;
