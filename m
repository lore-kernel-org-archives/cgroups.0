From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm, pm, vmpressure: add missing slab.h includes
Date: Tue, 28 Jan 2014 17:19:22 -0500
Message-ID: <20140128221922.GC16060@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=yN17rYmIBgrSvpTftw169nd6Kkm75O5C9pjTRnMzukE=;
        b=HAFINc07o30CVmYRuDnVQIfpgCT5rgtfPQEjFTX2sdUuB2czT3U8LdkdCtlpGRihUR
         F3oEo3al0PfYm5pz52/IxgQYA43bbm8FUIzCC5Ue+ZJDIzI/PCW8zyjXy3CDW92vpdvw
         xmTJyBTB35iV1r8O0lWWsOFqCP6uPHPLruZJvvokMUs1Xp9PJQUeYmKl9joJvk5qssT+
         OK+6u8jG46nFD/nuF02GYsIBJsIgKSxVwC1M249Wut2AvKqeKfjayNqFPFIUto+xIPUY
         tjTDkPqNSjeJ7WMXE5X6cQWl5cxGM+obH+T3WrF+KN3C4jIJ5uHTymaz6P/X9cbH4i4N
         beYw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

arch/arm/mach-tegra/pm.c, kernel/power/console.c and mm/vmpressure.c
were somehow getting slab.h indirectly through cgroup.h which in turn
was getting it indirectly through xattr.h.  A scheduled cgroup change
drops xattr.h inclusion from cgroup.h and breaks compilation of these
three files.  Add explicit slab.h includes to the three files.

A pending cgroup patch depends on this change and it'd be great if
this can be routed through cgroup/for-3.14-fixes branch.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
If you guys are okay with this going through cgroup/for-3.14-fixes,
can you please ack it?

Thanks!

 arch/arm/mach-tegra/pm.c |    1 +
 kernel/power/console.c   |    1 +
 mm/vmpressure.c          |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -24,6 +24,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/suspend.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/clk/tegra.h>
 
 #include <asm/smp_plat.h>
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -9,6 +9,7 @@
 #include <linux/kbd_kern.h>
 #include <linux/vt.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "power.h"
 
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/eventfd.h>
+#include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/printk.h>
 #include <linux/vmpressure.h>
