From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: Rename kernel/cgroup/stat.c to kernel/cgroup/rstat.c
Date: Fri, 23 Mar 2018 16:13:06 -0700
Message-ID: <20180323231313.1254142-2-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SGCuK+yj+Y4RuBK3r37s9pA8uatXEhJAJN9NUa2RhFA=;
        b=KfEw4g2ciZcHgtRMzyXtKgfDAjAgrTyFytsTunMrbYY10dZI/jzV9w3sXpp0MQpear
         HqCxf77QVtQwSAwjHOlVJdTNxFG95FuDK5SkYzYwYFaaHjrLduLTt2rCPCwi4O21D/Fb
         d62dpbtr3rlVh3+1mJIL+WE+0MWQfpwH6ACuMnina6MC+wVUpaeGVF+qvXYa8mmlEOSQ
         owLcAlwB+zKkYIXcXo9O9U+fWmXozXviOLWZvGvikzjisUYh5UxjxnGWa3uWoEU7emuO
         Mwgk0ny1p6UuA7yFrmszdwR+8JOy3rtyXYnvgxwYpFdHjYHUiOikNgD2L3ykk7eW+A65
         kptA==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

stat is too generic a name and ends up causing subtle confusions.
It'll be made generic so that controllers can plug into it, which will
make the problem worse.  Let's rename it to something more specific -
cgroup_rstat for cgroup recursive stat.

First, rename kernel/cgroup/stat.c to kernel/cgroup/rstat.c.  No
content changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/Makefile            | 2 +-
 kernel/cgroup/{stat.c => rstat.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename kernel/cgroup/{stat.c => rstat.c} (100%)

diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 2be89a00..bfcdae8 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y := cgroup.o stat.o namespace.o cgroup-v1.o
+obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o
 
 obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
diff --git a/kernel/cgroup/stat.c b/kernel/cgroup/rstat.c
similarity index 100%
rename from kernel/cgroup/stat.c
rename to kernel/cgroup/rstat.c
-- 
2.9.5

