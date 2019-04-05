From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v10 7/9] cgroup: make TRACE_CGROUP_PATH irq-safe
Date: Fri,  5 Apr 2019 10:47:06 -0700
Message-ID: <20190405174708.1010-8-guro@fb.com>
References: <20190405174708.1010-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4h9Nyqf/+CHjwR0GNBVcZWQPowVsjRY9nsfVCm7bZNA=;
        b=Rl1XMDihe97b1BCwFcVwt7ZYJsdT5/KIaQx9tfoNC8G2sFOBJ2A2Nww3bWBhbIu8jA
         uzI8nwLHkifqUu/hhbYxKTl06jab6byICC7xpMhrpAmQY3GmopPSAALBfueGvjZ6+hYw
         K4YGPISABLiwl12Pj6jHqJBozGeohYgoQbbRY630+Pgt4PorbijGa//dWn+jRc+ahwuK
         b3Cv/leaGU7zZL6t2xLAtgaM28SB3CIeofxr4I/pO+C1vdRwtP3DmSIEjKevESd5AyYx
         qH/wVMVIhVq3mfoNFPS6Bxh1XI71E2xK13ZOY0ppbrHvvGikzwqxXN1/5kROBnuCbc71
         Fk6Q==
In-Reply-To: <20190405174708.1010-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

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
index 02c001ffe2e2..809e34a3c017 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -28,12 +28,15 @@ extern void __init enable_debug_cgroup(void);
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

