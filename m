From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 14/14] cgroup: implement css_tryget()
Date: Fri, 16 May 2014 12:07:53 -0400
Message-ID: <20140516160753.GD5379@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oc5OBknZoUDbUIrY6g9RwUM2W1uWJ7H6SpJjVsuG68o=;
        b=pgz1FfnIHjRJWmoPxRCx8XySL8i53OSU3RM2XPKqNpf1IFW6kqRbU1jyz547dhHmd9
         XFdspLY4pfK0y8UNHuBLbGbQV9iXedSZxcEEh+pDFJ9gOL2E2as5CwG752N0Di+MpJlW
         ec4jR1VNUDmcKGQhhjEdywZY39jyIG2jINEPxCTci4t/zsCgp/uYfM80VhXJLnZs8OF7
         t5iA3KaMWyfRq8l6jNRAOM/R6MWq6j24L+d2Pd1nwjrUcNPxi4ZmZ0bMeBkW/LK4Qf8H
         vHrYwaMa69+VtFSXe66NnU/B2hzY0OMxA+HJ/8xWKxtHGX+3VlFy3CINUVGdcOVa1uUT
         ROdA==
Content-Disposition: inline
In-Reply-To: <1399671091-23867-15-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

From 141fdfadf18c10fed33624bbd414fcc0cb74d7ca Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 16 May 2014 11:40:38 -0400

Implement css_tryget() which tries to grab a cgroup_subsys_state's
reference as long as it already hasn't reached zero.  Combined with
the recent css iterator changes to include offline && !released csses
during traversal, this can be used to access csses regardless of its
online state.

v2: Take the new flag CSS_NO_REF into account.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b769999..4afe544 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -113,6 +113,24 @@ static inline void css_get(struct cgroup_subsys_state *css)
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
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget(&css->refcnt);
+	return true;
+}
+
+/**
  * css_tryget_online - try to obtain a reference on the specified css if online
  * @css: target css
  *
-- 
1.9.0
