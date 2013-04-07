From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Sun, 7 Apr 2013 11:32:48 +0800
Message-ID: <5160E8E0.2050602@huawei.com>
References: <515BF233.6070308@huawei.com> <515BF275.5080408@huawei.com> <20130403153133.GM16471@dhcp22.suse.cz> <515EA73C.8050602@parallels.com> <20130405134557.GG31132@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130405134557.GG31132-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>>> You are putting references but I do not see any single css_{try}get
>>> here. /me puzzled.
>>>
>>
>> There are two things being done in this code:
>> First, we acquired a css_ref to make sure that the underlying cgroup
>> would not go away. That is a short lived reference, and it is put as
>> soon as the cache is created.
>> At this point, we acquire a long-lived per-cache memcg reference count
>> to guarantee that the memcg will still be alive.
>>
>> so it is:
>>
>> enqueue: css_get
>> create : memcg_get, css_put
>> destroy: css_put
>>
>> If I understand Li's patch correctly, he is not touching the first
>> css_get, only turning that into the long lived reference (which was not
>> possible before, since that would prevent rmdir).
>>
>> Then he only needs to get rid of the memcg_get, change the memcg_put to
>> css_put, and get rid of the now extra css_put.
>>
>> He is issuing extra css_puts in memcg_create_kmem_cache, but only in
>> failure paths. So the code reads as:
>> * css_get on enqueue (already done, so not shown in patch)
>> * if it fails, css_put
>> * if it succeeds, don't do anything. This is already the long-lived
>> reference count. put it at release time.
> 
> OK, this makes more sense now. It is __memcg_create_cache_enqueue which
> takes the reference and it is not put after this because it replaced
> mem_cgroup reference counting.
> Li, please put something along these lines into the changelog. This is
> really tricky and easy to get misunderstand.
> 

Yeah, I think I'll just steal Glauber's explanation as the changelog.

> You can put my Acked-by then.
> 

Thanks!

>> The code looks correct, and of course, extremely simpler due to the
>> use of a single reference.
>>
>> Li, am I right in my understanding that this is your intention?
>>

