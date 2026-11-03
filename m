Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712434;
	b=TX+46hMVOW/CGwXID8fTJTUNBG5kmGcn4En5vAS3ch8b20f/dI4cJuSOnn+cJGOIKgBC
	 z7eHCIfC87SvUsG1qN2uIHFpp6gjHeTCZjP6OIzJkE0ARqvbABfB3xnNn+6+vILDW0+uj
	 DC1CbeWp5+pyWOx4MxpLWL+nSQZ9D2TG0JIS9ArYJ6+GCOxnXEctZCvmwMOdUkVlu8H2D
	 oQn+sZtHakGtj4jpWH2UQDyQpNg/feoZA01GnsejMMlGq2adnSCQp2de1cK3AAT9DL4yI
	 J4StXhbacPJmm0JcELTadaJ8W12oCLQuBVRrFwA32GZXnadAvK06VFH8SCE46DUaFMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712434;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9VAhO8KBM9mOdifI8nmOoX/2TqgeYxG3nBGm5R3+hSk=;
	b=2tmioHq4G2K1uSZLfiGa/rWhQA8T/HuW1BJWyKgcstxHkfh5648uqPaPUK/p8LmN611b
	 a1pUa7JOoowlxwzLEFD8CY9AlBzDDDfCsGwWAxrGQ7A3/8ZKmRWiwFMrAgEpAN6dv+sIL
	 vG1N4i1NOYFikm7XwyAhx2cwfSmKCJ0F4+2WHOGejZiN022azZXcv24aSOgreKRZInvxh
	 IGGJsgDqMq8umTur4LjzcH45ueQdjBzkedfl+bzJZfWv/bQATfR8ai+NRJ/OT9+0Tr3Pz
	 ap3L6DE4+axNOLkiJFov4hWDtAjFued3CjBmbqJSVJ/VgWsrh77QyqA2F1mZY8REiAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jQggFAhP;
	arc=none smtp.remote-ip=91.218.175.40
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05376085081
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 13:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B05376085081
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jQggFAhP
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dZMvqS4c+48JMUQ62nOXGEohEi1C+eqSvF1H1cvPGHA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793712431; v=1; x=1794317231;
 b=jQggFAhPNDGDne8cOo7hGsMcyDuPltvGyPW3td6U8W4asuBjI8QYBcouRdgc7uM4lIrNOcaX
 ZPX6OfGvIxwiff3hNLL9/H2vWvuCdhUDoYAZcI80mA8/Nc5Y2Ch3hNTLp48UhucYNoUklNoFRSJ
 WB/oR4IoP74z2XP3lsgcvEHk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fb2cfe47defad250;
	Tue, 03 Nov 2026 13:27:11 +0000
X-Mizu-Trace-ID: fb2cfe47defad250
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
Subject: [RFC PATCH v12 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Tue,  3 Nov 2026 21:26:13 +0800
Message-ID: <20261103132613.1952975-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103132613.1952975-1-cui.tao@linux.dev>
References: <20261103132613.1952975-1-cui.tao@linux.dev>
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
 Documentation/admin-guide/cgroup-v2.rst | 45 ++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..0965645b1286 100644
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
@@ -2111,13 +2112,40 @@ IO Interface Files
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
+	-EBUSY if the device already has a model attached.  The
+	attached model prices IOs only while the controller is
+	enabled through "io.cost.qos"; attaching does not enable it.
+	IOs issued directly by the root cgroup bypass the model.
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
@@ -2125,7 +2153,8 @@ IO Interface Files
 	automatic changes are disabled.
 
 	When "model" is "linear", the following model parameters are
-	defined.
+	defined.  They remain readable and writable while "model" is
+	"bpf".
 
 	  =============	========================================
 	  [r|w]bps	The maximum sequential IO throughput
-- 
2.53.0

