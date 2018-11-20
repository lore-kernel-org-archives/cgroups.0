From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 3/5] cgroup: Make debug controller report new controller masks
Date: Tue, 20 Nov 2018 12:51:27 -0500
Message-ID: <1542736289-31338-4-git-send-email-longman@redhat.com>
References: <1542736289-31338-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542736289-31338-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Roman Gushchin <guro@fb.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Shakeel Butt <shakeelb@google.com>, Waiman Long <longman@redhat.com>

The newly added cgroup controller masks (subtree_bypass and
enable_ss_mask) are now being reported in the debug.masks controller
file.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 5f1b873..176bb9e 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -263,6 +263,8 @@ static int cgroup_masks_read(struct seq_file *seq, void *v)
 
 	cgroup_masks_read_one(seq, "subtree_control", cgrp->subtree_control);
 	cgroup_masks_read_one(seq, "subtree_ss_mask", cgrp->subtree_ss_mask);
+	cgroup_masks_read_one(seq, "subtree_bypass",  cgrp->subtree_bypass);
+	cgroup_masks_read_one(seq, "enable_ss_mask",  cgrp->enable_ss_mask);
 
 	cgroup_kn_unlock(of->kn);
 	return 0;
-- 
1.8.3.1

