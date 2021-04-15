From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Thu, 15 Apr 2021 15:25:05 -0700
Message-ID: <86a6f2e1-8aed-00fc-fbd7-9250277b201f@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 4/8/21 10:18 AM, Shakeel Butt wrote:

> 
> Using v1's soft limit like behavior can potentially cause high
> priority jobs to stall to make enough space on top tier memory on
> their allocation path and I think this patchset is aiming to reduce
> that impact by making kswapd do that work. However I think the more
> concerning issue is the low priority job hogging the top tier memory.
> 
> The possible ways the low priority job can hog the top tier memory are
> by allocating non-movable memory or by mlocking the memory. (Oh there
> is also pinning the memory but I don't know if there is a user api to
> pin memory?) For the mlocked memory, you need to either modify the
> reclaim code or use a different mechanism for demoting cold memory.
> 
> Basically I am saying we should put the upfront control (limit) on the
> usage of top tier memory by the jobs.
> 

Circling back to your comment here.  

I agree that soft limit is deficient in this scenario that you 
have pointed out.  Eventually I was shooting for a hard limit on a 
memory tier for a cgroup that's similar to the v2 memory controller
interface (see mail in the other thread).  That interface should
satisfy the hard constraint you want to place on the low priority
jobs.


Tim
