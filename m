Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4343B4AA
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727075; cv=none; b=sF+7xG4cKf7zSgdcwl1hnjvcZuYMbbYWbBEz7iwXircxnBFh6+45tx1ltqaXvlyAkBVBWjXRRmgHRnm/IdIeS2+RjYoUl23qazhrsDmYNA2L3nx3WVGGPKDzqFDy5Ee1z8XWEpVtNHJkTP8UTLpaRyGT+aRxDHvq9gbGNrwQMik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727075; c=relaxed/simple;
	bh=J45Y1ObSy/eJBhcSeTA5XpHzBDid6XYZQmAy94wszCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu+o32p39Zjs1zLZQiaymy92GE3+XJq4fikd3ICbqJk2BsVAedQ7+Rdh5P9QCUj7COye+AJD0wEyGHpHqawgJVDVQI4rK28LsFQkGZyLMdh3hO5FbjFX1lBObSQrfsX4bN27ZIPAw0Hue79GNmCxj7WJVz3DUmDxjkWLC4SfSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EUZWBpPL; arc=none smtp.client-ip=91.218.175.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EUZWBpPL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=J45Y1ObSy/eJBhcSeTA5XpHzBDid6XYZQmAy94wszCg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789727071; v=1; x=1790331871;
 b=EUZWBpPLap2Zq2wEJLWGFF8tiY6xuFKhuNP65atENvfuX2JOS5twZuAG3RrLrNi1XBytYh7p
 iufruDSHQ3pnlOiXbrp13qAvxC377TCozFNwdMDUV8Dr1ZrZIIl2IqXg96ac5c5uhoozr9rSCrP
 8EkPDpriOWSCWb7iCcENQVFk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 05f701c3f01e40bb;
	Fri, 18 Sep 2026 10:24:31 +0000
X-Mizu-Trace-ID: 05f701c3f01e40bb
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 2/2] docs: cgroup-v2: Describe effective CPUs of partition roots
Date: Fri, 18 Sep 2026 18:23:59 +0800
Message-ID: <20260918102359.71826-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918102359.71826-1-guopeng.zhang@linux.dev>
References: <20260918102359.71826-1-guopeng.zhang@linux.dev>
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

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 29 ++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 272e9f2432bd..49ce8deb4115 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2505,16 +2505,25 @@ Cpuset Interface Files
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
+	available from the parent cgroup.  Otherwise, it is a subset
+	of "cpuset.cpus" unless none of the requested CPUs can be
+	granted.  In that case, it is treated like an empty
+	"cpuset.cpus".
+
+	For a valid non-root partition root, "cpuset.cpus.effective" contains
+	the active CPUs from "cpuset.cpus.exclusive.effective" except
+	those granted to valid child partition roots.  If
+	"cpuset.cpus.exclusive" is set to a value different from
+	"cpuset.cpus", the effective CPUs need not be a subset of
+	"cpuset.cpus".  For example, if CPUs 2-5 are active,
+	available, and not assigned to a valid child partition root,
+	a partition root with "cpuset.cpus" set to "0-3" and
+	"cpuset.cpus.exclusive" set to "2-5" has "2-5" in
+	"cpuset.cpus.effective".
 
 	Its value will be affected by CPU hotplug events.
 
-- 
2.43.0

