From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH 4/4] numa: introduce numa cling feature
Date: Fri, 12 Jul 2019 16:58:41 +0800
Message-ID: <0a5066be-ac10-5dce-c0a6-408725bc0784@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <9a440936-1e5d-d3bb-c795-ef6f9839a021@linux.alibaba.com>
 <20190711142728.GF3402@hirez.programming.kicks-ass.net>
 <82f42063-ce51-dd34-ba95-5b32ee733de7@linux.alibaba.com>
 <20190712075318.GM3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712075318.GM3402@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com



On 2019/7/12 下午3:53, Peter Zijlstra wrote:
[snip]
>>>>  	return target;
>>>>  }
>>>
>>> Select idle sibling should never cross node boundaries and is thus the
>>> entirely wrong place to fix anything.
>>
>> Hmm.. in our early testing the printk show both select_task_rq_fair() and
>> task_numa_find_cpu() will call select_idle_sibling with prev and target on
>> different node, thus we pick this point to save few lines.
> 
> But it will never return @prev if it is not in the same cache domain as
> @target. See how everything is gated by:
> 
>   && cpus_share_cache(x, target)

Yeah, that's right.

> 
>> But if the semantics of select_idle_sibling() is to return cpu on the same
>> node of target, what about move the logical after select_idle_sibling() for
>> the two callers?
> 
> No, that's insane. You don't do select_idle_sibling() to then ignore the
> result. You have to change @target before calling select_idle_sibling().
> 

I see, we should not override the decision of select_idle_sibling().

Actually the original design we try to achieve is:

  let wake affine select the target
  try find idle sibling of target
  if got one
	pick it
  else if task cling to prev
	pick prev

That is to consider wake affine superior to numa cling.

But after rethinking maybe this is not necessary, since numa cling is
also some kind of strong wake affine hint, actually maybe even a better
one to filter out the bad cases.

I'll try change @target instead and give a retest then.

Regards,
Michael Wang
