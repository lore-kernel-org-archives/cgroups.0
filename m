From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 07/14] bfq: introduce better_fairness for container scene
Date: Thu, 25 Mar 2021 14:57:51 +0800
Message-ID: <9d9566d30702268e1f270f0cf7e8b08444c127a6.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=U2Ib5ddOEuKBopBvgjIJBWoMeTG4fDxN3eIx8DhyDG0=;
        b=te9NBf+emxKWBuf7IJoeMpDO6KZYXEcL9VBzWGRMDUAbr/9GThJYF8oDn0LtaQjFlh
         X/4Hu5GtC2OgZVNMaOCOIIiRdILv+sAybk9aqi/C/cyU10oULWf4FBtNcla+hnbhDhAF
         DahdKd4VTsFjIoNo1TLAGFPsF493k6SseDengj3eeJam+Ibi6ZDht6aSmDkmcNoV8bvm
         6zveANN7YmTEirYyRgSV4zKcOyo9yWwcXJbLuKKf3p2SUwV2Ja3wX7h0Uv8qGfZDbytB
         fZTbj4tBwhRrlG+WokxAEtMbLHjJLbbJA6k841sKw2TtNQ2l9357WOJkKx0VgmsN85rI
         mKVg==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

In the container scenario, in addition to throughput, we
also pay attention to Qos. In order to better support this
scenario, we introduce the better_fairness mode here. In
this mode, we expect to control the Qos of each group
according to its priority better. Only add configuration
interface here

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c | 22 ++++++++++++++++++++++
 block/bfq-iosched.h | 10 ++++++++++
 2 files changed, 32 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ee8c457..e7bc5e2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6745,6 +6745,7 @@ static ssize_t __FUNC(struct elevator_queue *e, char *page)		\
 SHOW_FUNCTION(bfq_max_budget_show, bfqd->bfq_user_max_budget, 0);
 SHOW_FUNCTION(bfq_timeout_sync_show, bfqd->bfq_timeout, 1);
 SHOW_FUNCTION(bfq_strict_guarantees_show, bfqd->strict_guarantees, 0);
+SHOW_FUNCTION(bfq_better_fairness_show, bfqd->better_fairness, 0);
 SHOW_FUNCTION(bfq_low_latency_show, bfqd->low_latency, 0);
 #undef SHOW_FUNCTION
 
@@ -6886,6 +6887,26 @@ static ssize_t bfq_strict_guarantees_store(struct elevator_queue *e,
 	return count;
 }
 
+static ssize_t bfq_better_fairness_store(struct elevator_queue *e,
+				     const char *page, size_t count)
+{
+	struct bfq_data *bfqd = e->elevator_data;
+	unsigned long __data;
+	int ret;
+
+	ret = bfq_var_store(&__data, (page));
+	if (ret)
+		return ret;
+
+	if (__data > 1)
+		__data = 1;
+	if (__data == 0 && bfqd->better_fairness != 0)
+		bfq_end_wr(bfqd);
+	bfqd->better_fairness = __data;
+
+	return count;
+}
+
 static ssize_t bfq_low_latency_store(struct elevator_queue *e,
 				     const char *page, size_t count)
 {
@@ -6919,6 +6940,7 @@ static ssize_t bfq_low_latency_store(struct elevator_queue *e,
 	BFQ_ATTR(max_budget),
 	BFQ_ATTR(timeout_sync),
 	BFQ_ATTR(strict_guarantees),
+	BFQ_ATTR(better_fairness),
 	BFQ_ATTR(low_latency),
 	__ATTR_NULL
 };
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index f9ed1da..674de8b 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -672,6 +672,16 @@ struct bfq_data {
 	bool strict_guarantees;
 
 	/*
+	 * If there is no prio preemption, we force the device to
+	 * idle to ensure Qos. IO inject also has some additional
+	 * restrictions. The inject/merge queue should come from the
+	 * same class in the same group. Doing so will reduce the
+	 * throughput of the system, but it can better guarantee
+	 * the Qos of each group and real-time tasks.
+	 */
+	bool better_fairness;
+
+	/*
 	 * Last time at which a queue entered the current burst of
 	 * queues being activated shortly after each other; for more
 	 * details about this and the following parameters related to
-- 
1.8.3.1

