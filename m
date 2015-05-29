From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add seq_file forward declaration for struct
 cftype
Date: Fri, 29 May 2015 09:16:30 -0400
Message-ID: <20150529131630.GI27479@htj.duckdns.org>
References: <8289624.GnpfIU6Era@wuerfel>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=X/NeFcv3h+yhzhtKyDej101v26Gp6VBUBvC4OGj23EE=;
        b=e6UNd6kG8ls4IPkCpAR3a3QQShXW82RoSxpY9cDf2ynvfu0oZEOSeJCM0pGmoJdQgH
         ZDIRe1a50++WufF6NEKYQbBPxn/7yfTVizVur/66rSuJ8SKRZ7G2R8CMB9+vtJFsTGQI
         0rNUAQsxVOzqlU/XZJgiAKB8mzp8Faq3boCe4EDX2XH492fP4OOH6AYq1D3fokws3fVS
         qhzY09WtZhu7005Q69VlxRL+TaoDByejjQlky+C0k0y88t0WROrgrrfkUW/PM1xcjVcf
         GFoUU+czjkV/PyNKgKDOm2Ems+lEjsMA0XQzePDioiQzldx5EjtGRYNOjbkSiWrVFsEy
         18lQ==
Content-Disposition: inline
In-Reply-To: <8289624.GnpfIU6Era@wuerfel>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Hello, Arnd.

Applied to cgroup/for-4.2 with the declaration moved so that it's
where others are.  Sorry that I missed that.

Thanks.

----- 8< -----
From c80ef9e0c021ff86771fdd72583c75d8f7b6a720 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Date: Fri, 29 May 2015 10:52:59 +0200
Subject: [PATCH] cgroup: add seq_file forward declaration for struct cftype

Recent header file changes for cgroup caused lots of warnings
about a missing struct seq_file form declaration for every
inclusion of include/linux/cgroup-defs.h.

As some files are built with -Werror, this leads to build
failure like:

                 from /git/arm-soc/drivers/gpu/drm/tilcdc/tilcdc_crtc.c:18:
/git/arm-soc/include/linux/cgroup-defs.h:354:25: error: 'struct seq_file' declared inside parameter list [-Werror]
cc1: all warnings being treated as errors
make[6]: *** [drivers/gpu/drm/tilcdc/tilcdc_crtc.o] Error 1

This patch adds the declaration, which resolves both the
warnings and the drm failure.

tj: Moved it where other type declarations are.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: b4a04ab7a37b ("cgroup: separate out include/linux/cgroup-defs.h")
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup-defs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 7d83d7f..26d1cea 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -26,6 +26,7 @@ struct cgroup_taskset;
 struct kernfs_node;
 struct kernfs_ops;
 struct kernfs_open_file;
+struct seq_file;
 
 #define MAX_CGROUP_TYPE_NAMELEN 32
 #define MAX_CGROUP_ROOT_NAMELEN 64
-- 
2.4.0
