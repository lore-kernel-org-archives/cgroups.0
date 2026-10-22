Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639052;
	b=Yqq4D3NTEDpsUiX8z5pDbvdK7DBSoXRlPxIrcXu5WwoQ3VQNNlrY0N9AmsQkV2sinmZu
	 +MJrxs20G52Q24+ftTyXek39Z61pv9xm4/Y5KJLv1WO0JWe2UomQKGPtUbAkrfQcWxONQ
	 dHELP5kRmGT21WF+L5LQwKDLTo5fs+Et/oMRKl+b5va7rkJZjRyLaqoUdvI5J3VbKLgmU
	 uY6QLA5GwohYltzq73FAqAikuZ5DI7eLqljfZMIJAhj4qlPQzVShjXCU+Hac8WcpaXptY
	 VllFY+D3SNSAOB6GidU2b6OvLerjYcRgr7KyfNMvGjLFQ8K6LEwHl0gkuSC5EuTwwgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639052;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=Qnw0J4srQiLA5T2mT8sBLYjPGzbVS2YPDTu5qKh7uz0=;
	b=3TFW4ndGm/ChZg88p2Of8/QuG8t4BnVKq2uuSQvATzeseaJx+IjTl8ow116qtGksknMr
	 CugvanjVd/958WyjmeOcKixQ4vJ047DPiDSaNaOOOm+kAcw2iaHHZdYhLkayOkZqr0gJJ
	 iYrKUP15EDJNCm36+QQ1CxdawbI5vl7jUkdbRkUr5lO2wcjh9U/sCb0HgR/HlBkW8nNFu
	 kbuTDn/GOOCc1ui0vh+Z69H2zIUu4a9k3LAFXJg2jINXeGnm2F6VwBvMwHlboiBPWvUaU
	 fMyumBMQM9KAwJoqU6dnYbMNc2s1ARfdijEQmjEPbNiOUg4qSejNpUyBF3+T35pcdVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Me7bdF4l;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B5606A339
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 03:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B43B5606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Me7bdF4l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792639050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qnw0J4srQiLA5T2mT8sBLYjPGzbVS2YPDTu5qKh7uz0=;
	b=Me7bdF4lqJap3/0hWOoHCLCwHrUpC1I9lyXEVUxSofIdDhpSt8MDwCNCwWlahz7le7+495
	Jjcp2z166XH98v7lj8MIODVm/GdLyFVgetj5XrlcDw+n8b/NGTHv+HH1c7zbMnbeRDc79K
	VG3IQbComWRGOcsTkT5n6i0lcnZXS+s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-z4AnmJC_Mnikx9eN9EM6cg-1; Thu,
 22 Oct 2026 03:17:27 +0000
X-MC-Unique: z4AnmJC_Mnikx9eN9EM6cg-1
X-Mimecast-MFC-AGG-ID: z4AnmJC_Mnikx9eN9EM6cg_1792639045
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72DE219560B8;
	Thu, 22 Oct 2026 03:17:25 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA67818004D2;
	Thu, 22 Oct 2026 03:17:23 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 1/6] cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition
Date: Wed, 21 Oct 2026 23:16:38 -0400
Message-ID: <20261022031643.1351877-2-longman@redhat.com>
In-Reply-To: <20261022031643.1351877-1-longman@redhat.com>
References: <20261022031643.1351877-1-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Commit 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus
update in update_cpumasks_hier()") searches for the closet partition
root ancestor to determine if the isolated CPUs in a to be invalidated
isolation partition should be removed from isolated_cpus or not.

As reported by sashiko, this method may not work when there is a deeply
nested isolated partition hierarchy. For instance, Consider a nested
hierarchy A0 -> A1 -> A2 -> A3 where all four are PRS_ISOLATED:

  A0: effective_xcpus = 0-4
  A1: effective_xcpus = 1-4
  A2: effective_xcpus = 2-4
  A3: effective_xcpus = 3-4

When A1 shrinks its exclusive_cpus from 1-4 to 1-2, A2 will update it
effective_xcpus to 2. A3 will find its closet partition root ancestor
A2 and decides that its effective_xcpus 3-4 should be removed from
isolated_cpus which is incorrect.

Address this corner case by searching for the furthest isolated partition
root ancestor instead to decide if its isolated CPUs should be returned
to isolated_cpus.

Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 585a982249ad..7ead8c3b7974 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2156,22 +2156,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 }
 
 /*
- * ancestor_partition - Find and return the closest valid partition root ancestor
+ * iancestor_partition - Return furthest isolated partition root ancestor available
  * @cs: the current cpuset
- *
- * Return: The closet partition root ancestor cpuset
+ * Return: The furthest isolated partition root ancestor available or NULL if
+ *	   not found.
  */
-static struct cpuset *ancestor_partition(struct cpuset *cs)
+static struct cpuset *iancestor_partition(struct cpuset *cs)
 {
 	struct cpuset *ancestor = parent_cs(cs);
+	struct cpuset *iancestor = NULL;
 
-	/*
-	 * The top_cpuset is always a valid partition root which will stop
-	 * the loop if it is reached.
-	 */
-	while (!is_partition_valid(ancestor))
-		ancestor = parent_cs(ancestor);
-	return ancestor;
+	for (; ancestor; ancestor = parent_cs(ancestor))
+		if (ancestor->partition_root_state == PRS_ISOLATED)
+			iancestor = ancestor;
+	return iancestor;
 }
 
 /*
@@ -2283,23 +2281,23 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 				 * For a to be invalidated isolated partition,
 				 * its isolated CPUs may or may not need to be
 				 * removed from isolated_cpus depending on if
-				 * its closest partition root ancestor is a root
-				 * or isolated partition. With a PRS_ISOLATED
-				 * ancestor, the CPUs are checked against its
-				 * effective xcpus to see if any of them needed
-				 * to be removed.
+				 * there is a furthest isolated partition root
+				 * ancestor available. When such a PRS_ISOLATED
+				 * ancestor is available, the CPUs are checked
+				 * against its effective xcpus to see if any of
+				 * them needed to be removed.
 				 */
 				if (is_partition_valid(cp))
 					new_prs = -old_prs;
 
 				if (old_prs == PRS_ISOLATED) {
-					struct cpuset *ancestor = ancestor_partition(cp);
+					struct cpuset *iancestor = iancestor_partition(cp);
 
-					if (ancestor->partition_root_state == PRS_ROOT)
+					if (!iancestor)
 						del_cpus = cp->effective_xcpus;
 					else if (cpumask_andnot(tmp->delmask,
 								cp->effective_xcpus,
-								ancestor->effective_xcpus))
+								iancestor->effective_xcpus))
 						del_cpus = tmp->delmask;
 
 					if (del_cpus) {
-- 
2.55.0

