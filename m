Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967889;
	b=NIF0ypIBmLJfkPWvJnTvEycn4hA8WaNT8NobQ5BotYM73Bgb7bvnSHGhthj9v3JfLMxX
	 mkUij0gU+ZUyVocawZz56DKgF7wW+CecztExPgr1XrrYAg4eIhDR03VPw8R2kRXk/T1Jr
	 YMuPsM8zvleax8Kd5zpWs7IhtMefNKMdDvDgkrgRnUMq7/jr93QX1+rCEQXrFQRGo9Kdc
	 iwrELwq0rpKPAB34xw+asONuolMJvDCX4NgaDO4yMsRnOeNLsIq8HMFOljV0PWdUJak7z
	 C7vGCefBfOX2BTsvwMSAw+Xs31cCgtEASi0HqgLrcS4WXxNsbrDuuI9PtN725vBzs3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967889;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CZa/+auwJ53QeObgCQyye3ozLJHNV1LzGLNqsS8IqWU=;
	b=lwPx5S64aZjtuFHBIUHBa/76wBT3mA28fwxzD+ixOcfR3bCHeQWZIwk06nDDesT87CA5
	 cJytSMazVOfCvpmwhJC+K5NbAZoOobFcYMChimtzOQE3kepEV5Bb3hQ0/WCzEKVp29kpR
	 V7ciyyklmV5VchZFmHelDDsZh5isvICYqFMgbDnD1s43//631n1kcBL68i1+LZ6+g6I37
	 7ebkxj0vLEyDrrKa3etyg/4EoxTGRCRQqA19S7qlYBgdeiMjAeVXCypv33ClncU/Vd6wI
	 ALW5J65W9nMGw1MWtpekMzh8Nf44KKwEGLvnBdm5FVwaO1DiEuZZoih8YI9wpLvr1Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HTy9yykA;
	arc=none smtp.remote-ip=95.215.58.125
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A32606A329
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 12:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29A32606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HTy9yykA
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jUmHwKNqJMANYN0pI4Lsx0VheHHuZ6sYGI5Hh257CJQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793967887; v=1; x=1794572687;
 b=HTy9yykAiSjmmXAZ+fCiGVONMQibu6bLOcCow0bfn2g6rOsoNk6emsZIpwwHI6PjArEQqZ3f
 R4ZGwDSZYBevuWk6Ez5ylc8vogiXUSq5u1Fms0h6GZJHtLoasVVg1CL2nV03RUFtXB/LKhdeQrJ
 hbdKdA19pl19HL8db7IH7Dcs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c5bfabdb6db8feb0;
	Fri, 06 Nov 2026 12:24:47 +0000
X-Mizu-Trace-ID: c5bfabdb6db8feb0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	alexei.starovoitov@gmail.com
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
	ameryhung@gmail.com
Subject: [RFC PATCH v13 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Fri,  6 Nov 2026 20:23:56 +0800
Message-ID: <20261106122356.3224638-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106122356.3224638-1-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev>
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
 Documentation/admin-guide/cgroup-v2.rst | 49 +++++++++++++++++++++----
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..608ebd311b79 100644
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
@@ -2111,13 +2112,44 @@ IO Interface Files
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
+	partition's major:minor is rejected).  Attaching creates the
+	controller if needed, like
+	an io.cost.model write does, switches the device's pricing to
+	the model and populates the device's line in this file and in
+	"io.cost.qos" if it did not exist yet.  Attaching fails with
+	-EBUSY if the device already has a model attached.  It fails
+	with -EOPNOTSUPP if dev names a partition or a device without
+	a multiqueue queue, and with -ENODEV if the device has gone
+	away.  The attached model prices IOs only while the controller
+	is enabled through "io.cost.qos"; attaching does not enable it.
+	IOs issued directly by the root cgroup bypass the model's
+	per-IO pricing; the completion-time sizing of their requests
+	still uses the attached model's transfer coefficients.
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
@@ -2125,7 +2157,8 @@ IO Interface Files
 	automatic changes are disabled.
 
 	When "model" is "linear", the following model parameters are
-	defined.
+	defined.  They remain readable and writable while "model" is
+	"bpf".
 
 	  =============	========================================
 	  [r|w]bps	The maximum sequential IO throughput
-- 
2.53.0

