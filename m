From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Fri, 19 Feb 2021 10:59:05 -0800
Message-ID: <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YC+ApsntwnlVfCuK-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/19/21 1:11 AM, Michal Hocko wrote:
> On Wed 17-02-21 12:41:35, Tim Chen wrote:

>> Memory is accessed at a much lower frequency
>> for the second cgroup.  The memcg event update was not triggered for the
>> second cgroup as the memcg event update didn't happened on the 1024th sample.
>> The second cgroup was not placed on the soft limit tree and we didn't
>> try to reclaim the excess pages.
>>
>> As time goes on, we saw that the first cgroup was kept close to its
>> soft limit due to reclaim activities, while the second cgroup's memory
>> usage slowly creep up as it keeps getting missed from the soft limit tree
>> update as the update didn't fall on the modulo 1024 sample.  As a result,
>> the memory usage of the second cgroup keeps growing over the soft limit
>> for a long time due to its relatively rare occurrence.
> 
> Soft limit is evaluated every THRESHOLDS_EVENTS_TARGET * SOFTLIMIT_EVENTS_TARGET.
> If all events correspond with a newly charged memory and the last event
> was just about the soft limit boundary then we should be bound by 128k
> pages (512M and much more if this were huge pages) which is a lot!
> I haven't realized this was that much. Now I see the problem. This would
> be a useful information for the changelog.
> 
> Your fix is focusing on the over-the-limit boundary which will solve the
> problem but wouldn't that lead to to updates happening too often in
> pathological situation when a memcg would get reclaimed immediatelly?

Not really immediately.  The memcg that has the most soft limit excess will
be chosen for page reclaim, which is the way it should be.  
It is less likely that a memcg that just exceeded
the soft limit becomes the worst offender immediately.  With the fix, we make
sure that it is on the bad guys list and will not be ignored and be chosen
eventually for reclaim.  It will not sneakily increase its memory usage
slowly.   

> 
> One way around that would be to lower the SOFTLIMIT_EVENTS_TARGET. Have
> you tried that? Do we even need a separate treshold for soft limit, why
> cannot we simply update the tree each MEM_CGROUP_TARGET_THRESH?
>  

Lowering the threshold is a band aid that really doesn't fix the problem.
I found that if the cgroup touches the memory infrequently enough, you
could still miss the update of it.  And in the mean time, you are updating
things a lot more frequently with added overhead.

Tim
