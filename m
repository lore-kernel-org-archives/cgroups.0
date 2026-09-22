Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1821F3C585A
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 03:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047350; cv=none; b=JJOb0OjDTrVs4bpUNhKIOW9B6e9a3ghDHVYIkf1EnzCWyU+z/s4cMAWUuYA7GD+ziatLE2KBVvoMNMSlWki1wETAxmYUaiXCdbhyhjFdKHihQ7vREMKDNwS7iYLlIB1JymhmtUsNwZH9lfF6d4FbHJPGs4f1082YQZVtKtUJAEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047350; c=relaxed/simple;
	bh=7JPshgisP/gZKt07zp73sn2ZgmhMnlsFZ1jh2Bjoutk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxbFXEtHs8tojvwcXEta7fBef79y6WF03zc5NumI5Q7Qa7v5UU2bxWVNkYXPAKhZf/K2j4tlNbfIWjwIR27ipUUur762rENGzWehaKvtrO8haR78W4fvGRUAh6YZp0M4EGL7qOsugp4J7jUU4gjVqAm3SCZAq0bpX6NHy4aznF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qbeh/PYn; arc=none smtp.client-ip=95.215.58.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qbeh/PYn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7JPshgisP/gZKt07zp73sn2ZgmhMnlsFZ1jh2Bjoutk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790047347; v=1; x=1790652147;
 b=qbeh/PYneXt/Z16/KO0X49SzL25xMr46LzdcaT+zpPhASXEJOiIhm/yJhpw8JvqkqwoJwodG
 8TU1arKIF5Z2jo0jK7N4ykUxoJHyaXg6Qs9aEcWxTQ8JHtkEjjN3fWcvdvHZW4e3PtO51Gj7PCk
 SI95588ILYb0kQY/zla9e1tg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0ca956a7054bf7e0;
	Tue, 22 Sep 2026 03:22:26 +0000
X-Mizu-Trace-ID: 0ca956a7054bf7e0
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
Subject: [PATCH v2 2/2] docs: cgroup-v2: Describe effective CPUs of partition roots
Date: Tue, 22 Sep 2026 11:21:30 +0800
Message-ID: <20260922032130.33777-3-guopeng.zhang@linux.dev>
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

The cpuset.cpus.effective description says that the effective CPUs are
granted by the parent and are normally a subset of cpuset.cpus. This
does not always hold for a valid non-root partition root. Its effective
CPUs are the active CPUs in cpuset.cpus.exclusive.effective after CPUs
assigned to valid child partition roots are removed.

If cpuset.cpus.exclusive differs from cpuset.cpus, the effective CPUs
may therefore be outside cpuset.cpus. Remote partitions also do not
necessarily get their CPUs from their immediate parent.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 56 ++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 18a01ce4c334..d21bbae3312a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2505,16 +2505,52 @@ Cpuset Interface Files
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
+	For example, if CPUs 2-5 are active, available, and not assigned
+	to a valid child partition root::
+
+	  top (root)
+	  |
+	  \-- P (valid partition root)
+	      cpuset.cpus=0-3
+	      cpuset.cpus.exclusive=2-5
+	      cpuset.cpus.exclusive.effective=2-5
+	      cpuset.cpus.effective=2-5
+
+	P has 2-5 in "cpuset.cpus.effective" even though its
+	"cpuset.cpus" is 0-3.
 
 	Its value will be affected by CPU hotplug events.
 
-- 
2.43.0

