Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7218472
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 02:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787710705; cv=none; b=ScFZa8aHu+PqVu6RtRGcS3hNAuONUfMtpq22YN1JFDWpg5J2hBzkSdaSnwT3PGraQ/D8lJcplhj3Mf2Zn/kfgMc0vMWAQxm4J0idAMqMO0+zP+OGI1sSOf4q/YmBRAUsdbEk252hboucy5K58nhMPRO709r0KoCPDHiT4siA5rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787710705; c=relaxed/simple;
	bh=t/05Fp8KvIdQ3wJax8e4wYX6B2lpmgVrEQ6lnlSI1GY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=URsjnUsGaQ3BiUmBsQvIcOr7msu7c6mUKBwAuAholNI0sLl93u9D4KOhi34SGjTBXlNn5FCghN3c+d9kMlIwNjeVTMexIyWQfGOmUty4phP8v+F97VbWS0Kh7p5UPgTRgRpGH0wHGa4qi7l7mFxIGPsrs8YwMdrH/nQc18xHY6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fe38BSaU; arc=none smtp.client-ip=95.215.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fe38BSaU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=t/05Fp8KvIdQ3wJax8e4wYX6B2lpmgVrEQ6lnlSI1GY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787710700; v=1; x=1788315500;
 b=fe38BSaUQDBavAjpQIFCgpdHyzLYDhM0INhYqF3yOODfNB9x/Cjk7eOEyjzpl7068Xr9Gx0e
 6P1vm6mdzF6qvze919ms5gMoPIsl10JWwGJmatxfiIGHTUKCW15OkyXwa66+QRORLEM0AqFcm7b
 r6bvXtPBePFcCDiKhkvlTYI8=
X-Envelope-To: cgroups@vger.kernel.org
Received: from ctao-book.. (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 376f8c39feeeb18b;
	Wed, 26 Aug 2026 02:18:10 +0000
X-Mizu-Trace-ID: 376f8c39feeeb18b
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	akpm@linux-foundation.org,
	shakeel.butt@linux.dev,
	mhocko@suse.com
Cc: mhocko@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] docs: cgroup: document empty-write behavior of memory limit knobs
Date: Wed, 26 Aug 2026 10:17:53 +0800
Message-ID: <20260826021753.197871-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

A maintenance script on a cluster wrote an unset variable into
memory.max of a workload cgroup; the variable expanded to an empty
string, the write succeeded, and the workload in the cgroup was
OOM-killed.  Nothing pointed back at the write, so it took quite
some time to trace the OOM kills to that script.

The memory controller documentation does not say what an empty
write does; the cpuset controller documents its empty-value
semantics.  The actual behavior is that the empty string is
accepted as 0.  Reproduced on a k8s cluster (v1.29, cgroup v2,
two-container pod, 384M limit):

  # LIMIT=
  # echo "$LIMIT" > $CG/memory.max
  # echo $?
  0

  m6demo   0/2     OOMKilled   0

  Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB

State it where the interface files are introduced, alongside the
existing notes on units and page rounding.

Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---

Changes since v1: document the empty-write behavior instead of
rejecting it, the outcome of the review discussion at the Link:
below.

---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..8d2603751c51 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1321,6 +1321,10 @@ All memory amounts are in bytes.  If a value which is not aligned to
 PAGE_SIZE is written, the value may be rounded up to the closest
 PAGE_SIZE multiple when read back.
 
+For the limit files described below, an empty or all-whitespace
+write is accepted and sets the limit to 0.  To disable a limit,
+write "max"; to set it to zero explicitly, write "0".
+
   memory.current
 	A read-only single value file which exists on non-root
 	cgroups.
-- 
2.43.0

