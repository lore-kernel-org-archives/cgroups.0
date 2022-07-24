From: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests/cgroup: fix repeated words in comments
Date: Sun, 24 Jul 2022 15:04:35 +0800
Message-ID: <20220724070435.7999-1-wangjianli@cdjrlc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>

Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_freezer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index ff519029f6f4..b479434e87b7 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -740,7 +740,7 @@ static int test_cgfreezer_ptraced(const char *root)
 
 	/*
 	 * cg_check_frozen(cgroup, true) will fail here,
-	 * because the task in in the TRACEd state.
+	 * because the task in the TRACEd state.
 	 */
 	if (cg_freeze_wait(cgroup, false))
 		goto cleanup;
-- 
2.36.1

