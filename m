From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v3 1/7] cgroup: rename freezer.c into legacy_freezer.c
Date: Fri, 16 Nov 2018 16:38:24 -0800
Message-ID: <20181117003830.15344-2-guro@fb.com>
References: <20181117003830.15344-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mJ+hAWBjzYrtG9eKN+9slhswn7Xi2CuWuxj5q13heRo=;
        b=qwvIc2Y+PXxx8kZ4H59GjS4idYhJKXQCk2kP/Ehq6DgTL266DiskYKZ/w61t1i4TpV
         uohREcBifiWOad4Y2v+iGBDv+Fk0rxiXc2xLDsbuCZMsSGnlLWo7Cih2Yzch8NuGSRYv
         KywrxnKSkq1+4gTdaa2by22YOgUT17SQbKUgNjwftZ7w2KxYzSKMnmBxYGroSWAtyRJ+
         hlc3XBC5GRws2Dz7pcIij5R71k9Z91gftthEHmD/ZOaBv881WQw/JLfNfdbXmKGLmFbf
         MiYqX5KyOzIktaYjqgHX6Zl05fkFZIhYzS8c3S0rtaznB2mf2eLFSyuMEjudPmffgxZ8
         XhgQ==
In-Reply-To: <20181117003830.15344-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

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

