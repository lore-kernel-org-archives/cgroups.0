Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5830C178
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 02:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784858733; cv=none; b=X7zIjWF8J2zoqJ6T3IOY/USQisFFWuhLW4VvTBeR2rxqXZoaE9f5Wy8RPJ3dApEg+Ryu8V64OARVaxZJYUCW4UeW6J5rL9H3VP+HDcwfXnO8btO0bcPjRsh8UNkHVBEaeuLip9KuNd5vRjA9vDvwp1AHmnNt/SxvInEfNG6L4Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784858733; c=relaxed/simple;
	bh=ffCQchMker1wPYEfl8ejLSrNhpv2vNiVuOQI+Ywu/uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zbcfk5bflmRKzo1yGPD7WPLOGjC5a4Fh+NzGopDbvxPMtsyePKeSAJ+X/1s7hq5OEhiYDVtqal7Gh57by7bVmxUywxRwoB84O8r0Hhw4lcyh8yWdwdFFyTwz0ul4SuT+2q+KOUrQzr8fb+x/JllaXBLL1gJPUwDb6o2mjz/nEaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tVqE/Mm4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tVqE/Mm4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784858730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ojJ2pAn/zGWkgI9HfsTcJD6pnALlzsfKN1zcDOzu9QA=;
	b=tVqE/Mm4UI2F9KI92m93XmvtALv9KnGqbWr3NRU7bmbeih5MglyoHdDQk0qySu8698bZaL
	I90eCIQ/tOa3gW2k32Gm/h4wgkEGw0qqvWP5dzVkmN8o0+l+2tSclvBKycMx2yZiAOFHEk
	ZfJbGdscFm+dd1X9wAJpjxbySoIGMp8=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH] docs: cgroup-v2: mark memory.pressure and io.pressure as read-write
Date: Fri, 24 Jul 2026 10:05:08 +0800
Message-ID: <20260724020508.500893-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The cgroup-v2 documentation describes memory.pressure and io.pressure as
"read-only nested-keyed file", but both files accept trigger writes
(cgroup_memory_pressure_write / cgroup_io_pressure_write) and are therefore
read-write. cpu.pressure and irq.pressure are already documented as
read-write, so this also resolves an internal inconsistency.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f3a3e26854c2..c08ae18afea8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1930,7 +1930,7 @@ The following nested keys are defined.
 	is allowed unless memory.swap.max is set to 0.
 
   memory.pressure
-	A read-only nested-keyed file.
+	A read-write nested-keyed file.
 
 	Shows pressure stall information for memory. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
@@ -2190,7 +2190,7 @@ IO Interface Files
 	  8:16 rbps=2097152 wbps=max riops=max wiops=max
 
   io.pressure
-	A read-only nested-keyed file.
+	A read-write nested-keyed file.
 
 	Shows pressure stall information for IO. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
-- 
2.43.0

