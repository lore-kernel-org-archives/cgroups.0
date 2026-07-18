Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F723175A88
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 02:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784340510; cv=none; b=ek88qBxzr7AMG+WoHGX7W43ZRKH7khtQqeVqqVKb12TaSwFQr5VGNWyaRI8fyp3W3mZKYvGmOQHQOmlbRmtXbeCOKYcSLQ71quqqGggVWO6aWPN6qbxqmXfOFrfiMgz38yhZEy/KfYQCZtZSixyvBof08cGQA74meZq+Ts1M2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784340510; c=relaxed/simple;
	bh=3pE+tgkIuY/Ca2sAWUVuP1GVOj7xZBUFMFASsPfnp+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gZDg10fAFAJBGpLPIZIXVLhkkP/DAEZonPqyRZVvOWY7kLZYR+2+GShDNKADrB+W9wsBqpdAYa/cx5egJ7FQWC+IUrgTGc/ZCxG1BlR6PJksYHNUtctxBdWZL0GJGQ/FqgjmG6hH+IEc1vPcaW26KeT1RhUPQ4GF2Ilb1w3nV8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PG3CCQWs; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PG3CCQWs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784340496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mLvjICcbMIr0f9MhrwqmeB/yUQgqe7bvFBAED3Mii2g=;
	b=PG3CCQWsOwLAcKNSB25/5bWHPXOe6iqKEmfpxiq9nBc7GkyH10RFSmkqeZyCECCwFDb908
	u9hbmcs9tfgDQ5JgQw6+8sADm0gLa/qy+mvAyO3yZ9mr0T2MzDCFa60ExduMrWi6ibPMRq
	RYzu0r7oCZtt6WNcEPO7je/9apCzp1E=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH v3] Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior
Date: Sat, 18 Jul 2026 10:07:59 +0800
Message-ID: <20260718020759.2272551-1-cui.tao@linux.dev>
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
misses its target when 10% or more of the IOs in the window individually
exceed it, and io.stat reports missed/total rather than avg_lat/win.

Describe both cases: how a miss is detected, note that the avg_lat tuning
guidance is rotational-only, and update the io.stat field list (mark
avg_lat/win as rotational-only, document missed/total).

Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---

Changes in v3:
- Move the missing-target note to the missed field and avoid naming the
  exact threshold there (Michal Koutný).
- Add Acked-by from Michal Koutný.

---
 Documentation/admin-guide/cgroup-v2.rst | 50 ++++++++++++++++++-------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0df15a672cf3..d60c2361feb5 100644
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
+non-rotational devices a miss is counted when 10% or more of the IOs in the
+window individually exceed the target.
 
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

