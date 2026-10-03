Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D055F370AC6
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 01:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991083; cv=none; b=Px8ANvITgFF/xV34WlYEIa7NFBdD8zaGdSPropqAk7V1uJVIbDaVpsgdeCYjjV1q+WNT51N/pYowlWog6zRkWyZV1REuzwok5RggLkT9ZH/99Ti+yacw0tL9FWA6sDHmDj5pCyfGBWLUw/aigJYJfMQNSh+quct3O1k44PKrtRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991083; c=relaxed/simple;
	bh=VrUjaFpfqhbBta7NxOheeA+88Rj1Be533vYMgr2BzzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=if094ZVxqArCZZvoqQt3/DTp4iwtnM2FJdAHofc4uu78V+FPaNIgZZJLuTClto7N7CmjT2CdNl+f5dIT1r190Djc7Dsse40s0JavpbviJLLvTR1j9ixI0dWEopkycvQG8LDcGGyiQu8arW3zrfjSOPh0hwP0APRkxTOPoMfQipM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u1d9uVxc; arc=none smtp.client-ip=95.215.58.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u1d9uVxc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VrUjaFpfqhbBta7NxOheeA+88Rj1Be533vYMgr2BzzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790991079; v=1; x=1791595879;
 b=u1d9uVxcC7a/c+SWtsy3W63ylACVacB5mNkYIEnmZaMc0oWfpiSIMxnW4pQi+fzi5+tm9x/U
 d74svHx31UNJnLh08R+5XjZtumOk2znDI3b9EWiXGAj1/lgxOdrwcmK6ySRpGZb+Iz/oQqTMS41
 N4Rc6Qg8ery6wYjbSFyP+22E=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ed5ea994910a12e4;
	Sat, 03 Oct 2026 01:31:19 +0000
X-Mizu-Trace-ID: ed5ea994910a12e4
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
Subject: [RFC PATCH v9 4/4] docs: cgroup-v2: document the iocost BPF cost model attachment
Date: Sat,  3 Oct 2026 09:30:33 +0800
Message-ID: <20261003013033.149288-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003013033.149288-1-cui.tao@linux.dev>
References: <20261003013033.149288-1-cui.tao@linux.dev>
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
 Documentation/admin-guide/cgroup-v2.rst | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7fe950425216c..07da465bb4ef0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2117,8 +2117,31 @@ IO Interface Files
 	  =====		================================
 	  ctrl		"auto" or "user"
 	  model		The cost model in use - "linear"
+			or "bpf" while the BPF model
+			is in use
 	  =====		================================
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
+	can be bound to a device by attaching an "iocost_model_ops"
+	struct_ops carrying the whole disk's major:minor in its "dev"
+	member (a partition's major:minor is rejected).  Attaching creates
+	the
+	controller if needed, like an io.cost.model write does, and
+	switches the device's pricing to the model; enabling and
+	disabling the controller stays with io.cost.qos.  While a model
+	is attached, "model" selects between it and the builtin model:
+	"model=bpf" switches to the attached model and "model=linear"
+	switches back to the builtin model, and neither detaches the
+	struct_ops; only detaching removes the model, after which
+	"model=bpf" fails and the device prices with the builtin model
+	again.  Device removal ejects the attached model as well, while
+	the struct_ops link remains until userspace destroys it.  "ctrl"
+	accepts only "auto" and "user" and never
+	selects a model; it keeps describing the builtin coefficients,
+	which are kept while the BPF model is in use and take effect
+	again when switched back, and the automatic profile stepping
+	does not switch profiles while the BPF model is in use.
+
 	When "ctrl" is "auto", the kernel may change all parameters
 	dynamically.  When "ctrl" is set to "user" or any other
 	parameters are written to, "ctrl" become "user" and the
-- 
2.43.0

