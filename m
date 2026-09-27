Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4F43C8724
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 21:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546036; cv=none; b=Blxn/9Wu/T/0IXlQTp38OQV0SIbs+LJvCN4zb/TOqBgKPDaFhrXfJeVqpsWTIYVK+LcRTcgPFNlF0mCcBZ19MNodec98H05+2ymnD0Da2zI35W+OwZOci9KIbye8HsVj0rtCxvuCbGxGFW06wQCCUUiNJwCG515ZBNihQqdXhyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546036; c=relaxed/simple;
	bh=cpZxU+V5LSjZlr11ty+VxIhYvgU1Di2SyCt5UsyluzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXV7bxdEa0UX9l15afNRGl/OH4zEM6LCU2sxFMaijTWXoGbZkchk9Bzs7eQYLg3gEf3Wt/5N5oda/9KJ7GfRC487GrntLj3k6ieC03eD99s0UC7PRl2a900xegp7cCiRI5aXKd0SpIAax+1rX0vEp2CY0EZHJHWBZK7ZskjuDU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zkv22idl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zkv22idl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790546030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krGMz5bdStFSZEE6OdNkCFJTj92DJdIV5J6AFUS24/4=;
	b=Zkv22idlq40jsX6VjgDi9jig1GzIIeCFRI2ZQaxLCcslMpMklGv2qYZ35hKfdSRcLE3pPX
	sNl2GfBpjb5o5CnqJyNOJ29idXkKZRmCnyRa9IBuwjsg9Tl8sdWzkvF6ZsCUOlldvZGY81
	b8OpC8Ds+Dh/XSnbtxbKyBQXcY4wVmw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-SbEL44PuPaOZSS_ENoFh3w-1; Sun,
 27 Sep 2026 17:53:44 -0400
X-MC-Unique: SbEL44PuPaOZSS_ENoFh3w-1
X-Mimecast-MFC-AGG-ID: SbEL44PuPaOZSS_ENoFh3w_1790546023
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F22A819560AA;
	Sun, 27 Sep 2026 21:53:42 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 71F9341D;
	Sun, 27 Sep 2026 21:53:41 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v2 2/2] cgroup/cpuset: Remove CS_CPU_EXCLUSIVE handling code from v2
Date: Sun, 27 Sep 2026 17:53:19 -0400
Message-ID: <20260927215319.382422-3-longman@redhat.com>
In-Reply-To: <20260927215319.382422-1-longman@redhat.com>
References: <20260927215319.382422-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

As the is_cpu_exclusive() function is only used for DEADLINE shrink
test with v1 there is no need to have the CS_CPU_EXCLUSIVE flag set on
valid partition root anymore. Remove update_partition_exclusive_flag()
and other CS_CPU_EXCLUSIVE flag handling code in cpuset.c.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 52 ++++--------------------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 104fe10c336d..4a915da37bb3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1174,25 +1174,6 @@ enum partition_cmd {
 static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 				    struct tmpmasks *tmp);
 
-/*
- * Update partition exclusive flag
- *
- * Return: 0 if successful, an error code otherwise
- */
-static int update_partition_exclusive_flag(struct cpuset *cs, int new_prs)
-{
-	bool exclusive = (new_prs > PRS_MEMBER);
-
-	if (exclusive && !is_cpu_exclusive(cs)) {
-		if (cpuset_update_flag(CS_CPU_EXCLUSIVE, cs, 1))
-			return PERR_NOTEXCL;
-	} else if (!exclusive && is_cpu_exclusive(cs)) {
-		/* Turning off CS_CPU_EXCLUSIVE will not return error */
-		cpuset_update_flag(CS_CPU_EXCLUSIVE, cs, 0);
-	}
-	return 0;
-}
-
 /*
  * Update partition load balance flag and/or rebuild sched domain
  *
@@ -1248,11 +1229,9 @@ static void reset_partition_data(struct cpuset *cs)
 
 	lockdep_assert_held(&callback_lock);
 
-	if (cpumask_empty(cs->exclusive_cpus)) {
+	if (cpumask_empty(cs->exclusive_cpus))
 		cpumask_clear(cs->effective_xcpus);
-		if (is_cpu_exclusive(cs))
-			clear_bit(CS_CPU_EXCLUSIVE, &cs->flags);
-	}
+
 	if (!cpumask_and(cs->effective_cpus, parent->effective_cpus, cs->cpus_allowed))
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 }
@@ -2028,19 +2007,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	if (!adding && !deleting && (new_prs == old_prs))
 		return 0;
 
-	/*
-	 * Transitioning between invalid to valid or vice versa may require
-	 * changing CS_CPU_EXCLUSIVE. In the case of partcmd_update,
-	 * validate_change() has already been successfully called and
-	 * CPU lists in cs haven't been updated yet. So defer it to later.
-	 */
-	if ((old_prs != new_prs) && (cmd != partcmd_update))  {
-		int err = update_partition_exclusive_flag(cs, new_prs);
-
-		if (err)
-			return err;
-	}
-
 	/*
 	 * Change the parent's effective_cpus & effective_xcpus (top cpuset
 	 * only).
@@ -2063,9 +2029,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 
 	spin_unlock_irq(&callback_lock);
 
-	if ((old_prs != new_prs) && (cmd == partcmd_update))
-		update_partition_exclusive_flag(cs, new_prs);
-
 	if (adding || deleting) {
 		cpuset_update_tasks_cpumask(parent, tmp->addmask);
 		update_sibling_cpumasks(parent, cs, tmp);
@@ -2942,10 +2905,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (alloc_tmpmasks(&tmpmask))
 		return -ENOMEM;
 
-	err = update_partition_exclusive_flag(cs, new_prs);
-	if (err)
-		goto out;
-
 	if (!old_prs) {
 		/*
 		 * cpus_allowed and exclusive_cpus cannot be both empty.
@@ -3009,13 +2968,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	}
 out:
 	/*
-	 * Make partition invalid & disable CS_CPU_EXCLUSIVE if an error
-	 * happens.
+	 * Make partition invalid if an error happens.
 	 */
-	if (err) {
+	if (err)
 		new_prs = -new_prs;
-		update_partition_exclusive_flag(cs, new_prs);
-	}
 
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
-- 
2.55.0

