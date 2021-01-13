From: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 2/2] MAINTAINERS: Update my email address
Date: Wed, 13 Jan 2021 16:50:52 +0800
Message-ID: <d09fd675-00fa-21e4-00b6-1cc4c2533a94@bytedance.com>
References: <75494a75-a74b-3dba-9846-7f51d805023a@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=7bLM0SCOKHe/fCiUaodu2A32W/TBhIHCOkDztDbBVPw=;
        b=OVDbUIK/40/4Bmxe//hY97Zk9F8gvprX3CooRRdOK52T50X2qY2nkMmNxudovLCQTp
         dJyO3hcd45gfuloJGvUi4pgVbARR6OQLuhFjR0FM47Ie4+M84e0zXnZYDUgzZdh7YDt6
         FwWSeh7UPC6Z6w4BGTyiqQ+cv1b83DKZm6vAojXOk7pD1np4wsbSRgOqCVOyZpCnyTaq
         cAPH6T6i5nhKYXJM5XeUFP8Fqs5bDrSszPonUJQb4uhUXrr26xHqs1DIAy3OT9OlhNpg
         k+M6M1JU952L+lvwwb+OIDh3+POJ2nEnHX2s6MkB2sBOgS9BHGIGtS7RCKBtKyWAXr10
         XMfg==
In-Reply-To: <75494a75-a74b-3dba-9846-7f51d805023a-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Signed-off-by: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 89140540aa8d..bc38f36f257c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4467,7 +4467,7 @@ F:	include/linux/console*
 
 CONTROL GROUP (CGROUP)
 M:	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
-M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
 M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
@@ -4491,11 +4491,11 @@ F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
-M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
+F:	Documentation/admin-guide/cgroup-v0/cpusets.rst
 F:	include/linux/cpuset.h
 F:	kernel/cgroup/cpuset.c
 
-- 
2.25.1
