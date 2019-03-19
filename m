From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v6 6/7] refactor header includes to allow kthread.h inclusion
 in psi_types.h
Date: Tue, 19 Mar 2019 16:56:18 -0700
Message-ID: <20190319235619.260832-7-surenb@google.com>
References: <20190319235619.260832-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CF4+E5UIa39xAKg6YCWVn7zIouVA3+WI4DKW8uAVCQw=;
        b=JEDIRq0NpHszfqFfgtVD61U2sHtyH+5HwG104koBNiR1CVnOdbZIQ4T7vm1xgqB50H
         thW4tUOnS/p6aXoascAN+Dz6Gdx60R0hL2NJtBGym4V5OdgxsWlooDMVXhqauD5dvIf0
         9+CLQTjHPP5q5QCRpzsZTUK0lbWDcn9aM5ow9098GJcCbaDlHtZLL8xqoZoW3weRMuVU
         Kgiw2eXJz/3tDBSIvexT6rGnLTcBKSeiNpmE4SWVOOBbgwyWNVKTStkLtZKteam1R6sI
         KT563q/OieuZG9lPrc1cm2wdB93lDHzC3hFQkJ9EXZhD7gqcLNh6exFuVacN12aIAOqa
         yjEQ==
In-Reply-To: <20190319235619.260832-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>

kthread.h can't be included in psi_types.h because it creates a circular
inclusion with kthread.h eventually including psi_types.h and complaining
on kthread structures not being defined because they are defined further
in the kthread.h. Resolve this by removing psi_types.h inclusion from the
headers included from kthread.h.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 drivers/spi/spi-rockchip.c | 1 +
 include/linux/kthread.h    | 3 ++-
 include/linux/sched.h      | 1 -
 kernel/kthread.c           | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 3912526ead66..cdb613d38062 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -15,6 +15,7 @@
 
 #include <linux/clk.h>
 #include <linux/dmaengine.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 2c89e60bc752..0f9da966934e 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -4,7 +4,6 @@
 /* Simple interface for creating and stopping kernel threads without mess. */
 #include <linux/err.h>
 #include <linux/sched.h>
-#include <linux/cgroup.h>
 
 __printf(4, 5)
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
@@ -198,6 +197,8 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
 
 void kthread_destroy_worker(struct kthread_worker *worker);
 
+struct cgroup_subsys_state;
+
 #ifdef CONFIG_BLK_CGROUP
 void kthread_associate_blkcg(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *kthread_blkcg(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1549584a1538..20b9f03399a7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -26,7 +26,6 @@
 #include <linux/latencytop.h>
 #include <linux/sched/prio.h>
 #include <linux/signal_types.h>
-#include <linux/psi_types.h>
 #include <linux/mm_types_task.h>
 #include <linux/task_io_accounting.h>
 #include <linux/rseq.h>
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5942eeafb9ac..be4e8795561a 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/completion.h>
 #include <linux/err.h>
+#include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/unistd.h>
 #include <linux/file.h>
-- 
2.21.0.225.g810b269d1ac-goog

