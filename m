From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 5/7] memcg: divide force_empty into 2 functions, avoid
 memory reclaim at rmdir
Date: Wed, 18 Apr 2012 16:14:32 +0900
Message-ID: <4F8E69D8.4070102@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <4F86BC71.9070403@jp.fujitsu.com> <CALWz4iwYX4r5dJmcKFuc+zj_rjMB76dtpbvArdzySF+dyxMohg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALWz4iwYX4r5dJmcKFuc+zj_rjMB76dtpbvArdzySF+dyxMohg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/18 2:29), Ying Han wrote:

> On Thu, Apr 12, 2012 at 4:28 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> Now, at rmdir, memory cgroup's charge will be moved to
>>  - parent if use_hierarchy=1
>>  - root   if use_hierarchy=0
>>
>> Then, we don't have to have memory reclaim code at destroying memcg.
>>
>> This patch divides force_empty to 2 functions as
>>
>>  - memory_cgroup_recharge() ... try to move all charges to ancestors.
>>  - memory_cgroup_force_empty().. try to reclaim all memory.
>>
>> After this patch, memory.force_empty will _not_ move charges to ancestors
>> but just reclaim all pages. (This meets documenation.)
> 
> Not sure why it matches the documentation:
> "
> memory.force_empty>---->------- # trigger forced move charge to parent
> "

I missed this...

> 
> and
> "
>   # echo 0 > memory.force_empty
> 
>   Almost all pages tracked by this memory cgroup will be unmapped and freed.
>   Some pages cannot be freed because they are locked or in-use. Such pages are
>   moved to parent and this cgroup will be empty. This may return -EBUSY if
>   VM is too busy to free/move all pages immediately.
> "
> 


The 1st feature is "will be unmapped and freed".

I'll update Documentation. Thank you.

-Kame



