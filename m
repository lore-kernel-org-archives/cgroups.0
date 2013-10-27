From: Greg Thelen <gthelen@google.com>
Subject: [PATCH v2 3/3] memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting
Date: Sun, 27 Oct 2013 10:30:17 -0700
Message-ID: <1382895017-19067-4-git-send-email-gthelen@google.com>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=smJj+4ZEvJneTCXYJIAqvUU84j8aTsHtutQ96ZZX/ho=;
        b=lUcWLPW8PHEJ6QlWvdOXiOq6xS3GjoEi3o9/p4pxIWZvJCTL6XAeIolfxkpRcN/UBY
         2bFI9PxI+sqfuAZmAewZEZJTxVirmlyBgSNgt5tgmTXA+80NvNc54fPm3A/h/a851EPC
         sZd/Qzhs/udUNEwiqz5siKNHgYht+47Wd2CksdkBBDAXqnusnhHanvQg/NagQM0MvHJj
         H2C8OIizv7wDrCfwJSYSPSV6DQt8Nidj6sNXq325p9MJ6pqoWtLe0Fsfndg/A/4/3FkC
         a332VfG/B+MdjLwhGT0qaujJzFKkfhEOzYp/rHU5eNByAODTnOTDcv/qNvWpJYNFKFSl
         xU7A==
In-Reply-To: <1382895017-19067-1-git-send-email-gthelen@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, handai.szj@taobao.com, Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Greg Thelen <gthelen@google.com>

As of v3.11-9444-g3ea67d0 "memcg: add per cgroup writeback pages
accounting" memcg counter errors are possible when moving charged
memory to a different memcg.  Charge movement occurs when processing
writes to memory.force_empty, moving tasks to a memcg with
memcg.move_charge_at_immigrate=1, or memcg deletion.  An example
showing error after memory.force_empty:
  $ cd /sys/fs/cgroup/memory
  $ mkdir x
  $ rm /data/tmp/file
  $ (echo $BASHPID >> x/tasks && exec mmap_writer /data/tmp/file 1M) &
  [1] 13600
  $ grep ^mapped x/memory.stat
  mapped_file 1048576
  $ echo 13600 > tasks
  $ echo 1 > x/memory.force_empty
  $ grep ^mapped x/memory.stat
  mapped_file 4503599627370496

mapped_file should end with 0.
  4503599627370496 == 0x10,0000,0000,0000 == 0x100,0000,0000 pages
  1048576          == 0x10,0000           == 0x100 pages

This issue only affects the source memcg on 64 bit machines; the
destination memcg counters are correct.  So the rmdir case is not too
important because such counters are soon disappearing with the entire
memcg.  But the memcg.force_empty and
memory.move_charge_at_immigrate=1 cases are larger problems as the
bogus counters are visible for the (possibly long) remaining life of
the source memcg.

The problem is due to memcg use of __this_cpu_from(.., -nr_pages),
which is subtly wrong because it subtracts the unsigned int nr_pages
(either -1 or -512 for THP) from a signed long percpu counter.  When
nr_pages=-1, -nr_pages=0xffffffff.  On 64 bit machines
stat->count[idx] is signed 64 bit.  So memcg's attempt to simply
decrement a count (e.g. from 1 to 0) boils down to:
  long count = 1
  unsigned int nr_pages = 1
  count += -nr_pages  /* -nr_pages == 0xffff,ffff */
  count is now 0x1,0000,0000 instead of 0

The fix is to subtract the unsigned page count rather than adding its
negation.  This only works once "percpu: fix this_cpu_sub() subtrahend
casting for unsigneds" is applied to fix this_cpu_sub().

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aa8185c..b7ace0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3773,7 +3773,7 @@ void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
 {
 	/* Update stat data for mem_cgroup */
 	preempt_disable();
-	__this_cpu_add(from->stat->count[idx], -nr_pages);
+	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
 	preempt_enable();
 }
-- 
1.8.4.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
