Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B90485945
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 05:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710657; cv=none; b=r7t692oQx5Kdb4O2mqWJyc7WiuYeOJKesrkWuhqYCCkMw5Mf9mwk5spK429hEsWAfyG5AKxBkxVdSc2Yk6iHRF0yhpb5Fz961cF+YYZcOwyzJx7fcOrc+TUujnENh6oc3JRhYXZEifmiJYMNVRbSAy4LiDkyKK1rb8ZF8pDSbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710657; c=relaxed/simple;
	bh=540cxTg5uDW77sA6XWjeiYlrh41jTEnl7CqpEmnjPE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE3woRZUvrM9tmtnGZOE0LXr9XmsoaUuqJhRFX4Ka0YCKLhqNRUO1lLpjr+NVI7jGpIplW8nvTEcuLzmPUv/Wons/Xs4tHQQ9iOsz8s/dfK/+3ohz3O1OaiO6y8fxIseQ8fz6sJF5NcgfQWBa0/9OPE31Nvevp0/69ZMYLmejNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CuWFIohJ; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CuWFIohJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=540cxTg5uDW77sA6XWjeiYlrh41jTEnl7CqpEmnjPE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789710649; v=1; x=1790315449;
 b=CuWFIohJhBqDiqWliYaqGcXq/qrhRdi/69jPdab26umkT8TF5KwPlnlHEVkcE5Bm77tnQ5nW
 lgxC2EOH7FUjWc1ZW5B2mtOVLg86RC843vTMeg3ITHXAVOhKYsZ4V8fODNFfA65ClzZgFCMJwUP
 dUY3oX9FAKG11kGAtZReF+7k=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 05ce3288277777a3;
	Fri, 18 Sep 2026 05:50:49 +0000
X-Mizu-Trace-ID: 05ce3288277777a3
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
Subject: [RFC PATCH v6 5/5] docs: cgroup-v2: document io.cost model=<name> binding
Date: Fri, 18 Sep 2026 13:50:01 +0800
Message-ID: <20260918055001.1273840-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918055001.1273840-1-cui.tao@linux.dev>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
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
index 8d2603751c51a..d9d82559e2bc6 100644
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

