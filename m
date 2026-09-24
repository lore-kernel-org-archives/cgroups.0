Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C813FAE15
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228791; cv=none; b=f1zSo66RPie2Z0dDsdlrrlAw7c4WM43aK2o7Hdhc7fep0u/tvQRoZntFUbNUX2gaH8tf8lmVSO+Sfh3F6vxqBP2JoqNYO4lyMJp3aNRo51iBdGp2PkyHuhGdeQJLvL0UCQCZ2tc6l2Bbf16o+eXaURwT+sMuEIHlOHkFtVp+kxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228791; c=relaxed/simple;
	bh=gq5YaNX1tq+qtMZoYlZYtZqfDgp0LgXDTh2kYD4sEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVK3Nn4hbQXxY1lymsQsWQOhXS4IsZpb8hA2mV+gkNV0aUwP568tweVRQmUcf5I+1jxWHNRfMBbewgw0C7lsnbqym5vNFQp0Cqpe4V3JEE/Wgl91gw/Wa6oy0d9dVJYBJSv7g6Qantor0C5CmWuDT17rxEi+KE42GVAKADnkoxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WGsxiJMd; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WGsxiJMd"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gq5YaNX1tq+qtMZoYlZYtZqfDgp0LgXDTh2kYD4sEXA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790228787; v=1; x=1790833587;
 b=WGsxiJMdZ6QjlZ0hegC3GJ1huPIpq9/xhC3m50cDR1vzGLBvHHgpzedSrQVd6xkhzFBtsEut
 jeqhKubPrIOqGf3WeZDvXz3DkO6lmiNm1aE5R3LnpsKhctKFJaN6T6RbgFmaRleaityXCdcEsIj
 w/Er8thaBzxfsus71VownKU8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1003cfcb96295a8f;
	Thu, 24 Sep 2026 05:46:27 +0000
X-Mizu-Trace-ID: 1003cfcb96295a8f
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
Subject: [RFC PATCH v7 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Thu, 24 Sep 2026 13:45:49 +0800
Message-ID: <20260924054549.2271705-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924054549.2271705-1-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Document the BPF cost model attachment in the io.cost.model section
of the cgroup v2 documentation: attaching an iocost_model_ops
struct_ops to a device by its major:minor, the model=bpf readback
while attached (ctrl keeps describing the coefficients), that
detaching restores the builtin model, and that writes never select
a model.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..306cc929c88d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2117,8 +2117,30 @@ IO Interface Files
 	  =====		================================
 	  ctrl		"auto" or "user"
 	  model		The cost model in use - "linear"
+			or "bpf" while a BPF model is
+			attached
 	  =====		================================
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
+	can be attached to a device by loading an "iocost_model_ops"
+	struct_ops with the whole disk's major:minor in its "dev" member
+	(a partition's major:minor is rejected);
+	attaching switches the device's pricing to the model, detaching
+	the struct_ops restores the builtin linear model.  While a model
+	is attached, "model" reads back "bpf"; "ctrl" keeps describing
+	the builtin coefficients, which are inert while the model is
+	attached: coefficient writes are stored and take effect again
+	after the struct_ops is detached, and the automatic profile
+	stepping does not switch profiles.  Writing "ctrl=bpf" or
+	"model=bpf" is accepted as a no-op so a saved configuration
+	still parses, but re-attaching the model requires loading the
+	struct_ops again, not writing to this file.  Attaching
+	implicitly enables the controller if needed (disabling wbt
+	like io.cost.qos does); detaching does not disable it again,
+	and writing "enable=0" to io.cost.qos suspends the model's
+	pricing until the controller is re-enabled, while it stays
+	attached.
+
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
 	parameters are written to, "ctrl" become "user" and the
-- 
2.43.0

