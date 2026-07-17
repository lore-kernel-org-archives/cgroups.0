Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2350733A718
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 06:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784268179; cv=none; b=KlCMYJRs5NJJKfQ1iHy2vVgIBLDcgCyuFWwsUB6yMdk/VSDhTxOXKUpFmiv2KfHlGHDS8nGeVQcqDcNqKmIOypqGHWU4LTFQ24xPw1wXnKpKA9bVUjiFku2ob4eWGm54qs63gpioLSbl/fH5fS4RrHgJ4+kiYzBM/RXZWXk3few=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784268179; c=relaxed/simple;
	bh=4bc6S5C6yC6MEtBr0JmUnzulBhHWRvVu/Fu3+OIZPb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwqU5BYWJpvgfZJW9WgpYQWznnGzbyGKQv7JJwQO2LnmAOvplkiw7La5iL8j1KYpOZBxDc65g6cKbDdKzxnNKOkdVp4mseCbQ1wBmUMI6mauON6qDMXG0jejEi8/69GwLutT8ZG7Ywc6ldNpEuocgShLVMZ8nY6UDKbxi7FJZro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k0/nk8Uy; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k0/nk8Uy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784268175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U9iSZ3eirkta0qM7JPu7dHM5Fy1BbTSQrFYTTGjqWiY=;
	b=k0/nk8UyKYLE6EtQ4qE8EHhPNMqHOi5EOYyGBG76Kf0yDilXIOSUC+oijrtCaoDwqUaXdG
	YkK0r+S4+zTWYTqX/LG70z3CUqBArFRYyIYfDAjCa/2OtvNpvQJ3O5zo1qspSNaCJPx1XX
	pKo0qF9sNHNDIZUVaP7Und30BpE7HTA=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v2 1/2] Docs/admin-guide/cgroup-v2: document io.latency rotational vs non-rotational behavior
Date: Fri, 17 Jul 2026 14:02:24 +0800
Message-ID: <20260717060225.2019764-2-cui.tao@linux.dev>
In-Reply-To: <20260717060225.2019764-1-cui.tao@linux.dev>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 49 ++++++++++++++++++-------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0df15a672cf3..4386365ef180 100644
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
@@ -2324,19 +2329,35 @@ IO Latency Interface Files
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
+		current window whose latency exceeded the target.
+
+	  total
+		(Non-rotational devices only.)  The total number of IOs
+		accounted in the current window.  A group is considered to be
+		missing its target once missed reaches 10% of total.
 
 IO Priority
 ~~~~~~~~~~~
-- 
2.43.0

