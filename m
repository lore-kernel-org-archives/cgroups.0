From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 1/5] cgroup: rename freezer.c into legacy_freezer.c
Date: Thu,  8 Nov 2018 15:15:56 -0500
Message-ID: <20181108201600.9129-2-guro@fb.com>
References: <20181108201600.9129-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mJ+hAWBjzYrtG9eKN+9slhswn7Xi2CuWuxj5q13heRo=;
        b=iEyOmvJWIkp2iDqOu4d/ZJzOXwaz59Zzuacsb1iK7faH53XGcY2v00rJrDUCgQBCxd
         DNcF2h91l5DDJiSK5rgn27lbAOcrokur/9wdGKDSTLM39qOzekCpTLArqcnOXyGSLUTt
         0a/3hvgnGdGS0592nMd321GuNGer7Td79eNruH0jOEURN2kmoZ8Gv1V5RC2qdr+vzMqE
         ARCJUR1yV+bgtlCCiyEimjmytvlqRZPm1DklSD4BRsexd3W4j0LVsG6hbDitBI5LhWBj
         ty6/H3fMMyx4xOGxQRRnhM+yGJ6vVWbZsHuvDbHlw7UA9UftAagFMopwcgXJsnGkJi90
         6BAQ==
In-Reply-To: <20181108201600.9129-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>

Freezer.c will contain an implementation of cgroup v2 freezer,
so let's rename the v1 freezer to avoid naming conflicts.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
---
 kernel/cgroup/Makefile                        | 2 +-
 kernel/cgroup/{freezer.c => legacy_freezer.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename kernel/cgroup/{freezer.c => legacy_freezer.c} (100%)

diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index bfcdae896122..8d5689ca94b9 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o
 
-obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
+obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/legacy_freezer.c
similarity index 100%
rename from kernel/cgroup/freezer.c
rename to kernel/cgroup/legacy_freezer.c
-- 
2.17.2

