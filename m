From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] Revert "cgroup: use an ordered workqueue for cgroup
 destruction"
Date: Wed, 12 Feb 2014 19:09:39 -0500
Message-ID: <20140213000939.GA2916@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
 <20140207164321.GE6963@cmpxchg.org>
 <alpine.LSU.2.11.1402121417230.5029@eggly.anvils>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VgmOiAwsYijAwvP1BjhNHNcn25nHo8MnY++fXQw5Hvc=;
        b=GpTF2vQNVK2pfSZMa6J8U4RgHR+/hpSNogYDKuwyzS+DSFrykmMxxbv5I9s5DUigLJ
         IpwavvTzQezeWWvdYzaacld8FSvsP0wAZR3NenvmkpCFfwgsk8qj6a3crZeRidQOM4Au
         JWytF2y1VKCdsDK1Jz6kDd7HpeX/vtf2V/vzpWUOItiOsW7U8cnOwRZAYGIZrIo4AAl3
         hkt24VRW9fkkxSt2bkpTgp2p+t2GSTkILIDWy3ZpqFMQM2tTggYs4iSXshw3qH1h1Nwd
         1ew+QU3WQpXdxDMemAyvJjT5o8XLnBGErTxUb7DZkg4QQMho6u4mSJkVx5HZFIfE0YW8
         kcLg==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402121417230.5029@eggly.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

From 1a11533fbd71792e8c5d36f6763fbce8df0d231d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 12 Feb 2014 19:06:19 -0500

This reverts commit ab3f5faa6255a0eb4f832675507d9e295ca7e9ba.
Explanation from Hugh:

  It's because more thorough testing, by others here, found that it
  wasn't always solving the problem: so I asked Tejun privately to
  hold off from sending it in, until we'd worked out why not.

  Most of our testing being on a v3,11-based kernel, it was perfectly
  possible that the problem was merely our own e.g. missing Tejun's
  8a2b75384444 ("workqueue: fix ordered workqueues in NUMA setups").

  But that turned out not to be enough to fix it either. Then Filipe
  pointed out how percpu_ref_kill_and_confirm() uses call_rcu_sched()
  before we ever get to put the offline on to the workqueue: by the
  time we get to the workqueue, the ordering has already been lost.

  So, thanks for the Acks, but I'm afraid that this ordered workqueue
  solution is just not good enough: we should simply forget that patch
  and provide a different answer."

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
---
Queued to cgroup/for-3.14-fixes.

Thanks.

 kernel/cgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 52719ce..68d8710 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4844,16 +4844,12 @@ static int __init cgroup_wq_init(void)
 	/*
 	 * There isn't much point in executing destruction path in
 	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
-	 *
-	 * XXX: Must be ordered to make sure parent is offlined after
-	 * children.  The ordering requirement is for memcg where a
-	 * parent's offline may wait for a child's leading to deadlock.  In
-	 * the long term, this should be fixed from memcg side.
+	 * Use 1 for @max_active.
 	 *
 	 * We would prefer to do this in cgroup_init() above, but that
 	 * is called before init_workqueues(): so leave this until after.
 	 */
-	cgroup_destroy_wq = alloc_ordered_workqueue("cgroup_destroy", 0);
+	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
 	BUG_ON(!cgroup_destroy_wq);
 
 	/*
-- 
1.8.5.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
