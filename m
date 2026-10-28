Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198160;
	b=KEzPzDEkGUTm6Sl01zrR7Y4vJrQ0QvkI/9rYInU3bmHI+yWUX0Nwino0YSRoJGwbDFMs
	 y6p90EPPjoADPV5nSX3HYKiQ/jaKkXJp3hJEQXK+4CIMLQxAXDzC5rSJ0XjmLl/EiXkve
	 UFx8X+Wgi/uF/Z9V6sm7U81GkqKQr7kKDKbtVSyNdVTj8efnN4jGEPAEKNq2dyR6k4euW
	 Ua+Kv7rdcaeA/v9qjqwR6Ha570dixJ4tmli70yQphzrlX6lJoMJ5y2UPMfC+W2SDn2Skk
	 5UT1ilhKWWp/zfl241HWTJkFiGnmYU9N8jljlcjqf0TIE8nMZkXEFHoQvkQRYVf7CQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198160;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gsK8/dZw9QUoJyEt3ULExQZ9fof1doakw3TyRykSoZg=;
	b=aOJuUu7tIGdOoBQabctkO1ydjPkxio6WywB6pz3KXbVUfqr8pYh9wfLGZN+guTfCVxn9
	 oPjX52CyTdhuToQPsoAuOZYTowNw1dFjbcFdqiENp8NrmaYlAWDLnqwvkLZRrM4nS+LEa
	 +BjZ8D+9qkFOYRgPKa2QllmqyghNQBbgPe1VOH6raTIpAz0zJWUVCpGWhr8lPpoqqUf5W
	 ykAuJVWzCSIy9io3qv48u1EGzfb2r30a8SK4MeeP3Nzft9Q9ThuFYTcf1cSh8YV34xLNb
	 4gbCBLbtYSNGtRbg/36w0fZVpfRguAatJqF597xPbofIhBUvLs5oiShxbLoliDXS4zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qeqX59Ml;
	arc=none smtp.remote-ip=91.218.175.158
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D1606A321
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:35:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 827D1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qeqX59Ml
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vEuc0L6KiHMXKPufKyBruOEI+Llu990u2CSIR74swUA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793198157; v=1; x=1793802957;
 b=qeqX59Ml5K4S/Sl4NtgfhSoXMvOdBgeVDqDVC7kr/mXIwzSJfW2eWJ8liFgIVmkpiHxYOP2Q
 xYoS5Klmem/B1ob4IypJeNYZr9tLlEzdVCpdrcHnh0CVLZmAChtqN10boLkiDRh9Hr5LqN0q4o9
 JxfAE46JdowSDFvsqoPr9JK0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e3e6b4354e7799b4;
	Wed, 28 Oct 2026 14:35:56 +0000
X-Mizu-Trace-ID: e3e6b4354e7799b4
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [PATCH 1/5] blk-iocost: move shared definitions to blk-iocost.h
Date: Wed, 28 Oct 2026 22:35:30 +0800
Message-ID: <20261028143534.135968-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The BPF cost model code to be added in the following patch needs the
ioc/ioc_gq definitions and the queue accessors which are private to
blk-iocost.c.  Move the enums, the structs and the accessors into a
private blk-iocost.h so that everything can go where it belongs.
blkcg_policy_iocost becomes an extern declaration in the header so
that the inline accessors can be used from both translation units.

No functional change intended.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 MAINTAINERS        |   1 +
 block/blk-iocost.c | 415 +-----------------------------------------
 block/blk-iocost.h | 436 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 439 insertions(+), 413 deletions(-)
 create mode 100644 block/blk-iocost.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 365bec8eb7fb..b3b421ee262e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6827,6 +6827,7 @@ F:	Documentation/admin-guide/cgroup-v1/blkio-controller.rst
 F:	block/bfq-cgroup.c
 F:	block/blk-cgroup.c
 F:	block/blk-iocost.c
+F:	block/blk-iocost.h
 F:	block/blk-iolatency.c
 F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a81488c755ca..9b610734871f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -184,6 +184,7 @@
 #include "blk-stat.h"
 #include "blk-wbt.h"
 #include "blk-cgroup.h"
+#include "blk-iocost.h"
 
 #ifdef CONFIG_TRACEPOINTS
 
