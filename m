From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v7 1/7] cgroup: rename freezer.c into legacy_freezer.c
Date: Tue, 12 Feb 2019 10:48:01 -0800
Message-ID: <20190212184807.20304-2-guro@fb.com>
References: <20190212184807.20304-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=suU4k9iE7Md/KfJ4CfzvKVa4/9QAyJfSEidhnmW/+G4=;
        b=INtNvp3H9zdMtp3kcYDQMskua1THtfRgxAGGAIVRB7JNDn874CDV9KsMStpNWa2xEL
         RR9EQIAfASG2f5G41VZHK2HnxHV8kZ0pnnalBWPQlxagDRFqPxEfxHN9JlURxkFswNLn
         3FtoFMTfHNMM+prhDC/yYPtfAIxtM3JmFrWdOEIwn+rfAdCwiwVLbcdHD0kUbkkWjY0M
         vO/wyXBF3IWR8czOiJYKUC48AYvGvMixBgIr+6i6bwsnW5+FncVroEKebN/P8hZ2dDWS
         +2MAONo26YVbxJAdZgOKF/ruZbPc1WABeR6PKFTBZD5E+4y1hnsDg9BvaynjpStiIYJU
         AayA==
In-Reply-To: <20190212184807.20304-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

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
2.20.1

