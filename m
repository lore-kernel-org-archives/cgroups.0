From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Fri, 12 Jan 2018 00:59:38 +0300
Message-ID: <560a77b5-02d7-cbae-35f3-0b20a1c384c2@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180111104239.GZ1732@dhcp22.suse.cz>
 <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com>
 <20180111124629.GA1732@dhcp22.suse.cz>
 <ce885a69-67af-5f4c-1116-9f6803fb45ee@virtuozzo.com>
 <20180111162947.GG1732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VxNvRGGAK1NxfG+Im8ZMESp7occ3hNdVMbRBEd7dHLk=;
 b=dYzlcL42SW6DJ/p8uRNH++BiSooa2E4oHPhXyG6kbfg/fqEbk3b8zMw/tZW41XqaH9pyhOuu/2Vv4N3M8X2jlG8yhyb/pxQZaBIiB95zFhXar85BPWBJDcp9aMirWvbyGf7xuuX03XkM3MLhHuue/Hjp3jZlocvDtnUW4kw7YS4=
In-Reply-To: <20180111162947.GG1732-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 01/11/2018 07:29 PM, Michal Hocko wrote:
> On Thu 11-01-18 18:23:57, Andrey Ryabinin wrote:
>> On 01/11/2018 03:46 PM, Michal Hocko wrote:
>>> On Thu 11-01-18 15:21:33, Andrey Ryabinin wrote:
>>>>
>>>>
>>>> On 01/11/2018 01:42 PM, Michal Hocko wrote:
>>>>> On Wed 10-01-18 15:43:17, Andrey Ryabinin wrote:
>>>>> [...]
>>>>>> @@ -2506,15 +2480,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>>>>>  		if (!ret)
>>>>>>  			break;
>>>>>>  
>>>>>> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
>>>>>> -
>>>>>> -		curusage = page_counter_read(counter);
>>>>>> -		/* Usage is reduced ? */
>>>>>> -		if (curusage >= oldusage)
>>>>>> -			retry_count--;
>>>>>> -		else
>>>>>> -			oldusage = curusage;
>>>>>> -	} while (retry_count);
>>>>>> +		usage = page_counter_read(counter);
>>>>>> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
>>>>>> +						GFP_KERNEL, !memsw)) {
>>>>>
>>>>> If the usage drops below limit in the meantime then you get underflow
>>>>> and reclaim the whole memcg. I do not think this is a good idea. This
>>>>> can also lead to over reclaim. Why don't you simply stick with the
>>>>> original SWAP_CLUSTER_MAX (aka 1 for try_to_free_mem_cgroup_pages)?
>>>>>
>>>>
>>>> Because, if new limit is gigabytes bellow the current usage, retrying to set
>>>> new limit after reclaiming only 32 pages seems unreasonable.
>>>
>>> Who would do insanity like that?
>>>
>>
>> What's insane about that?
> 
> I haven't seen this being done in practice. Why would you want to
> reclaim GBs of memory from a cgroup? Anyway, if you believe this is
> really needed then simply do it in a separate patch.
>  

For the same reason as anyone would want to set memory limit on some job that generates
too much pressure and disrupts others. Whether this GBs or MBs is just a matter of scale.

More concrete example is workload that generates lots of page cache. Without limit (or with too high limit)
it wakes up kswapd which starts trashing all other cgroups. It's pretty bad for anon mostly cgroups
as we may constantly swap back and forth hot data.


>>>> @@ -2487,8 +2487,8 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>>>  		if (!ret)
>>>>  			break;
>>>>  
>>>> -		usage = page_counter_read(counter);
>>>> -		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
>>>> +		nr_pages = max_t(long, 1, page_counter_read(counter) - limit);
>>>> +		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages,
>>>>  						GFP_KERNEL, !memsw)) {
>>>>  			ret = -EBUSY;
>>>>  			break;
>>>
>>> How does this address the over reclaim concern?
>>  
>> It protects from over reclaim due to underflow.
> 
> I do not think so. Consider that this reclaim races with other
> reclaimers. Now you are reclaiming a large chunk so you might end up
> reclaiming more than necessary. SWAP_CLUSTER_MAX would reduce the over
> reclaim to be negligible.
> 

I did consider this. And I think, I already explained that sort of race in previous email.
Whether "Task B" is really a task in cgroup or it's actually a bunch of reclaimers,
doesn't matter. That doesn't change anything.


