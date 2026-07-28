Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6740F8F8
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 09:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232662; cv=none; b=nTlqrkxKI1y9pe7uyS/hpmZpEtlJW8j4/2Nq2MUFWetvNv7S0qIujAAK+ohmM7PG2hoBWgyqtbNYnYtZ8no9sbwl5vk343YZpEL3We6YCObGqzeyTOADLqPoCgjG7veJ4KfxQX20VfWvUDGYYAPeD8T2d+/Fb8DBDtgO0CjGSZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232662; c=relaxed/simple;
	bh=NqIa1tP6CEdR4fPrhcTsaNT80aX6rwW5GkGWrsGVdEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MFzktcNRfnS2ezpTc3ZBpXagA1GpQ37PrtQWc4SjmQMqnNvqdOrwrt+ZFiuKB30T6qlEbUPNSOjju8hmjDTiB9SnpDkyKlHbLbkDpWdr1qfn0QMgAxGxFbG0BFIWkNR4g6+ph2a7RZu+UEu+24tgxD7VkGa8O/8iZpOoOig9oew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MU65/pcE; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MU65/pcE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785232648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tba99Tt7UimiNNcYdebhja5mXw6zYmOPg0uLJptQ66w=;
	b=MU65/pcE9IJvcg6Agn8T0mmnwktpn4zs3vzIUESJkV0dNSOK7RBL/jTwYUHEl2sBjqwGQC
	zcGgoM9bSnP879taiFtEy5bw4cntz0ee1wCGaoXIuFRdBDoP1iX26RKqwM2VfZZUQznI72
	ffbHLjKhkA5/ChmueJKLiHhmtZJ1a80=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v4] Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior
Date: Tue, 28 Jul 2026 17:57:07 +0800
Message-ID: <20260728095707.2398498-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

io.latency is documented only in terms of average latency and the avg_lat
stat, which matches rotational devices.  On non-rotational devices a group
misses its target once enough of the IOs in the window individually exceed
it, and io.stat reports missed/total rather than avg_lat/win.

Describe both cases: how a miss is detected, note that the avg_lat tuning
guidance is rotational-only, and update the io.stat field list (mark
avg_lat/win as rotational-only, document missed/total).

Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---

Changes in v4:
- Also drop the exact threshold value from the intro paragraph, so the
  documentation does not bind to it anywhere.  This fully matches Michal's
  "would not bind to the exact value in the docs"; v3 had only removed it
  from the field list.  Michal's Acked-by is retained.

Changes in v3:
- Move the missing-target note to the missed field and avoid naming the
  exact threshold there (Michal Koutný).
- Add Acked-by from Michal Koutný.

V3: https://lore.kernel.org/r/20260718020759.2272551-1-cui.tao@linux.dev
---
 Documentation/admin-guide/cgroup-v2.rst | 50 ++++++++++++++++++-------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6cd7623..04457f6 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2260,9 +2260,12 @@ IO Latency
 ~~~~~~~~~~
 
 This is a cgroup v2 controller for IO workload protection.  You provide a group
-with a latency target, and if the average latency exceeds that target the
-controller will throttle any peers that have a lower latency target than the
-protected workload.
+with a latency target, and if the group misses its target the controller will
+throttle any peers that have a lower latency target than the protected
+workload.  How a miss is detected depends on the device: on rotational devices
+the average latency over the window must exceed the target, while on
+non-rotational devices a miss is counted once enough of the IOs in the window
+individually exceed the target.
 
 The limits are only applied at the peer level in the hierarchy.  This means that
 in the diagram below, only groups A, B, and C will influence each other, and
@@ -2279,10 +2282,12 @@ So the ideal way to configure this is to set io.latency in groups A, B, and C.
 Generally you do not want to set a value lower than the latency your device
 supports.  Experiment to find the value that works best for your workload.
 Start at higher than the expected latency for your device and, with
-blkcg_debug_stats enabled, watch the avg_lat value in io.stat for your
-workload group to get an idea of the latency you see during normal operation.
-Use the avg_lat value as a basis for your real setting, setting at 10-15%
-higher than the value in io.stat.
+blkcg_debug_stats enabled, observe io.stat for your workload group to get an
+idea of the latency you see during normal operation.  On rotational devices,
+use the avg_lat value as a basis for your real setting, setting it 10-15%
+higher.  On non-rotational devices io.stat reports no average latency; set
+the target based on your device and use the missed/total fields to verify it
+is being met.
 
 How IO Latency Throttling Works
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -2324,19 +2329,36 @@ IO Latency Interface Files
 	the blkcg_debug_stats module parameter is enabled (it is disabled by
 	default).
 
+	The reported latency fields depend on the device.  Rotational devices
+	report avg_lat and win; non-rotational devices report missed and total
+	instead.  missed and total are live counters for the current window and
+	may change between reads.
+
 	  depth
 		This is the current queue depth for the group.
 
 	  avg_lat
-		This is an exponential moving average with a decay rate of 1/exp
-		bound by the sampling interval.  The decay rate interval can be
-		calculated by multiplying the win value in io.stat by the
-		corresponding number of samples based on the win value.
+		(Rotational devices only.)  This is an exponential moving
+		average with a decay rate of 1/exp bound by the sampling
+		interval.  The decay rate interval can be calculated by
+		multiplying the win value in io.stat by the corresponding number
+		of samples based on the win value.
 
 	  win
-		The sampling window size in milliseconds.  This is the minimum
-		duration of time between evaluation events.  Windows only elapse
-		with IO activity.  Idle periods extend the most recent window.
+		(Rotational devices only.)  The sampling window size in
+		milliseconds.  This is the minimum duration of time between
+		evaluation events.  Windows only elapse with IO activity.  Idle
+		periods extend the most recent window.
+
+	  missed
+		(Non-rotational devices only.)  The number of IOs in the
+		current window whose latency exceeded the target.  A group is
+		considered to be missing its target once missed reaches a
+		certain ratio of total.
+
+	  total
+		(Non-rotational devices only.)  The total number of IOs
+		accounted in the current window.
 
 IO Priority
 ~~~~~~~~~~~
-- 
2.43.0

