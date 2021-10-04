From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] cgroup: reorder cgroup_subsys fields to save 8 byte
Date: Mon,  4 Oct 2021 08:49:26 +0000
Message-ID: <20211004084928.17622-2-richard.weiyang@gmail.com>
References: <20211004084928.17622-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N3sruM3usLkej2geppAhAsEmxswQsSvrfu16yvAY3QU=;
        b=PUaJh/0D5EDmWmLJIGwBb0YRcdlZP3U8HbZzUs3GyO0byzRLKQxiftuiNqVZbLBwuW
         l127GSCaYwwQl5xI2Y5dZIp+b9IYz9tfkMa+YU6/gIaehp3tdwlDGUDPFPogiM9rUug+
         2wlne4vBEDBYaQdGCT+3uSRLFEGa/GoE1uP8oRxe4yL5t843uxXb6sCodhsaYN3xyojx
         fA053an6P3pQdpBwdzFna2bAHSpF2dWNY8IafpXYKRL4qZjqL09eICf2kDgUDcqPfU4p
         vGOwDCsx4xZNVwtjMMCVA8pMFnPis+jJziABbBJpcIVGwAxcsViE/tgAos3uzkJdWhru
         z4Kw==
In-Reply-To: <20211004084928.17622-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 64bit platform, struct is aligned by 8 bytes by default.

By moving cgroup_subsys.depends_on, we fit these adjacent fields into
8 bytes alignment.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup-defs.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f6d80896daab..4649d09396fd 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -672,6 +672,15 @@ struct cgroup_subsys {
 	 */
 	bool threaded:1;
 
+	/*
+	 * A subsystem may depend on other subsystems.  When such subsystem
+	 * is enabled on a cgroup, the depended-upon subsystems are enabled
+	 * together if available.  Subsystems enabled due to dependency are
+	 * not visible to userland until explicitly enabled.  The following
+	 * specifies the mask of subsystems that this one depends on.
+	 */
+	u16 depends_on;
+
 	/* the following two fields are initialized automatically during boot */
 	int id;
 	const char *name;
@@ -698,14 +707,6 @@ struct cgroup_subsys {
 	struct cftype *dfl_cftypes;	/* for the default hierarchy */
 	struct cftype *legacy_cftypes;	/* for the legacy hierarchies */
 
-	/*
-	 * A subsystem may depend on other subsystems.  When such subsystem
-	 * is enabled on a cgroup, the depended-upon subsystems are enabled
-	 * together if available.  Subsystems enabled due to dependency are
-	 * not visible to userland until explicitly enabled.  The following
-	 * specifies the mask of subsystems that this one depends on.
-	 */
-	u16 depends_on;
 };
 
 extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
-- 
2.23.0

