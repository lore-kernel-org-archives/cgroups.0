From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] mm, docs: update memory.stat description with workingset* entries
Date: Thu, 11 May 2017 20:18:13 +0100
Message-ID: <1494530293-31236-1-git-send-email-guro@fb.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Commit 4b4cea91691d ("mm: vmscan: fix IO/refault regression in
cache workingset transition") introduced three new entries in memory
stat file:
     - workingset_refault,
     - workingset_activate,
     - workingset_nodereclaim.

This commit adds a corresponding description to the cgroup v2 docs.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index e50b95c..dc5e2dc 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -918,6 +918,18 @@ PAGE_SIZE multiple when read back.
 
 		Number of major page faults incurred
 
+	  workingset_refault
+
+		Number of refaults of previously evicted pages
+
+	  workingset_activate
+
+		Number of refaulted pages that were immediately activated
+
+	  workingset_nodereclaim
+
+		Number of times a shadow node has been reclaimed
+
   memory.swap.current
 
 	A read-only single value file which exists on non-root
-- 
2.7.4

