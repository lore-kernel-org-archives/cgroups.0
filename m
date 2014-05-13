From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 02/14] cgroup: remove pointless has tasks/children test
 from mem_cgroup_force_empty()
Date: Tue, 13 May 2014 09:10:15 -0400
Message-ID: <20140513131014.GB18849@cmpxchg.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Fs6I6ov7TFvCiMeku/mdfKRx/apuwbBlPr5jXxoyI4U=;
	b=BXvUth9oj6/A8dQobYPcbe/QHSMNWNhczisZf24u/HMTSIznrz3etkT8B+hhq+jyfTB3OAbpHl9tGsDqUxmisgfcbduhC3yMS4l8IqTX5/opPgUuu/5dyPEpo4+arPzYIdUbugCOwAeae8qMJJSPSAPcTKT9aPrSC4JHaRulzeo=;
Content-Disposition: inline
In-Reply-To: <20140512145324.GE9564-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 12, 2014 at 04:53:24PM +0200, Michal Hocko wrote:
> On Fri 09-05-14 17:31:19, Tejun Heo wrote:
> > mem_cgroup_force_empty() is used only from
> > mem_cgroup_force_empty_write() and tests whether the target memcg has
> > any tasks or children without any synchronization and then returns
> > -EBUSY if so.
> > 
> > This is just weird.  The tests don't really mean anything as tasks and
> > children may be added after the tests and it also makes the behavior
> > of the knob arbitrary because there may be lingering offline and
> > removed children on the children list for extended period of time -
> > writes to the knob can return -EBUSY for reasons completely invisible
> > to userland.
> 
> Agreed.
> 
> > The knob is best-effort anyway and the broken business test doesn't
> > affect its operation.  Remove it.
> 
> But I do not think that removing just the test is the right way to go.
> It is mem_cgroup_reparent_charges which bothers me because it loops
> until the current counter falls down to 0 and it also feels strange that
> a group can hand over pages up the hierarchy (or even to an unlimitted
> root if this is a top of a hierarchy).
> 
> So I think that we want to get rid of reparenting as well.  The main use
> case as described by the documentation is:
> "
>   The typical use case for this interface is before calling rmdir().
>   Because rmdir() moves all pages to parent, some out-of-use page caches can be
>   moved to the parent. If you want to avoid that, force_empty will be useful.
> "
> 
> rmdir will reparent pages implicitly so the reclaim part should be
> sufficient and it would be OK even with existing tasks. Subgroups would
> be little bit more tricky because the user doesn't have any control over
> which group of the hierarchy will get reclaimed.
> 
> Anyway, the knob sucks - for the similar reasons why drop_cache sucks -
> especially when the check would be gone and it would be another way how
> to trigger reclaim anytime. Having the check doesn't prevent from races
> but it at least prevents abuse.
> 
> So I would be rather for dropping the knob altogether, but that seems to
> be a long term thing. So let's start with deprecating it + remove the
> check with dropping reparenting part.
> 
> What do you think about the following patch instead:
> ---
> >From 03f8cb2e1fd2636d859c54df9b58719fe96e0e54 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Mon, 12 May 2014 16:34:17 +0200
> Subject: [PATCH] memcg: remove tasks/children test from from
>  mem_cgroup_force_empty
> 
> Tejun has correctly pointed out that tasks/children test in
> mem_cgroup_force_empty is not correct because there is no other locking
> which preserves this state throughout the rest of the function so both
> new tasks can join the group or new children groups can be added while
> somebody is writing to memory.force_empty. A new task would break
> mem_cgroup_reparent_charges expectation that all failures as described
> by mem_cgroup_force_empty_list are temporal and there is no way out.
> 
> The main use case for the knob as described by
> Documentation/cgroups/memory.txt is to:
> "
>   The typical use case for this interface is before calling rmdir().
>   Because rmdir() moves all pages to parent, some out-of-use page caches can be
>   moved to the parent. If you want to avoid that, force_empty will be useful.
> "
> 
> This means that reparenting is not really required as rmdir will
> reparent pages implicitly from the safe context. If we remove it from
> mem_cgroup_force_empty then we are safe even with existing tasks because
> the number of reclaim attempts is bounded. Moreover the knob still does
> what the documentation claims (modulo reparenting which doesn't make any
> difference) and users might expect. Longterm we want to deprecate the
> whole knob and put the reparented pages to the tail of parent LRU during
> cgroup removal.

Yeah, let's deprecate the knob, but please change this to "deal with
left-over pages during cgroup removal".  Reparenting is an
implementation detail.

In fact, now that Tejun made offlined csss iterable, we can make
charges pin the css beyond cgroup lifetime and just reclaim leftovers
from their original css.  Then get rid of exit-reparenting entirely.

Should also make kmemcg handling during cgroup removal much easier...

[ I was going to send patches to do all this already but couldn't get
  them ready in time before my vacation. ]

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
