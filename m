From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: 4.3-rc1 dirty page count underflow (cgroup-related?)
Date: Fri, 18 Sep 2015 07:50:42 -0700
Message-ID: <55FC24C2.8020501@intel.com>
References: <55FB9319.2010000@intel.com>
 <xr938u84ntrn.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <xr938u84ntrn.fsf@gthelen.mtv.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>

On 09/17/2015 11:09 PM, Greg Thelen wrote:
> I'm not denying the issue, bug the WARNING splat isn't necessarily
> catching a problem.  The corresponding code comes from your debug patch:
> +		WARN_ONCE(__this_cpu_read(memcg->stat->count[MEM_CGROUP_STAT_DIRTY]) > (1UL<<30), "MEM_CGROUP_STAT_DIRTY bogus");
> 
> This only checks a single cpu's counter, which can be negative.  The sum
> of all counters is what matters.
> Imagine:
> cpu1) dirty page: inc
> cpu2) clean page: dec
> The sum is properly zero, but cpu2 is -1, which will trigger the WARN.
> 
> I'll look at the code and also see if I can reproduce the failure using
> mem_cgroup_read_stat() for all of the new WARNs.

D'oh.  I'll replace those with the proper mem_cgroup_read_stat() and
test with your patch to see if anything still triggers.

> Did you notice if the global /proc/meminfo:Dirty count also underflowed?

It did not underflow.  It was one of the first things I looked at and it
looked fine, went down near 0 at 'sync', etc...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
