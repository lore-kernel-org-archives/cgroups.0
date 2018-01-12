From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Thu, 11 Jan 2018 16:21:34 -0800
Message-ID: <20180111162134.53aa5a44c59689ec0399db57@linux-foundation.org>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
        <20180110124317.28887-1-aryabinin@virtuozzo.com>
        <20180110143121.cf2a1c5497b31642c9b38b2a@linux-foundation.org>
        <47856d2b-1534-6198-c2e2-6d2356973bef@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47856d2b-1534-6198-c2e2-6d2356973bef-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, 11 Jan 2018 14:59:23 +0300 Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> On 01/11/2018 01:31 AM, Andrew Morton wrote:
> > On Wed, 10 Jan 2018 15:43:17 +0300 Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > 
> >> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> >> pages on each iteration. This makes practically impossible to decrease
> >> limit of memory cgroup. Tasks could easily allocate back 32 pages,
> >> so we can't reduce memory usage, and once retry_count reaches zero we return
> >> -EBUSY.
> >>
> >> Easy to reproduce the problem by running the following commands:
> >>
> >>   mkdir /sys/fs/cgroup/memory/test
> >>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
> >>   cat big_file > /dev/null &
> >>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> >>   -bash: echo: write error: Device or resource busy
> >>
> >> Instead of relying on retry_count, keep retrying the reclaim until
> >> the desired limit is reached or fail if the reclaim doesn't make
> >> any progress or a signal is pending.
> >>
> > 
> > Is there any situation under which that mem_cgroup_resize_limit() can
> > get stuck semi-indefinitely in a livelockish state?  It isn't very
> > obvious that we're protected from this, so perhaps it would help to
> > have a comment which describes how loop termination is assured?
> > 
> 
> We are not protected from this. If tasks in cgroup *indefinitely* generate reclaimable memory at high rate
> and user asks to set unreachable limit, like 'echo 4096 > memory.limit_in_bytes', than
> try_to_free_mem_cgroup_pages() will return non-zero indefinitely.
> 
> Is that a big deal? At least loop can be interrupted by a signal, and we don't hold any locks here.

It may be better to detect this condition, give up and return an error?
