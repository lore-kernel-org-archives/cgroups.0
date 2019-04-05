From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v10 1/9] cgroup: rename freezer.c into legacy_freezer.c
Date: Fri,  5 Apr 2019 10:47:00 -0700
Message-ID: <20190405174708.1010-2-guro@fb.com>
References: <20190405174708.1010-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=suU4k9iE7Md/KfJ4CfzvKVa4/9QAyJfSEidhnmW/+G4=;
        b=BugrLjyBKWj237HaLZhmd0b3erplta9gtTzJ4llVQZAr6aObUFEF/fyTNgN9kLKo6H
         FxP53TFCmPPP89OLwHbkjs9GX66HI1k9ZQgJW44s6s69R0H+UwstNKqui9JpWqCiVv3L
         NrvVC6W+BKJ3HVBIWEdKhr38Q2jgDewI82X8hUZ1kkbrTW0sr2JMx0yUhWIb4S5Tkm+1
         s0uvhsNYjj0sqZkre/nN0MsSWDbMpn+jegzh12NEyKo4GS7s4mb9a9BEfgFsLMZc0lQT
         qZZnnEorQOMD+tZ/TL2QKR/f84SFydZ7dh1S38gb4F+8O6JBg2hN7d7bfjwpleWaS7Dv
         x5WQ==
In-Reply-To: <20190405174708.1010-1-guro@fb.com>
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

