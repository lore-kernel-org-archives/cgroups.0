Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43100392823
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620971; cv=none; b=meuZaxjMFJTZ4MHLlT4Qpy7Yo84zgwZXPAAk+ngKH3jt6saoV1KIyw388UU4iD64RMKkFl8LXDUnsz4oQLOWGH9YCRdxxcDDPOrgoFlhZR1livcKiofPOh3Yv1CgcNzO225di26RoWtT266GGjHipGG5tNevXvyJtptlpBRmxtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620971; c=relaxed/simple;
	bh=0duH7b3UXc8mlRAP9LVXU+dMi7JWWQNNmpfmLJ9K9RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyodLV/g55KJQ289Edda8S1D3FvBbLmiCIN/6sY3rhVVaIz/VFaq2B2+OjVrktvwWAOwsOFICC6XbwZq5O+qJWJhqXduvUJjjjpMYb1WXh1vDOlXhCBQKEqQBqQ462Rvrcwv/4Df98nlrNAVlttpIIpU9ARtycuXBN67BsQ00dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=afjS5llZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="afjS5llZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791620969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rAz/dH94hG1y1hXXuuZpGdD4EfNPJYVuuvaPCBV7t6o=;
	b=afjS5llZjFKMIVFCkVwJVvHM3EGezL/HlNT78xU+c2vHlGNICroE8A7SMa9gyT1/D5dfNx
	SyHgLpmg+DQYV7yyimXvxA1gStYuqWvdoOefwKXezLUt1ljroRJyloj1bNM29oUyOwZUo+
	PhvAhGD9tcAN9MDXcVdxvY4iJN71/WU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-RabgyjUpPPa2lm0vBWnYXQ-1; Sat,
 10 Oct 2026 08:29:25 +0000
X-MC-Unique: RabgyjUpPPa2lm0vBWnYXQ-1
X-Mimecast-MFC-AGG-ID: RabgyjUpPPa2lm0vBWnYXQ_1791620964
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEF911956055;
	Sat, 10 Oct 2026 08:29:23 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21E4B180034F;
	Sat, 10 Oct 2026 08:29:20 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 2/5] cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check
Date: Sat, 10 Oct 2026 04:28:45 -0400
Message-ID: <20261010082848.193182-3-longman@redhat.com>
In-Reply-To: <20261010082848.193182-1-longman@redhat.com>
References: <20261010082848.193182-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

When prstate_housekeeping_conflict() is called to perform housekeeping
check with cpumask changes, the exclusive CPUs owned by child partitions
are excluded. If the current cpuset is an isolated partition with root
partition children. It is possible the cpumask change will still leave
active housekeeping CPUs but then no housekeeping CPUs will be left when
the child partitions are disabled or invalidated.

To protect against this possibility, all the exclusive CPUs of the
cpuset should be considered to be owned by the current cpuset when doing
housekeeping check. Do that by calling prstate_housekeeping_conflict()
in partition_cpus_change() and passing in the add_cpus and del_cpus
parameters as if the cpuset owns all the exclusive CPUs. With that
change, we can remove the duplicated prstate_housekeeping_conflict()
calls in update_parent_effective_cpumask() with partcmd_update and
in remote_cpus_update().

In the case of partition state switch from isolated to root and vice
versa, the set of exclusive CPUs are recomputed to include those
transferred to child paritions as well.

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f3cebb277a68..ce32e7a31c72 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1692,9 +1692,6 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
-						       tmp->addmask, tmp->delmask))
-			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -1907,14 +1904,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 					       parent->effective_xcpus);
 		}
 
-		/*
-		 * Check for housekeeping conflicts
-		 */
-		if (is_partition_valid(cs) &&
-		    prstate_housekeeping_conflict(old_prs, parent_prs,
-						  tmp->delmask, tmp->addmask))
-			part_error = PERR_HKEEPING;
-
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
 		 * must be present.
@@ -2398,6 +2387,21 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
+	if (!prs_err) {
+		int parent_prs = is_remote_partition(cs)
+			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+		/*
+		 * Check for housekeeping CPUs conflict assuming that all the
+		 * exclusive CPUs belong to the current cpuset.
+		 */
+		compute_excpus(trialcs, tmp->new_cpus);
+		cpumask_andnot(tmp->addmask, tmp->new_cpus, cs->effective_xcpus);
+		cpumask_andnot(tmp->delmask, cs->effective_xcpus, tmp->new_cpus);
+		if (prstate_housekeeping_conflict(cs->partition_root_state,
+						  parent_prs, tmp->addmask,
+						  tmp->delmask))
+			prs_err = PERR_HKEEPING;
+	}
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
@@ -2897,8 +2901,9 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
+		compute_excpus(cs, tmpmask.new_cpus);
 		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
+						  tmpmask.new_cpus, NULL))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
-- 
2.55.0

