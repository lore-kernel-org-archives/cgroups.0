Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D93EAC74
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791031304; cv=none; b=e/e2qc73nCTk4goWHtLRPUV9qHsQxC8mns2hwKdnS1p5WA4HZL+emOLz9yWdNaS3Q0x5YHo7F8KMBgVhEC/5JMxnPWTAemokQ1Yu6uMP2fXJzDgt93mBOwGM8hYGRv0d0MW3jwALFwu9ekshh8qp3Hu9dc1/hbUGE49Cs2NFXYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791031304; c=relaxed/simple;
	bh=FG6QxT+rGZh/WtFWGdcIIamPu9fZeHWAtIDLanVq3uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up96BLgPhobbDjmHoXcTbjxBwcOfc2wFBlZaUbu3hSMHnIQ8qlDTv/E/YCj6zeq6YkUBTZIednVmC/+phU+StOYUVNdjri/zAe8HFplD1CSkU6NDgyjI9UipAPB8DmP5QVb8IpIIxDJMBYxih88KrcsOaOTgnYNLJvSHfiVvxnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y0LB/LFO; arc=none smtp.client-ip=95.215.58.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y0LB/LFO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FG6QxT+rGZh/WtFWGdcIIamPu9fZeHWAtIDLanVq3uw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791031300; v=1; x=1791636100;
 b=Y0LB/LFOQfKuq9SyUFvmlJ5cJS5pzczMRDRs/pVA68RHDkDRggpYU1XCGXMaqGLX/gxZglHW
 P4+7ioS9d95TETH4yNUxm6qO1h9kOOa7pa245nzrsaHeA5Vf8iM5jz2MRkYEwxJgLMGXKnoIyUA
 JZhXWQNI21iPcPMbv6Tj2iKQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3a42cfea82c4eeb8;
	Sat, 03 Oct 2026 12:41:40 +0000
X-Mizu-Trace-ID: 3a42cfea82c4eeb8
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
Subject: [RFC PATCH v10 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Sat,  3 Oct 2026 20:40:45 +0800
Message-ID: <20261003124045.1289305-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003124045.1289305-1-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
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

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7fe950425216c..f883d1c9e67d7 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2117,8 +2117,30 @@ IO Interface Files
 	  =====		================================
 	  ctrl		"auto" or "user"
 	  model		The cost model in use - "linear"
+			or "bpf" while the BPF model
+			is in use
 	  =====		================================
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
+	can be bound to a device by attaching an "iocost_model_ops"
+	struct_ops carrying the whole disk's major:minor in its "dev"
+	member (a partition's major:minor is rejected).  Attaching
+	creates the controller if needed, like an io.cost.model write
+	does, and
+	switches the device's pricing to the model; enabling and
+	disabling the controller stays with io.cost.qos.  While a model
+	is attached, "model" selects between it and the builtin model:
+	"model=bpf" switches to the attached model and "model=linear"
+	switches back to the builtin model, and neither detaches the
+	struct_ops; only detaching removes the model, after which
+	"model=bpf" fails and the device prices with the builtin model
+	again.  Device removal ejects the attached model as well, while
+	the struct_ops link remains until userspace destroys it.  "ctrl"
+	accepts only "auto" and "user" and never selects a model; it
+	keeps describing the builtin coefficients, which take effect
+	again when switched back, and the automatic profile stepping
+	does not switch profiles while the BPF model is in use.
+
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
 	parameters are written to, "ctrl" become "user" and the
-- 
2.43.0

