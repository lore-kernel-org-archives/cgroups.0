Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794792246;
	b=D/CZ6OtibHq2y0g+DB4Z1itjG+f2CN6mcF4WiGZaHKqgylyTL65h4NQvCEQUJGoKGzUq
	 mBFHTujNvJiaXDBTLz1D7yMwcc1TgLmGdo0VQ1iuVFqx77IKnk/XNRUm6UQr028vihu+u
	 y1oBtZeDQdYwrN7ShalwZ6JTz2VwzVCkdlahXaut05jp0mteAg4caKG8WnQpC/Ixh2eOW
	 zSDgJFgNMSHldNICnpuiYt/LNmB0KIzXS6J/Mt6eqXs8p2GWfP2dvJLJJsZQEymNLfWuR
	 ueorIxdkWGKwrE+IYUJ8Po9e+0NTAqS2vdGM9WYwHfTItEeAfaAEO5D5FYBIdXfJH5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794792246;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=cqduZ2KwIvpm0uMrcKhEaZAXc6fJ9kHYUpVlrzljMxs=;
	b=1SoQclapFdvaKFXESP23GQVuqmlvIZsrhkMNLKxH1Sj75mGwRNtvX0O+1lwdKyEChTii
	 xnl9qzW6jNDlMEeIub8hhojW7b1GRS2+aG7g8Cs5ClBTJF5fmUYuB7oM87rkgy671Glvc
	 yC31HTRfrHaFH8OYHneBj2sZmkYHnbT1d/Rj503sOADq1va2L8T1gxO6U6HQvF4Wvx1Pp
	 fgG8hXTpo1uPDQUFHLMr6HB/mOHuyD68U0Phvbv1LkIp7C4Aq7AYoumoUTTcjWOUzDchK
	 t8H7AlQhlzDGlbVsrEx1tzM+0bWKvEFvPa5qJ8pa6wpn/LvnsJVQ2FF8f/8BriVXHRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GMh9a6Td;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFE5606A33E
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 01:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EFE5606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GMh9a6Td
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794792245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cqduZ2KwIvpm0uMrcKhEaZAXc6fJ9kHYUpVlrzljMxs=;
	b=GMh9a6Td8ScHU5QIxsmzzgwls7ggEaW1bY1/q7Ap0u0JHdiNt7AiboiUmQNGX/niLbSFUJ
	CIpn75yFAQOztQpUW6bePZvEPHmEpkD4qErrlVsSuz332zw0Ft4W5nj1+LivaHgLaPS016
	TR9m6aN+KlsQim+n6BWCQ/G6ssrvZhE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-lJXxzLbmNHCFgHI6r8TFLA-1; Sun,
 15 Nov 2026 20:23:59 -0500
X-MC-Unique: lJXxzLbmNHCFgHI6r8TFLA-1
X-Mimecast-MFC-AGG-ID: lJXxzLbmNHCFgHI6r8TFLA_1794792238
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E719919560B0;
	Mon, 16 Nov 2026 01:23:57 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C21B589;
	Mon, 16 Nov 2026 01:23:56 +0000 (UTC)
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
Subject: [PATCH-next v4 4/6] cgroup/cpuset: Revert "remove global remote_children list"
Date: Sun, 15 Nov 2026 20:23:07 -0500
Message-ID: <20261116012330.2271010-5-longman@redhat.com>
In-Reply-To: <20261116012330.2271010-1-longman@redhat.com>
References: <20261116012330.2271010-1-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Commit 648d43da64f0 ("cpuset: remove global remote_children list") is being
reverted as there is now a need to iterate the list of remote partition
roots available.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset-internal.h | 10 +++-------
 kernel/cgroup/cpuset.c          | 14 +++++++++++---
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 1ba94ffaff9d..f3fed906e7ee 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -154,13 +154,6 @@ struct cpuset {
 	/* partition root state */
 	int partition_root_state;
 
-	/*
-	 * Whether cpuset is a remote partition.
-	 * It used to be a list anchoring all remote partitions — we can switch back
-	 * to a list if we need to iterate over the remote partitions.
-	 */
-	bool remote_partition;
-
 	/*
 	 * Set to true when a remote partition is undergoing update.
 	 */
@@ -186,6 +179,9 @@ struct cpuset {
 	/* Handle for cpuset.cpus.partition */
 	struct cgroup_file partition_file;
 
+	/* Remote partition silbling list anchored at remote_children */
+	struct list_head remote_sibling;
+
 #ifdef CONFIG_CPUSETS_V1
 	struct fmeter fmeter;		/* memory_pressure filter */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 81481fa62cfe..0fe9f2731fee 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -148,6 +148,11 @@ static cpumask_var_t	subpartitions_cpus;	/* RWCS */
  */
 static cpumask_var_t	isolated_cpus;		/* CSCB */
 
+/*
+ * List of remote partition root children
+ */
+static struct list_head remote_children;	/* RWCS */
+
 /*
  * Set if housekeeping cpumasks are to be updated.
  */
@@ -286,6 +291,7 @@ struct cpuset top_cpuset = {
 	.flags = BIT(CS_CPU_EXCLUSIVE) |
 		 BIT(CS_MEM_EXCLUSIVE) | BIT(CS_SCHED_LOAD_BALANCE),
 	.partition_root_state = PRS_ROOT,
+	.remote_sibling = LIST_HEAD_INIT(top_cpuset.remote_sibling),
 	.dl_bw_cpu = -1,
 };
 
@@ -1213,7 +1219,7 @@ static void reset_partition_data(struct cpuset *cs)
 
 static inline bool is_remote_partition(struct cpuset *cs)
 {
-	return cs->remote_partition;
+	return !list_empty(&cs->remote_sibling);
 }
 
 static inline bool is_local_partition(struct cpuset *cs)
@@ -1742,7 +1748,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 
 	spin_lock_irq(&callback_lock);
 	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
-	cs->remote_partition = true;
+	list_add(&cs->remote_sibling, &remote_children);
 	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
 	spin_unlock_irq(&callback_lock);
 	cpuset_force_rebuild();
@@ -1769,7 +1775,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 {
 	WARN_ON_ONCE(!is_remote_partition(cs));
 	spin_lock_irq(&callback_lock);
-	cs->remote_partition = false;
+	list_del_init(&cs->remote_sibling);
 	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
 	if (cs->prs_err)
 		cs->partition_root_state = -cs->partition_root_state;
@@ -3677,6 +3683,7 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_PTR(-ENOMEM);
 
 	__set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	INIT_LIST_HEAD(&cs->remote_sibling);
 	cpuset1_init(cs);
 
 	/* Set CS_MEMORY_MIGRATE for default hierarchy */
@@ -3920,6 +3927,7 @@ int __init cpuset_init(void)
 	cpumask_setall(top_cpuset.exclusive_cpus);
 	nodes_setall(top_cpuset.effective_mems);
 	init_llist_node(&top_cpuset.attach_node);
+	INIT_LIST_HEAD(&remote_children);
 
 	cpuset1_init(&top_cpuset);
 
-- 
2.56.0

