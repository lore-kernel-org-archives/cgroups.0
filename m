From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] blk-iocost: account for IO size when testing latencies
Date: Wed,  8 Apr 2020 16:14:48 -0400
Message-ID: <20200408201450.3959560-4-tj@kernel.org>
References: <20200408201450.3959560-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdXZ3lJLN6mj2DFzKWWl+veWK2Db945pbS3QdWvrLY0=;
        b=vSHKOPOY1fZ0RWyLB4sv9rKbE91lJyvINDh9HA66upkxrCZCsFqamFz/DYSOhOgdYg
         rhxi9bNKEd+fNPZK7od8vDCK/+vuOvEozB6DDyDXPKN3i9608HYrOHwc9TS5SYRR+l3d
         ErVkebnrtKaYJY5OOYkBmWrYSxBv2fa1p+zB8dGYc77HKNJ23/vu5Miief6DgyIlWk1c
         Dteif6bDq7sYypOvnwPEX+FdMG/0OayCjgzzePAgz3Bi6wXWO6CBuPeAOQWTOqyQm2AZ
         l7AmSsojdFv3eC7jugIOdcAItndujAc3JMFc19DwwdGI6D3ZC1lI8HliuiuKc+UY7W2q
         LoaQ==
In-Reply-To: <20200408201450.3959560-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, Tejun Heo <tj@kernel.org>

On each IO completion, iocost decides whether the IO met or missed its latency
target. Currently, the targets are fixed numbers per IO type. While this can be
good enough for loose latency targets way higher than typical completion
latencies, the effect of IO size makes it difficult to tighten the latency
target - a target adequate for 4k IOs might be too tight for 512k IOs and
vice-versa.

iocost already has all the necessary information to account for different IO
sizes when testing whether the latency target is met as iocost can calculate the
size vtime cost of a given IO. This patch updates the completion path to
calculate the size vtime cost of the IO, deduct the nsec equivalent from the
observed latency and use the adjusted value to decide whether the target is met.

This makes latency targets independent from IO size and enables determining
adequate latency targets with fixed size fio runs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Newell <newella@fb.com>
---
 block/Kconfig      |  1 +
 block/blk-iocost.c | 31 +++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 48308e600dc8..3b0b698ca254 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -149,6 +149,7 @@ config BLK_CGROUP_IOLATENCY
 config BLK_CGROUP_IOCOST
 	bool "Enable support for cost model based cgroup IO controller"
 	depends on BLK_CGROUP=y
+	select BLK_RQ_IO_DATA_LEN
 	select BLK_RQ_ALLOC_TIME
 	---help---
 	Enabling this option enables the .weight interface for cost
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a8e99ef76a08..76e8738f7bb5 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -260,6 +260,7 @@ enum {
 	VTIME_PER_SEC_SHIFT	= 37,
 	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
 	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
+	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
 
 	/* bound vrate adjustments within two orders of magnitude */
 	VRATE_MIN_PPM		= 10000,	/* 1% */
@@ -1668,6 +1669,30 @@ static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 	return cost;
 }
 
+static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc, u64 *costp)
+{
+	u64 pages = max_t(u64, rq->io_data_len >> IOC_PAGE_SHIFT, 1);
+
+	switch (req_op(rq)) {
+	case REQ_OP_READ:
+		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
+		break;
+	case REQ_OP_WRITE:
+		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
+		break;
+	default:
+		*costp = 0;
+	}
+}
+
+static u64 calc_size_vtime_cost(struct request *rq, struct ioc *ioc)
+{
+	u64 cost;
+
+	calc_size_vtime_cost_builtin(rq, ioc, &cost);
+	return cost;
+}
+
 static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 {
 	struct blkcg_gq *blkg = bio->bi_blkg;
@@ -1837,7 +1862,7 @@ static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
 static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
-	u64 on_q_ns, rq_wait_ns;
+	u64 on_q_ns, rq_wait_ns, size_nsec;
 	int pidx, rw;
 
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
@@ -1858,8 +1883,10 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 
 	on_q_ns = ktime_get_ns() - rq->alloc_time_ns;
 	rq_wait_ns = rq->start_time_ns - rq->alloc_time_ns;
+	size_nsec = div64_u64(calc_size_vtime_cost(rq, ioc), VTIME_PER_NSEC);
 
-	if (on_q_ns <= ioc->params.qos[pidx] * NSEC_PER_USEC)
+	if (on_q_ns <= size_nsec ||
+	    on_q_ns - size_nsec <= ioc->params.qos[pidx] * NSEC_PER_USEC)
 		this_cpu_inc(ioc->pcpu_stat->missed[rw].nr_met);
 	else
 		this_cpu_inc(ioc->pcpu_stat->missed[rw].nr_missed);
-- 
2.25.1

