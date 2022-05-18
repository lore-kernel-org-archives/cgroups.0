From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 04:08:15 +0530
Message-ID: <20220518223815.809858-1-vaibhav@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=cWTccgEFni0SxdgeQnDGBy9L1Zho1qh6R/OThU17sl8=;
 b=ZOZcebrJGbgwHxCcYecMtKnjvK4wLXM9H04DjFyVCjX3ux0bJgJlOKB7ZnmbAu2cnL0b
 pHTobF0gikeR9oo+GUGFJh7ytrxzP8nKyyd2VO1bdD5bi/ggvsiEZkqBjrr8+3oAyswW
 g6nooA2efPDT45R51URRzKY7JaU944KOYKDjpKIYifat4B6N7zdDCUrtS/gopBvGtt+A
 rae5DRO4L7qh/wSJf0DzfJwHYuEQSL8HhK0MiGIYWszZHXi4fwaCovtM8xBlu7nxICTV
 L9U7BDa+reXdgayM4Kjf/qgkmEDXemte+07rre1yQ4UIfTRmOK9/2lghvaYbyUHR3Kzj sw== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>

[1] Provides a way for user-space to trigger proactive reclaim by introducing
a write-only memcg file 'memory.reclaim'. However reclaim stats like number
of pages scanned and reclaimed is still not directly available to the
user-space.

This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
readable which returns the number of pages scanned / reclaimed during the
reclaim process from 'struct vmpressure' associated with each memcg. This should
let user-space asses how successful proactive reclaim triggered from memcg
'memory.reclaim' was ?

With the patch following command flow is expected:

 # echo "1M" > memory.reclaim

 # cat memory.reclaim
   scanned 76
   reclaimed 32

[1]:  https://lore.kernel.org/r/20220425190040.2475377-1-yosryahmed@google.com

Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 15 ++++++++++++---
 mm/memcontrol.c                         | 14 ++++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 27ebef2485a3..44610165261d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1209,18 +1209,27 @@ PAGE_SIZE multiple when read back.
 	utility is limited to providing the final safety net.
 
   memory.reclaim
-	A write-only nested-keyed file which exists for all cgroups.
+	A nested-keyed file which exists for all cgroups.
 
-	This is a simple interface to trigger memory reclaim in the
-	target cgroup.
+	This is a simple interface to trigger memory reclaim and retrieve
+	reclaim stats in the target cgroup.
 
 	This file accepts a single key, the number of bytes to reclaim.
 	No nested keys are currently supported.
 
+	Reading the file returns number of pages scanned and number of
+	pages reclaimed from the memcg. This information fetched from
+	vmpressure info associated with each cgroup.
+
 	Example::
 
 	  echo "1G" > memory.reclaim
 
+	  cat memory.reclaim
+
+	  scanned 78
+	  reclaimed 30
+
 	The interface can be later extended with nested keys to
 	configure the reclaim behavior. For example, specify the
 	type of memory to reclaim from (anon, file, ..).
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e2bfbed4717..9e43580a8726 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6423,6 +6423,19 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_reclaim_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+
+	spin_lock(&vmpr->sr_lock);
+	seq_printf(m, "scanned %lu\nreclaimed %lu\n",
+		   vmpr->scanned, vmpr->reclaimed);
+	spin_unlock(&vmpr->sr_lock);
+
+	return 0;
+}
+
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
@@ -6525,6 +6538,7 @@ static struct cftype memory_files[] = {
 		.name = "reclaim",
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
+		.seq_show  = memory_reclaim_show,
 	},
 	{ }	/* terminate */
 };
-- 
2.35.1

