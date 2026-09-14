Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733563EFFCC
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 07:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371277; cv=none; b=VUWVIFJ9dapA7L8rKS/31/paICKDNqtiHEPUegMsZv2NexTGP1ffWqM76u5z6Xgv5jE6r1gsUIP20WITMZKQP1/vWwzxH/XWLVZ+wqOvLDwu1MlsNAm/QEszV22SOipPsYB4CyJhWu+MbGWyLeCXjHlWus7Bldq4HoZ7NIrCL2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371277; c=relaxed/simple;
	bh=8AnQPQHmMcavg+NgdFWqfItM439TPTTQXb8sYh9+VlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SznjGT6sCMnBo3I/LAqBkGKEXVq2xD2rAGKdnEF4q8qOWkadchgwyZzztgezD1xctdGZJ6ezP8GCsacQX+rNM9VpnRL950D5L/nyHHJU3qaeTbjeEAHkyxDAvaqtFgiJak/PzviHh/atogQBRG1yhHN7jCYJKmPv1J0LXGbj7Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UPwWRVMw; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UPwWRVMw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8AnQPQHmMcavg+NgdFWqfItM439TPTTQXb8sYh9+VlQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789371272; v=1; x=1789976072;
 b=UPwWRVMwTBeowfpRjH5V+IBHJOMDC/OxEpvMaU7RFQBZ+9CDflpPDTIjtKL5MhUVUzCFjEs7
 Mn0Qce/54b8afbdN93SaHohaZ/8q/YCvlMCe+1dZ6ny1agcKHeLnyGoYDKhHEH8K5KH/pq6S3Gy
 YnwLWr7Ba2bhMvebI0m1MqC8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 569a7bb680ac6dae;
	Mon, 14 Sep 2026 07:34:32 +0000
X-Mizu-Trace-ID: 569a7bb680ac6dae
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v3 5/5] docs: cgroup-v2: document io.cost model=<name> binding
Date: Mon, 14 Sep 2026 15:33:56 +0800
Message-ID: <20260914073356.791518-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914073356.791518-1-cui.tao@linux.dev>
References: <20260914073356.791518-1-cui.tao@linux.dev>
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
 Documentation/admin-guide/cgroup-v2.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51a..0d2d0525255cb 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2124,6 +2124,18 @@ IO Interface Files
 	parameters are written to, "ctrl" become "user" and the
 	automatic changes are disabled.
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, "model" also accepts
+	the name of a registered iocost_model_ops BPF struct_ops model:
+	"model=<name>" binds the model to the device and the model fully
+	replaces the builtin linear pricing, for every operation including
+	flushes; "model=linear" (or "ctrl=auto/user") restores the builtin
+	model.  Writing an unknown name fails with ENOENT and nothing is
+	applied.  Unregistering a model removes its name so it can no
+	longer be selected; devices already bound keep using it, and keep
+	receiving cgroup lifecycle notifications, until switched back to
+	the builtin model.  See include/linux/blk-iocost.h
+	for the model interface.
+
 	When "model" is "linear", the following model parameters are
 	defined.
 
-- 
2.43.0

