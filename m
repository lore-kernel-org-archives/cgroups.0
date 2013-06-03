From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Mon, 3 Jun 2013 18:31:34 +0200
Message-ID: <20130603163012.GA23257@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YR6MslnpOhDktWhbGPBYpbQsMe/NXT1smJRLrzqwAQM=;
        b=F5BMXkrdptRDJYloC6GZzm+XiCm41zCoErBX5x1otbVjFFmPH+/wPOWYeeooj8dOLz
         pXOdhMyGQXelsbXkjJYca+cuubwazmxI3dAYCC6+JJiPF2yk/8TqSPauIr64QJeA8ZGl
         Kt4fe89DYXiuxSFZNNjcEePQnh4Vv732euvXeEWF1/+qD9k6zmquBZRQtyKtZq0o7vlU
         sD1CLyMMB+NUuVkfzzORzWXn4S+Y4Ri4DLmNoAvWTBJXC3ryLcB5Gpo+xX2FxnNof2vD
         rLBcobBknv4gm5mEaTqSepYHnyzk1G+I58WzariIqjsAxbrecw74+WeqD7lm5VIkDzsY
         xVWQ==
Content-Disposition: inline
In-Reply-To: <20130601061151.GC15576@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Sat 01-06-13 02:11:51, Johannes Weiner wrote:
> @@ -2076,6 +2077,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *memcg)
>  {
>  	/* for filtering, pass "memcg" as argument. */
>  	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
> +	atomic_inc(&memcg->oom_wakeups);
>  }
>  
>  static void memcg_oom_recover(struct mem_cgroup *memcg)
[...]
> +	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
> +	/* Only sleep if we didn't miss any wakeups since OOM */
> +	if (atomic_read(&memcg->oom_wakeups) == current->memcg_oom.wakeups)
> +		schedule();

On the way home it occured to me that the ordering might be wrong here.
The wake up can be lost here.
					__wake_up(memcg_oom_waitq)
					<preempted>
prepare_to_wait
atomic_read(&memcg->oom_wakeups)
					atomic_inc(oom_wakeups)

I guess we want atomic_inc before __wake_up, right?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
