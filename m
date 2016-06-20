From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 3/3] mm: memcontrol: fix cgroup creation failure after
 many small jobs
Date: Mon, 20 Jun 2016 09:14:56 +0300
Message-ID: <576789E0.6000302@kyup.com>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160616200617.GD3262@mtj.duckdns.org> <20160617162310.GA19084@cmpxchg.org>
 <20160617162516.GD19084@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160617162516.GD19084@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com



On 06/17/2016 07:25 PM, Johannes Weiner wrote:
> The memory controller has quite a bit of state that usually outlives
> the cgroup and pins its CSS until said state disappears. At the same
> time it imposes a 16-bit limit on the CSS ID space to economically
> store IDs in the wild. Consequently, when we use cgroups to contain
> frequent but small and short-lived jobs that leave behind some page
> cache, we quickly run into the 64k limitations of outstanding CSSs.
> Creating a new cgroup fails with -ENOSPC while there are only a few,
> or even no user-visible cgroups in existence.
> 
> Although pinning CSSs past cgroup removal is common, there are only
> two instances that actually need an ID after a cgroup is deleted:
> cache shadow entries and swapout records.
> 
> Cache shadow entries reference the ID weakly and can deal with the CSS
> having disappeared when it's looked up later. They pose no hurdle.
> 
> Swap-out records do need to pin the css to hierarchically attribute
> swapins after the cgroup has been deleted; though the only pages that
> remain swapped out after offlining are tmpfs/shmem pages. And those
> references are under the user's control, so they are manageable.
> 
> This patch introduces a private 16-bit memcg ID and switches swap and
> cache shadow entries over to using that. This ID can then be recycled
> after offlining when the CSS remains pinned only by objects that don't
> specifically need it.
> 
> This script demonstrates the problem by faulting one cache page in a
> new cgroup and deleting it again:
> 
> set -e
> mkdir -p pages
> for x in `seq 128000`; do
>   [ $((x % 1000)) -eq 0 ] && echo $x
>   mkdir /cgroup/foo
>   echo $$ >/cgroup/foo/cgroup.procs
>   echo trex >pages/$x
>   echo $$ >/cgroup/cgroup.procs
>   rmdir /cgroup/foo
> done

Perhaps you could send this script to the LTP project to have this as a
regression test?

> 
> When run on an unpatched kernel, we eventually run out of possible IDs
> even though there are no visible cgroups:
> 
> [root@ham ~]# ./cssidstress.sh
> [...]
> 65000
> mkdir: cannot create directory '/cgroup/foo': No space left on device
> 
> After this patch, the IDs get released upon cgroup destruction and the
> cache and css objects get released once memory reclaim kicks in.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
