Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375248F820
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045139; cv=none; b=CuEL/LXUcnWnhAbd3cho4FeIloIPfr/rX8agKnbW0c61sMi+eqYLd0EX5vsJFQuLIGfmAOw6cyUKpQNgnOg6wqXYnCtwOY+0CSgU4NpWOW2TiBGKGm+nO8GylDUSp8Ela5kD9TL3myPBZhDTGPWS6YaAVC781RrMJjEZa/H4DJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045139; c=relaxed/simple;
	bh=FY3LXKu+5c2SOYK7Zse2tGCHfSqhOu/bDt33iTqGd4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgzm+TRdQ5Je/YOrefhDFyRzD5oWNNqaH+3dBukFi7iGW55CKvtI2ME5RJPExC4vKqsL5NQMEynv4fmqulTB0R2UG6cKlqJAUcrTeDnrvKzyI7iD4m0CGPPpHIryUVkfWuy7LP8mUaTsVsJWhZfxTFcIfxEaPe+MzYb9qQffcCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LtkEc5vW; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LtkEc5vW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FY3LXKu+5c2SOYK7Zse2tGCHfSqhOu/bDt33iTqGd4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789045133; v=1; x=1789649933;
 b=LtkEc5vW2sC7ZA6b9E60TcM5egp/NT3jLhuj+fONnmi03fSWJqSaop31plixNfPFFCyLvzsp
 QW7q4ZwPNLlGlIuhkxr8vz+skvWY+aXBztscPurVNK5mfeGoAs829Z1MEEF9FyYfScKW7u/XLvJ
 G2wS4bT7nv3gvIdG1NFdGToY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 01bb2cbd500ae1c4;
	Thu, 10 Sep 2026 12:58:53 +0000
X-Mizu-Trace-ID: 01bb2cbd500ae1c4
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
Subject: [RFC PATCH v2 5/5] docs: cgroup-v2: document io.cost model=<name> binding
Date: Thu, 10 Sep 2026 20:58:17 +0800
Message-ID: <20260910125817.223354-6-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910125817.223354-1-cui.tao@linux.dev>
References: <20260910125817.223354-1-cui.tao@linux.dev>
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
 Documentation/admin-guide/cgroup-v2.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..a6910ad7c2d0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2124,6 +2124,17 @@ IO Interface Files
 	parameters are written to, "ctrl" become "user" and the
 	automatic changes are disabled.
 
+	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, "model" also accepts
+	the name of a registered iocost_model_ops BPF struct_ops model:
+	"model=<name>" binds the model to the device and the model fully
+	replaces the builtin linear pricing, for every operation including
+	flushes; "model=linear" (or "ctrl=auto/user") restores the builtin
+	model.  Writing an unknown name fails with ENOENT.  Unregistering
+	a model removes its name; devices already bound keep using it
+	until switched back to the builtin model, following the lifetime
+	model of TCP congestion control.  See include/linux/blk-iocost.h
+	for the model interface.
+
 	When "model" is "linear", the following model parameters are
 	defined.
 
-- 
2.43.0

