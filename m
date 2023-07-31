From: Li Zetao <lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] selftests: cgroup: Remove redundant if statements
Date: Mon, 31 Jul 2023 21:42:05 +0800
Message-ID: <20230731134205.2723657-1-lizetao1@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There is a warning reported by coccinelle:

./tools/testing/selftests/cgroup/test_zswap.c:211:6-18: WARNING:
		Unsigned expression compared with zero: stored_pages     <     0

The type of "stored_pages" is size_t, which always be an unsigned type,
so it is impossible less than zero. Drop the if statements to silence
the warning.

Signed-off-by: Li Zetao <lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49def87a909b..dbad8d0cd090 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -208,8 +208,6 @@ static int test_no_kmem_bypass(const char *root)
 		free(trigger_allocation);
 		if (get_zswap_stored_pages(&stored_pages))
 			break;
-		if (stored_pages < 0)
-			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-- 
2.34.1

