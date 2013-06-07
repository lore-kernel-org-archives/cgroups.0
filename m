From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Thu, 6 Jun 2013 17:52:42 -0700
Message-ID: <20130607005242.GB16160@htj.dyndns.org>
References: <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605143949.GQ15576@cmpxchg.org>
 <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IU3esIbEUCDqPVU19DuNCjRM+ZBnrl6/vF7LqRGSd9k=;
        b=cVxxlZ7eAKr3tn59kxbHS68dFrJB9nl7MJWr2AXa8zaD9fm2rIVXiotMRwQ3X2YqFR
         Kw6PVFCDk3fmlNrFiBJ71LPPZrFVXcUBkRCrh1ztEzYJ/5XP/1DHTUukeqi47bVFn0dW
         y2F4AD+Db05MBcLae32CIEu47vU3kFWvD6O0LdJDkM8TkRPYaM70PWs0tzODEGKPcZoZ
         pf1+iO2M/P/boqSQQi3tjaC9umn6MSr+RgEpfbwqXPO4rsTOdIUr2i2j8jscfyLrXR1m
         y5F3ibwdGbJ4HL90u6/NB25YyFertwLIy1j8vc82rJorx33daefB/HD8zJtZbqH7lGI0
         TFig==
Content-Disposition: inline
In-Reply-To: <20130606115031.GE7909@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Hello,

On Thu, Jun 06, 2013 at 01:50:31PM +0200, Michal Hocko wrote:
> > Also, do we need to hold a lock?  It doesn't have to be completely
> > strict, so we might as well get away with something like,
> > 
> > 	for_each_cached_pos() {
> > 		if (hint == me) {
> > 			/* simple clearing implementation, we prolly wanna push it forward */
> > 			cached = xchg(hint, NULL);
> > 			if (cached)
> > 				css_put(cached);
> > 		}
> > 	}
> 
> This would be racy:
> mem_cgroup_iter
>   rcu_read_lock
>   __mem_cgroup_iter_next		cgroup_destroy_locked
>     css_tryget(memcg)
>   					  atomic_add(CSS_DEACT_BIAS)
>     					  offline_css(memcg)
> 					    xchg(memcg, NULL)
>   mem_cgroup_iter_update
>     iter->last_visited = memcg
>   rcy_read_unlock
> 
> But if it was called from call_rcu the we should be safe AFAICS.

Oh yeah, it is racy.  That's what I meant by "not having to be
completely strict".  The race window is small enough and it's not like
we're messing up refcnt or may end up with use-after-free.  Doing it
from RCU would make the race go away but I'm not sure whether the
extra RCU bouncing is worthwhile.  I don't know.  Maybe.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
