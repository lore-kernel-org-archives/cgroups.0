Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327F34446E8
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229793; cv=none; b=HPl5NTdGtOQeyumqhj0mE+cxZ8IhOowD0OLyw62X6OKhmGDWSYxsCLt6sYGBAzOSFRimCRdx+qf391Viqphx7D64cJAs1z0UkBYnp3WUNB9H0STo5JdtUTOF5ePl3VhV41JYwDwIyE7KCtMzJBOl8YQ40YtNUb/eAgNBNIu0+io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229793; c=relaxed/simple;
	bh=UIyRewsL6EM7FOwm547z0q306fVBn1MP8SPMo6etr5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJpupjvkmqxH3+hRSGO8peFtppPxs+sDgv4S48QopuAuVB7MNHmIxOH9bmf7vxylSgfjKEdPoeCTWCC8Rhd3Hf4b8+DlFoZJuJ/wlcrtxo1bkfl29SJ/rWIVvJiGteJcgAH6VX7R2QlkBuYEx5Fp/psxzS4JRd1RdyuRozf6BsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MsG4cgaO; arc=none smtp.client-ip=95.215.58.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MsG4cgaO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UIyRewsL6EM7FOwm547z0q306fVBn1MP8SPMo6etr5w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229790; v=1; x=1787834590;
 b=MsG4cgaO99iDKoRiUSXM1dONGMjy3ov40NmhF8XMJelP72QBm1EulBwP5xpYZiHDnh4/CQMk
 8X1V+96JZffgjhHVFjgz/tdklw7JKlL+KtWvUa5dYeE+i47b0vjFJzsGDDGvDwMTtgJb5+yscf9
 jwwplaWuXmNfiveD2aWhqyvk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 2522fcb16bdfe49b;
	Thu, 20 Aug 2026 12:43:10 +0000
X-Mizu-Trace-ID: 2522fcb16bdfe49b
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 12/17] cgroup/cpuset: Invalidate children outside the new CPU mask
Date: Thu, 20 Aug 2026 20:41:57 +0800
Message-ID: <20260820124202.517160-13-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When cpuset.cpus changes, compute_partition_effective_cpumask() builds a
new exclusive mask but checks child partitions against
cs->effective_xcpus. That field still contains the old mask, so a child
that no longer fits can remain valid.

Use new_xcpus for the check. A later partcmd_update() may revisit the
newly invalid child. Report PERR_INVCPUS if the child CPUs are outside
the parent effective exclusive mask so that this visit does not make the
child valid again.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b9faadf4af6d..b3e749ede7d1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1987,12 +1987,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 				adding = cpumask_and(tmp->addmask,
 						     cs->effective_xcpus,
 						     parent->effective_xcpus);
-		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
-			   cpumask_subset(xcpus, parent->effective_xcpus)) {
+		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
 			bool exclusive = true;
 
+			if (!cpumask_subset(xcpus, parent->effective_xcpus)) {
+				part_error = PERR_INVCPUS;
+				goto write_error;
+			}
+
 			/*
 			 * Convert invalid partition to valid has to
 			 * pass the cpu exclusivity test.
@@ -2144,7 +2148,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		WARN_ON_ONCE(is_remote_partition(child));
 		WRITE_ONCE(child->prs_err, 0);
 		if (!cpumask_subset(child->effective_xcpus,
-				    cs->effective_xcpus))
+				    new_xcpus))
 			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
 		else if (populated &&
 			 cpumask_subset(new_ecpus, child->effective_xcpus))
-- 
2.43.0

