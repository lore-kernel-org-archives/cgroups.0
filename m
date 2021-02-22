From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Mon, 22 Feb 2021 11:48:37 -0800
Message-ID: <cf5ca7a1-7965-f307-22e1-e216316904cf@linux.intel.com>
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

>>
>> I actually have tried adjusting the threshold but found that it doesn't work well for
>> the case with unenven memory access frequency between cgroups.  The soft
>> limit for the low memory event cgroup could creep up quite a lot, exceeding
>> the soft limit by hundreds of MB, even
>> if I drop the SOFTLIMIT_EVENTS_TARGET from 1024 to something like 8.
> 
> What was the underlying reason? Higher order allocations?
> 

Not high order allocation.

The reason was because the run away memcg asks for memory much less often, compared
to the other memcgs in the system.  So it escapes the sampling update and
was not put onto the tree and exceeds the soft limit
pretty badly.  Even if it was put onto the tree and gets page reclaimed below the
limit, it could escape the sampling the next time it exceeds the soft limit.

As long as we are doing sampling update, this problem is baked in unless we
add the check to make sure that the memcg is subjected to page reclaim as long
as it exceeds the soft limit.

Tim

