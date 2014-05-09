From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] cgroup: implement css_tryget()
Date: Fri,  9 May 2014 17:31:31 -0400
Message-ID: <1399671091-23867-15-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=48vsfIxb5t3zVfVZxv8NUF2ZtSWsPinRkUUNpaMG9qE=;
        b=VhFAS2QRjX01JZ8SDOG+x7omsl9CSmZyjehxCTUIKCchJtqtz2VXiualnjke81KeNh
         2fisVmffbStXspOc+Eehc1zXXGOuS6dIIPjXqJYWpiWXB/rDXhOVFh8I/e/JAsUyD12Z
         ngs1HbvUUvtRUKdXGPvqw7ewRomIcad9gGl4EMYUHvmW6j7DaXrl/BDppokzrPjYrF9t
         2uTxx3vNUe6pml15mWM4Zo+IEDf4i2vHSpCvbUwXDqxVSj7QiLT+n3Twk6LIuvFTj3Dv
         clGakLKTWXgw0LDY/X7BPWKgOrEnBu26jHZ9s/KxZvdO0/LvTaAXn+FOpkW7Ebr5b1o7
         s6ww==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

Implement css_tryget() which tries to grab a cgroup_subsys_state's
reference as long as it already hasn't reached zero.  Combined with
the recent css iterator changes to include offline && !released csses
during traversal, this can be used to access csses regardless of its
online state.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/cgroup.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c8eb66e..6dd3867 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -111,6 +111,22 @@ static inline void css_get(struct cgroup_subsys_state *css)
 }
 
 /**
+ * css_tryget - try to obtain a reference on the specified css
+ * @css: target css
+ *
+ * Obtain a reference on @css unless it already has reached zero and is
+ * being released.  This function doesn't care whether @css is on or
+ * offline.  The caller naturally needs to ensure that @css is accessible
+ * but doesn't have to be holding a reference on it - IOW, RCU protected
+ * access is good enough for this function.  Returns %true if a reference
+ * count was successfully obtained; %false otherwise.
+ */
+static inline bool css_tryget(struct cgroup_subsys_state *css)
+{
+	return percpu_ref_tryget(&css->refcnt);
+}
+
+/**
  * css_tryget_online - try to obtain a reference on the specified css if online
  * @css: target css
  *
-- 
1.9.0
