From: David Rientjes <rientjes@google.com>
Subject: Re: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for
 cpu hotplug
Date: Tue, 1 Oct 2013 20:08:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310011958440.31300@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com> <20131002022227.GR856@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=ezMYM7Snb2ayNlGxKffWHEXIMyzftKTx6msg7lX4V9c=;
        b=QqS+bKVpd+Krw1Winbj6Cj4wYlwkBU7qOGQxx4DlJaIvD/Pn9WtKeGhetS2oxrC7vo
         NvIgKd6H7xKbSufCyX04/kmEwkYnsN+fYJvXhL9L/TvvJRv5H799E7I5n26uqjRwZnHj
         gGnGROzltZ2jTW2cjVMYwbpj4OHIITKJz72fb5rURSSNY85NAFR/fDfDIwomyvWMdld/
         VTqD0YKCVItshrZsW7+gHNdlCiTuMevC7+srV4g9Y6IfGyugweU4XiapY/BH4NhpUyvd
         l+OxwaqUIM8vC3X3VGSZfWDkL5f6YwwNbnhzvKBeZ/iYDVNNKXYVFOKOuBbRB2PsDv0M
         2rOw==
In-Reply-To: <20131002022227.GR856@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Johannes Weiner wrote:

> On Tue, Oct 01, 2013 at 04:31:23PM -0700, David Rientjes wrote:
> > for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
> > cpu_online_mask doesn't change during the iteration.
> 
> There is no problem report here.
> 
> Is there a crash?
> 

No.

> If it's just accuracy of the read, why would we care about some
> inaccuracies in counters that can change before you even get the
> results to userspace?  And care to the point where we hold up CPU
> hotplugging for this?
> 

cpu_hotplug.lock is held while a cpu is going down, it's a coarse lock 
that is used kernel-wide to synchronize cpu hotplug activity.  Memcg has 
a cpu hotplug notifier, called while there may not be any cpu hotplug 
refcounts, which drains per-cpu event counts to memcg->nocpu_base.events 
to maintain a cumulative event count as cpus disappear.  Without 
get_online_cpus() in mem_cgroup_read_events(), it's possible to account 
for the event count on a dying cpu twice, and this value may be 
significantly large.

In fact, all memcg->pcp_counter_lock use should be nested by 
{get,put}_online_cpus().

This fixes that issue and ensures the reported statistics are not vastly 
over-reported during cpu hotplug.

> Also, the fact that you directly sent this to Linus suggests there is
> some urgency for this fix.  What's going on?
> 

I believe users of cpu hotplug still want event counts that are 
approximate to the real value and that this is 3.12 material.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
