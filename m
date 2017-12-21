From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 21 Dec 2017 13:00:46 +0300
Message-ID: <5db8aef5-2d5e-1e3b-d121-778fc4bd6875@virtuozzo.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20171220103337.GL4831@dhcp22.suse.cz>
 <6e9ee949-c203-621d-890f-25a432bd4bb3@virtuozzo.com>
 <20171220113404.GN4831@dhcp22.suse.cz>
 <CALvZod7ED3qaqekGTd-2PHmbTjY+D_NcFP1bE5_AgP8OF=jXJw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GUst3rYSpyoxg7TRTy8B3k9c1VSb32DEJcVTvMRj/U4=;
 b=VT2wjexV+Qf75+3L4UcHwFx+rdTAoQDaQIuxB7x2qdGJ05XaTuncUoL93Y6QnvMqNvRq0bGT5CljwypqvfqPAlJIfyG7F7+TSYrT9ZbGwkp6ZulR1ep0ELzM0c9y+asztd5hOJywCvR1dqjw1aQ3Cs+RBHwariw9QGsfZVR5PqE=
In-Reply-To: <CALvZod7ED3qaqekGTd-2PHmbTjY+D_NcFP1bE5_AgP8OF=jXJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 12/20/2017 09:15 PM, Shakeel Butt wrote:
> On Wed, Dec 20, 2017 at 3:34 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Wed 20-12-17 14:32:19, Andrey Ryabinin wrote:
>>> On 12/20/2017 01:33 PM, Michal Hocko wrote:
>>>> On Wed 20-12-17 13:24:28, Andrey Ryabinin wrote:
>>>>> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
>>>>> pages on each iteration. This makes practically impossible to decrease
>>>>> limit of memory cgroup. Tasks could easily allocate back 32 pages,
>>>>> so we can't reduce memory usage, and once retry_count reaches zero we return
>>>>> -EBUSY.
>>>>>
>>>>> It's easy to reproduce the problem by running the following commands:
>>>>>
>>>>>   mkdir /sys/fs/cgroup/memory/test
>>>>>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>>>>>   cat big_file > /dev/null &
>>>>>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>>>>   -bash: echo: write error: Device or resource busy
>>>>>
>>>>> Instead of trying to free small amount of pages, it's much more
>>>>> reasonable to free 'usage - limit' pages.
>>>>
>>>> But that only makes the issue less probable. It doesn't fix it because
>>>>             if (curusage >= oldusage)
>>>>                     retry_count--;
>>>> can still be true because allocator might be faster than the reclaimer.
>>>> Wouldn't it be more reasonable to simply remove the retry count and keep
>>>> trying until interrupted or we manage to update the limit.
>>>
>>> But does it makes sense to continue reclaiming even if reclaimer can't
>>> make any progress? I'd say no. "Allocator is faster than reclaimer"
>>> may be not the only reason for failed reclaim. E.g. we could try to
>>> set limit lower than amount of mlock()ed memory in cgroup, retrying
>>> reclaim would be just a waste of machine's resources.  Or we simply
>>> don't have any swap, and anon > new_limit. Should be burn the cpu in
>>> that case?
>>
>> We can check the number of reclaimed pages and go EBUSY if it is 0.
>>
>>>> Another option would be to commit the new limit and allow temporal overcommit
>>>> of the hard limit. New allocations and the limit update paths would
>>>> reclaim to the hard limit.
>>>>
>>>
>>> It sounds a bit fragile and tricky to me. I wouldn't go that way
>>> without unless we have a very good reason for this.
>>
>> I haven't explored this, to be honest, so there may be dragons that way.
>> I've just mentioned that option for completness.
>>
> 
> We already do this for cgroup-v2's memory.max. So, I don't think it is
> fragile or tricky.
> 

It has a potential to break userspace expectation. Userspace might expect that lowering 
limit_in_bytes too much fails with EBUSY and doesn't trigger OOM killer.
