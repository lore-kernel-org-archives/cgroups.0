From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v5 1/7] cgroup: rename freezer.c into legacy_freezer.c
Date: Fri,  7 Dec 2018 12:15:25 -0800
Message-ID: <20181207201531.1665-2-guro@fb.com>
References: <20181207201531.1665-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mJ+hAWBjzYrtG9eKN+9slhswn7Xi2CuWuxj5q13heRo=;
        b=jHeNzApqttpKVz/ltNtKvxViPu0Gw62SHb5Tfbcxn1h3KauOhz+MIdEFlRkommBDtO
         UKaoPECJvDtrpn7BLmf27GGZvKQh7AZcvsB4T0c+kPxzhugZK1dQTfBYiZAsN6Q93USO
         TRSIaQ0MxMEl3dHIQK69uGxvTnWiprLJ2hsRuiIlAYpxpJ5JrCGm6ezTj8Sua7VQqpT4
         jHNuFsmdGNeSCldgIIMsdKddU5l2/VhtWE0sI6xmsXd7Nfx5B8dgpO+D/ttnTkbObkVQ
         5WbgZKxaoZg16Y5L/7/ak0gSnVzpTWg4s6klP0xja4XUqB6Zi1UHmA8sHhKzo0/3uMls
         kkuw==
In-Reply-To: <20181207201531.1665-1-guro@fb.com>
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

