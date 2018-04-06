From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 4/4] mm/vmscan: Don't mess with pgdat->flags in memcg reclaim.
Date: Fri, 6 Apr 2018 07:15:40 -0700
Message-ID: <CALvZod4YCvz4bvjcrQxi_=HeZ49pZcA2xvres6_jMKwvOdhqcg@mail.gmail.com>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
 <20180323152029.11084-5-aryabinin@virtuozzo.com> <CALvZod7P7cE38fDrWd=0caA2J6ZOmSzEuLGQH9VSaagCbo5O+A@mail.gmail.com>
 <72db1bfb-aa79-3764-54fd-2c7ddbd07bea@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=DZGX8UMMSb/gHPkaueqjmLtJwdiL8M7YEM0DWtQ4ksI=;
        b=qYtXsbDjKyZe1TYAPV5lBok/6VyRqXl/xqimQsyJ7h3cADZselA9hon5Zm49BuAgvm
         72TjbfIlanUGZOm2M5y+l2o7H9p7BPKqfF6k8lQJX0ujYbAUhK4hTPDPIOYvWRYbiPNM
         Hu7xP/IkErmMvKL0b4o+ST6CdUcvOR465pSue6bf6uHiZfjTKh8qEAvkxzMU3Gdg2SKc
         L9OxcHuidR04qynO8l+C/8UQQRTZtb4LHwZFdhWTS9Z7nNfbw4ocGsEsB6fl8dFSCavq
         6hgq1ujWx4VtQsjOexXdagK1zH6MU7janapAt4ebULaGMzrl7kYgVobRawG9GbCi7Jqp
         EcNw==
In-Reply-To: <72db1bfb-aa79-3764-54fd-2c7ddbd07bea@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Apr 6, 2018 at 4:44 AM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> On 04/06/2018 05:13 AM, Shakeel Butt wrote:
>> On Fri, Mar 23, 2018 at 8:20 AM, Andrey Ryabinin
>> <aryabinin@virtuozzo.com> wrote:
>>> memcg reclaim may alter pgdat->flags based on the state of LRU lists
>>> in cgroup and its children. PGDAT_WRITEBACK may force kswapd to sleep
>>> congested_wait(), PGDAT_DIRTY may force kswapd to writeback filesystem
>>> pages. But the worst here is PGDAT_CONGESTED, since it may force all
>>> direct reclaims to stall in wait_iff_congested(). Note that only kswapd
>>> have powers to clear any of these bits. This might just never happen if
>>> cgroup limits configured that way. So all direct reclaims will stall
>>> as long as we have some congested bdi in the system.
>>>
>>> Leave all pgdat->flags manipulations to kswapd. kswapd scans the whole
>>> pgdat, only kswapd can clear pgdat->flags once node is balance, thus
>>> it's reasonable to leave all decisions about node state to kswapd.
>>
>> What about global reclaimers? Is the assumption that when global
>> reclaimers hit such condition, kswapd will be running and correctly
>> set PGDAT_CONGESTED?
>>
>
> The reason I moved this under if(current_is_kswapd()) is because only kswapd
> can clear these flags. I'm less worried about the case when PGDAT_CONGESTED falsely
> not set, and more worried about the case when it falsely set. If direct reclaimer sets
> PGDAT_CONGESTED, do we have guarantee that, after congestion problem is sorted, kswapd
> ill be woken up and clear the flag? It seems like there is no such guarantee.
> E.g. direct reclaimers may eventually balance pgdat and kswapd simply won't wake up
> (see wakeup_kswapd()).
>
>
Thanks for the explanation, I think it should be in the commit message.
