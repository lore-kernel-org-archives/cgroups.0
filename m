Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007477;
	b=q89DGpfACwAI9Kb3CKwF7/N54VB179pmgDcZQAdTI5qGBHqLtYEQtdcjA/5oKfPJ58Hv
	 soXjNljlNbIbZeteJaGjhJJ1w9KwL2H+D9K3Kb275UyNxw5Z1D+iSKkNG5rMYwB5LRPYo
	 XUnlRAN27d69p4VnCve6m9Z82PcXbv/SHawVe1EFjbiziUhFmx9yG05XmG4eUGmnAyJfC
	 SMrUBBDg47V+HJ8L2Kaz+JimBgya5MU3h8zSaUafwnkZ8NcmtCB1NJqV0/Sx+x8teNMUW
	 +pcp/5YLdqGwBLxYFZF+iua5QmrwmvtWo5fS/hCZcjaSg3k8BZqcKQiPjtOSlcFNvaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007477;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QJAC08ngDRm9W4yawdTHyboRVQ9MGN7haYElLNq+7pU=;
	b=A3ydlKe80+s/dtUGIi9pBJ2dZUpfRPsSdSjgjCbEXJe/KCWdrEiackKLF3PJ07ogX1gp
	 gg6ZNBH/tSpILO5VIC0NN0FWBD0252QRP1P+2EE+SSqoIzbtYL5tsHK+uJ5YpSRmzd4Fd
	 yf1N/zlZXnxFGg3HZ46gQuaUrmNwbCqI98htuDV+hIyTQ+e2/bDGTlfRAv3hYmTQmPPob
	 IInc1uD/HUZYwDLqKRbLcqaHPtOSwF4dzaDafFV/ZIwV36PImMcjnb7t1AuFxxaDd9f4z
	 cfSpdekRL9kFUVwheFvXTI8o0Y5toEo+c00y0z3meqf15Lvm0hb3C7ubSSC4WTse0jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WyZI6CJM;
	arc=none smtp.remote-ip=91.218.175.86
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710C2606A332
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 13:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 710C2606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WyZI6CJM
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RMpd59Gb6dpKtX3get0waM32XpfRzKJRh6E8RWM6GBM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795007474; v=1; x=1795612274;
 b=WyZI6CJMpR2JzG0xH9pWLqLOd9sD5rcrzUY3EyZSpuedZRCwAcV0ju6Cbq+bBG9I9tozVrKv
 ahN5j7O3ka+rk9/fDYa4C6TlWsyJB6WkDsha63OcVJ15xKmJ/aRTuw4ToWB/MHj+VSP+9ozXuuk
 9MbkuYctNf0NJ6cx4I3QHOjA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8bd3cc9683cdaa16;
	Wed, 18 Nov 2026 13:11:14 +0000
X-Mizu-Trace-ID: 8bd3cc9683cdaa16
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ast@kernel.org,
	alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com
Subject: [RFC PATCH v14 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Wed, 18 Nov 2026 21:10:29 +0800
Message-ID: <20261118131029.797007-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118131029.797007-1-cui.tao@linux.dev>
References: <20261118131029.797007-1-cui.tao@linux.dev>
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

Document the BPF cost model attachment in the io.cost.model section
of the cgroup v2 documentation: attaching an iocost_model_ops
struct_ops to a device by its major:minor, the model=bpf readback
while attached (ctrl keeps describing the coefficients), the builtin
model coming back on detach, and ctrl writes never selecting a model.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 55 +++++++++++++++++++++----
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..a3c402f03ae9 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2056,8 +2056,9 @@ IO Interface Files
 	currently implements "io.weight" proportional control.  Lines
 	are keyed by $MAJ:$MIN device numbers and not ordered.  The
 	line for a given device is populated on the first write for
-	the device on "io.cost.qos" or "io.cost.model".  The following
-	nested keys are defined.
+	the device on "io.cost.qos" or "io.cost.model", or when a BPF
+	cost model is attached to it.  The following nested keys are
+	defined.
 
 	  ======	=====================================
 	  enable	Weight-based control enable
@@ -2111,13 +2112,50 @@ IO Interface Files
 	implements "io.weight" proportional control.  Lines are keyed
 	by $MAJ:$MIN device numbers and not ordered.  The line for a
 	given device is populated on the first write for the device on
-	"io.cost.qos" or "io.cost.model".  The following nested keys
-	are defined.
+	"io.cost.qos" or "io.cost.model", or when a BPF cost model is
+	attached to it.  The following nested keys are defined.
 
-	  =====		================================
+	  =====		==========================================
 	  ctrl		"auto" or "user"
-	  model		The cost model in use - "linear"
-	  =====		================================
+	  model		The cost model in use - "linear" or "bpf"
+	  =====		==========================================
+
+	When BPF cost model support is available, a BPF cost model
+	can be bound to a device by attaching an
+	"iocost_model_ops" struct_ops carrying the whole disk's
+	major:minor as encoded by makedev(3) in its "dev" member (a
+	partition's major:minor is rejected).  The loader supplies
+	"dev" when the map is created and it cannot be changed
+	afterward.  Attaching creates the controller if needed, like an
+	io.cost.model write does, switches the device's pricing to the
+	model and populates the device's line in this file and in
+	"io.cost.qos" if it did not exist yet.  Attaching fails with
+	-EBUSY if the device already has a model attached, with
+	-EINVAL if the model fails its attach-time validation, with
+	-EOPNOTSUPP if dev names a partition or a device without a
+	multiqueue queue, and with -ENODEV if dev does not name an
+	existing device or if the device has gone away.  Updating the
+	link to a different model is not supported and fails with
+	-EINVAL or -EOPNOTSUPP; switching models requires detaching
+	first.  The
+	attached model prices IOs only while the controller is enabled
+	through "io.cost.qos"; attaching does not enable it.  IOs issued
+	directly by the root cgroup bypass the model's per-IO pricing;
+	the completion-time sizing of their requests still uses the
+	attached model's transfer coefficients.
+
+	While a model is attached, "model" selects between it and the
+	builtin model: "model=bpf" switches to the attached model and
+	"model=linear" switches back to the builtin model, and neither
+	detaches the struct_ops.
+
+	Detaching removes the model, after which "model=bpf"
+	fails and the device prices with the builtin model again.
+	Device removal ejects the attached model as well, while the
+	struct_ops link remains until userspace destroys it.  "ctrl"
+	accepts only "auto" and "user" and never selects a model.  It
+	keeps describing the builtin coefficients, which take effect
+	again when switched back.
 
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
@@ -2125,7 +2163,8 @@ IO Interface Files
 	automatic changes are disabled.
 
 	When "model" is "linear", the following model parameters are
-	defined.
+	defined.  They remain readable and writable while "model" is
+	"bpf".
 
 	  =============	========================================
 	  [r|w]bps	The maximum sequential IO throughput
-- 
2.53.0

