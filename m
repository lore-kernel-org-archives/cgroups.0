From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 4/5] mm, oom: reduce dependency on tasklist_lock
Date: Tue, 10 Jul 2012 14:04:36 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1207101400500.12399@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com> <20120703181708.GB14104@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=X8ayqGA1rm55qOlRMmXwDRDZzRBbNQrzGdGPNc8YFdY=;
        b=dkzo7UN6zW5SEraQcJhnCtmnfm1r3xyhwzPglm+YlauMmfBwCWCfEphdeXaHR7BqMy
         H3JVdV06BOGm+tVtLgWsuRGQg8o+racVSIrR4VehxuKh63bGqprCOgadYYAkTwnxCCg9
         RPGkOs0crjRjXX1NxJ+7s25iGqpSODtCrVkpLn4FJ0qGU9Uk/kjZecEubgsnFcThaWAr
         8Zq6yza5aewNRbzGTXzfXzv6fIgKXIy5uAsJnFe2wOg/fuJHQEE3DDzOtJ6CMFEv6R05
         jhC8jr2WyATAcmXJ/0Z3TYDWPvxGv++jerTjcD3b2AeHVtdhS/LoM9vXSFiXfxAkHH7/
         750A==
In-Reply-To: <20120703181708.GB14104@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 3 Jul 2012, Oleg Nesterov wrote:

> >  		      unsigned int points, unsigned long totalpages,
> >  		      struct mem_cgroup *memcg, nodemask_t *nodemask,
> > @@ -454,6 +462,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  	 */
> >  	if (p->flags & PF_EXITING) {
> >  		set_tsk_thread_flag(p, TIF_MEMDIE);
> > +		put_task_struct(p);
> >  		return;
> >  	}
> >  
> > @@ -471,6 +480,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  	 * parent.  This attempts to lose the minimal amount of work done while
> >  	 * still freeing memory.
> >  	 */
> > +	read_lock(&tasklist_lock);
> >  	do {
> >  		list_for_each_entry(child, &t->children, sibling) {
> >  			unsigned int child_points;
> > @@ -483,15 +493,26 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  			child_points = oom_badness(child, memcg, nodemask,
> >  								totalpages);
> >  			if (child_points > victim_points) {
> > +				put_task_struct(victim);
> >  				victim = child;
> >  				victim_points = child_points;
> > +				get_task_struct(victim);
> >  			}
> >  		}
> >  	} while_each_thread(p, t);
> > +	read_unlock(&tasklist_lock);
> >  
> > -	victim = find_lock_task_mm(victim);
> > -	if (!victim)
> > +	rcu_read_lock();
> > +	p = find_lock_task_mm(victim);
> > +	if (!p) {
> > +		rcu_read_unlock();
> > +		put_task_struct(victim);
> >  		return;
> > +	} else if (victim != p) {
> > +		get_task_struct(p);
> > +		put_task_struct(victim);
> > +		victim = p;
> > +	}
> >  
> >  	/* mm cannot safely be dereferenced after task_unlock(victim) */
> >  	mm = victim->mm;
> > @@ -522,9 +543,11 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  			task_unlock(p);
> >  			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
> >  		}
> > +	rcu_read_unlock();
> >  
> >  	set_tsk_thread_flag(victim, TIF_MEMDIE);
> >  	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
> > +	put_task_struct(victim);
> 
> It seems to me we can avoid this get/put dance in oom_kill_process(),
> just you need to extend the rcu-protected area. In this case the caller
> of select_bad_process() does a single put_, and
> sysctl_oom_kill_allocating_task doesn't need get_task_struct(current).
> Look more clean/simple to me.
> 

We could grab rcu_read_lock() before the first tasklist scan and hold it 
until a process is killed, yes, but there's a higher liklihood that it 
will never be dropped for concurrent oom kills in the same way that the 
write-side of tasklist_lock is currently starved.  On a system with a 
large number of cpus this isn't even a rare situation to run into: the 
read lock will never be dropped on all cpus.  I've attempted to make it as 
fine-grained as possible and only hold it when absolutely required and use 
task references to keep the selected threads around until they are killed.

Let me know if you have a better solution to rcu read lock starvation.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
