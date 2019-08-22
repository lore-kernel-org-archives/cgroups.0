From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Thu, 22 Aug 2019 19:56:59 +0800
Message-ID: <348495d2-b558-fdfd-a411-89c75d4a9c78@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <6ba1ffb0-fce0-c590-c373-7cbc516dbebd@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6ba1ffb0-fce0-c590-c373-7cbc516dbebd@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Daniel Jordan <daniel.m.jordan@oracle.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>



在 2019/8/22 上午2:00, Daniel Jordan 写道:
>>
> 
> This is system-wide right, not per container?  Even per container, 89 usec isn't much contention over 20 seconds.  You may want to give this a try:

yes, perf lock show the host info.
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice> 
> It's also synthetic but it stresses lru_lock more than just anon alloc/free.  It hits the page activate path, which is where we see this lock in our database, and if enough memory is configured lru_lock also gets stressed during reclaim, similar to [1].

Thanks for the sharing, this patchset can not help the [1] case, since it's just relief the per container lock contention now. Yes, readtwice case could be more sensitive for this lru_lock changes in containers. I may try to use it in container with some tuning. But anyway, aim9 is also pretty good to show the problem and solutions. :)
> 
> It'd be better though, as Michal suggests, to use the real workload that's causing problems.  Where are you seeing contention?

We repeatly create or delete a lot of different containers according to servers load/usage, so normal workload could cause lots of pages alloc/remove. aim9 could reflect part of scenarios. I don't know the DB scenario yet.

> 
>> With this patch series, lruvec->lru_lock show no contentions
>>          &(&lruvec->lru_l...          8          0               0       0               0               0
>>
>> and aim9 page_test/brk_test performance increased 5%~50%.
> 
> Where does the 50% number come in?  The numbers below seem to only show ~4% boost.

the Setddev/CoeffVar case has about 50% performance increase. one of container's mmtests result as following:

Stddev    page_test      245.15 (   0.00%)      189.29 (  22.79%)
Stddev    brk_test      1258.60 (   0.00%)      629.16 (  50.01%)
CoeffVar  page_test        0.71 (   0.00%)        0.53 (  26.05%)
CoeffVar  brk_test         1.32 (   0.00%)        0.64 (  51.14%)

