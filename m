From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH V2 04/10] cgroup: add owner name to cftypes
Date: Mon, 19 Nov 2018 11:34:18 +0100
Message-ID: <20181119103424.3853-5-paolo.valente@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ixCco3tkgOz6XOnATIyg3v7JG+fMVyFH/i6hN9+7LbE=;
        b=kKp2I6yh/orVyEouSJpVWokRdAT9xO+g+kCnqgaaTzcRgXwvj2mzpvsQeI/fL870j/
         FWJpkmfYHVEX994JHS9HKt3nipa3xeLHvXCMO6b7u5kQXIhAGjuRJ+Y8HyG2lb5f+Ag9
         5/O6i7rXVsv45I3wffJr69woHSqCdtIyD3Cxw=
In-Reply-To: <20181119103424.3853-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

The piece of information "who created a certain cftype" is not stored
anywhere, thus a cftype is not able to know who is its owner.

This commit addresses this problem by adding a new field in the cftype
structure that enables the name of its owner to be explicitly set.

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 include/linux/cgroup-defs.h |  2 ++
 include/linux/cgroup.h      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index d659763c7221..6e31f478c6e1 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -36,6 +36,7 @@ struct seq_file;
 #define MAX_CGROUP_TYPE_NAMELEN 32
 #define MAX_CGROUP_ROOT_NAMELEN 64
 #define MAX_CFTYPE_NAME		64
+#define MAX_OWNER_NAME		64
 
 /* define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _cgrp_id,
@@ -505,6 +506,7 @@ struct cftype {
 	 * end of cftype array.
 	 */
 	char name[MAX_CFTYPE_NAME];
+	char owner_name[MAX_OWNER_NAME];
 	unsigned long private;
 
 	/*
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9d12757a65b0..267153bd898a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -291,6 +291,19 @@ void css_task_iter_end(struct css_task_iter *it);
 			;						\
 		else
 
+/**
+ * list_for_each_cft - walk circular list of cftypes linked together
+ * @cft: cftype from where to start
+ * @n: cftype used as a temporary storage
+ *
+ * A cftype pointed by a file may be part of a circular list of cftypes, this
+ * macro walks the circular list starting from any given cftype. Unlike the
+ * "list_for_each_entry" macro, the first element is included in the iteration.
+ */
+#define list_for_each_cft(cft, n)					\
+	for (n = NULL; cft != n; n = (n == NULL) ? cft : n,		\
+	     cft = list_next_entry(cft, share_node))
+
 /*
  * Inline functions.
  */
-- 
2.16.1

