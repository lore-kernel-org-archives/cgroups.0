From: Hugh Dickins <hughd@google.com>
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
Date: Wed, 28 Nov 2012 15:29:30 -0800 (PST)
Message-ID: <alpine.LNX.2.00.1211281509560.15410@eggly.anvils>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <20121120134932.055bc192.akpm@linux-foundation.org> <20121121083505.GA8761@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=xMLwTrlOjNnfnaO1HW4lkUOfbI21bO3mpWXaTS9padY=;
        b=pHoK8EgnnFs9dwcOd0shcTmPECar1oYfBATDaHZW6Gmky96LFTjRHHg28GizlICYDC
         3vIF2UcWmG/jfKpUoDl8yUikSqRcSPGpejjjlouA1FJJ2dMUKXNM8S06tl9ml0MaoAgq
         SQSs+Z85Woy0MlqImjdXuW98kqE8Cixd6gQJlL3ivj9Vr7i9JNj0zBegZTq7gzb215ao
         HSfcPVbEuzEgKKW2Fv2IGt5ZE8wzbH2NHPXYwLWYhtgLEdMKJrccT9E4UJY/oQ3NXyuP
         /BQnpQKXpcM09+KcXqUTHyjrFw4wWqkWpeISGN6YiPVjfS40Xe0/SO4qLXCwC37aqw4O
         /PzQ==
In-Reply-To: <20121121083505.GA8761@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>, David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, 21 Nov 2012, Michal Hocko wrote:
> On Tue 20-11-12 13:49:32, Andrew Morton wrote:
> > On Mon, 19 Nov 2012 17:44:34 -0800 (PST)
> > David Rientjes <rientjes@google.com> wrote:
> > 
> > > While profiling numa/core v16 with cgroup_disable=memory on the command 
> > > line, I noticed mem_cgroup_count_vm_event() still showed up as high as 
> > > 0.60% in perftop.
> > > 
> > > This occurs because the function is called extremely often even when memcg 
> > > is disabled.
> > > 
> > > To fix this, inline the check for mem_cgroup_disabled() so we avoid the 
> > > unnecessary function call if memcg is disabled.
> > > 
> > > ...
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
> > >  						gfp_t gfp_mask,
> > >  						unsigned long *total_scanned);
> > >  
> > > -void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> > > +void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> > > +static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
> > > +					     enum vm_event_item idx)
> > > +{
> > > +	if (mem_cgroup_disabled() || !mm)
> > > +		return;
> > > +	__mem_cgroup_count_vm_event(mm, idx);
> > > +}
> > 
> > Does the !mm case occur frequently enough to justify inlining it, or
> > should that test remain out-of-line?
> 
> Now that you've asked about it I started looking around and I cannot see
> how mm can ever be NULL. The condition is there since the very beginning
> (456f998e memcg: add the pagefault count into memcg stats) but all the
> callers are page fault handlers and those shouldn't have mm==NULL.
> Or is there anything obvious I am missing?
> 
> Ying, the whole thread starts https://lkml.org/lkml/2012/11/19/545 but
> the primary question is why we need !mm test for mem_cgroup_count_vm_event
> at all.

Here's a guess: as Ying's 456f998e patch started out in akpm's tree,
shmem.c was calling mem_cgroup_count_vm_event(current->mm, PGMAJFAULT).

Then I insisted that was inconsistent with how we usually account when
one task touches another's address space, and rearranged it to work on
vma->vm_mm instead.

Done the original way, if the touching task were a kernel daemon (KSM's
ksmd comes to my mind), then the current->mm could well have been NULL.

I agree with you that it looks redundant now.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
