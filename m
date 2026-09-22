Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A043B71A3
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 03:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047347; cv=none; b=JetaeKFj/hwmuKckHjL1tkrWXBhv2ilPri6X9M55yuh/54bq+TmzSznRxfkvrnSeSqvmn5FmIuHu3JJUtpcwlEzyGfzFOp2GfZDccqr5LTLRBtJD3G0h2OBWo3oPjIg8LrECet9vQvgac5pJPv2A+AbwjMpObAPRATzF1fo+e0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047347; c=relaxed/simple;
	bh=pauak53psAXKLYl2w6xPdGBF4uRbBTPOApr/KH0j4F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSJesrlTkmS5Im0IDRM0a1xehEn0S3pZexIqu9nuyNvvtsCW2e6rFvJmdMqARlcjyA2kVc3yj1vpH6V0CWTT5Ws1Syn/WDF+vaaNKRZcimj+wzwtQfNS8bAK72TW8Ca/JC0kXA2WZXaQ6GrFTiqjODa/RqHmpKvhGRxqj//ZhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C49OkL7L; arc=none smtp.client-ip=91.218.175.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C49OkL7L"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pauak53psAXKLYl2w6xPdGBF4uRbBTPOApr/KH0j4F0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790047342; v=1; x=1790652142;
 b=C49OkL7LFYddJEhZEUbvcbZ7weqRfBRST96EE5phGSn+Y4HpyVtwmBauz/6M93+u3U8P1zGx
 jogztmXF0UczPe6VC6xW4KiqW/+z+3kkd03OdZEe+bjJDFhrZBLTdDWAL0fwciqPoVkPsx0LWKh
 wvtSPaHaBstwm2iFC1DbVQ2s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ebad361c0570f0a0;
	Tue, 22 Sep 2026 03:22:22 +0000
X-Mizu-Trace-ID: ebad361c0570f0a0
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 1/2] docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
Date: Tue, 22 Sep 2026 11:21:29 +0800
Message-ID: <20260922032130.33777-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922032130.33777-1-guopeng.zhang@linux.dev>
References: <20260922032130.33777-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

cpuset.cpus.isolated is documented as empty when no isolated partition
exists. This is not true when CPUs are isolated at boot with
isolcpus=domain. cpuset_init() adds those CPUs to the isolated mask,
and isolcpus=<cpu-list> uses domain isolation by default. They remain
listed after a partition using them is released.

Document the boot-isolated CPUs as well.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 2ec582985b5b..18a01ce4c334 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2626,8 +2626,9 @@ Cpuset Interface Files
 	A read-only and root cgroup only multiple values file.
 
 	This file shows the set of all isolated CPUs used in existing
-	isolated partitions. It will be empty if no isolated partition
-	is created.
+	isolated partitions or isolated at boot time via the "domain"
+	flag of "isolcpus". The latter remain listed even after any
+	partition using them is released.
 
   cpuset.cpus.partition
 	A read-write single value file which exists on non-root
-- 
2.43.0

