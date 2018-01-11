From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 11 Jan 2018 14:59:23 +0300
Message-ID: <47856d2b-1534-6198-c2e2-6d2356973bef@virtuozzo.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180110143121.cf2a1c5497b31642c9b38b2a@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KEJen7WoW3wkPhLKMmUEpfmkZWH+f3zzlVDT0csIczU=;
 b=IjBlhLvqw+/mOKfmnUS5IRZ/JcxvzmDTL8q13VVnPvZLrQOAkD5aow0eHDtxEe1j768jFGFmnleBKoEdZ+pabQuXawiD9t+peTPWql5dRR9LXFnHYR4wBhybONa1ZCSG3PHg5ZfiK5Fk7JS3l9vQ4dr3gAcoHx1v0TDHFOKtpho=
In-Reply-To: <20180110143121.cf2a1c5497b31642c9b38b2a@linux-foundation.org>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

On 01/11/2018 01:31 AM, Andrew Morton wrote:
> On Wed, 10 Jan 2018 15:43:17 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> 
>> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
>> pages on each iteration. This makes practically impossible to decrease
>> limit of memory cgroup. Tasks could easily allocate back 32 pages,
>> so we can't reduce memory usage, and once retry_count reaches zero we return
>> -EBUSY.
>>
>> Easy to reproduce the problem by running the following commands:
>>
>>   mkdir /sys/fs/cgroup/memory/test
>>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>>   cat big_file > /dev/null &
>>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>   -bash: echo: write error: Device or resource busy
>>
>> Instead of relying on retry_count, keep retrying the reclaim until
>> the desired limit is reached or fail if the reclaim doesn't make
>> any progress or a signal is pending.
>>
> 
> Is there any situation under which that mem_cgroup_resize_limit() can
> get stuck semi-indefinitely in a livelockish state?  It isn't very
> obvious that we're protected from this, so perhaps it would help to
> have a comment which describes how loop termination is assured?
> 

We are not protected from this. If tasks in cgroup *indefinitely* generate reclaimable memory at high rate
and user asks to set unreachable limit, like 'echo 4096 > memory.limit_in_bytes', than
try_to_free_mem_cgroup_pages() will return non-zero indefinitely.

Is that a big deal? At least loop can be interrupted by a signal, and we don't hold any locks here.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
