From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Sat, 20 Feb 2021 08:23:15 -0800
Message-ID: <0f8117ef-c461-e2be-ea7a-6cbf727c9bb5@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <884d7559-e118-3773-351d-84c02642ca96-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/19/21 10:59 AM, Tim Chen wrote:
> 
> 
> On 2/19/21 1:11 AM, Michal Hocko wrote:

>>
>> Soft limit is evaluated every THRESHOLDS_EVENTS_TARGET * SOFTLIMIT_EVENTS_TARGET.
>> If all events correspond with a newly charged memory and the last event
>> was just about the soft limit boundary then we should be bound by 128k
>> pages (512M and much more if this were huge pages) which is a lot!
>> I haven't realized this was that much. Now I see the problem. This would
>> be a useful information for the changelog.
>>
>> Your fix is focusing on the over-the-limit boundary which will solve the
>> problem but wouldn't that lead to to updates happening too often in
>> pathological situation when a memcg would get reclaimed immediatelly?
> 
> Not really immediately.  The memcg that has the most soft limit excess will
> be chosen for page reclaim, which is the way it should be.  
> It is less likely that a memcg that just exceeded
> the soft limit becomes the worst offender immediately.  With the fix, we make
> sure that it is on the bad guys list and will not be ignored and be chosen
> eventually for reclaim.  It will not sneakily increase its memory usage
> slowly.   
> 

I should also mention that the forced update is only performed once when
the memcg first exceeded the soft limit as we check whether the memcg
is already in the soft limit tree due to the !mz->on_tree check.
+	if (mz && !mz->on_tree && soft_limit_excess(mz->memcg) > 0)
+		force_update = true;

So the update overhead is very low. 

Tim
