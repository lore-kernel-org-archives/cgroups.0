Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488C328BAB9
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 08:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784361701; cv=none; b=jReDiCj+4xeFd6NZxEPLCj75WMyEoo/TJ6yGrxfKUNTWpMdPJlc8Bv98KcxguhAAj0DcmDyBQn/X1b2jEK2gi93fjedDKvrHnwmz+mUVm1WK6ZzYVAB8bfetOi8mnZ/1A99OQ9kjjZG+BL7hj3xDV1qDebCJqZ4uyuU/wuPQDBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784361701; c=relaxed/simple;
	bh=d68Ya7HiAP0xYkYqHSHW6R4ffOfeNxcGo31YGd1lqso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TbxD8PCq01wc1NOYUrXJZjP0gmgLZUvUfRat2RP9kAwoVbRiAkrd3f4hN9nQ1vkdENgikko4SSG7kGFTh9d3AuJq50e9VS4pA7eltVNkdtwsJXjEgQM1sWRj8BuRJIq/GP+IO0WkEnwtpkXJSoEJjNzOzJMXdvSKjVQdntya33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MJWcde2C; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MJWcde2C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784361687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LRgkyVrEclmb/HHrcMCdcgRj0fn8xYZkl46DaljsFwU=;
	b=MJWcde2Cnzq3/7Bohf79Y8T286gaqbKl4pR3SaUopATVDYAbo+UpTXbU4Z/uXfW2q12cTP
	xUxBGXraJ716lCpBbW2vTHL7UOcgQ28+6CIyCSoq+14z0RpHCqfUyi7dQi1/6lhNckraIf
	ylIVZFtD3gebAsVP8/GtBYW70k4h9Og=
From: Tao Cui <cui.tao@linux.dev>
To: cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH] cgroup/cpu: document cpu.stat nice_usec and core_sched.force_idle_usec
Date: Sat, 18 Jul 2026 16:01:00 +0800
Message-ID: <20260718080100.2334415-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

cgroup_base_stat_cputime_show() unconditionally prints a fourth base
stat, nice_usec, in addition to usage_usec/user_usec/system_usec, and
also prints core_sched.force_idle_usec when CONFIG_SCHED_CORE is enabled.
Neither field is currently described in the cpu.stat section of
cgroup-v2.rst, which still states it "always reports the following three
stats".

nice_usec was added by commit aefa398d93d5 ("cgroup/rstat: Tracking
cgroup-level niced CPU time") and core_sched.force_idle_usec by commit
1fcf54deb767 ("sched/core: add forced idle accounting for cgroups"); the
documentation was not updated in either case.

Update the cpu.stat description to list both fields and fix the count.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0df15a672cf3..778b759dd892 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1144,12 +1144,18 @@ will be referred to. All time durations are in microseconds.
 	A read-only flat-keyed file.
 	This file exists whether the controller is enabled or not.
 
-	It always reports the following three stats, which account for all the
+	It always reports the following four stats, which account for all the
 	processes in the cgroup (including those in descendant cgroups):
 
 	- usage_usec
 	- user_usec
 	- system_usec
+	- nice_usec
+
+	When core scheduling (CONFIG_SCHED_CORE) is enabled, an additional
+	stat is reported:
+
+	- core_sched.force_idle_usec
 
 	and the following five when the controller is enabled, which account for
 	only the processes under the fair-class scheduler:
-- 
2.43.0

