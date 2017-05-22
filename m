From: Roman Guschin <guroan@gmail.com>
Subject: Re: [PATCH] mm/oom_kill: count global and memory cgroup oom kills
Date: Mon, 22 May 2017 19:05:51 +0100
Message-ID: <CALo0P10LM4LYWidrNKGkw=6Bcrq198gmwPbpUBD7yt4C=jJ0pQ@mail.gmail.com>
References: <149520375057.74196.2843113275800730971.stgit@buzz>
 <CALo0P1123MROxgveCdX6YFpWDwG4qrAyHu3Xd1F+ckaFBnF4dQ@mail.gmail.com> <ecd4a7ea-06c0-f549-a1bf-6d2d3c0af719@yandex-team.ru>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=t1ObjOtPxhRgbCuuCyVcbZ/yb4aNzDUHvE4iXks38DU=;
        b=MmZS9GKUznFfqCcsLupFPmMKClBw8TbjrloAo6J0UL1N7mBju6S/942X8/LI9T1Aiw
         iRcQAIymCMdMEpSZVLIM6rdWONrDqOsDMY85eaWBV+8lgkZqBlrQP6ecbpf/Ien9M8s1
         6eFpMmEyy2f+puBdihgJJIJoTgGC2LTaY0ONGSZFMOPvmqe8CPRTsa9U6z8boEdBNrJc
         J0an7Yy4P5GK0/ZFslp/gROKW1156OuHTCJpERC3bL/t1uIs/dH1nlwzJao72HWaoaAh
         4ERuFftQIgG3bbVsS7EjK5TrekWUqTh4PwysO6BK8ehNEh91wE+cKdNEULPSdmrsFk75
         wZ9g==
In-Reply-To: <ecd4a7ea-06c0-f549-a1bf-6d2d3c0af719@yandex-team.ru>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>

2017-05-22 10:11 GMT+01:00 Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
>
>
> On 19.05.2017 19:34, Roman Guschin wrote:
>>
>> 2017-05-19 15:22 GMT+01:00 Konstantin Khlebnikov
>> <khlebnikov@yandex-team.ru>:
>>  From a user's point of view the difference between "oom" and "max"
>> becomes really vague here,
>> assuming that "max" is described almost in the same words:
>>
>> "The number of times the cgroup's memory usage was
>> about to go over the max boundary.  If direct reclaim
>> fails to bring it down, the OOM killer is invoked."
>>
>> I wonder, if it's better to fix the existing "oom" value  to show what
>> it has to show, according to docs,
>> rather than to introduce a new one?
>>
>
> Nope, they are different. I think we should rephase documentation somehow
>
> low - count of reclaims below low level
> high - count of post-allocation reclaims above high level
> max - count of direct reclaims
> oom - count of failed direct reclaims
> oom_kill - count of oom killer invocations and killed processes

Definitely worth it.

Also, I would prefer to reserve "oom" for number of oom victims,
and introduce something like "reclaim_failed".
It will be consistent with existing vmstat.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
