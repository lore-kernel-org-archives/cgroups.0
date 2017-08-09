From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 3/3] cgroup: Make debug controller report new controller masks
Date: Wed,  9 Aug 2017 13:55:50 -0400
Message-ID: <1502301350-19757-4-git-send-email-longman@redhat.com>
References: <1502301350-19757-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502301350-19757-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

The newly added cgroup controller masks (subtree_bypass and
enable_ss_mask) are now being reported in the debug.masks controller
file.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index f661b4c..5f35a76 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -262,6 +262,8 @@ static int cgroup_masks_read(struct seq_file *seq, void *v)
 
 	cgroup_masks_read_one(seq, "subtree_control", cgrp->subtree_control);
 	cgroup_masks_read_one(seq, "subtree_ss_mask", cgrp->subtree_ss_mask);
+	cgroup_masks_read_one(seq, "subtree_bypass",  cgrp->subtree_bypass);
+	cgroup_masks_read_one(seq, "enable_ss_mask",  cgrp->enable_ss_mask);
 
 	cgroup_kn_unlock(of->kn);
 	return 0;
-- 
1.8.3.1

