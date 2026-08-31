Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1D3A3826;
	Mon, 31 Aug 2026 08:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165757; cv=none; b=Q0blaX8s7YPBuyYNxrJKq9aIF/dUiFbZ6BdgEa9WjYZqC9AO9rV451AqNJtQ991QuA4m4f5wSA03jfJjmmrWWM2TtsI1tR2QAUQutwAfRUw7gMlfVZ/oZNWmj2nnwx7TkrrugPElHIddXNga3cIbfSHofor7qd4RxXIrN4WIKxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165757; c=relaxed/simple;
	bh=AnnLzZQASW3ffm7HTAuT/jmzPEia7UpYkcE3pF7Rkko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inkogKL0nLhIZgKu4Ja5cMCeId5CP/gdl1h7Cah7AlDPXGfZ3LN1kxaQEeuYBnvhJWb0ny+JWywjn1YBGAaY8k3X9GYbvSWZq6oUkKQlXJhNPeou1i2z5d5c915xsV2QDn8HMMhSdpEP1FMs98TTc2Rxf2ra4zUk5D0OCXqXje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AP2Fjn92; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AP2Fjn92"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788165755; x=1819701755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnnLzZQASW3ffm7HTAuT/jmzPEia7UpYkcE3pF7Rkko=;
  b=AP2Fjn9204qJQTWumq4kgtdS4J4hWjhd6kBBKEHZHV+kyc/IoxVgBPZu
   KxfFxlSlFRGMdp2VOh1NRTtG+Ay9JpU9QrbZlLrvFcSAQ2mBoJxn096mZ
   RW8HXl6XKzRj/U74+K2onId2yrAJLURZOtNKpy5Z56t5/s+do9vyMiVkS
   GwVZfLAgsCuwU3jhmb9bsMshGFppq3VG2w8bBH5avTqZmKIg1j2BkjLuz
   Ta9JxQjvH7vF52RxFxzR+hef8nvqSV5WtVKCbX2qBty0N4tWcDv5FR3Cv
   FKEJJVm//k6McKzfF90TZVz6tMXHBn2NaJLhxl8hPds9eDhuREf9QdUUz
   A==;
X-CSE-ConnectionGUID: 3hgIHp6CT3OixxAA48OpTg==
X-CSE-MsgGUID: ts7UQ/aeS/CxK3zuZ1ujpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88420960"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="88420960"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:43 -0700
X-CSE-ConnectionGUID: G0af2RCzRaqI7TbIqJ/Gmg==
X-CSE-MsgGUID: +StTUGGuSV+FSzs8rhOhVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="269326210"
Received: from junjie-desk-dev.bj.intel.com (HELO junjie-desk-dev.tail2c02c1.ts.net) ([10.238.152.71])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 01:41:37 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mhocko@suse.com,
	muchun.song@linux.dev,
	netdev@vger.kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	hdanton@sina.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	vinicius.gomes@intel.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in exit_to_user_mode_loop
Date: Mon, 31 Aug 2026 16:41:31 +0800
Message-ID: <20260831084131.410457-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
References: <6887ebf4.a00a0220.b12ec.00ae.GAE@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git a8455260b2e9c024d1872ac1c094793d55a7e537

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 39ac5b97aa3a..901dfd2484e1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -83,6 +83,10 @@ struct sched_gate_list {
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
+	/* min(cycle_time, sum of intervals): the software schedule restarts
+	 * the list after the last entry even when cycle_time is not up yet.
+	 */
+	s64 period;
 };
 
 struct taprio_sched {
@@ -871,12 +875,13 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 }
 
 static bool should_restart_cycle(const struct sched_gate_list *oper,
-				 const struct sched_entry *entry)
+				 const struct sched_entry *entry,
+				 ktime_t end_time)
 {
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
+	if (ktime_compare(end_time, oper->cycle_end_time) == 0)
 		return true;
 
 	return false;
@@ -925,8 +930,9 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
-	int tc;
+	ktime_t end_time, next_start, now;
+	int budget, tc;
+	s64 behind;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -952,23 +958,49 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 		goto first_run;
 	}
 
-	if (should_restart_cycle(oper, entry)) {
-		next = list_first_entry(&oper->entries, struct sched_entry,
-					list);
-		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
-						    oper->cycle_time);
-	} else {
-		next = list_next_entry(entry, list);
+	now = hrtimer_cb_get_time(timer);
+	end_time = entry->end_time;
+	behind = ktime_sub(now, end_time);
+
+	/* Behind, e.g. delayed timer or stepped clock: skip whole periods
+	 * arithmetically and walk at most one more to the entry covering
+	 * now, instead of replaying the backlog one expiry at a time. The
+	 * cap bounds the walk; a leftover is picked up by the next expiry.
+	 */
+	if (unlikely(behind >= oper->period)) {
+		s64 jump = div64_s64(behind, oper->period) * oper->period;
+
+		end_time = ktime_add_ns(end_time, jump);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time, jump);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
-	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+	budget = 2 * oper->num_entries;
+	do {
+		if (should_restart_cycle(oper, entry, end_time)) {
+			next = list_first_entry(&oper->entries,
+						struct sched_entry, list);
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    oper->period);
+		} else {
+			next = list_next_entry(entry, list);
+		}
+
+		next_start = end_time;
+		end_time = ktime_add_ns(next_start, next->interval);
+		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
+		entry = next;
+	} while (unlikely(ktime_compare(end_time, now) <= 0) && budget--);
 
+	/* next can be the entry already published as q->current_entry (a
+	 * single-entry schedule, or a catch-up of whole periods), so the
+	 * close times and budgets below are rewritten in place while
+	 * taprio_dequeue_from_txq() may be reading them.
+	 */
 	for (tc = 0; tc < num_tc; tc++) {
 		if (next->gate_duration[tc] == oper->cycle_time)
 			next->gate_close_time[tc] = KTIME_MAX;
 		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
+			next->gate_close_time[tc] = ktime_add_ns(next_start,
 								 next->gate_duration[tc]);
 	}
 
@@ -1130,6 +1162,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
+	struct sched_entry *entry;
+	ktime_t cycle = 0;
 	int err = 0;
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
@@ -1152,13 +1186,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 	if (err < 0)
 		return err;
 
-	if (!new->cycle_time) {
-		struct sched_entry *entry;
-		ktime_t cycle = 0;
-
-		list_for_each_entry(entry, &new->entries, list)
-			cycle = ktime_add_ns(cycle, entry->interval);
+	list_for_each_entry(entry, &new->entries, list)
+		cycle = ktime_add_ns(cycle, entry->interval);
 
+	if (!new->cycle_time) {
 		if (cycle < 0 || cycle > INT_MAX) {
 			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
 			return -EINVAL;
@@ -1172,6 +1203,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 		return -EINVAL;
 	}
 
+	new->period = min(new->cycle_time, cycle);
 	taprio_calculate_gate_durations(q, new);
 
 	return 0;
