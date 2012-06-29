From: David Rientjes <rientjes@google.com>
Subject: Re: [rfc][patch 3/3] mm, memcg: introduce own oom handler to iterate
 only over its own threads
Date: Fri, 29 Jun 2012 13:37:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206291333080.6040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206251847180.24838@chino.kir.corp.google.com> <4FE94968.6010500@jp.fujitsu.com> <alpine.DEB.2.00.1206261323260.8673@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206262229380.32567@chino.kir.corp.google.com> <alpine.DEB.2.00.1206271837460.14446@chino.kir.corp.google.com> <20120628171618.GA27089@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=3JqaoAh62/xCzkR4G6Iqyr4XCi9vh3Q8pVv3h2kC4J4=;
        b=nhMxT39AXIvhHOYTemW0zyTYSn5zU/jYdDN6PMNPF4cBk+NOLBsvhNHJlod+VhIB/T
         0ksx5hf3zqRZEX2MqPkuh6y2buB03UKLtod+h3bX62oZ4bIvhgQVi0Kn2j0r/lYWjl5/
         9WWn+xo+3AhcdtlJ6+0LSRm4b+TqHljcRBogMaNdh3bNUW5GA4yAwTNo6JtLKxVb9Qt0
         uagOWJ/2JKIIYFbdf/pdf4YxX2eOO0xGWrhfXB29UC4uEN0XulttnfPpZvrxXQKd1oLR
         LJ2AxqDevkzaPha1v8Z67UljpsobKd/h475uVk1z56WMTCk0vB4M7IEVEQ8j2YPqMtz4
         rJ2g==
In-Reply-To: <20120628171618.GA27089@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu, 28 Jun 2012, Oleg Nesterov wrote:

> > @@ -348,6 +348,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
> >  	struct task_struct *chosen = NULL;
> >  	unsigned long chosen_points = 0;
> >
> > +	rcu_read_lock();
> >  	do_each_thread(g, p) {
> >  		unsigned int points;
> >
> > @@ -370,6 +371,9 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
> >  			chosen_points = points;
> >  		}
> >  	} while_each_thread(g, p);
> > +	if (chosen)
> > +		get_task_struct(chosen);
> 
> OK, so the caller should do put_task_struct().
> 

oom_kill_process() will now do the put_task_struct() since we need a 
reference before killing it, so callers to oom_kill_process() are 
responsible for grabbing it before doing rcu_read_unlock().

> But, unless I misread the patch,
> 
> > @@ -454,6 +458,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> > ...
> > +	rcu_read_lock();
> > +	p = find_lock_task_mm(victim);
> > +	if (!p) {
> > +		rcu_read_unlock();
> > +		put_task_struct(victim);

So if the victim has no threads that have an mm, then we have raced with 
select_bad_process() and we silently return.

> >  		return;
> > +	} else
> > +		victim = p;
> 
> And, before return,
> 
> > +	put_task_struct(victim);
> 
> Doesn't look right if victim != p.
> 

Ah, good catch, we need to do

	if (!p) {
		rcu_read_unlock();
		put_task_struct(victim);
		return;
	} else {
		put_task_struct(victim);
		victim = p;
		get_task_struct(victim);
		rcu_read_unlock();
	}

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
