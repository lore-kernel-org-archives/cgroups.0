From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [REGRESSION] cgroup: notify_on_release may not be triggered in some
 cases
Date: Thu, 4 Oct 2012 16:37:16 +0900
Message-ID: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

notify_on_release must be triggered when the last process in a cgroup is
move to another. But if the first(and only) process in a cgroup is moved to
another, notify_on_release is not triggered.

	# mkdir /cgroup/cpu/SRC
	# mkdir /cgroup/cpu/DST
	#
	# echo 1 >/cgroup/cpu/SRC/notify_on_release
	# echo 1 >/cgroup/cpu/DST/notify_on_release
	#
	# sleep 300 &
	[1] 8629
	#
	# echo 8629 >/cgroup/cpu/SRC/tasks
	# echo 8629 >/cgroup/cpu/DST/tasks
	-> notify_on_release for /SRC must be triggered at this point,
	   but it isn't.

This is because put_css_set() is called before setting CGRP_RELEASABLE
in cgroup_task_migrate(), and is a regression introduce by the
commit:74a1166d(cgroups: make procs file writable), which was merged
into v3.0.

Cc: Ben Blum <bblum@andrew.cmu.edu>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: <stable@vger.kernel.org> # v3.0.x and later
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
This patch is based on v3.6.

 kernel/cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7981850..7d01182 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1923,9 +1923,8 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
 	 * it here; it will be freed under RCU.
 	 */
-	put_css_set(oldcg);
-
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
+	put_css_set(oldcg);
 }
 
 /**
-- 
1.7.1
