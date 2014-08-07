From: Greg Thelen <gthelen@google.com>
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for higher order requests
Date: Thu, 07 Aug 2014 09:10:43 -0700
Message-ID: <xr93lhr0z1ur.fsf@gthelen.mtv.corp.google.com>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org> <1407186897-21048-2-git-send-email-hannes@cmpxchg.org> <20140807130822.GB12730@dhcp22.suse.cz> <20140807153141.GD14734@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:date:in-reply-to:message-id
         :mime-version:content-type;
        bh=yLPSXEHQcnpqtHMT8W4ytAQpmUwfqpI/uqLF4FnjJTk=;
        b=KvYGTTBxCPdUCaFN0hSSpJ+vY0oG1lEDnamq9OT+oiX3hUjretT+t/EulNxO3pboPO
         G+75OqcY400itQDOb5UN5YSMjeDd/hpIDPkzctJJNJmytjCVMMuONV33ex314ZofL3iR
         eYM9HvTexICY+z6gAaw1WA5EAuBghoM/fr3bQ7Rbz9IE5gZbY3P1+vEi3ZTmQ8sbhlWL
         p6yrlnIfoU2VbT074b3F4+rCCBAo5r330bgMoBknHiM7J22s1ZkbJ+9LM8Cek9Et1sfa
         CG2YNk1rbCIAml8AA2EA0JIV47t+Xo2RHyl/H653AOqcnFnmMJvdyC35cvXh+uo4hQ9O
         +PAQ==
In-reply-to: <20140807153141.GD14734@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On Thu, Aug 07 2014, Johannes Weiner wrote:

> On Thu, Aug 07, 2014 at 03:08:22PM +0200, Michal Hocko wrote:
>> On Mon 04-08-14 17:14:54, Johannes Weiner wrote:
>> > Instead of passing the request size to direct reclaim, memcg just
>> > manually loops around reclaiming SWAP_CLUSTER_MAX pages until the
>> > charge can succeed.  That potentially wastes scan progress when huge
>> > page allocations require multiple invocations, which always have to
>> > restart from the default scan priority.
>> > 
>> > Pass the request size as a reclaim target to direct reclaim and leave
>> > it to that code to reach the goal.
>> 
>> THP charge then will ask for 512 pages to be (direct) reclaimed. That
>> is _a lot_ and I would expect long stalls to achieve this target. I
>> would also expect quick priority drop down and potential over-reclaim
>> for small and moderately sized memcgs (e.g. memcg with 1G worth of pages
>> would need to drop down below DEF_PRIORITY-2 to have a chance to scan
>> that many pages). All that done for a charge which can fallback to a
>> single page charge.
>> 
>> The current code is quite hostile to THP when we are close to the limit
>> but solving this by introducing long stalls instead doesn't sound like a
>> proper approach to me.
>
> THP latencies are actually the same when comparing high limit nr_pages
> reclaim with the current hard limit SWAP_CLUSTER_MAX reclaim, although
> system time is reduced with the high limit.
>
> High limit reclaim with SWAP_CLUSTER_MAX has better fault latency but
> it doesn't actually contain the workload - with 1G high and a 4G load,
> the consumption at the end of the run is 3.7G.
>
> So what I'm proposing works and is of equal quality from a THP POV.
> This change is complicated enough when we stick to the facts, let's
> not make up things based on gut feeling.

I think that high order non THP page allocations also benefit from this.
Such allocations don't have a small page fallback.

This may be in flux, but linux-next shows me that:
* mem_cgroup_reclaim()
  frees at least SWAP_CLUSTER_MAX (32) pages.
* try_charge() calls mem_cgroup_reclaim() indefinitely for
  costly (3) or smaller orders assuming that something is reclaimed on
  each iteration.
* try_charge() uses a loop of MEM_CGROUP_RECLAIM_RETRIES (5) for
  larger-than-costly orders.

So for larger-than-costly allocations, try_charge() should be able to
reclaim 160 (5*32) pages which satisfies an order:7 allocation.  But for
order:8+ allocations try_charge() and mem_cgroup_reclaim() are too eager
to give up without something like this.  So I think this patch is a step
in the right direction.

Coincidentally, we've been recently been experimenting with something
like this.  Though we didn't modify the interface between
mem_cgroup_reclaim() and try_to_free_mem_cgroup_pages() - instead we
looped within mem_cgroup_reclaim() until nr_pages of margin were found.
But I have no objection the proposed plumbing of nr_pages all the way
into try_to_free_mem_cgroup_pages().

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
