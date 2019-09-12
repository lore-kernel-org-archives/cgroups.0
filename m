From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 2/2] cgroup: freezer: fix frozen state inheritance
Date: Thu, 12 Sep 2019 10:56:45 -0700
Message-ID: <20190912175645.2841713-2-guro@fb.com>
References: <20190912175645.2841713-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JHcGIr6DfeeZGfRlp0Bw8MSSseCy7tNcl4Zfer3yjas=;
 b=Ws37Eh+4it10LaEbzqprrRYoR6i8fyBwmbB70feddo3KvOnHh2Ev0c0EM7XHb9TEqslA
 /MJbRaOrckgrmUOtNmfr62EObwVA3ajdVceCbAEhzZVlTzOReprBcrp8ne7bIRs/zxm0
 Ks4NZE4CCTU0VenxfprPN4jzLDkXeNDah6Y= 
In-Reply-To: <20190912175645.2841713-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Mark Crossen <mcrossen@fb.com>, Roman Gushchin <guro@fb.com>, stable@vger.kernel.org

If a new child cgroup is created in the frozen cgroup hierarchy
(one or more of ancestor cgroups is frozen), the CGRP_FREEZE cgroup
flag should be set. Otherwise if a process will be attached to the
child cgroup, it won't become frozen.

The problem can be reproduced with the test_cgfreezer_mkdir test.

This is the output before this patch:
  ~/test_freezer
  ok 1 test_cgfreezer_simple
  ok 2 test_cgfreezer_tree
  ok 3 test_cgfreezer_forkbomb
  Cgroup /sys/fs/cgroup/cg_test_mkdir_A/cg_test_mkdir_B isn't frozen
  not ok 4 test_cgfreezer_mkdir
  ok 5 test_cgfreezer_rmdir
  ok 6 test_cgfreezer_migrate
  ok 7 test_cgfreezer_ptrace
  ok 8 test_cgfreezer_stopped
  ok 9 test_cgfreezer_ptraced
  ok 10 test_cgfreezer_vfork

And with this patch:
  ~/test_freezer
  ok 1 test_cgfreezer_simple
  ok 2 test_cgfreezer_tree
  ok 3 test_cgfreezer_forkbomb
  ok 4 test_cgfreezer_mkdir
  ok 5 test_cgfreezer_rmdir
  ok 6 test_cgfreezer_migrate
  ok 7 test_cgfreezer_ptrace
  ok 8 test_cgfreezer_stopped
  ok 9 test_cgfreezer_ptraced
  ok 10 test_cgfreezer_vfork

Reported-by: Mark Crossen <mcrossen@fb.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/cgroup/cgroup.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 753afbca549f..8be1da1ebd9a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5255,8 +5255,16 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 * if the parent has to be frozen, the child has too.
 	 */
 	cgrp->freezer.e_freeze = parent->freezer.e_freeze;
-	if (cgrp->freezer.e_freeze)
+	if (cgrp->freezer.e_freeze) {
+		/*
+		 * Set the CGRP_FREEZE flag, so when a process will be
+		 * attached to the child cgroup, it will become frozen.
+		 * At this point the new cgroup is unpopulated, so we can
+		 * consider it frozen immediately.
+		 */
+		set_bit(CGRP_FREEZE, &cgrp->flags);
 		set_bit(CGRP_FROZEN, &cgrp->flags);
+	}
 
 	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
-- 
2.21.0

