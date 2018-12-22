From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v6 1/7] cgroup: rename freezer.c into legacy_freezer.c
Date: Fri, 21 Dec 2018 16:03:01 -0800
Message-ID: <20181222000307.28231-2-guro@fb.com>
References: <20181222000307.28231-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A6BTJfzWIelD7mVbuHLF+in+X9LUwJiyPSv1dibuIj4=;
        b=jsLqI56HTTsqPVi3FX3oDfH+umsq+zqs513EUQXSMHgRXBe4lnwCYBxA+mnMQhTsgf
         ctCjKne4LV487O8kl+UKHNKeqjizRXwpi7JuHZkFseu/z91NQjr7wugBNBEGpwRyU0W5
         CqfHVsSIgfqHODmdFdgkWgek7xqpYziz7U3ipIRjkIOZZuE8LaQ1nhgU7le5n8d7XmFu
         rD9JN3Co42nNjA15DrDL/f/L8si7h8yH8nZbHU6TIyCyr7iHCFMqH+xek2Wo0d+R3hv0
         0RQZyHO722DaBD4frDUYoZmqJ51vtNhCoByIN9LA77yUDOzQRg6AwbjflyooaXDyf1Vo
         Sjug==
In-Reply-To: <20181222000307.28231-1-guro@fb.com>
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
2.19.2

