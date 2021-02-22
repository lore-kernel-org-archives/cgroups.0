From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Mon, 22 Feb 2021 11:23:45 -0800
Message-ID: <1d8d4ec6-e97d-b7e5-695e-f189404a80fd@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
 <YDNuAIztiGJpLEtw@dhcp22.suse.cz>
 <e132f836-b5d5-3776-22d6-669e713983e4@linux.intel.com>
 <YDQBh5th9txxEFUm@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YDQBh5th9txxEFUm-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/22/21 11:09 AM, Michal Hocko wrote:
> On Mon 22-02-21 09:41:00, Tim Chen wrote:
>>
>>
>> On 2/22/21 12:40 AM, Michal Hocko wrote:
>>> On Fri 19-02-21 10:59:05, Tim Chen wrote:
>>  occurrence.
>>>>>
>>>>> Soft limit is evaluated every THRESHOLDS_EVENTS_TARGET * SOFTLIMIT_EVENTS_TARGET.
>>>>> If all events correspond with a newly charged memory and the last event
>>>>> was just about the soft limit boundary then we should be bound by 128k
>>>>> pages (512M and much more if this were huge pages) which is a lot!
>>>>> I haven't realized this was that much. Now I see the problem. This would
>>>>> be a useful information for the changelog.
>>>>>
>>>>> Your fix is focusing on the over-the-limit boundary which will solve the
>>>>> problem but wouldn't that lead to to updates happening too often in
>>>>> pathological situation when a memcg would get reclaimed immediatelly?
>>>>
>>>> Not really immediately.  The memcg that has the most soft limit excess will
>>>> be chosen for page reclaim, which is the way it should be.  
>>>> It is less likely that a memcg that just exceeded
>>>> the soft limit becomes the worst offender immediately. 
>>>
>>> Well this all depends on when the the soft limit reclaim triggeres. In
>>> other words how often you see the global memory reclaim. If we have a
>>> memcg with a sufficient excess then this will work mostly fine. I was more
>>> worried about a case when you have memcgs just slightly over the limit
>>> and the global memory pressure is a regular event. You can easily end up
>>> bouncing memcgs off and on the tree in a rapid fashion. 
>>>
>>
>> If you are concerned about such a case, we can add an excess threshold,
>> say 4 MB (or 1024 4K pages), before we trigger a forced update. You think
>> that will cover this concern?
> 
> Yes some sort of rate limiting should help. My understanding has been
> that this is the main purpose of the even counting threshold. The code
> as we have doesn't seem to work properly so there are two ways, either
> tune the existing threshold or replace it by something else. Having both
> a force update and non-functional threshold is not a great outcome.
> 

The event counting threshold's purpose is to limit the *rate*  of event update.  The
side effect is we will miss some update by the sampling nature.  However, we can't
afford to let the sampling go to frequent or the overhead will be too much.

The forced update makes sure that a needed update happens 
to put the memcg on the tree happens and we don't allow the
memcg to escape page reclaim even if the update happens relatively rarely.  Lowering
the threshold does not guarantee that the update happens, resulting in a runaway
memcg.  The forced update and threshold serves different purpose. In my opinion
the forced update is necessary.  We can keep the update overhead low with
low update rate, and yet make sure that a needed update happens.  I think both
are necessary for proper function.  The overhead from the forced update
is negligible and I don't a downside adding it. 

Tim
