From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: [PATCH] selftests: cgroup: fix test_zswap error path and meaningless check
Date: Tue, 12 Sep 2023 10:38:00 +0200
Message-ID: <20230912083800.57435-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694507915; x=1695112715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d5WzW7udVB3HdwrirrUGrjvkqjfIkPOdv3DY3SpLmXk=;
        b=kprj7FtczO5+01Xw1n/tLGqFrn4h+aI1W4RCgmCVk+sgHNEZc0gI6y5r8U/p2JwwW5
         ijqy/USEumr+x1/XvTAv1GXBTosc4MM0GtlQafqXNg8c74CNffK7KHZatwRgFQhTDHwW
         ScZv7b/m1d2fmkZWNakXFByd5l9XhcMF4uey2lA/6ojOa2AkvQ8zeMOiaSVfI4KDesLN
         Hnh7K1zD1SrDjHh7CX5mk1LYnzRQrbTwRqB4PowqDm4CAhigzyH9SiC793x3A5UD2ODu
         HPXUiBGU7VLYLtGEMtKlVYdJZdvHx/3YF9NPODYyrspCwmX0Ck8LuIxnK0IjItnegm+D
         6JJw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dan.carpenter@linaro.org, akpm@linux-foundation.org, kernel-team@meta.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>

Replace destruction paths with simple returns before the test cgroup is
created, there is nothing to free or destroy at that point.

Remove pointless check, stored_pages is a size_t and cannot be < 0.

Fixes: a549f9f31561 ("selftests: cgroup: add test_zswap with no kmem bypass test")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49def87a909b..5257106776d5 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -178,10 +178,10 @@ static int test_no_kmem_bypass(const char *root)
 
 	/* Set up test memcg */
 	if (cg_write(root, "cgroup.subtree_control", "+memory"))
-		goto out;
+		return KSFT_FAIL;
 	test_group = cg_name(root, "kmem_bypass_test");
 	if (!test_group)
-		goto out;
+		return KSFT_FAIL;
 
 	/* Spawn memcg child and wait for it to allocate */
 	set_min_free_kb(min_free_kb_low);
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

