From: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 2/2] cpuset: Replace ktime_get_real_ts64() with
 ktime_get_ts64()
Date: Mon, 13 Oct 2014 10:22:19 +0530
Message-ID: <476bc8af8e6ffd450d62e1e18d3a114d98d01c37.1413174804.git.heenasirwani@gmail.com>
References: <cover.1413174804.git.heenasirwani@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eM5TA1FbIYn7Hl/jck1hfhhDC2XYuuivKLsjN9S7ss0=;
        b=NapkMWuEWJQcTuyWkZoLpe9u9D/TAMAkxqqKzlqfOf3n53nGjlSinF5vpo3P4QcqHV
         GcUxE24E45c8Kf51BFJEwYpH/B/I0Z6l035kju7Vcjk2x3/YBDYwBDpLElFGDgx6erY6
         pdaWbeiUQXbkLdvNNYK0VS3F6jHNkRfQPuETdon2M5yn1yAdzhKg7o6Eog/6xgeYZ1re
         b84Yj/ro8ZCfx5YdDp84ySNurAgDVgvBzlaTlvIpqswpbqMDb+NkYLtZECPaIgxhTCD8
         FHqjQgHz88l/V+jgoXkcJEZmlPXSa11Gujst1J03VCtZGnqtIzvtkj9wdnguBMzTPqFi
         YyDg==
Content-Disposition: inline
In-Reply-To: <cover.1413174804.git.heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opw-kernel-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following patch makes the kernel code independent of the
setimeofday() function by replacing the function ktime_get_real_ts64()
with ktime_get_ts64().

The function calculates the interval between two successive calls to
fmeter_update() and between these if a call to settimeofday() is called
it would lead to erroneous calculation of the interval. The function
ktime_get_ts64() is the monotonic wall-time clock that does an extra
calculation to remove the effects of settimeofday().

Signed-off-by: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c3e3aac..98cf976 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1377,7 +1377,7 @@ static void fmeter_update(struct fmeter *fmp)
 	u32 ticks;
 
 	/* One should probably use get_seconds64().*/
-	ktime_get_real_ts64(&timespec);		
+	ktime_get_ts64(&timespec);		
 	now = timespec.tv_sec;
 	ticks = now - fmp->time;
 
-- 
1.9.1
