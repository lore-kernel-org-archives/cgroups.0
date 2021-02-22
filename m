From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Mon, 22 Feb 2021 09:41:00 -0800
Message-ID: <e132f836-b5d5-3776-22d6-669e713983e4@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
 <YDNuAIztiGJpLEtw@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YDNuAIztiGJpLEtw-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/22/21 12:40 AM, Michal Hocko wrote:
> On Fri 19-02-21 10:59:05, Tim Chen wrote:
 occurrence.
>>>
>>> Soft limit is evaluated every THRESHOLDS_EVENTS_TARGET * SOFTLIMIT_EVENTS_TARGET.
>>> If all events correspond with a newly charged memory and the last event
>>> was just about the soft limit boundary then we should be bound by 128k
>>> pages (512M and much more if this were huge pages) which is a lot!
>>> I haven't realized this was that much. Now I see the problem. This would
>>> be a useful information for the changelog.
>>>
>>> Your fix is focusing on the over-the-limit boundary which will solve the
>>> problem but wouldn't that lead to to updates happening too often in
>>> pathological situation when a memcg would get reclaimed immediatelly?
>>
>> Not really immediately.  The memcg that has the most soft limit excess will
>> be chosen for page reclaim, which is the way it should be.  
>> It is less likely that a memcg that just exceeded
>> the soft limit becomes the worst offender immediately. 
> 
> Well this all depends on when the the soft limit reclaim triggeres. In
> other words how often you see the global memory reclaim. If we have a
> memcg with a sufficient excess then this will work mostly fine. I was more
> worried about a case when you have memcgs just slightly over the limit
> and the global memory pressure is a regular event. You can easily end up
> bouncing memcgs off and on the tree in a rapid fashion. 
> 

If you are concerned about such a case, we can add an excess threshold,
say 4 MB (or 1024 4K pages), before we trigger a forced update. You think
that will cover this concern?

>>>
>>> One way around that would be to lower the SOFTLIMIT_EVENTS_TARGET. Have
>>> you tried that? Do we even need a separate treshold for soft limit, why
>>> cannot we simply update the tree each MEM_CGROUP_TARGET_THRESH?
>>>  
>>
>> Lowering the threshold is a band aid that really doesn't fix the problem.
>> I found that if the cgroup touches the memory infrequently enough, you
>> could still miss the update of it.  And in the mean time, you are updating
>> things a lot more frequently with added overhead.
> 
> Yes, I agree this is more of a workaround than a fix but I would rather
> go and touch the threshold which is simply bad than play more tricks
> which can lead to other potential problems. All that for a feature which
> is rarely used and quite problematic in itself. Not sure what Johannes
> thinks about that.
> 

I actually have tried adjusting the threshold but found that it doesn't work well for
the case with unenven memory access frequency between cgroups.  The soft
limit for the low memory event cgroup could creep up quite a lot, exceeding
the soft limit by hundreds of MB, even
if I drop the SOFTLIMIT_EVENTS_TARGET from 1024 to something like 8.

Tim
