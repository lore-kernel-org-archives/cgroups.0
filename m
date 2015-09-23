From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: make mem_cgroup_read_stat() unsigned
Date: Wed, 23 Sep 2015 00:21:33 -0700
Message-ID: <xr936131mwhu.fsf@gthelen.mtv.corp.google.com>
References: <20150922210346.749204fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=references:from:to:cc:subject:in-reply-to:date:message-id
         :mime-version:content-type;
        bh=Qt3PB1MJ644U+1WZsptE2Jj/tjfN8/yaZz0t8tybH64=;
        b=YRLrZZISivVKcz/gzu2sl70IeOX/XXuVhT084bBMLcEzEvEoXAvODgcgD2nwslbXlV
         kip/GQ3P0X9FQDFuKnW95aJe5/zTvjrvJsnewBRDZBjAFRuriILjLf1GuYzrxTDDGjAL
         HSueSkcyiMKuCVJo3gpa4cLFEmvdZ3BlYGIH3v1OarI1LqhSM4YhxZJa6OCvIrrZ+WXh
         O1sasgeRa61rk8DDHk/7UaNfqHCX3Ie9oqy78Kcj/WzlVCa4seZNdGJJTiuGkswQl0Qk
         E8KzAK7XqZq3I6+uVgH4vyQ/v5ZCmlFS/2sBZQ4U3Zt6kNVvubBLNCGAA/WAw49DwBPa
         lTWg==
In-reply-to: <20150922210346.749204fb.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


Andrew Morton wrote:

> On Tue, 22 Sep 2015 17:42:13 -0700 Greg Thelen <gthelen@google.com> wrote:
>
>> Andrew Morton wrote:
>> 
>> > On Tue, 22 Sep 2015 15:16:32 -0700 Greg Thelen <gthelen@google.com> wrote:
>> >
>> >> mem_cgroup_read_stat() returns a page count by summing per cpu page
>> >> counters.  The summing is racy wrt. updates, so a transient negative sum
>> >> is possible.  Callers don't want negative values:
>> >> - mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.
>> >> - oom reports and memory.stat shouldn't show confusing negative usage.
>> >> - tree_usage() already avoids negatives.
>> >>
>> >> Avoid returning negative page counts from mem_cgroup_read_stat() and
>> >> convert it to unsigned.
>> >
>> > Someone please remind me why this code doesn't use the existing
>> > percpu_counter library which solved this problem years ago.
>> >
>> >>   for_each_possible_cpu(cpu)
>> >
>> > and which doesn't iterate across offlined CPUs.
>> 
>> I found [1] and [2] discussing memory layout differences between:
>> a) existing memcg hand rolled per cpu arrays of counters
>> vs
>> b) array of generic percpu_counter
>> The current approach was claimed to have lower memory overhead and
>> better cache behavior.
>> 
>> I assume it's pretty straightforward to create generic
>> percpu_counter_array routines which memcg could use.  Possibly something
>> like this could be made general enough could be created to satisfy
>> vmstat, but less clear.
>> 
>> [1] http://www.spinics.net/lists/cgroups/msg06216.html
>> [2] https://lkml.org/lkml/2014/9/11/1057
>
> That all sounds rather bogus to me.  __percpu_counter_add() doesn't
> modify struct percpu_counter at all except for when the cpu-local
> counter overflows the configured batch size.  And for the memcg
> application I suspect we can set the batch size to INT_MAX...

Nod.  The memory usage will be a bit larger, but the code reuse is
attractive.  I dusted off Vladimir's
https://lkml.org/lkml/2014/9/11/710.  Next step is to benchmark it
before posting.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
