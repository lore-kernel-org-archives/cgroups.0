From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Fri, 12 Jan 2018 12:08:12 +0300
Message-ID: <8f706bc5-cc9c-01f5-1918-41cd0501f4f0@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180110143121.cf2a1c5497b31642c9b38b2a@linux-foundation.org>
 <47856d2b-1534-6198-c2e2-6d2356973bef@virtuozzo.com>
 <20180111162134.53aa5a44c59689ec0399db57@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=J/EVSyLmUhrzuB9g5gH3Vl6gxKd4rYpTfKWKWiJtsb4=;
 b=ZPkk7jt+jzaipnBPD6u9XwCmbI5vbiAhBim7yCtMgvu7rejvJfDk8zJonS5zOR/rWje/vbmdFF56hv5ac00sSJXr4s4HGvmNGcb/qsxCwf4E9Vljw124g/eQ12qRHn/yeAT+CzLKvmqkeYKrJKRvfpxVjTtYszJxBEodyaaAxxQ=
In-Reply-To: <20180111162134.53aa5a44c59689ec0399db57@linux-foundation.org>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>



On 01/12/2018 03:21 AM, Andrew Morton wrote:
> On Thu, 11 Jan 2018 14:59:23 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> 
>> On 01/11/2018 01:31 AM, Andrew Morton wrote:
>>> On Wed, 10 Jan 2018 15:43:17 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>>
>>>> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
>>>> pages on each iteration. This makes practically impossible to decrease
>>>> limit of memory cgroup. Tasks could easily allocate back 32 pages,
>>>> so we can't reduce memory usage, and once retry_count reaches zero we return
>>>> -EBUSY.
>>>>
>>>> Easy to reproduce the problem by running the following commands:
>>>>
>>>>   mkdir /sys/fs/cgroup/memory/test
>>>>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>>>>   cat big_file > /dev/null &
>>>>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>>>   -bash: echo: write error: Device or resource busy
>>>>
>>>> Instead of relying on retry_count, keep retrying the reclaim until
>>>> the desired limit is reached or fail if the reclaim doesn't make
>>>> any progress or a signal is pending.
>>>>
>>>
>>> Is there any situation under which that mem_cgroup_resize_limit() can
>>> get stuck semi-indefinitely in a livelockish state?  It isn't very
>>> obvious that we're protected from this, so perhaps it would help to
>>> have a comment which describes how loop termination is assured?
>>>
>>
>> We are not protected from this. If tasks in cgroup *indefinitely* generate reclaimable memory at high rate
>> and user asks to set unreachable limit, like 'echo 4096 > memory.limit_in_bytes', than
>> try_to_free_mem_cgroup_pages() will return non-zero indefinitely.
>>
>> Is that a big deal? At least loop can be interrupted by a signal, and we don't hold any locks here.
> 
> It may be better to detect this condition, give up and return an error?
> 

That's basically what how v1 worked, "if (curusage >= oldusage)" used to be
the way to detect this potential livelock.
So we can just go back to it?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
