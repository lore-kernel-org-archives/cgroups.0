From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Fri, 12 Jul 2019 17:11:25 +0800
Message-ID: <37474414-1a54-8e3a-60df-eb7e5e1cc1ed@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134754.GD3402@hirez.programming.kicks-ass.net>
 <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
 <20190712075815.GN3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712075815.GN3402@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com



On 2019/7/12 下午3:58, Peter Zijlstra wrote:
[snip]
>>>
>>> Then our task t1 should be accounted to B (as you do), but also to A and
>>> R.
>>
>> I get the point but not quite sure about this...
>>
>> Not like pages there are no hierarchical limitation on locality, also tasks
> 
> You can use cpusets to affect that.

Could you please give more detail on this?

> 
>> running in a particular group have no influence to others, not to mention the
>> extra overhead, does it really meaningful to account the stuff hierarchically?
> 
> AFAIU it's a requirement of cgroups to be hierarchical. All our other
> cgroup accounting is like that.

Ok, should respect the convention :-)

Regards,
Michael Wang

> 
