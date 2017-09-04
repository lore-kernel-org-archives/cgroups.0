From: Roman Gushchin <guro@fb.com>
Subject: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware OOM killer
Date: Mon, 4 Sep 2017 15:21:08 +0100
Message-ID: <20170904142108.7165-6-guro@fb.com>
References: <20170904142108.7165-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1lI722+A0fcKOGNAD5UObgfbkHSTUYd+T95UW9Qiarg=;
 b=LYjgughQjTFnHBFtFsvMFW0kt3b3zAleqzxIGHrjMpVxk5tOmFzv4Dva5wTZ8prDApHO
 H2oeMQgDYSKibi2CD7PkeC7XN1djSF8CVTcMAhaOFh5sH82FhkqTpTOlfB1cPqSh7QI/
 mG5K5vYtJWAUVYfKKAr45yBWKR7s9uyMoLo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1lI722+A0fcKOGNAD5UObgfbkHSTUYd+T95UW9Qiarg=;
 b=AOddiGyvuWr7P2yJZP5dUayqbde9ATjMd3+gotKj1fMtewvM7y8DL+4ednlD9hXFuu0+OOlf+JHPOBSdJJ65FPtVKFDDocytnIuP1wXBivOXZRM9aMJepgxyGN8UedAZfcOUZnkhUzKSRHMOG2/pa0wpgHuaUrmChWONFgKrMsA=
In-Reply-To: <20170904142108.7165-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Introducing of cgroup-aware OOM killer changes the victim selection
algorithm used by default: instead of picking the largest process,
it will pick the largest memcg and then the largest process inside.

This affects only cgroup v2 users.

To provide a way to use cgroups v2 if the old OOM victim selection
algorithm is preferred for some reason, the nogroupoom mount option
is added.

If set, the OOM selection is performed in a "traditional" per-process
way. Both oom_priority and oom_group memcg knobs are ignored.

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
 Documentation/admin-guide/kernel-parameters.txt | 1 +
 mm/memcontrol.c                                 | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 28f1a0f84456..07891f1030aa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -489,6 +489,7 @@
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
 			nokmem -- Disable kernel memory accounting.
+			nogroupoom -- Disable cgroup-aware OOM killer.
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d7dd293897ca..6a8235dc41f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -87,6 +87,9 @@ static bool cgroup_memory_nosocket;
 /* Kernel memory accounting disabled? */
 static bool cgroup_memory_nokmem;
 
+/* Cgroup-aware OOM  disabled? */
+static bool cgroup_memory_nogroupoom;
+
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
 int do_swap_account __read_mostly;
@@ -2822,6 +2825,9 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
 	if (mem_cgroup_disabled())
 		return false;
 
+	if (cgroup_memory_nogroupoom)
+		return false;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
@@ -6188,6 +6194,8 @@ static int __init cgroup_memory(char *s)
 			cgroup_memory_nosocket = true;
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
+		if (!strcmp(token, "nogroupoom"))
+			cgroup_memory_nogroupoom = true;
 	}
 	return 0;
 }
-- 
2.13.5

