From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] mm/oom_kill: count global and memory cgroup oom kills
Date: Mon, 22 May 2017 12:11:19 +0300
Message-ID: <ecd4a7ea-06c0-f549-a1bf-6d2d3c0af719@yandex-team.ru>
References: <149520375057.74196.2843113275800730971.stgit@buzz>
 <CALo0P1123MROxgveCdX6YFpWDwG4qrAyHu3Xd1F+ckaFBnF4dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1495444280; bh=6Xu4uCmRFlXEMJNHnyWN8/gt5EACOsdR67kaUpF4YbE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:In-Reply-To;
	b=SFgSBiy4gevxJ91tQrcUT0e38S65sXyRZXzPH9+7stiSPre6Rb26zzdmoVj8JuVYQ
	 YnjiRC1R9mGRQ0fIwyuraa+Z8g2wodLWBQ+kDy/UQnaU+CvTccmfoTs6mILwt9D2Yi
	 8fy/smxghSmQZUThAMUjHlnYUXEWbMb6SjjZm6ZE=
In-Reply-To: <CALo0P1123MROxgveCdX6YFpWDwG4qrAyHu3Xd1F+ckaFBnF4dQ@mail.gmail.com>
Content-Language: ru-RU
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Guschin <guroan@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, hannes@cmpxchg.org



On 19.05.2017 19:34, Roman Guschin wrote:
> 2017-05-19 15:22 GMT+01:00 Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
>> Show count of global oom killer invocations in /proc/vmstat and
>> count of oom kills inside memory cgroup in knob "memory.events"
>> (in memory.oom_control for v1 cgroup).
>>
>> Also describe difference between "oom" and "oom_kill" in memory
>> cgroup documentation. Currently oom in memory cgroup kills tasks
>> iff shortage has happened inside page fault.
>>
>> These counters helps in monitoring oom kills - for now
>> the only way is grepping for magic words in kernel log.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> ---
>>   Documentation/cgroup-v2.txt   |   12 +++++++++++-
>>   include/linux/memcontrol.h    |    1 +
>>   include/linux/vm_event_item.h |    1 +
>>   mm/memcontrol.c               |    2 ++
>>   mm/oom_kill.c                 |    6 ++++++
>>   mm/vmstat.c                   |    1 +
>>   6 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
>> index dc5e2dcdbef4..a742008d76aa 100644
>> --- a/Documentation/cgroup-v2.txt
>> +++ b/Documentation/cgroup-v2.txt
>> @@ -830,9 +830,19 @@ PAGE_SIZE multiple when read back.
>>
>>            oom
>>
>> +               The number of time the cgroup's memory usage was
>> +               reached the limit and allocation was about to fail.
>> +               Result could be oom kill, -ENOMEM from any syscall or
>> +               completely ignored in cases like disk readahead.
>> +               For now oom in memory cgroup kills tasks iff shortage
>> +               has happened inside page fault.
> 
>  From a user's point of view the difference between "oom" and "max"
> becomes really vague here,
> assuming that "max" is described almost in the same words:
> 
> "The number of times the cgroup's memory usage was
> about to go over the max boundary.  If direct reclaim
> fails to bring it down, the OOM killer is invoked."
> 
> I wonder, if it's better to fix the existing "oom" value  to show what
> it has to show, according to docs,
> rather than to introduce a new one?
> 

Nope, they are different. I think we should rephase documentation somehow

low - count of reclaims below low level
high - count of post-allocation reclaims above high level
max - count of direct reclaims
oom - count of failed direct reclaims
oom_kill - count of oom killer invocations and killed processes

>> +
>> +         oom_kill
>> +
>>                  The number of times the OOM killer has been invoked in
>>                  the cgroup.  This may not exactly match the number of
>> -               processes killed but should generally be close.
>> +               processes killed but should generally be close: each
>> +               invocation could kill several processes at once.
>>
>>     memory.stat
>>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
