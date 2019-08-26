From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Mon, 26 Aug 2019 11:39:49 +0300
Message-ID: <d5256ebf-8314-8c24-a7ed-e170b7d39b61@yandex-team.ru>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <6ba1ffb0-fce0-c590-c373-7cbc516dbebd@oracle.com>
 <348495d2-b558-fdfd-a411-89c75d4a9c78@linux.alibaba.com>
 <b776032e-eabb-64ff-8aee-acc2b3711717@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1566808791; bh=Y7ejts7lpiJhlX4+egWDk+iu4dJWOZ7po0kKT0OpMC4=;
        h=In-Reply-To:References:Date:Message-ID:From:To:Subject;
        b=ZVQN0C0X7bfLpqONhnIcbXCciPSnf0ZQe87EOzqxF7ubpJcjvtoTJmY+Jof+wIqia
         PEaE9w9ENQcqOpxatGvjD0TmDLw+9EItjqMz8obWXNyoLfUEk2Nq2/ckAr+NthoGs5
         cCPwE+ZAbNG9qfRqLLqgDRWz23KdHvzmNr8zZToU=
In-Reply-To: <b776032e-eabb-64ff-8aee-acc2b3711717@oracle.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Hugh Dickins <hughd@google.com>

On 22/08/2019 18.20, Daniel Jordan wrote:
> On 8/22/19 7:56 AM, Alex Shi wrote:
>> 在 2019/8/22 上午2:00, Daniel Jordan 写道:
>>>    https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice>
>>> It's also synthetic but it stresses lru_lock more than just anon alloc/free.  It hits the page activate path, which is where we see this 
>>> lock in our database, and if enough memory is configured lru_lock also gets stressed during reclaim, similar to [1].
>>
>> Thanks for the sharing, this patchset can not help the [1] case, since it's just relief the per container lock contention now.
> 
> I should've been clearer.  [1] is meant as an example of someone suffering from lru_lock during reclaim.  Wouldn't your series help 
> per-memcg reclaim?
> 
>> Yes, readtwice case could be more sensitive for this lru_lock changes in containers. I may try to use it in container with some tuning. 
>> But anyway, aim9 is also pretty good to show the problem and solutions. :)
>>>
>>> It'd be better though, as Michal suggests, to use the real workload that's causing problems.  Where are you seeing contention?
>>
>> We repeatly create or delete a lot of different containers according to servers load/usage, so normal workload could cause lots of pages 
>> alloc/remove. 
> 
> I think numbers from that scenario would help your case.
> 
>> aim9 could reflect part of scenarios. I don't know the DB scenario yet.
> 
> We see it during DB shutdown when each DB process frees its memory (zap_pte_range -> mark_page_accessed).  But that's a different thing, 
> clearly Not This Series.
> 
>>>> With this patch series, lruvec->lru_lock show no contentions
>>>>           &(&lruvec->lru_l...          8          0               0       0               0               0
>>>>
>>>> and aim9 page_test/brk_test performance increased 5%~50%.
>>>
>>> Where does the 50% number come in?  The numbers below seem to only show ~4% boost.
>>After splitting lru-locks present per-cpu page-vectors works no so well
because they mixes pages from different cgroups.

pagevec_lru_move_fn and friends need better implementation:
either sorting pages or splitting vectores in per-lruvec basis.
>> the Setddev/CoeffVar case has about 50% performance increase. one of container's mmtests result as following:
>>
>> Stddev    page_test      245.15 (   0.00%)      189.29 (  22.79%)
>> Stddev    brk_test      1258.60 (   0.00%)      629.16 (  50.01%)
>> CoeffVar  page_test        0.71 (   0.00%)        0.53 (  26.05%)
>> CoeffVar  brk_test         1.32 (   0.00%)        0.64 (  51.14%)
> 
> Aha.  50% decrease in stdev.
> 

After splitting lru-locks present per-cpu page-vectors works
no so well because they mix pages from different cgroups.

pagevec_lru_move_fn and friends need better implementation:
either sorting pages or splitting vectores in per-lruvec basis.
