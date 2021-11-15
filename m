From: Andrey Ryabinin <arbn@yandex-team.com>
Subject: Re: [PATCH] cgroup: Fix rootcg cpu.stat guest double counting
Date: Mon, 15 Nov 2021 19:41:12 +0300
Message-ID: <161a70b7-ee6f-bbc7-8a2e-1fd42fcba3eb@yandex-team.com>
References: <20211028221528.2174284-1-schatzberg.dan@gmail.com>
 <20211029172129.smeyk5adocjrwtlb@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994379; bh=sJgNHnb3hOQwurINlS2X7YNRsTmHCa/JxTtjIM5qnfg=;
        h=In-Reply-To:References:Date:From:To:Subject:Message-ID:Cc;
        b=3JyafGaHD9qpsnhQ+lmPh5DLKs3kKIfHRnHasFGDpCRLUjaMtamqq+j7Dpx6hylln
         E4brZ/IlP8Aj4+b/OtVJTlqFno0lfwi8foBxXxIsj7hGrqhBHyrjq+SFCop8KTAaG/
         NqPhOgcmv/OH/N6sEeEKE84jBu0wU/BH+ACBVx6k=
In-Reply-To: <20211029172129.smeyk5adocjrwtlb@oracle.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Boris Burkov <boris@bur.io>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>



On 10/29/21 8:21 PM, Daniel Jordan wrote:
> On Thu, Oct 28, 2021 at 03:15:27PM -0700, Dan Schatzberg wrote:
>> In account_guest_time in kernel/sched/cputime.c guest time is
>> attributed to both CPUTIME_NICE and CPUTIME_USER in addition to
>> CPUTIME_GUEST_NICE and CPUTIME_GUEST respectively. Therefore, adding
>> both to calculate usage results in double counting any guest time at
>> the rootcg.
> 
> Yes, definitely a bug.  The same fix was posted a couple months ago as
> part of a series but never picked up:
> 
>   https://x-lore.kernel.org/all/20210820094005.20596-3-arbn@yandex-team.com/
> 
> The series also touched cputime, so we might be waiting for scheduler
> folks?   +Ingo +Peter +Andrey
> 

Yeah, I'll do rebase and send v3
