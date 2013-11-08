From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 8 Nov 2013 08:34:57 -0500
Message-ID: <20131108133457.GD1092@cmpxchg.org>
References: <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <527CA292.7090104@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=T54XjVkXkzbXVEaUvGfUBia31JXJ8PGtHxx7DI5/6+o=;
	b=WXouQnOF7QH88I3PfasTYoWI6Ifc59VxPpvtEkCxjbrptRctWvrBzf9u7ALeS548aOcmqs6pEtRj5z1sqFH/diLHmaE3Ctbue/y222sVgYFA/+mUz04Mm2dHPSscAQgc5udMRDZZv/ZxSGny+pwglaFYwucrnC6E6gCwkPBtFBo=;
Content-Disposition: inline
In-Reply-To: <527CA292.7090104-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 08, 2013 at 04:36:34PM +0800, Li Zefan wrote:
> >>>>      kworker/3:5-7605  [003] ....   987.475678:
> >>>> mem_cgroup_reparent_charges: usage: 1568768
> >>>>      kworker/3:5-7605  [003] ....   987.478677:
> >>>> mem_cgroup_reparent_charges: usage: 1568768
> >>>>      kworker/3:5-7605  [003] ....   987.481675:
> >>>> mem_cgroup_reparent_charges: usage: 1568768
> >>>
> >>> So it's much more likely this is a memcg bug rather than a cgroup bug.
> >>> I hope memcg guys could look into it, or you could do a git-bisect if
> >>> you can reliably reproduce the bug.
> >>
> >> I think there is a problem with ref counting and memcg.
> >>
> >> The old scheme would wait with the charge reparenting until all
> >> references were gone for good, whereas the new scheme has only a RCU
> >> grace period between disabling tryget and offlining the css.
> >> Unfortunately, memory cgroups don't hold the rcu_read_lock() over both
> >> the tryget and the res_counter charge that would make it visible to
> >> offline_css(), which means that there is a possible race condition
> >> between cgroup teardown and an ongoing charge:
> >>
> >> #0: destroy                #1: charge
> >>
> >>                            rcu_read_lock()
> >>                            css_tryget()
> >>                            rcu_read_unlock()
> >> disable tryget()
> >> call_rcu()
> >>   offline_css()
> >>     reparent_charges()
> >>                            res_counter_charge()
> >>                            css_put()
> >>                              css_free()
> >>                            pc->mem_cgroup = deadcg
> >>                            add page to lru
> >>
> >> If the res_counter is hierarchical, there is now a leaked charge from
> >> the dead group in the parent counter with no corresponding page on the
> >> LRU, which will lead to this endless loop when deleting the parent.
> > 
> > Hugh, I bet your problem is actually the same thing, where
> > reparent_charges is looping and the workqueue is not actually stuck,
> > it's just that waiting for the CPU callbacks is the longest thing the
> > loop does so it's most likely to show up in the trace.
> > 
> >> The race window can be seconds if the res_counter hits its limit and
> >> page reclaim is entered between css_tryget() and the res counter
> >> charge succeeding.
> >>
> >> I thought about calling reparent_charges() again from css_free() at
> >> first to catch any raced charges.  But that won't work if the last
> >> reference is actually put by the charger because then it'll drop into
> >> the loop before putting the page on the LRU.
> > 
> > Actually, it *should* work after all, because the final css_put()
> > schedules css_free() in a workqueue, which will just block until the
> > charge finishes and lru-links the page.  Not the most elegant
> > behavior, but hey, neither is livelocking!
> > 
> > So how about this?
> > 
> 
> Thanks for the analysis and fix!
> 
> But we fix the bug by adding a call to mem_cgroup_reparent_charge() in
> css_free() while we are dead-looping in css_offline()? We won't call
> css_free() if css_offline() hasn't finished.

The css_free() reparenting is supposed to catch racing charges in the
child so that later on the css_offline() in the parent can find them.

> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Subject: [patch] mm: memcg: reparent charges during css_free()
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # 3.8+
> 
> FYI, I don't think Markus and google ever experience this issue
> before 3.11.

3.8 is when the cgroup destruction protocol changed.  But as per
Markus's email, his issue is actually not fixed by this, so back to
staring at the change history...
