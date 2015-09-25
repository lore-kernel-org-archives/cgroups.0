From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: make mem_cgroup_read_stat() unsigned
Date: Fri, 25 Sep 2015 09:17:41 -0700
Message-ID: <xr93h9milbh6.fsf@gthelen.mtv.corp.google.com>
References: <20150925152533.GP16497@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:in-reply-to:date:message-id
         :mime-version:content-type;
        bh=Ql+jD04HqV7FDQnP/mlERwWsrNGR/FbPtwhJ3uRCVOk=;
        b=GS9K99R0XffRqCn9sUQFiWwqAz1Qp5IjceMtuGR60fZM6AcsQfjV65Y2ISE6Pr+Vh9
         fZvpBvjY4iL7HTftA3nw/7RopqtIESqHgkoelAWFH1pHe0LxGIVk0nVqWIK3SsFwy9mJ
         vc/gThUdvBj+uCXTjivYLBYmFJu/Uda8icDF9WPPymXRft1Sfggg9p62pLNUTtSws/m1
         0m1KaGT6n2j92mZWcyD0T+GxtQH+6avzaLGWDbbOMly5kgVIBxPPfBROONFlgbHyUIll
         yN3h38AHHq0hsysunCqL16CkdMhfIhUza2VcgFkL1yCVDMezYP7wOOW8yj00t8a/KvT3
         spBg==
In-reply-to: <20150925152533.GP16497@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, tj@kernel.org


Michal Hocko wrote:

> On Tue 22-09-15 15:16:32, Greg Thelen wrote:
>> mem_cgroup_read_stat() returns a page count by summing per cpu page
>> counters.  The summing is racy wrt. updates, so a transient negative sum
>> is possible.  Callers don't want negative values:
>> - mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.
>
> OK, this can confuse dirty throttling AFAIU
>
>> - oom reports and memory.stat shouldn't show confusing negative usage.
>
> I guess this is not earth shattering.
>
>> - tree_usage() already avoids negatives.
>> 
>> Avoid returning negative page counts from mem_cgroup_read_stat() and
>> convert it to unsigned.
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> I guess we want that for stable 4.2 because of the dirty throttling
> part. Longterm we should use generic per-cpu counter.
>
> Acked-by: Michal Hocko <mhocko@suse.com>
>
> Thanks!

Correct, this is not an earth shattering patch.  The patch only filters
out negative memcg stat values from mem_cgroup_read_stat() callers.
Negative values should only be temporary due to stat update races.  So
I'm not sure it's worth sending it to stable.  I've heard no reports of
it troubling anyone.  The worst case without this patch is that memcg
temporarily burps up a negative dirty and/or writeback count which
causes balance_dirty_pages() to sleep for a (at most) 200ms nap
(MAX_PAUSE).  Ccing Tejun in case there are more serious consequences to
balance_dirty_pages() occasionally seeing a massive (underflowed) dirty
or writeback count.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
