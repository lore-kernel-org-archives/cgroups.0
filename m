From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH 1/2] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Wed, 20 Dec 2017 14:32:19 +0300
Message-ID: <6e9ee949-c203-621d-890f-25a432bd4bb3@virtuozzo.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20171220103337.GL4831@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=N2e8hybeoxs/0+UgEg7PozcwwpD8GRD/yK+GPTdPAX8=;
 b=JHrzE5CalfghS3+ScvvzfUbbFrGHiXgzWKQVmI2QnEya0+BEXfVQiEV//zOAu8uJHftIzOFEHVMSoRxlsy7QPWqP97SaAe/iyrzg6Hem4WQklwEiANlXFj3SEVG+0c+dnVwMT+OZxJX8AWfRYWG/0KcviUBxD6DuSP8l5qt7cNM=
In-Reply-To: <20171220103337.GL4831@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 12/20/2017 01:33 PM, Michal Hocko wrote:
> On Wed 20-12-17 13:24:28, Andrey Ryabinin wrote:
>> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
>> pages on each iteration. This makes practically impossible to decrease
>> limit of memory cgroup. Tasks could easily allocate back 32 pages,
>> so we can't reduce memory usage, and once retry_count reaches zero we return
>> -EBUSY.
>>
>> It's easy to reproduce the problem by running the following commands:
>>
>>   mkdir /sys/fs/cgroup/memory/test
>>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>>   cat big_file > /dev/null &
>>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>   -bash: echo: write error: Device or resource busy
>>
>> Instead of trying to free small amount of pages, it's much more
>> reasonable to free 'usage - limit' pages.
> 
> But that only makes the issue less probable. It doesn't fix it because 
> 		if (curusage >= oldusage)
> 			retry_count--;
> can still be true because allocator might be faster than the reclaimer.
> Wouldn't it be more reasonable to simply remove the retry count and keep
> trying until interrupted or we manage to update the limit.

But does it makes sense to continue reclaiming even if reclaimer can't make any
progress? I'd say no. "Allocator is faster than reclaimer" may be not the only reason
for failed reclaim. E.g. we could try to set limit lower than amount of mlock()ed memory
in cgroup, retrying reclaim would be just a waste of machine's resources.
Or we simply don't have any swap, and anon > new_limit. Should be burn the cpu in that case?


> Another option would be to commit the new limit and allow temporal overcommit
> of the hard limit. New allocations and the limit update paths would
> reclaim to the hard limit.
> 

It sounds a bit fragile and tricky to me. I wouldn't go that way without unless we have a very good reason for this.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
