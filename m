Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15643C2B9B
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068874; cv=none; b=kh6R1DtfewaNwqWzK5nmWt5GDMKpSvd/Iy/2FnF+E5vSBIk8+TBW0WSr+LM3V2YL06/DgAh4sSmkcf7aLI27ehfnO0d19dpHiFYfuUVgZJ0NzDErkdlCxQOQtEoVMfxFB5xBE0S8x7+3Lc7A0zD+ptoQuSf2JjdigRs4qZJv0Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068874; c=relaxed/simple;
	bh=tEqbYVDyKqM7Hc/fFzmDq51q6SiHClV2nLZaCnxNlr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ32iagxq56A2d7T0PBFlvp5mUN40GL+ZFLai961cFrHoPNexuIUA7qVPHKSfcjWGB1CXxgy3RFngU6gVFuGibqoRunRy74htLwKEYzjMt1EMf5DwsOfgVXfdZT5PS2Mhxo2VWIwjSHdoVIzmhSTeLU0WPIBof2916Ryw25SjJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mc1ldZZD; arc=none smtp.client-ip=95.215.58.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mc1ldZZD"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tEqbYVDyKqM7Hc/fFzmDq51q6SiHClV2nLZaCnxNlr8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790068870; v=1; x=1790673670;
 b=mc1ldZZDc44AqAZtR4xJVX3zwXMf9ZXE/oJkCYzjBbbpLIeglL170zij8QhU75b86D5/sqyj
 O76U4xCqrwtD49JgwNCENqmXZMBpcr/4ndG26yp8UdHKw/oWiq6nihXODkjRevvKSexdz2FR5wA
 rRIPOtnGKDT5XZTaGHZGoXgc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b325b4af7485a9b4;
	Tue, 22 Sep 2026 09:21:10 +0000
X-Mizu-Trace-ID: b325b4af7485a9b4
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
Subject: [PATCH v3 2/2] docs: cgroup-v2: Describe effective CPUs of partition roots
Date: Tue, 22 Sep 2026 17:20:34 +0800
Message-ID: <20260922092034.68840-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922092034.68840-1-guopeng.zhang@linux.dev>
References: <20260922092034.68840-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The cpuset.cpus.effective description says that the effective CPUs are
granted by the parent and are normally a subset of cpuset.cpus. This
does not always hold for a valid non-root partition root. Its effective
CPUs are the active CPUs in cpuset.cpus.exclusive.effective after CPUs
assigned to valid child partition roots are removed.

If cpuset.cpus.exclusive differs from cpuset.cpus, the effective CPUs
may therefore be outside cpuset.cpus. Remote partitions also do not
necessarily get their CPUs from their immediate parent.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 59 ++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 18a01ce4c334..8f7263eeed4d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2505,16 +2505,55 @@ Cpuset Interface Files
 	A read-only multiple values file which exists on all
 	cpuset-enabled cgroups.
 
-	It lists the onlined CPUs that are actually granted to this
-	cgroup by its parent.  These CPUs are allowed to be used by
-	tasks within the current cgroup.
-
-	If "cpuset.cpus" is empty, the "cpuset.cpus.effective" file shows
-	all the CPUs from the parent cgroup that can be available to
-	be used by this cgroup.  Otherwise, it should be a subset of
-	"cpuset.cpus" unless none of the CPUs listed in "cpuset.cpus"
-	can be granted.  In this case, it will be treated just like an
-	empty "cpuset.cpus".
+	It lists the active CPUs available to tasks in this cgroup.
+
+	For a cgroup that is not a valid partition root, an empty
+	"cpuset.cpus" makes "cpuset.cpus.effective" show all CPUs
+	available from the parent cgroup. Otherwise, it is a subset
+	of "cpuset.cpus" unless none of the requested CPUs can be
+	granted. In that case, it is treated like an empty
+	"cpuset.cpus".
+
+	For example::
+
+	  P (cpuset.cpus.effective=0-3)
+	  |
+	  +-- C0 (member):       cpuset.cpus=1-2
+	  |                      cpuset.cpus.effective=1-2
+	  +-- C1 (invalid root): cpuset.cpus=4-5
+	  |                      cpuset.cpus.effective=0-3
+	  \-- C2 (member):       cpuset.cpus=<empty>
+	                         cpuset.cpus.effective=0-3
+
+	C0 gets CPUs 1-2 because they are available from P.
+	None of C1's requested CPUs 4-5 are available from P, so C1 uses P's
+	effective CPUs 0-3 instead.
+	C2 has an empty "cpuset.cpus" and therefore also uses P's effective
+	CPUs 0-3.
+
+	For a valid non-root partition root, "cpuset.cpus.effective" contains
+	the active CPUs from "cpuset.cpus.exclusive.effective" except
+	those granted to valid child partition roots. If
+	"cpuset.cpus.exclusive" is set to a value different from
+	"cpuset.cpus", the effective CPUs need not be a subset of
+	"cpuset.cpus".
+
+	For example, if CPUs 2-5 are allocated to P for exclusive use,
+	CPUs 2-4 are active, CPU 5 is offline, and none of CPUs 2-5 are
+	assigned to a valid child partition root::
+
+	  top (root)
+	  |
+	  \-- P (valid partition root)
+	      cpuset.cpus=0-3
+	      cpuset.cpus.exclusive=2-5
+	      cpuset.cpus.exclusive.effective=2-5
+	      cpuset.cpus.effective=2-4
+
+	P has 2-5 in "cpuset.cpus.exclusive.effective", including the
+	offline CPU 5. CPU 5 is excluded from "cpuset.cpus.effective",
+	leaving 2-4. The result also shows that "cpuset.cpus.effective"
+	need not be a subset of "cpuset.cpus", which is 0-3.
 
 	Its value will be affected by CPU hotplug events.
 
-- 
2.43.0

