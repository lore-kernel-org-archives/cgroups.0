From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
Date: Mon, 25 Jun 2012 22:24:44 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252224350.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625162352.51997c5a.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=QZaBdsOU+yF2ruuencQevhDNLhr5HUZRucHHn/b5FkE=;
        b=CQg6QS7V581aI/0FvffHvN6sUIBEKHtihIQZu0FymXStpabZWtb6A25mUFCFJ/f9XI
         bkd1UVg4WFh2IDdhnZ/deNfPAuUqcG+n04qq86PqPzfV6OQBTgalWkWcyb1x/bdTeew+
         jF6C2iF2mecAtPLRh3/IiqB75UlMb+Eb36JemyXUzX7m9QulSXmSz7srM+K83NE5BDi6
         eiwjImI3VUgzlqtcOrGm+pSsBnZRVlBqeWX8XNJaGyzf15N9aXZteS8kMoiLj7Rbrjs6
         kxkhEZrrQ2L5zlIOJ7SM7ETWilXFqrw7wJBpvNAEGs7sE/DtVjEDlbsGSBK8610ED4Nd
         LLFg==
In-Reply-To: <20120625162352.51997c5a.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Mon, 25 Jun 2012, Andrew Morton wrote:

> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -287,7 +287,11 @@ struct mem_cgroup {
> >  	 * Should the accounting and control be hierarchical, per subtree?
> >  	 */
> >  	bool use_hierarchy;
> > -	bool kmem_accounted;
> > +	/*
> > +	 * bit0: accounted by this cgroup
> > +	 * bit1: accounted by a parent.
> > +	 */
> > +	volatile unsigned long kmem_accounted;
> 
> I suggest
> 
> 	unsigned long kmem_accounted;	/* See KMEM_ACCOUNTED_*, below */
> 
> >  	bool		oom_lock;
> >  	atomic_t	under_oom;
> > @@ -340,6 +344,9 @@ struct mem_cgroup {
> >  #endif
> >  };
> >  
> > +#define KMEM_ACCOUNTED_THIS	0
> > +#define KMEM_ACCOUNTED_PARENT	1
> 
> And then document the fields here.
> 

In hex, please?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
