From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Wed, 10 Jan 2018 14:31:21 -0800
Message-ID: <20180110143121.cf2a1c5497b31642c9b38b2a@linux-foundation.org>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
        <20180110124317.28887-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110124317.28887-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

On Wed, 10 Jan 2018 15:43:17 +0300 Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:

> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration. This makes practically impossible to decrease
> limit of memory cgroup. Tasks could easily allocate back 32 pages,
> so we can't reduce memory usage, and once retry_count reaches zero we return
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
> Instead of relying on retry_count, keep retrying the reclaim until
> the desired limit is reached or fail if the reclaim doesn't make
> any progress or a signal is pending.
> 

Is there any situation under which that mem_cgroup_resize_limit() can
get stuck semi-indefinitely in a livelockish state?  It isn't very
obvious that we're protected from this, so perhaps it would help to
have a comment which describes how loop termination is assured?

