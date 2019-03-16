From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v9 7/9] cgroup: make TRACE_CGROUP_PATH irq-safe
Date: Sat, 16 Mar 2019 10:58:10 -0700
Message-ID: <20190316175812.6787-8-guro@fb.com>
References: <20190316175812.6787-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oe77XjSU239xs9p3BqL+eqRFZwO25QtGRaXNUMRkpIk=;
        b=gwnZvuGx8dL29LbvdrxUS4TDzNVLwL9a/UvAPMbrh/qb8n4uLHvekCXX1uPBc21WZ+
         5YH3ptGRPoSgdmHtHIKjCa2cjHIVrn9RRbcrxXi5hZHm+qQpHybIuFWBgnxz1gBFUI43
         gabFF7Ok06E0fa1AfnvmX5kopie9ksPQ5YxeuUiqhwuX4FFXZqOQ81a67l8k51+ap0H4
         l+dAcoaXLYdRZPsSb3EpISiadKEdey3DlxVfvjfbEBgCyawiycyYagNihs9x0+rb9f7m
         qYR/9SHBGp9wRcnluG+VzGsDTvYgKlgH2mc72W+xyerzFSCx+7rQ8rcGIrLwYo2TMPxJ
         OOHA==
In-Reply-To: <20190316175812.6787-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

To use the TRACE_CGROUP_PATH() macro with css_set_lock
locked, let's make the macro irq-safe.
It's necessary in order to trace cgroup freezer state
transitions (frozen/not frozen), which are happening
with css_set_lock locked.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/cgroup/cgroup-internal.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index a195328431ce..cdfa34485022 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -27,12 +27,15 @@ extern void __init enable_debug_cgroup(void);
 #define TRACE_CGROUP_PATH(type, cgrp, ...)				\
 	do {								\
 		if (trace_cgroup_##type##_enabled()) {			\
-			spin_lock(&trace_cgroup_path_lock);		\
+			unsigned long flags;				\
+			spin_lock_irqsave(&trace_cgroup_path_lock,	\
+					  flags);			\
 			cgroup_path(cgrp, trace_cgroup_path,		\
 				    TRACE_CGROUP_PATH_LEN);		\
 			trace_cgroup_##type(cgrp, trace_cgroup_path,	\
 					    ##__VA_ARGS__);		\
-			spin_unlock(&trace_cgroup_path_lock);		\
+			spin_unlock_irqrestore(&trace_cgroup_path_lock, \
+					       flags);			\
 		}							\
 	} while (0)
 
-- 
2.20.1

