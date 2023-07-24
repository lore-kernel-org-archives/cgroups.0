From: Kai Huang <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] misc_cgroup: Fix the obsolete comment around 'struct misc_res'
Date: Mon, 24 Jul 2023 23:54:25 +1200
Message-ID: <20230724115425.1452383-1-kai.huang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690199679; x=1721735679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dUUOtqOX17ixG0CQwxEwuagR7WN91Ssj1qeb6A0Plp0=;
  b=NfqbXbxzvsEWlqE2ntIx/yYp8GgSckaGBblCdxL4N53L1G9RFGCpk2Dt
   yOYl1ab3FxCmpfzjJeeTIHx4FzH2bgVbv6BJuHPUZq9xILObnBWzejgRX
   //3OZarSU2uc1Y9nxDRfB+h8eawNsooX1MQkzcipn0Z3ifQ1dq1oVxf2L
   eMObKmtCT2/La7xu0J4ONYAmrxn9FUudo4Pzj5K5PaA5HH9C7uqxbIYZx
   THl7xrD6Zto4QUplUlt/4vwsLSEGfRzT/9geDRw3ke+fF4RgOsOdkeuT1
   8VGPmjFCKQIa7TDmgQFsUFORh0GQzJHZb/KUSW5PwBkocpC7mjEE4tMjl
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kai Huang <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The comment of the 'failed' member of 'struct misc_res' is obsolete
since commit b03357528fd9 ("misc_cgroup: remove error log to avoid log
flood"), which removed the 'failed' member from the structure.  Remove
the obsolete comment.

Also add the missing comment for the 'events' field, which should come
with commit f279294b3293 ("misc_cgroup: introduce misc.events to count
failures") where the 'events' member was added.

Signed-off-by: Kai Huang <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/linux/misc_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c238207d1615..41aa213a1125 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -31,7 +31,7 @@ struct misc_cg;
  * struct misc_res: Per cgroup per misc type resource
  * @max: Maximum limit on the resource.
  * @usage: Current usage of the resource.
- * @failed: True if charged failed for the resource in a cgroup.
+ * @events: Charge failure event counter of the resource.
  */
 struct misc_res {
 	unsigned long max;

base-commit: 3f01e9fed8454dcd89727016c3e5b2fbb8f8e50c
-- 
2.41.0

