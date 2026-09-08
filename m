Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A449EC5B
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861813; cv=none; b=KIr296VGG0Bsi7ojO01oG/6wv1nB0Q86pnmHDf5nquAd8mtc0O8MuEMmwqPVCn0YmuLfVlU+MhVMiDOJiRhhrCpNwzLKuwWvO+TNIudb777fjH/b1E9FiQ0GxTFR6DohC4gI9qGApUKqpUjmd5/VECpZnpQyGQBy/khdicpxL3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861813; c=relaxed/simple;
	bh=k5Y//fCuyAhbYOt7/YCpHnHqsrzwl/eKE/03WaIacHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un0BMaY1L1fXLLzPc4pBFpKz0cxKuRnw99V0B11SfLxUaeYAL5iqycKhf3GeJXop2r4Whmu5iZOhAu2J6NieQ71mP+nI2Z9YVgVr3S6dQ2dV7vwDbrpGG+T/fROXUV4otuUhABfeIEjdmrZ7uUP7uta4CAW+rQwDSM012GN2WIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DRyqWAQ/; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DRyqWAQ/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=k5Y//fCuyAhbYOt7/YCpHnHqsrzwl/eKE/03WaIacHw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861809; v=1; x=1789466609;
 b=DRyqWAQ/01uOxFLLVdU0Q3kcUtbK0o8j+ZZ1WjXK5DF86otKxmQUkRvVMLzifVzmt2JKbjjO
 ciXGVelUME4KVM030fOrQu3qbJf9d9gzURgAl79PxQ6Anq8nPoNcy/5EV9ly3+KCad116vNirWm
 4V4jYvLi1f4MwIBvydRRrR/Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d758f2e248c73fe8;
	Tue, 08 Sep 2026 10:03:29 +0000
X-Mizu-Trace-ID: d758f2e248c73fe8
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
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 8/8] docs: cgroup-v2: document io.cost ctrl=bpf option
Date: Tue,  8 Sep 2026 18:01:43 +0800
Message-ID: <20260908100143.47598-9-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Document the "bpf" value of the ctrl key of io.cost.model and the
iocost_model_ops struct_ops it selects, in the io.cost.model section
of the cgroup v2 documentation: the registration precondition and
single-instance limit, the scalar arguments, the vtime clamp and the
delegation-to-builtin semantics of a zero return value.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51a..54b0574ce586c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2115,10 +2115,24 @@ IO Interface Files
 	are defined.
 
 	  =====		================================
-	  ctrl		"auto" or "user"
+	  ctrl		"auto", "user" or "bpf"
 	  model		The cost model in use - "linear"
 	  =====		================================
 
+	When "ctrl" is "bpf" (only available when
+	CONFIG_BLK_CGROUP_IOCOST_BPF is enabled), cost calculation for
+	the device is dispatched to the BPF program registered against
+	the iocost_model_ops struct_ops.  Writing "bpf" fails with -EINVAL
+	until such a program is registered, and at most one program can
+	be registered system-wide.  The model is called with scalar
+	arguments (operation, size, sector, cgroup cursor, css id of the
+	issuing cgroup, flags; see include/linux/blk-iocost.h for their
+	meaning) and returns a cost in vtime units, clamped by the kernel
+	to 1 second of device time per IO.  A return value of 0 delegates
+	the IO back to the builtin linear formula, so a model which only
+	handles some IO types cannot make the rest free.  Devices which
+	don't opt in keep the builtin linear model unchanged.
+
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
 	parameters are written to, "ctrl" become "user" and the
-- 
2.43.0

