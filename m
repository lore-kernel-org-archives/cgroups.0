From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: dump memory.stat during cgroup OOM
Date: Wed, 5 Jun 2019 14:08:37 +0200
Message-ID: <20190605120837.GE15685@dhcp22.suse.cz>
References: <20190604210509.9744-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190604210509.9744-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 04-06-19 17:05:09, Johannes Weiner wrote:
> The current cgroup OOM memory info dump doesn't include all the memory
> we are tracking, nor does it give insight into what the VM tried to do
> leading up to the OOM. All that useful info is in memory.stat.

I agree that other memcg counters can provide a useful insight for the OOM
situation.

> Furthermore, the recursive printing for every child cgroup can
> generate absurd amounts of data on the console for larger cgroup
> trees, and it's not like we provide a per-cgroup breakdown during
> global OOM kills.

The idea was that this information might help to identify which subgroup
is the major contributor to the OOM at a higher level. I have to confess
that I have never really used that information myself though.

> When an OOM kill is triggered, print one set of recursive memory.stat
> items at the level whose limit triggered the OOM condition.
> 
> Example output:
> 
[...]
> memory: usage 1024kB, limit 1024kB, failcnt 75131
> swap: usage 0kB, limit 9007199254740988kB, failcnt 0
> Memory cgroup stats for /foo:
> anon 0
> file 0
> kernel_stack 36864
> slab 274432
> sock 0
> shmem 0
> file_mapped 0
> file_dirty 0
> file_writeback 0
> anon_thp 0
> inactive_anon 126976
> active_anon 0
> inactive_file 0
> active_file 0
> unevictable 0
> slab_reclaimable 0
> slab_unreclaimable 274432
> pgfault 59466
> pgmajfault 1617
> workingset_refault 2145
> workingset_activate 0
> workingset_nodereclaim 0
> pgrefill 98952
> pgscan 200060
> pgsteal 59340
> pgactivate 40095
> pgdeactivate 96787
> pglazyfree 0
> pglazyfreed 0
> thp_fault_alloc 0
> thp_collapse_alloc 0

I am not entirely happy with that many lines in the oom report though. I
do see that you are trying to reduce code duplication which is fine but
would it be possible to squeeze all of these counters on a single line?
The same way we do for the global OOM report?

> Tasks state (memory values in pages):
> [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
> [    200]     0   200     1121      884    53248       29             0 bash
> [    209]     0   209      905      246    45056       19             0 stress
> [    210]     0   210    66442       56   499712    56349             0 stress
> oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),oom_memcg=/foo,task_memcg=/foo,task=stress,pid=210,uid=0
> Memory cgroup out of memory: Killed process 210 (stress) total-vm:265768kB, anon-rss:0kB, file-rss:224kB, shmem-rss:0kB
> oom_reaper: reaped process 210 (stress), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 289 ++++++++++++++++++++++++++----------------------
>  1 file changed, 157 insertions(+), 132 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6de8ca735ee2..0907a96ceddf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -66,6 +66,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/file.h>
>  #include <linux/tracehook.h>
> +#include <linux/seq_buf.h>
>  #include "internal.h"
>  #include <net/sock.h>
>  #include <net/ip.h>
> @@ -1365,27 +1366,114 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  	return false;
>  }
>  
> -static const unsigned int memcg1_stats[] = {
> -	MEMCG_CACHE,
> -	MEMCG_RSS,
> -	MEMCG_RSS_HUGE,
> -	NR_SHMEM,
> -	NR_FILE_MAPPED,
> -	NR_FILE_DIRTY,
> -	NR_WRITEBACK,
> -	MEMCG_SWAP,
> -};
> +static char *memory_stat_format(struct mem_cgroup *memcg)
> +{
> +	struct seq_buf s;
> +	int i;
>  
> -static const char *const memcg1_stat_names[] = {
> -	"cache",
> -	"rss",
> -	"rss_huge",
> -	"shmem",
> -	"mapped_file",
> -	"dirty",
> -	"writeback",
> -	"swap",
> -};
> +	seq_buf_init(&s, kvmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);

What is the reason to use kvmalloc here? It doesn't make much sense to
me to use it for the page size allocation TBH.

Other than that this looks sane to me.
-- 
Michal Hocko
SUSE Labs
