From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 3/5] mm, memcg: introduce own oom handler to iterate only
 over its own threads
Date: Tue, 10 Jul 2012 16:24:29 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1207101620230.25532@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291405500.6040@chino.kir.corp.google.com> <20120710141959.b6a3ecbe.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=fxuJMVly2Hi4+HxDeDHMhfjI+USfmXiZROymOKEIrN4=;
        b=hVAuTx8bnBnFINS8zmM5XgiX7R4ZgdNpe1zgZxnR5Y81/iG013r2FwdnADIpoi4hN/
         yANkdd2afs7cYhcvD1/JENRx/hfhJpOUeEnDuq5htYve7BB3n5yKAbXmh4U72I14mrou
         4s84Ke6xDjDhR3XMKIEuXpAcChsGpmX5pRQYOPCHibdOCWJfAfEWaRw/5ybWAOPkJ3OW
         WNVlidJJrd0ule/ia/IDnPLlZWWRGg0P5iNYq1S2mAnm4IavXpH018BSP9V9EvsBvkbq
         9Z2sBxb49nn2HfGluu6ubrB72pOlBY8jhK+Z2o10Fxs56MSQMiRMAuyOx8oddLjshANq
         9Zmw==
In-Reply-To: <20120710141959.b6a3ecbe.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Minchan Kim <minchan@kernel.org>, Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 10 Jul 2012, Andrew Morton wrote:

> > The global oom killer is serialized by the zonelist being used in the
> > page allocation.
> 
> Brain hurts.  Presumably this is referring to some lock within the
> zonelist.  Clarify, please?
> 

Yeah, it's done with try_set_zonelist_oom() before calling the oom killer; 
it sets the ZONE_OOM_LOCKED bit for each zone in the zonelist to avoid 
concurrent oom kills for the same zonelist, otherwise it's possible to 
overkill.

> >  Concurrent oom kills are thus a rare event and only
> > occur in systems using mempolicies and with a large number of nodes.
> > 
> > Memory controller oom kills, however, can frequently be concurrent since
> > there is no serialization once the oom killer is called for oom
> > conditions in several different memcgs in parallel.
> > 
> > This creates a massive contention on tasklist_lock since the oom killer
> > requires the readside for the tasklist iteration.  If several memcgs are
> > calling the oom killer, this lock can be held for a substantial amount of
> > time, especially if threads continue to enter it as other threads are
> > exiting.
> > 
> > Since the exit path grabs the writeside of the lock with irqs disabled in
> > a few different places, this can cause a soft lockup on cpus as a result
> > of tasklist_lock starvation.
> > 
> > The kernel lacks unfair writelocks, and successful calls to the oom
> > killer usually result in at least one thread entering the exit path, so
> > an alternative solution is needed.
> > 
> > This patch introduces a seperate oom handler for memcgs so that they do
> > not require tasklist_lock for as much time.  Instead, it iterates only
> > over the threads attached to the oom memcg and grabs a reference to the
> > selected thread before calling oom_kill_process() to ensure it doesn't
> > prematurely exit.
> > 
> > This still requires tasklist_lock for the tasklist dump, iterating
> > children of the selected process, and killing all other threads on the
> > system sharing the same memory as the selected victim.  So while this
> > isn't a complete solution to tasklist_lock starvation, it significantly
> > reduces the amount of time that it is held.
> > 
> >
> > ...
> >
> > @@ -1469,6 +1469,65 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
> >  	return min(limit, memsw);
> >  }
> >  
> > +void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > +				int order)
> 
> Perhaps have a comment over this function explaining why it exists?
> 

It's removed in the last patch in the series, but I can add a comment to 
explain why we need to kill a task when a memcg reaches its limit to the 
new mem_cgroup_out_of_memory() if you'd like.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
