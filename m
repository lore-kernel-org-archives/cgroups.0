From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v13 5/7] mm, oom: add cgroup v2 mount option for cgroup-aware OOM killer
Date: Thu, 30 Nov 2017 15:28:22 +0000
Message-ID: <20171130152824.1591-6-guro@fb.com>
References: <20171130152824.1591-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=auoZRLpBsF0t/SxUk0F6kCH/8vKw4nAnQNLbJIFVn2A=;
 b=qtx72IOcEx2C4jXs789KWNU269/LJi9ocN8y+j4DU6JE7rHA6UTWWU5P/antZ5XzFauf
 frl3hv9Q/ISMKwGatTchguerX8DtO3hyRNZqGdGSEiOWq4CwHZo6h3fM/Sx5XGsaI3UP
 5BpO7l0+QQVWdfEi/99SoKlvpj6MYL5tMws= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=auoZRLpBsF0t/SxUk0F6kCH/8vKw4nAnQNLbJIFVn2A=;
 b=Bu17RRvFbO4Lpb4Kc3z8mLGjE7kCrOH3lkaqF8uvTXrAoB3XRMOfrqIe1IoCzmxWdgM36igS7VNHUacGpHakaqexVf3m52oy8rb/L6AQFIwPJz3cooUWzWeg2gwmTCZU7dYhOPJs61c//M4T+pcmCuHpSuiBQRKz6+zIZdjZMkA=
In-Reply-To: <20171130152824.1591-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware
OOM killer. If not set, the OOM selection is performed in
a "traditional" per-process way.

The behavior can be changed dynamically by remounting the cgroupfs.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/cgroup-defs.h |  5 +++++
 kernel/cgroup/cgroup.c      | 10 ++++++++++
 mm/memcontrol.c             |  3 +++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8b7fd8eeccee..9fb99e25d654 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -81,6 +81,11 @@ enum {
 	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
 	 */
 	CGRP_ROOT_CPUSET_V2_MODE = (1 << 4),
+
+	/*
+	 * Enable cgroup-aware OOM killer.
+	 */
+	CGRP_GROUP_OOM = (1 << 5),
 };
 
 /* cftype->flags */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe147f24..7338e12979e1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1731,6 +1731,9 @@ static int parse_cgroup_root_flags(char *data, unsigned int *root_flags)
 		if (!strcmp(token, "nsdelegate")) {
 			*root_flags |= CGRP_ROOT_NS_DELEGATE;
 			continue;
+		} else if (!strcmp(token, "groupoom")) {
+			*root_flags |= CGRP_GROUP_OOM;
+			continue;
 		}
 
 		pr_err("cgroup2: unknown option \"%s\"\n", token);
@@ -1747,6 +1750,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 			cgrp_dfl_root.flags |= CGRP_ROOT_NS_DELEGATE;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_NS_DELEGATE;
+
+		if (root_flags & CGRP_GROUP_OOM)
+			cgrp_dfl_root.flags |= CGRP_GROUP_OOM;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_GROUP_OOM;
 	}
 }
 
@@ -1754,6 +1762,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_GROUP_OOM)
+		seq_puts(seq, ",groupoom");
 	return 0;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5d27a4bbd478..c76d5fb55c5c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2869,6 +2869,9 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return false;
+
 	if (oc->memcg)
 		root = oc->memcg;
 	else
-- 
2.14.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
