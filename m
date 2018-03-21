From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH 5/6] mm/vmscan: Don't change pgdat state on base of a
 single LRU list state.
Date: Wed, 21 Mar 2018 18:57:39 +0300
Message-ID: <3c5d5884-44a6-0c7f-dca3-adcde718e5ea@virtuozzo.com>
References: <20180315164553.17856-1-aryabinin@virtuozzo.com>
 <20180315164553.17856-5-aryabinin@virtuozzo.com>
 <20180320152550.GZ23100@dhcp22.suse.cz>
 <232175b6-4cb0-1123-66cb-b9acafdcd660@virtuozzo.com>
 <20180321113217.GG23100@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vZjpRWAISbitT9uPDZWNNbJKtVshIOqo0sG+qwP9mk0=;
 b=EJi5rSh2m7dtV65St+5u5BCqVwrgMll7OJQnINXZQwDEKlOp9iwmUK8j8ighsbnNb3lI1N43ZgIi21OAp0/pksSfDUj2fT/VshKBqIL9nlzAaYbB6EUoU7qbvMGQENyNtzSK7sFffi4GD4+ZXvxIbWMBt2iCZOzGIzwC1uoXghY=
In-Reply-To: <20180321113217.GG23100@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org



On 03/21/2018 02:32 PM, Michal Hocko wrote:
> On Wed 21-03-18 13:40:32, Andrey Ryabinin wrote:
>> On 03/20/2018 06:25 PM, Michal Hocko wrote:
>>> On Thu 15-03-18 19:45:52, Andrey Ryabinin wrote:
>>>> We have separate LRU list for each memory cgroup. Memory reclaim iterates
>>>> over cgroups and calls shrink_inactive_list() every inactive LRU list.
>>>> Based on the state of a single LRU shrink_inactive_list() may flag
>>>> the whole node as dirty,congested or under writeback. This is obviously
>>>> wrong and hurtful. It's especially hurtful when we have possibly
>>>> small congested cgroup in system. Than *all* direct reclaims waste time
>>>> by sleeping in wait_iff_congested().
>>>
>>> I assume you have seen this in real workloads. Could you be more
>>> specific about how you noticed the problem?
>>>
>>
>> Does it matter?
> 
> Yes. Having relevant information in the changelog can help other people
> to evaluate whether they need to backport the patch. Their symptoms
> might be similar or even same.
> 
>> One of our userspace processes have some sort of watchdog.
>> When it doesn't receive some event in time it complains that process stuck.
>> In this case in-kernel allocation stuck in wait_iff_congested.
> 
> OK, so normally it would exhibit as a long stall in the page allocator.
> Anyway I was more curious about the setup. I assume you have many memcgs
> and some of them with a very small hard limit which triggers the
> throttling to other memcgs?
 
Quite some time went since this was observed, so I may don't remember all details by now.
Can't tell you whether there really was many memcgs or just a few, but the more memcgs we have
the more severe the issue is, since wait_iff_congested() called per-lru.

What I've seen was one cgroup A doing a lot of write on NFS. It's easy to congest the NFS
by generating more than nfs_congestion_kb writeback pages.
Other task (the one that with watchdog) from different cgroup B went into *global* direct reclaim
and stalled in wait_iff_congested().
System had dozens gigabytes of clean inactive file pages and relatively few dirty/writeback on NFS.

So, to trigger the issue one must have one memcg with mostly dirty pages on congested device.
It doesn't have to be small or hard limit memcg.
Global reclaim kicks in, sees 'congested' memcg, sets CONGESTED bit, stalls in wait_iff_congested(),
goes to the next memcg stalls again, and so on and on until the reclaim goal is satisfied.


