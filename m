From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v4 1/7] cgroup: rename freezer.c into legacy_freezer.c
Date: Fri, 30 Nov 2018 15:47:39 -0800
Message-ID: <20181130234745.6756-2-guro@fb.com>
References: <20181130234745.6756-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mJ+hAWBjzYrtG9eKN+9slhswn7Xi2CuWuxj5q13heRo=;
        b=hmQbOmQkV6ljdW0TaOvMcRuzEZsaozfPkRaLYJNXP8OepQ0Pr4eJVIeLZg6G+hs83q
         s8hd5fcqPW+j1gKTRiEMFBLqSN5SO6pgrMU4xI5Wj4+VL0vyhhyM0JbQYL144J+Jzu7B
         wAgTxsPzGtE3bpSybq+O2OEvYElzu2/H5M1rnrc/9quHagXlcLd5ind+qThxTJl9LO58
         GQe7DHH/oIKKo9gSnAB7dM7BpX3tuaFcwNRABuWBef8w+ccFWvxEU1y3lSgZR8emtK/H
         /6xgFb1EZDnxuOQzgM0YLeSO7fxRS14xzNoiVmD5EfgceCgCL/CFwJQcMvwRwGoyc4vq
         fMCQ==
In-Reply-To: <20181130234745.6756-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

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

