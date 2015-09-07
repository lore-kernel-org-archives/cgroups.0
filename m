From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] devcg: Added user option to rdma resource tracking.
Date: Tue,  8 Sep 2015 02:08:17 +0530
Message-ID: <1441658303-18081-2-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g4gZMdk+OEayv3wezSLB2Dwbb+Hystul42o5P6rPaUU=;
        b=EppaMtX8Lh9Oe1tEVOwdXqSJfibWWXUIdd2D4jshQEJDZPgqJV3t82xJbRHwOQSK+8
         hG8Fc4EdpLCP4jQV3O9l+wJRYhflVvpUbHbNv02ZD/jj60Lo+eFMhAoRq1e49OslMQBQ
         K8lIbQ+wvuI3bSq16j/T6s2psfrenz+ErqUTP0jCWKKLhe9D7t3HWZ+zGQ7AOjaWpExU
         aqWtg/s/JtzvjAlRnAr9KjmKobkgmvJ5dIJ77xIX+PHznyLaQyK/U2Nu/dGrLwp2a756
         30SmUXa/JMrqjNdEqNTBbk/rOJcbRwopnsMGpZQYlam3KgPChXJJUipOwUqvzMCwUlKI
         kmmA==
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added user configuration option to enable/disable RDMA resource tracking
feature of device cgroup as sub module.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 init/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 2184b34..089db85 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -977,6 +977,18 @@ config CGROUP_DEVICE
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
 
+config CGROUP_RDMA_RESOURCE
+	bool "RDMA Resource Controller for cgroups"
+	depends on CGROUP_DEVICE
+	default n
+	help
+	  This option enables limiting rdma resources for a device cgroup.
+	  Using this option, user space processes can be limited to use
+	  limited number of RDMA resources such as MR, PD, QP, AH, FLOW, CQ
+	  etc.
+
+	  Say N if unsure.
+
 config CPUSETS
 	bool "Cpuset support"
 	help
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
