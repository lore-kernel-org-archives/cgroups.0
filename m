From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v3 2/3] selftests: cgroup: refactor proactive reclaim code to reclaim_until()
Date: Fri,  2 Dec 2022 03:15:11 +0000
Message-ID: <20221202031512.1365483-3-yosryahmed@google.com>
References: <20221202031512.1365483-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DuRs+eCOo373fWFIamKdpS1DYx9E7KO6vBATpERNpN8=;
        b=P8OpmCy+hsdPsPghjVdy/8p6gbBKyWTBeA78u/eWGmraKF4XDkTC9BUAU4xols3RBJ
         Eb3T4ls0TY54/uxuYu7J+7atf4/xsoYt0KtUeRT9Zb5hY23o7MjxGkNxTpE6HlEG6JLX
         U4PTYctA7PHrrQ/iwUqeB94jmIuWs5SyK7sWXKJ1Nk2bdcheYAGV4dLM23SFnBy69R0L
         vBw+xnHv9O+RKwOcXilgLaN2TxlnG+nleMjWKyBjPB5guj+1LDHVlpKt8044WVFp6kV+
         prfW9gEk3LyWoDGd81vPJOKNBNtQiWQcZaS9NglCCm5pty1GVtmv0As3GfjkM/d/SVij
         WH3g==
In-Reply-To: <20221202031512.1365483-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, Muchun Song <songmuchun@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vasily Averin <vasily.averin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Chris Down <chris@chrisdown.name>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>

Refactor the code that drives writing to memory.reclaim (retrying, error
handling, etc) from test_memcg_reclaim() to a helper called
reclaim_until(), which proactively reclaims from a memcg until its
usage reaches a certain value.

While we are at it, refactor and simplify the reclaim loop.

This will be used in a following patch in another test.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 80 ++++++++++---------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 8833359556f3..a8f4700353a4 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -645,6 +645,48 @@ static int test_memcg_max(const char *root)
 	return ret;
 }
 
+/*
+ * Reclaim from @memcg until usage reaches @goal by writing to
+ * memory.reclaim.
+ *
+ * This function will return false if the usage is already below the
+ * goal.
+ *
+ * This function assumes that writing to memory.reclaim is the only
+ * source of change in memory.current (no concurrent allocations or
+ * reclaim).
+ *
+ * This function makes sure memory.reclaim is sane. It will return
+ * false if memory.reclaim's error codes do not make sense, even if
+ * the usage goal was satisfied.
+ */
+static bool reclaim_until(const char *memcg, long goal)
+{
+	char buf[64];
+	int retries, err;
+	long current, to_reclaim;
+	bool reclaimed = false;
+
+	for (retries = 5; retries > 0; retries--) {
+		current = cg_read_long(memcg, "memory.current");
+
+		if (current < goal || values_close(current, goal, 3))
+			break;
+		/* Did memory.reclaim return 0 incorrectly? */
+		else if (reclaimed)
+			return false;
+
+		to_reclaim = current - goal;
+		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
+		err = cg_write(memcg, "memory.reclaim", buf);
+		if (!err)
+			reclaimed = true;
+		else if (err != -EAGAIN)
+			return false;
+	}
+	return reclaimed;
+}
+
 /*
  * This test checks that memory.reclaim reclaims the given
  * amount of memory (from both anon and file, if possible).
@@ -653,8 +695,7 @@ static int test_memcg_reclaim(const char *root)
 {
 	int ret = KSFT_FAIL, fd, retries;
 	char *memcg;
-	long current, expected_usage, to_reclaim;
-	char buf[64];
+	long current, expected_usage;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -705,41 +746,8 @@ static int test_memcg_reclaim(const char *root)
 	 * Reclaim until current reaches 30M, this makes sure we hit both anon
 	 * and file if swap is enabled.
 	 */
-	retries = 5;
-	while (true) {
-		int err;
-
-		current = cg_read_long(memcg, "memory.current");
-		to_reclaim = current - MB(30);
-
-		/*
-		 * We only keep looping if we get EAGAIN, which means we could
-		 * not reclaim the full amount.
-		 */
-		if (to_reclaim <= 0)
-			goto cleanup;
-
-
-		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
-		err = cg_write(memcg, "memory.reclaim", buf);
-		if (!err) {
-			/*
-			 * If writing succeeds, then the written amount should have been
-			 * fully reclaimed (and maybe more).
-			 */
-			current = cg_read_long(memcg, "memory.current");
-			if (!values_close(current, MB(30), 3) && current > MB(30))
-				goto cleanup;
-			break;
-		}
-
-		/* The kernel could not reclaim the full amount, try again. */
-		if (err == -EAGAIN && retries--)
-			continue;
-
-		/* We got an unexpected error or ran out of retries. */
+	if (!reclaim_until(memcg, MB(30)))
 		goto cleanup;
-	}
 
 	ret = KSFT_PASS;
 cleanup:
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

