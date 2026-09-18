Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978339793C
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 03:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789701519; cv=none; b=WvxzT2Wg92k5pu473IBc4ibC4N+pauagbsx1WKk/KqzB16k26+JD4kXMe/UYqrgsmjIQifcxIvppki4LaLv/X/GGHpfWpYk7unjOFA3qPKFMxG85pxhnpZqDKNQiRkRcfLi+34FioZJU/Pn4G7MKFRdm3se5l99HYvmNt5le4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789701519; c=relaxed/simple;
	bh=3mKSiQIL6FOpAFOV5eJJfSCNGN+BvCHejhQQLpe8O1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud1zPjRaEqIMfog9VMwjDMA5tyffCpGPrY8wk6ARHwioF6QFvkO6Hw0TiQZjRhWOVl1a9d73mt6o1fBmm/QaQ27JpLSTNayAowBRIlcCDjZogpgfO8VyW4wq/9UHzHGAr62xZMDUV98w9p8SA+A0c28r0L9qI1/SbZgGgNl2XL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eQtzstkF; arc=none smtp.client-ip=91.218.175.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eQtzstkF"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3mKSiQIL6FOpAFOV5eJJfSCNGN+BvCHejhQQLpe8O1o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701515; v=1; x=1790306315;
 b=eQtzstkF6GhQhixm0/fx6CqE722y6csu+Te/Xq9FEUU3ylWDvaI/fUxg8iiJNs+4t3hirINK
 7xea419X67HuCNtZRJxG3IFiUstLTJN4uySFgke+DMFAemR2PvSSluEUla9oq7jvxoF9/u4sGWL
 xrCctwbchS1tvQ0zLB+GyYmo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 651ccbd17f0d03d4;
	Fri, 18 Sep 2026 03:18:35 +0000
X-Mizu-Trace-ID: 651ccbd17f0d03d4
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ameryhung@gmail.com
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v5 5/5] docs: cgroup-v2: document io.cost model=<name> binding
Date: Fri, 18 Sep 2026 11:17:51 +0800
Message-ID: <20260918031751.1255420-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918031751.1255420-1-cui.tao@linux.dev>
References: <20260918031751.1255420-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Document the named-model binding of io.cost.model in the
io.cost.model section of the cgroup v2 documentation: the binding
and restore syntax, the unknown-name rejection, the full-replacement
semantics of a bound model and the unregister lifetime.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51a..1cd0ecae9a940 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2115,8 +2115,10 @@ IO Interface Files
 	are defined.
 
 	  =====		================================
-	  ctrl		"auto" or "user"
+	  ctrl		"auto", "user" or "bpf"
 	  model		The cost model in use - "linear"
+			or the name of the bound
+			model
 	  =====		================================
 
 	When "ctrl" is "auto", the kernel may change all parameters
@@ -2124,6 +2126,23 @@ IO Interface Files
 	parameters are written to, "ctrl" become "user" and the
 	automatic changes are disabled.
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a bound model is
+	read back as "ctrl=bpf model=<name>", and writing "ctrl=bpf" is
+	accepted as a no-op so a saved configuration can be restored as-is.
+	"model" also accepts
+	the name of a registered iocost_model_ops BPF struct_ops model:
+	"model=<name>" binds the model to the device and the model fully
+	replaces the builtin linear pricing, for every operation including
+	flushes; "model=linear" (or "ctrl=auto/user") restores the builtin
+	model.  Writing an unknown name fails with ENOENT and nothing is
+	applied.  Unregistering a model removes its name from the
+	registry; devices already bound keep using it, and keep receiving
+	cgroup lifecycle notifications, until switched back to the builtin
+	model, and its name keeps working for writes (so a coefficient-only
+	write does not disturb the binding) until the last device unbinds.
+	See
+	include/linux/blk-iocost.h for the model interface.
+
 	When "model" is "linear", the following model parameters are
 	defined.
 
-- 
2.43.0