@@ -209,374 +210,6 @@ static char trace_iocg_path[TRACE_IOCG_PATH_LEN];
 #define TRACE_IOCG_PATH(type, iocg, ...)	do { } while (0)
 #endif	/* CONFIG_TRACE_POINTS */
 
-enum {
-	MILLION			= 1000000,
-
-	/* timer period is calculated from latency requirements, bound it */
-	MIN_PERIOD		= USEC_PER_MSEC,
-	MAX_PERIOD		= USEC_PER_SEC,
-
-	/*
-	 * iocg->vtime is targeted at 50% behind the device vtime, which
-	 * serves as its IO credit buffer.  Surplus weight adjustment is
-	 * immediately canceled if the vtime margin runs below 10%.
-	 */
-	MARGIN_MIN_PCT		= 10,
-	MARGIN_LOW_PCT		= 20,
-	MARGIN_TARGET_PCT	= 50,
-
-	INUSE_ADJ_STEP_PCT	= 25,
-
-	/* Have some play in timer operations */
-	TIMER_SLACK_PCT		= 1,
-
-	/* 1/64k is granular enough and can easily be handled w/ u32 */
-	WEIGHT_ONE		= 1 << 16,
-};
-
-enum {
-	/*
-	 * As vtime is used to calculate the cost of each IO, it needs to
-	 * be fairly high precision.  For example, it should be able to
-	 * represent the cost of a single page worth of discard with
-	 * suffificient accuracy.  At the same time, it should be able to
-	 * represent reasonably long enough durations to be useful and
-	 * convenient during operation.
-	 *
-	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
-	 * granularity and days of wrap-around time even at extreme vrates.
-	 */
-	VTIME_PER_SEC_SHIFT	= 37,
-	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
-	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
-	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
-
-	/* bound vrate adjustments within two orders of magnitude */
-	VRATE_MIN_PPM		= 10000,	/* 1% */
-	VRATE_MAX_PPM		= 100000000,	/* 10000% */
-
-	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
-	VRATE_CLAMP_ADJ_PCT	= 4,
-
-	/* switch iff the conditions are met for longer than this */
-	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
-};
-
-enum {
-	/* if IOs end up waiting for requests, issue less */
-	RQ_WAIT_BUSY_PCT	= 5,
-
-	/* unbusy hysterisis */
-	UNBUSY_THR_PCT		= 75,
-
-	/*
-	 * The effect of delay is indirect and non-linear and a huge amount of
-	 * future debt can accumulate abruptly while unthrottled. Linearly scale
-	 * up delay as debt is going up and then let it decay exponentially.
-	 * This gives us quick ramp ups while delay is accumulating and long
-	 * tails which can help reducing the frequency of debt explosions on
-	 * unthrottle. The parameters are experimentally determined.
-	 *
-	 * The delay mechanism provides adequate protection and behavior in many
-	 * cases. However, this is far from ideal and falls shorts on both
-	 * fronts. The debtors are often throttled too harshly costing a
-	 * significant level of fairness and possibly total work while the
-	 * protection against their impacts on the system can be choppy and
-	 * unreliable.
-	 *
-	 * The shortcoming primarily stems from the fact that, unlike for page
-	 * cache, the kernel doesn't have well-defined back-pressure propagation
-	 * mechanism and policies for anonymous memory. Fully addressing this
-	 * issue will likely require substantial improvements in the area.
-	 */
-	MIN_DELAY_THR_PCT	= 500,
-	MAX_DELAY_THR_PCT	= 25000,
-	MIN_DELAY		= 250,
-	MAX_DELAY		= 250 * USEC_PER_MSEC,
-
-	/* halve debts if avg usage over 100ms is under 50% */
-	DFGV_USAGE_PCT		= 50,
-	DFGV_PERIOD		= 100 * USEC_PER_MSEC,
-
-	/* don't let cmds which take a very long time pin lagging for too long */
-	MAX_LAGGING_PERIODS	= 10,
-
-	/*
-	 * Count IO size in 4k pages.  The 12bit shift helps keeping
-	 * size-proportional components of cost calculation in closer
-	 * numbers of digits to per-IO cost components.
-	 */
-	IOC_PAGE_SHIFT		= 12,
-	IOC_PAGE_SIZE		= 1 << IOC_PAGE_SHIFT,
-	IOC_SECT_TO_PAGE_SHIFT	= IOC_PAGE_SHIFT - SECTOR_SHIFT,
-
-	/* if apart further than 16M, consider randio for linear model */
-	LCOEF_RANDIO_PAGES	= 4096,
-};
-
-enum ioc_running {
-	IOC_IDLE,
-	IOC_RUNNING,
-	IOC_STOP,
-};
-
-/* io.cost.qos controls including per-dev enable of the whole controller */
-enum {
-	QOS_ENABLE,
-	QOS_CTRL,
-	NR_QOS_CTRL_PARAMS,
-};
-
-/* io.cost.qos params */
-enum {
-	QOS_RPPM,
-	QOS_RLAT,
-	QOS_WPPM,
-	QOS_WLAT,
-	QOS_MIN,
-	QOS_MAX,
-	NR_QOS_PARAMS,
-};
-
-/* io.cost.model controls */
-enum {
-	COST_CTRL,
-	COST_MODEL,
-	NR_COST_CTRL_PARAMS,
-};
-
-/* builtin linear cost model coefficients */
-enum {
-	I_LCOEF_RBPS,
-	I_LCOEF_RSEQIOPS,
-	I_LCOEF_RRANDIOPS,
-	I_LCOEF_WBPS,
-	I_LCOEF_WSEQIOPS,
-	I_LCOEF_WRANDIOPS,
-	I_LCOEF_FLUSHIOPS,
-	NR_I_LCOEFS,
-};
-
-enum {
-	LCOEF_RPAGE,
-	LCOEF_RSEQIO,
-	LCOEF_RRANDIO,
-	LCOEF_WPAGE,
-	LCOEF_WSEQIO,
-	LCOEF_WRANDIO,
-	LCOEF_FLUSH,
-	NR_LCOEFS,
-};
-
-enum {
-	AUTOP_INVALID,
-	AUTOP_HDD,
-	AUTOP_SSD_QD1,
-	AUTOP_SSD_DFL,
-	AUTOP_SSD_FAST,
-};
-
-struct ioc_params {
-	u32				qos[NR_QOS_PARAMS];
-	u64				i_lcoefs[NR_I_LCOEFS];
-	u64				lcoefs[NR_LCOEFS];
-	u32				too_fast_vrate_pct;
-	u32				too_slow_vrate_pct;
-};
-
-struct ioc_margins {
-	s64				min;
-	s64				low;
-	s64				target;
-};
-
-struct ioc_missed {
-	local_t				nr_met;
-	local_t				nr_missed;
-	u32				last_met;
-	u32				last_missed;
-};
-
-struct ioc_pcpu_stat {
-	struct ioc_missed		missed[2];
-
-	local64_t			rq_wait_ns;
-	u64				last_rq_wait_ns;
-};
-
-/* per device */
-struct ioc {
-	struct rq_qos			rqos;
-
-	bool				enabled;
-
-	struct ioc_params		params;
-	struct ioc_margins		margins;
-	u32				period_us;
-	u32				timer_slack_ns;
-	u64				vrate_min;
-	u64				vrate_max;
-
-	spinlock_t			lock;
-	struct timer_list		timer;
-	struct list_head		active_iocgs;	/* active cgroups */
-	struct ioc_pcpu_stat __percpu	*pcpu_stat;
-
-	enum ioc_running		running;
-	atomic64_t			vtime_rate;
-	u64				vtime_base_rate;
-	s64				vtime_err;
-
-	seqcount_spinlock_t		period_seqcount;
-	u64				period_at;	/* wallclock starttime */
-	u64				period_at_vtime; /* vtime starttime */
-
-	atomic64_t			cur_period;	/* inc'd each period */
-	int				busy_level;	/* saturation history */
-
-	bool				weights_updated;
-	atomic_t			hweight_gen;	/* for lazy hweights */
-
-	/* debt forgivness */
-	u64				dfgv_period_at;
-	u64				dfgv_period_rem;
-	u64				dfgv_usage_us_sum;
-
-	u64				autop_too_fast_at;
-	u64				autop_too_slow_at;
-	int				autop_idx;
-	bool				user_qos_params:1;
-	bool				user_cost_model:1;
-};
-
-struct iocg_pcpu_stat {
-	local64_t			abs_vusage;
-};
-
-struct iocg_stat {
-	u64				usage_us;
-	u64				wait_us;
-	u64				indebt_us;
-	u64				indelay_us;
-};
-
-/* per device-cgroup pair */
-struct ioc_gq {
-	struct blkg_policy_data		pd;
-	struct ioc			*ioc;
-
-	/*
-	 * A iocg can get its weight from two sources - an explicit
-	 * per-device-cgroup configuration or the default weight of the
-	 * cgroup.  `cfg_weight` is the explicit per-device-cgroup
-	 * configuration.  `weight` is the effective considering both
-	 * sources.
-	 *
-	 * When an idle cgroup becomes active its `active` goes from 0 to
-	 * `weight`.  `inuse` is the surplus adjusted active weight.
-	 * `active` and `inuse` are used to calculate `hweight_active` and
-	 * `hweight_inuse`.
-	 *
-	 * `last_inuse` remembers `inuse` while an iocg is idle to persist
-	 * surplus adjustments.
-	 *
-	 * `inuse` may be adjusted dynamically during period. `saved_*` are used
-	 * to determine and track adjustments.
-	 */
-	u32				cfg_weight;
-	u32				weight;
-	u32				active;
-	u32				inuse;
-
-	u32				last_inuse;
-	s64				saved_margin;
-
-	sector_t			cursor;		/* to detect randio */
-
-	/*
-	 * `vtime` is this iocg's vtime cursor which progresses as IOs are
-	 * issued.  If lagging behind device vtime, the delta represents
-	 * the currently available IO budget.  If running ahead, the
-	 * overage.
-	 *
-	 * `vtime_done` is the same but progressed on completion rather
-	 * than issue.  The delta behind `vtime` represents the cost of
-	 * currently in-flight IOs.
-	 */
-	atomic64_t			vtime;
-	atomic64_t			done_vtime;
-	u64				abs_vdebt;
-
-	/* current delay in effect and when it started */
-	u64				delay;
-	u64				delay_at;
-
-	/*
-	 * The period this iocg was last active in.  Used for deactivation
-	 * and invalidating `vtime`.
-	 */
-	atomic64_t			active_period;
-	struct list_head		active_list;
-
-	/* see __propagate_weights() and current_hweight() for details */
-	u64				child_active_sum;
-	u64				child_inuse_sum;
-	u64				child_adjusted_sum;
-	int				hweight_gen;
-	u32				hweight_active;
-	u32				hweight_inuse;
-	u32				hweight_donating;
-	u32				hweight_after_donation;
-
-	struct list_head		walk_list;
-	struct list_head		surplus_list;
-
-	struct wait_queue_head		waitq;
-	struct hrtimer			waitq_timer;
-
-	/* timestamp at the latest activation */
-	u64				activated_at;
-
-	/* statistics */
-	struct iocg_pcpu_stat __percpu	*pcpu_stat;
-	struct iocg_stat		stat;
-	struct iocg_stat		last_stat;
-	u64				last_stat_abs_vusage;
-	u64				usage_delta_us;
-	u64				wait_since;
-	u64				indebt_since;
-	u64				indelay_since;
-
-	/* this iocg's depth in the hierarchy and ancestors including self */
-	int				level;
-	struct ioc_gq			*ancestors[];
-};
-
-/* per cgroup */
-struct ioc_cgrp {
-	struct blkcg_policy_data	cpd;
-	unsigned int			dfl_weight;
-};
-
-struct ioc_now {
-	u64				now_ns;
-	u64				now;
-	u64				vnow;
-};
-
-struct iocg_wait {
-	struct wait_queue_entry		wait;
-	struct bio			*bio;
-	u64				abs_cost;
-	bool				committed;
-};
-
-struct iocg_wake_ctx {
-	struct ioc_gq			*iocg;
-	u32				hw_inuse;
-	s64				vbudget;
-};
-
 static const struct ioc_params autop[] = {
 	[AUTOP_HDD] = {
 		.qos				= {
@@ -656,49 +289,6 @@ static const u32 vrate_adj_pct[] =
 	  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
 	  4, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 8, 8, 16 };
 
-static struct blkcg_policy blkcg_policy_iocost;
-
-/* accessors and helpers */
-static struct ioc *rqos_to_ioc(struct rq_qos *rqos)
-{
-	return container_of(rqos, struct ioc, rqos);
-}
-
-static struct ioc *q_to_ioc(struct request_queue *q)
-{
-	return rqos_to_ioc(rq_qos_id(q, RQ_QOS_COST));
-}
-
-static const char __maybe_unused *ioc_name(struct ioc *ioc)
-{
-	struct gendisk *disk = ioc->rqos.disk;
-
-	if (!disk)
-		return "<unknown>";
-	return disk->disk_name;
-}
-
-static struct ioc_gq *pd_to_iocg(struct blkg_policy_data *pd)
-{
-	return pd ? container_of(pd, struct ioc_gq, pd) : NULL;
-}
-
-static struct ioc_gq *blkg_to_iocg(struct blkcg_gq *blkg)
-{
-	return pd_to_iocg(blkg_to_pd(blkg, &blkcg_policy_iocost));
-}
-
-static struct blkcg_gq *iocg_to_blkg(struct ioc_gq *iocg)
-{
-	return pd_to_blkg(&iocg->pd);
-}
-
-static struct ioc_cgrp *blkcg_to_iocc(struct blkcg *blkcg)
-{
-	return container_of(blkcg_to_cpd(blkcg, &blkcg_policy_iocost),
-			    struct ioc_cgrp, cpd);
-}
-
 /*
  * Scale @abs_cost to the inverse of @hw_inuse.  The lower the hierarchical
  * weight, the more expensive each IO.  Must round up.
@@ -3150,7 +2740,6 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 	return 0;
 }
 
-
 static int ioc_weight_show(struct seq_file *sf, void *v)
 {
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
@@ -3616,7 +3205,7 @@ static struct cftype ioc_files[] = {
 	{}
 };
 
-static struct blkcg_policy blkcg_policy_iocost = {
+struct blkcg_policy blkcg_policy_iocost = {
 	.dfl_cftypes	= ioc_files,
 	.cpd_alloc_fn	= ioc_cpd_alloc,
 	.cpd_free_fn	= ioc_cpd_free,
diff --git a/block/blk-iocost.h b/block/blk-iocost.h
new file mode 100644
index 000000000000..e4e517ef6a0f
--- /dev/null
+++ b/block/blk-iocost.h
@@ -0,0 +1,436 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * blk-iocost private definitions, shared between blk-iocost.c and
+ * blk-iocost-bpf.c. Not for direct inclusion by other files.
+ */
+#ifndef _BLK_IOCOST_H
+#define _BLK_IOCOST_H
+
+#include <linux/types.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+#include "blk-cgroup.h"
+#include <linux/blk-mq.h>
+#include <linux/timer.h>
+#include <linux/hrtimer.h>
+#include <linux/seqlock.h>
+#include <linux/atomic.h>
+#include <linux/minmax.h>
+#include <linux/time64.h>
+#include <linux/wait.h>
+#include <asm/local.h>
+#include <asm/local64.h>
+#include "blk-rq-qos.h"
+
+enum {
+	MILLION			= 1000000,
+
+	/* timer period is calculated from latency requirements, bound it */
+	MIN_PERIOD		= USEC_PER_MSEC,
+	MAX_PERIOD		= USEC_PER_SEC,
+
+	/*
+	 * iocg->vtime is targeted at 50% behind the device vtime, which
+	 * serves as its IO credit buffer.  Surplus weight adjustment is
+	 * immediately canceled if the vtime margin runs below 10%.
+	 */
+	MARGIN_MIN_PCT		= 10,
+	MARGIN_LOW_PCT		= 20,
+	MARGIN_TARGET_PCT	= 50,
+
+	INUSE_ADJ_STEP_PCT	= 25,
+
+	/* Have some play in timer operations */
+	TIMER_SLACK_PCT		= 1,
+
+	/* 1/64k is granular enough and can easily be handled w/ u32 */
+	WEIGHT_ONE		= 1 << 16,
+};
+
+enum {
+	/*
+	 * As vtime is used to calculate the cost of each IO, it needs to
+	 * be fairly high precision.  For example, it should be able to
+	 * represent the cost of a single page worth of discard with
+	 * suffificient accuracy.  At the same time, it should be able to
+	 * represent reasonably long enough durations to be useful and
+	 * convenient during operation.
+	 *
+	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
+	 * granularity and days of wrap-around time even at extreme vrates.
+	 */
+	VTIME_PER_SEC_SHIFT	= 37,
+	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
+	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
+	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
+
+	/* bound vrate adjustments within two orders of magnitude */
+	VRATE_MIN_PPM		= 10000,	/* 1% */
+	VRATE_MAX_PPM		= 100000000,	/* 10000% */
+
+	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
+	VRATE_CLAMP_ADJ_PCT	= 4,
+
+	/* switch iff the conditions are met for longer than this */
+	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
+};
+
+enum {
+	/* if IOs end up waiting for requests, issue less */
+	RQ_WAIT_BUSY_PCT	= 5,
+
+	/* unbusy hysterisis */
+	UNBUSY_THR_PCT		= 75,
+
+	/*
+	 * The effect of delay is indirect and non-linear and a huge amount of
+	 * future debt can accumulate abruptly while unthrottled. Linearly scale
+	 * up delay as debt is going up and then let it decay exponentially.
+	 * This gives us quick ramp ups while delay is accumulating and long
+	 * tails which can help reducing the frequency of debt explosions on
+	 * unthrottle. The parameters are experimentally determined.
+	 *
+	 * The delay mechanism provides adequate protection and behavior in many
+	 * cases. However, this is far from ideal and falls shorts on both
+	 * fronts. The debtors are often throttled too harshly costing a
+	 * significant level of fairness and possibly total work while the
+	 * protection against their impacts on the system can be choppy and
+	 * unreliable.
+	 *
+	 * The shortcoming primarily stems from the fact that, unlike for page
+	 * cache, the kernel doesn't have well-defined back-pressure propagation
+	 * mechanism and policies for anonymous memory. Fully addressing this
+	 * issue will likely require substantial improvements in the area.
+	 */
+	MIN_DELAY_THR_PCT	= 500,
+	MAX_DELAY_THR_PCT	= 25000,
+	MIN_DELAY		= 250,
+	MAX_DELAY		= 250 * USEC_PER_MSEC,
+
+	/* halve debts if avg usage over 100ms is under 50% */
+	DFGV_USAGE_PCT		= 50,
+	DFGV_PERIOD		= 100 * USEC_PER_MSEC,
+
+	/* don't let cmds which take a very long time pin lagging for too long */
+	MAX_LAGGING_PERIODS	= 10,
+
+	/*
+	 * Count IO size in 4k pages.  The 12bit shift helps keeping
+	 * size-proportional components of cost calculation in closer
+	 * numbers of digits to per-IO cost components.
+	 */
+	IOC_PAGE_SHIFT		= 12,
+	IOC_PAGE_SIZE		= 1 << IOC_PAGE_SHIFT,
+	IOC_SECT_TO_PAGE_SHIFT	= IOC_PAGE_SHIFT - SECTOR_SHIFT,
+
+	/* if apart further than 16M, consider randio for linear model */
+	LCOEF_RANDIO_PAGES	= 4096,
+};
+
+enum ioc_running {
+	IOC_IDLE,
+	IOC_RUNNING,
+	IOC_STOP,
+};
+
+/* io.cost.qos controls including per-dev enable of the whole controller */
+enum {
+	QOS_ENABLE,
+	QOS_CTRL,
+	NR_QOS_CTRL_PARAMS,
+};
+
+/* io.cost.qos params */
+enum {
+	QOS_RPPM,
+	QOS_RLAT,
+	QOS_WPPM,
+	QOS_WLAT,
+	QOS_MIN,
+	QOS_MAX,
+	NR_QOS_PARAMS,
+};
+
+/* io.cost.model controls */
+enum {
+	COST_CTRL,
+	COST_MODEL,
+	NR_COST_CTRL_PARAMS,
+};
+
+/* builtin linear cost model coefficients */
+enum {
+	I_LCOEF_RBPS,
+	I_LCOEF_RSEQIOPS,
+	I_LCOEF_RRANDIOPS,
+	I_LCOEF_WBPS,
+	I_LCOEF_WSEQIOPS,
+	I_LCOEF_WRANDIOPS,
+	I_LCOEF_FLUSHIOPS,
+	NR_I_LCOEFS,
+};
+
+enum {
+	LCOEF_RPAGE,
+	LCOEF_RSEQIO,
+	LCOEF_RRANDIO,
+	LCOEF_WPAGE,
+	LCOEF_WSEQIO,
+	LCOEF_WRANDIO,
+	LCOEF_FLUSH,
+	NR_LCOEFS,
+};
+
+enum {
+	AUTOP_INVALID,
+	AUTOP_HDD,
+	AUTOP_SSD_QD1,
+	AUTOP_SSD_DFL,
+	AUTOP_SSD_FAST,
+};
+
+struct ioc_params {
+	u32				qos[NR_QOS_PARAMS];
+	u64				i_lcoefs[NR_I_LCOEFS];
+	u64				lcoefs[NR_LCOEFS];
+	u32				too_fast_vrate_pct;
+	u32				too_slow_vrate_pct;
+};
+
+struct ioc_margins {
+	s64				min;
+	s64				low;
+	s64				target;
+};
+
+struct ioc_missed {
+	local_t				nr_met;
+	local_t				nr_missed;
+	u32				last_met;
+	u32				last_missed;
+};
+
+struct ioc_pcpu_stat {
+	struct ioc_missed		missed[2];
+
+	local64_t			rq_wait_ns;
+	u64				last_rq_wait_ns;
+};
+
+/* per device */
+struct ioc {
+	struct rq_qos			rqos;
+
+	bool				enabled;
+
+	struct ioc_params		params;
+	struct ioc_margins		margins;
+	u32				period_us;
+	u32				timer_slack_ns;
+	u64				vrate_min;
+	u64				vrate_max;
+
+	spinlock_t			lock;
+	struct timer_list		timer;
+	struct list_head		active_iocgs;	/* active cgroups */
+	struct ioc_pcpu_stat __percpu	*pcpu_stat;
+
+	enum ioc_running		running;
+	atomic64_t			vtime_rate;
+	u64				vtime_base_rate;
+	s64				vtime_err;
+
+	seqcount_spinlock_t		period_seqcount;
+	u64				period_at;	/* wallclock starttime */
+	u64				period_at_vtime; /* vtime starttime */
+
+	atomic64_t			cur_period;	/* inc'd each period */
+	int				busy_level;	/* saturation history */
+
+	bool				weights_updated;
+	atomic_t			hweight_gen;	/* for lazy hweights */
+
+	/* debt forgivness */
+	u64				dfgv_period_at;
+	u64				dfgv_period_rem;
+	u64				dfgv_usage_us_sum;
+
+	u64				autop_too_fast_at;
+	u64				autop_too_slow_at;
+	int				autop_idx;
+	bool				user_qos_params:1;
+	bool				user_cost_model:1;
+
+};
+
+struct iocg_pcpu_stat {
+	local64_t			abs_vusage;
+};
+
+struct iocg_stat {
+	u64				usage_us;
+	u64				wait_us;
+	u64				indebt_us;
+	u64				indelay_us;
+};
+
+/* per device-cgroup pair */
+struct ioc_gq {
+	struct blkg_policy_data		pd;
+	struct ioc			*ioc;
+
+	/*
+	 * A iocg can get its weight from two sources - an explicit
+	 * per-device-cgroup configuration or the default weight of the
+	 * cgroup.  `cfg_weight` is the explicit per-device-cgroup
+	 * configuration.  `weight` is the effective considering both
+	 * sources.
+	 *
+	 * When an idle cgroup becomes active its `active` goes from 0 to
+	 * `weight`.  `inuse` is the surplus adjusted active weight.
+	 * `active` and `inuse` are used to calculate `hweight_active` and
+	 * `hweight_inuse`.
+	 *
+	 * `last_inuse` remembers `inuse` while an iocg is idle to persist
+	 * surplus adjustments.
+	 *
+	 * `inuse` may be adjusted dynamically during period. `saved_*` are used
+	 * to determine and track adjustments.
+	 */
+	u32				cfg_weight;
+	u32				weight;
+	u32				active;
+	u32				inuse;
+
+	u32				last_inuse;
+	s64				saved_margin;
+
+	sector_t			cursor;		/* to detect randio */
+
+	/*
+	 * `vtime` is this iocg's vtime cursor which progresses as IOs are
+	 * issued.  If lagging behind device vtime, the delta represents
+	 * the currently available IO budget.  If running ahead, the
+	 * overage.
+	 *
+	 * `vtime_done` is the same but progressed on completion rather
+	 * than issue.  The delta behind `vtime` represents the cost of
+	 * currently in-flight IOs.
+	 */
+	atomic64_t			vtime;
+	atomic64_t			done_vtime;
+	u64				abs_vdebt;
+
+	/* current delay in effect and when it started */
+	u64				delay;
+	u64				delay_at;
+
+	/*
+	 * The period this iocg was last active in.  Used for deactivation
+	 * and invalidating `vtime`.
+	 */
+	atomic64_t			active_period;
+	struct list_head		active_list;
+
+	/* see __propagate_weights() and current_hweight() for details */
+	u64				child_active_sum;
+	u64				child_inuse_sum;
+	u64				child_adjusted_sum;
+	int				hweight_gen;
+	u32				hweight_active;
+	u32				hweight_inuse;
+	u32				hweight_donating;
+	u32				hweight_after_donation;
+
+	struct list_head		walk_list;
+	struct list_head		surplus_list;
+
+	struct wait_queue_head		waitq;
+	struct hrtimer			waitq_timer;
+
+	/* timestamp at the latest activation */
+	u64				activated_at;
+
+	/* statistics */
+	struct iocg_pcpu_stat __percpu	*pcpu_stat;
+	struct iocg_stat		stat;
+	struct iocg_stat		last_stat;
+	u64				last_stat_abs_vusage;
+	u64				usage_delta_us;
+	u64				wait_since;
+	u64				indebt_since;
+	u64				indelay_since;
+
+	/* this iocg's depth in the hierarchy and ancestors including self */
+	int				level;
+	struct ioc_gq			*ancestors[];
+};
+
+/* per cgroup */
+struct ioc_cgrp {
+	struct blkcg_policy_data	cpd;
+	unsigned int			dfl_weight;
+};
+
+struct ioc_now {
+	u64				now_ns;
+	u64				now;
+	u64				vnow;
+};
+
+struct iocg_wait {
+	struct wait_queue_entry		wait;
+	struct bio			*bio;
+	u64				abs_cost;
+	bool				committed;
+};
+
+struct iocg_wake_ctx {
+	struct ioc_gq			*iocg;
+	u32				hw_inuse;
+	s64				vbudget;
+};
+
+extern struct blkcg_policy blkcg_policy_iocost;
+
+static inline struct ioc *rqos_to_ioc(struct rq_qos *rqos)
+{
+	return container_of(rqos, struct ioc, rqos);
+}
+
+static inline struct ioc *q_to_ioc(struct request_queue *q)
+{
+	return rqos_to_ioc(rq_qos_id(q, RQ_QOS_COST));
+}
+
+static inline const char __maybe_unused *ioc_name(struct ioc *ioc)
+{
+	struct gendisk *disk = ioc->rqos.disk;
+
+	if (!disk)
+		return "<unknown>";
+	return disk->disk_name;
+}
+
+static inline struct ioc_gq *pd_to_iocg(struct blkg_policy_data *pd)
+{
+	return pd ? container_of(pd, struct ioc_gq, pd) : NULL;
+}
+
+static inline struct ioc_gq *blkg_to_iocg(struct blkcg_gq *blkg)
+{
+	return pd_to_iocg(blkg_to_pd(blkg, &blkcg_policy_iocost));
+}
+
+static inline struct blkcg_gq *iocg_to_blkg(struct ioc_gq *iocg)
+{
+	return pd_to_blkg(&iocg->pd);
+}
+
+static inline struct ioc_cgrp *blkcg_to_iocc(struct blkcg *blkcg)
+{
+	return container_of(blkcg_to_cpd(blkcg, &blkcg_policy_iocost),
+			    struct ioc_cgrp, cpd);
+}
+
+#endif	/* _BLK_IOCOST_H */
-- 
2.43.0

