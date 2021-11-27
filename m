From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cgroup: cgroup_subsys[ssid] is never NULL
Date: Sat, 27 Nov 2021 14:59:18 +0000
Message-ID: <20211127145919.31159-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jLD7GABe69Y2XIK8EiAw+ECm8aNoQireR1sVfpfjBUw=;
        b=XZeYzcUqFHoWKneResRr679zdRHeMgo5U8ZyVqUHrxnhcTRHSuLmO2QbJVgmmmJ5PI
         emrMJRDFtSew+vIqtyNpgmnOuT6ZXzc5h+cUGdd5yFK4kWlZVCTF7wsKotojpfNkxMGA
         vGWnEIeLui9YEszzwYJ6DK7iVlghNaFBil3Wxfh7e2Lvg7JCFx9TGd1hx2WOuGX6Jcph
         6j73Mc7Ih40R3MRxbaadn/Sa8bZmvxJIiNyFb2vD0o5pTZA/n79jzxpLeTA+YD94K/+4
         FF68W5SYmJLerPI7RUzDvD6bPf+j7ZV3C1v9UmwtqTYq4xiDn0GCJCQgScXHfIDt7l4w
         KEBA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When the check, (ssid) < CGROUP_SUBSYS_COUNT, passed, it means
cgroup_subsys[ssid] is defined to its proper value. It is not
necessary to use a true to enter the loop.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index bfbeabc17a9d..0c5d1df6cdef 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -163,7 +163,7 @@ extern struct file_system_type cgroup_fs_type;
  */
 #define for_each_subsys(ss, ssid)					\
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
-	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
+	     ((ss) = cgroup_subsys[ssid]); (ssid)++)
 
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
-- 
2.33.1

