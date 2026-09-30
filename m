Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4C457E7F
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 07:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754756; cv=none; b=CN8ncb+A49pD/CpSVq7OrXPkosdtGwlLnZx93WLfTFB0oUq+yTZBGDFEnpNk4gFdNnENxYHVZaCkzPwt3DJTxfgCqHHegxxL47uqxJHg8sjm7r5bIlQmjbi6fYP6enxtsq4+cTGk2CteE8VX8f158DL/YCKqC1tD7WutuTfo2wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754756; c=relaxed/simple;
	bh=8ma5wy0oJIj/chbeeAhuh0ZtFGfNhOnQTVLc6I5RlKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbodxr+5RTPqO2WwZ0W+pBew3BbfrFYgxFnMAzvylPUk87SwZWQaqZ80xSPmf32PXjlpebd5ie19sv0Sm/J3/mm5n5I5gPDi1fVD7x71p4YguvOH5RCfnIlmDahi2okUdOjuZS76j0inmq8jWc37qocmUQsW+6xDB+W+EJDkzqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hoyIe2tV; arc=none smtp.client-ip=91.218.175.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hoyIe2tV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8ma5wy0oJIj/chbeeAhuh0ZtFGfNhOnQTVLc6I5RlKQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790754752; v=1; x=1791359552;
 b=hoyIe2tVu7LbrNdOK4BCoPaXkPloBQPEyssSc7kF0Js8c9v8xA2QemWicEDl2OqDyVZGiYzZ
 RWR6Lmt3LpI/XrLGa4RsriPvM5M9TGjN5Ne1HMCH4FxBo0OL4w7Fx7tLYDjzqCMhCY7QQM/1lB1
 0t2AyW2lyN5zFhmrPQ54bIlI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7b477e88c5b0e9d9;
	Wed, 30 Sep 2026 07:52:32 +0000
X-Mizu-Trace-ID: 7b477e88c5b0e9d9
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
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [RFC PATCH v8 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Wed, 30 Sep 2026 15:51:54 +0800
Message-ID: <20260930075154.189958-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930075154.189958-1-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the BPF cost model attachment in the io.cost.model section
of the cgroup v2 documentation: attaching an iocost_model_ops
struct_ops to a device by its major:minor, the model=bpf readback
while attached (ctrl keeps describing the coefficients), that
detaching restores the builtin model, and that ctrl= writes never
select a model.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7fe950425216..5e780bdcf324 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2117,8 +2117,27 @@ IO Interface Files
 	  =====		================================
 	  ctrl		"auto" or "user"
 	  model		The cost model in use - "linear"
+			or "bpf" while the BPF model
+			is in use
 	  =====		================================
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
+	can be attached to a device by loading an "iocost_model_ops"
+	struct_ops with the whole disk's major:minor in its "dev" member
+	(a partition's major:minor is rejected).  Attaching creates the
+	controller if needed, like an io.cost.model write does, and
+	switches the device's pricing to the model; enabling and
+	disabling the controller stays with io.cost.qos.  While a model
+	is attached, "model" selects between it and the builtin model:
+	"model=bpf" switches to the attached model and "model=linear"
+	switches back to the builtin model, and neither detaches the
+	struct_ops; only detaching removes the model, after which
+	"model=bpf" fails.  "ctrl" keeps describing the builtin
+	coefficients, which are kept while the BPF model is in use and
+	take effect again when switched back, and the automatic profile
+	stepping does not switch profiles while the BPF model is in
+	use.
+
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
 	parameters are written to, "ctrl" become "user" and the
-- 
2.43.0

