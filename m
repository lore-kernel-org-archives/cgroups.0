From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Fri, 26 Feb 2021 16:56:28 -0800
Message-ID: <781634ee-ffb9-598d-fdb6-0ae6067448b7@linux.intel.com>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
 <884d7559-e118-3773-351d-84c02642ca96@linux.intel.com>
 <YDNuAIztiGJpLEtw@dhcp22.suse.cz>
 <e132f836-b5d5-3776-22d6-669e713983e4@linux.intel.com>
 <YDQBh5th9txxEFUm@dhcp22.suse.cz>
 <cf5ca7a1-7965-f307-22e1-e216316904cf@linux.intel.com>
 <YDY+PydRUGQpHNaJ@dhcp22.suse.cz>
 <b5b1944d-846b-3212-fe4a-f10f5fcb87d7@linux.intel.com>
 <YDi2udQqIML6Vdpo@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YDi2udQqIML6Vdpo-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/26/21 12:52 AM, Michal Hocko wrote:

>>
>> Michal,
>>
>> Let's take an extreme case where memcg 1 always generate the
>> first event and memcg 2 generates the rest of 128*8-1 events
>> and the pattern repeat.
> 
> I do not follow. Events are per-memcg, aren't they?
> 	__this_cpu_read(memcg->vmstats_percpu->targets[target]);
> 	[...]
> 	__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
> 

You are right. My previous reasoning is incorrect as the sampling is done per memcg.
I'll do some additional debugging on why memcg is not on the tree.

Tim 
