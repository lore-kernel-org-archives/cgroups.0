From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 11 Jan 2018 18:23:57 +0300
Message-ID: <ce885a69-67af-5f4c-1116-9f6803fb45ee@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180111104239.GZ1732@dhcp22.suse.cz>
 <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com>
 <20180111124629.GA1732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qeBGg6WDG8klifEF7oHbcCTtvGz0EgNi/5b9AnPYcUo=;
 b=VXoWH7pOGy6pj5SOUwsv97NN8Un2TpG8kzOskyJd2BAcGp7vrty9BRs10uLygxjcCkdDUjlwqPZhwZ1Nvj69V7oBkGLI6mMdtETkSNOunQeaLl9zZjhFZuy5oBO9MgFCgZAE8Jv1V7i9uFBzcV/gO2Lfp6w3r3TkHmLN8pIATvo=
In-Reply-To: <20180111124629.GA1732-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 01/11/2018 03:46 PM, Michal Hocko wrote:
> On Thu 11-01-18 15:21:33, Andrey Ryabinin wrote:
>>
>>
>> On 01/11/2018 01:42 PM, Michal Hocko wrote:
>>> On Wed 10-01-18 15:43:17, Andrey Ryabinin wrote:
>>> [...]
>>>> @@ -2506,15 +2480,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>>>  		if (!ret)
>>>>  			break;
>>>>  
>>>> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
>>>> -
>>>> -		curusage = page_counter_read(counter);
>>>> -		/* Usage is reduced ? */
>>>> -		if (curusage >= oldusage)
>>>> -			retry_count--;
>>>> -		else
>>>> -			oldusage = curusage;
>>>> -	} while (retry_count);
>>>> +		usage = page_counter_read(counter);
>>>> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
>>>> +						GFP_KERNEL, !memsw)) {
>>>
>>> If the usage drops below limit in the meantime then you get underflow
>>> and reclaim the whole memcg. I do not think this is a good idea. This
>>> can also lead to over reclaim. Why don't you simply stick with the
>>> original SWAP_CLUSTER_MAX (aka 1 for try_to_free_mem_cgroup_pages)?
>>>
>>
>> Because, if new limit is gigabytes bellow the current usage, retrying to set
>> new limit after reclaiming only 32 pages seems unreasonable.
> 
> Who would do insanity like that?
> 

What's insane about that?


>> @@ -2487,8 +2487,8 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>>  		if (!ret)
>>  			break;
>>  
>> -		usage = page_counter_read(counter);
>> -		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
>> +		nr_pages = max_t(long, 1, page_counter_read(counter) - limit);
>> +		if (!try_to_free_mem_cgroup_pages(memcg, nr_pages,
>>  						GFP_KERNEL, !memsw)) {
>>  			ret = -EBUSY;
>>  			break;
> 
> How does this address the over reclaim concern?
 
It protects from over reclaim due to underflow.


Assuming that yours over reclaim concern is situation like this:


         Task A                                            Task  B
                                 
mem_cgroup_resize_limit(new_limit):

...

   do {
...
        try_to_free_mem_cgroup_pages():
                //start reclaim

                                                         free memory => drop down usage below new_limit
                //end reclaim
...
    } while(true)


than I don't understand why is this a problem at all, and how try_to_free_mem_cgroup_pages(1) supposed to solve it.

First of all, this is highly unlikely situation. Decreasing limit is not something that happens very often.
I imagine that freeing large amounts of memory is also not very frequent operation, workloads mostly consume/use
resources. So this is something that should almost never happen, and when it does, who and how would notice?
I mean, that 'problem' has no user-visible effect.


Secondly, how try_to_free_mem_cgroup_pages(1) can help here? Task B could simply free() right after the limit
is successfully set. So it suddenly doesn't matter whether the memory was reclaimed by baby steps or in one go,
we 'over reclaimed' memory that B freed. Basically, your suggestion sounds like "lets slowly reclaim with baby
steps, and check the limit after each step in hope that tasks in cgroup did some of our job and freed some memory".


So, the only way to completely avoid such over reclaim would be to do not reclaim at all, and simply wait until the memory
usage goes down by itself. But we are not that crazy to do this, right?


