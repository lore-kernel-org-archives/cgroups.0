From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v5 1/2] mm/memcontrol.c: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 25 Jan 2018 22:44:16 +0300
Message-ID: <5741fb29-a343-1f20-8957-bcd3647f2111@virtuozzo.com>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Wfyn6ayR5z6v+WjVASayq0/BtoufL5DNKu42XnilGHc=;
 b=EOrsvX7dp+WAnLyplT55HuLTKuayoNlfXgraXV46i90vxiU9D9FeeE3csm+k8zMpQwSnHuDd3CyzNjB3GQ5sG1IB9pSleZCwHaIsmIG3HeSILsdAkM9de7QlkEvf3KosxY5HHIUAvGKt1GkExqERWvG2UQGg2Rf5rNzLyYcDgi0=
In-Reply-To: <20180119132544.19569-1-aryabinin@virtuozzo.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On 01/19/2018 04:25 PM, Andrey Ryabinin wrote:
> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration.  This makes it practically impossible to decrease
> limit of memory cgroup.  Tasks could easily allocate back 32 pages, so we
> can't reduce memory usage, and once retry_count reaches zero we return
> -EBUSY.
> 
> Easy to reproduce the problem by running the following commands:
> 
>   mkdir /sys/fs/cgroup/memory/test
>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>   cat big_file > /dev/null &
>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>   -bash: echo: write error: Device or resource busy
> 
> Instead of relying on retry_count, keep retrying the reclaim until the
> desired limit is reached or fail if the reclaim doesn't make any progress
> or a signal is pending.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>


Andrew, are you ok to pick up the patch?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
