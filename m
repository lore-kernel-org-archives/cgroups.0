Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A7443E20
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229769; cv=none; b=Pt1k7EaJoh057wkkI8FdhwoDUD6sAxXDbXRLjk/Qd76iyDNPpGflFRAHWUhAHPNuT4hkCSGCZK09i4xu4P2L7obLxyKEBkgNW9dGeUVwjVoQdt0smd1aqKXzUT9bHCAz0gDv747ji3J0cJPyZxA9Vz8QQNISBELu6P9uZpbTcd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229769; c=relaxed/simple;
	bh=JzFB1pWcXYEwlsA2BzhquKrozcDcigu9uFLgNjOtxFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTqmfgWALRYaS4yX5JDj1UoMfIKtTiPNkUNseEoaFMdyJqgtoKifSxY+DH2zDUrkbXYca/j46pl9XEol/+8YS/g9Ak2u/svSwWU9GCHWNA/tBAmOTh5a9xuDIs3QXRpLbUlFsoM32sBjWiYWl7Tn80HWKOvFUAd4LCQ30gXjsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BR/ap4z5; arc=none smtp.client-ip=91.218.175.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BR/ap4z5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JzFB1pWcXYEwlsA2BzhquKrozcDcigu9uFLgNjOtxFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229763; v=1; x=1787834563;
 b=BR/ap4z5/ScQG4h5ZYDYmBWGwQdtFptV141MTB7wYakNtF8ovMcGqpMBzpevIug7jyIqyTFS
 wVFSB+Ku2SUW4OPb71hz3TnU1Dte/bEEEem6PHbEorcNIWLm6Fs+Stz97cbMmq1yXhyq9prOPcq
 HmvZrWL1I5vbFpzyqLrKrQXI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id ca41ed51a2d43f94;
	Thu, 20 Aug 2026 12:42:43 +0000
X-Mizu-Trace-ID: ca41ed51a2d43f94
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
Subject: [PATCH 06/17] cgroup/cpuset: Validate type changes against owned CPUs
Date: Thu, 20 Aug 2026 20:41:51 +0800
Message-ID: <20260820124202.517160-7-guopeng.zhang@linux.dev>
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

update_prstate() checks effective_xcpus against the housekeeping masks
before changing a partition between root and isolated. effective_xcpus
also contains CPUs granted to valid child partitions, although those
CPUs are not affected by the parent's type change. A child-owned CPU can
therefore reject an otherwise valid change.

Run the nohz_full and boot-domain housekeeping checks against the mask
of CPUs owned by the partition instead.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 468272baadb2..853942c1afeb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3019,8 +3019,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 */
 		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
 		if (((new_prs == PRS_ISOLATED) &&
-		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
+		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
-- 
2.43.0

