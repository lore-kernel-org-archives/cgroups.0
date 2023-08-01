From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] selftests: cgroup: fix test_kmem_basic false positives
Date: Tue,  1 Aug 2023 09:56:32 -0400
Message-ID: <20230801135632.1768830-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1690898193; x=1691502993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XJLGW04mxEToFfRDeoOpyp00hE8LNX9fFBjKrCRhwps=;
        b=iLH7vqnb28PIkYe34u+mDj70sMwzhlg2Nc9Lt2f4INh+KceFZ4zMmArs8alLU4u0W1
         xuDos8oBmOj2eI8hOcKxNyjB9tlUl5gULORkj9AFCEfX0mZRPKbeVkBWvQtw3rU0aFZL
         qGVxwxzioM5kQNEUjBSr/VS4Yudj1ZSYn+Pk67O/2OGEHBnObl0Oxjqh5w56/qFguZeF
         0P4o7c44YclUPTxHlqXaMpNGRbK83ZiiVTuS+udod4EI3YUzNvZi7AAMVqNq6u/dr4Mv
         NoUhcNOKuM2pesfsikO7xYyIiTwESwnALMqSuZQOqB6X+3xxzvPkTuuBoUokQu/Pu+Gu
         /KBQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This test fails routinely in our prod testing environment, and I can
reproduce it locally as well.

The test allocates dcache inside a cgroup, then drops the memory limit
and checks that usage drops correspondingly. The reason it fails is
because dentries are freed with an RCU delay - a debugging sleep shows
that usage drops as expected shortly after.

Insert a 1s sleep after dropping the limit. This should be good
enough, assuming that machines running those tests are otherwise not
very busy.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 tools/testing/selftests/cgroup/test_kmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 258ddc565deb..1b2cec9d18a4 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -70,6 +70,10 @@ static int test_kmem_basic(const char *root)
 		goto cleanup;
 
 	cg_write(cg, "memory.high", "1M");
+
+	/* wait for RCU freeing */
+	sleep(1);
+
 	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
 	if (slab1 <= 0)
 		goto cleanup;
-- 
2.41.0

