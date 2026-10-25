Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964738;
	b=V082nFSZntgUzlSimWxJtHwLfYSz0SkuImcO3AKIKKE1kXcDjOx2FgnPCmelKeKC983Y
	 jz69GGEQAE+j/tx9UIBRNqciKH3nfF20fLYX8DF5SJ4cQ32ZVD9zEDhqcjXrvn8plIe4L
	 ewZOOimJV7mfhWbG74Na1WQ4hN197FSaMPoYynYYNUOQrkf5x8zfYgawzUrB4Qg6ppJsX
	 91q/uzrIrpVBTj6v9ebC5h5cw8YLPZNS8l0RoTF7CDT1U4kCQtz1A8NZI0DHGTsxVg4nY
	 Z5wV0lcgfyekkg0ODXku8I4GDl56lBTijor6SUgcvCUbgoHsXuVM6XbhcZwaUkrsVsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964738;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=h6WFt3YgCI28ZNWC/npk7R81DtafYfyZIF2d5T26qik=;
	b=pj1XMCG95q7zRLX13OAs0LuLwgYTTGg7h9/1vKE0SWTVPxz7Yp3MVyzS+EHw1+cMRcS9
	 4/phC4dEHlWtCEYKiqH2p6totNPfyEy6OmPMhQVVhKR9ypr8yf45D3EkLZsszb1jahKj+
	 c5oc2yeKCnKJIEUXZYM5h0IwEY2KPLxhaxm9j+f6D6wa9/eWMakpdvKUFX+uqNJBcgUmc
	 67gMtidGrPol5n5JEsweKWFkKnzgCPFSKBmB/WBybGuYz+vhamnHbfl2mmBwPEDaIKEan
	 /faPz80HesfROwLDh+Mka7NDcoTfh1QUsfeyU2sHFPZrEL39l3gsXVFP+G6h8ntJ7Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i5PkXiMj;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC24606A329
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABC24606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=i5PkXiMj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h6WFt3YgCI28ZNWC/npk7R81DtafYfyZIF2d5T26qik=;
	b=i5PkXiMjvXRg08uTzeoC2urLUQ0FHmz2JPan4cWouLCyK55HdnRr8S6j69qagiHREqp9ri
	GoFtp+ABf9Sp1uaYE9TuIhMnPMzzwIV3XOe8SDBl2Vb/Mgi2O3vcK7nCO42xl39YMdgF9W
	BQB8OAx/UKws5ljUSpPcvBjsHLjej00=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-i4y57uZENj2umPOz3BSqEg-1; Sun,
 25 Oct 2026 17:45:33 -0400
X-MC-Unique: i4y57uZENj2umPOz3BSqEg-1
X-Mimecast-MFC-AGG-ID: i4y57uZENj2umPOz3BSqEg_1792964732
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E268C1955D93;
	Sun, 25 Oct 2026 21:45:31 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6462F1956087;
	Sun, 25 Oct 2026 21:45:30 +0000 (UTC)
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
Subject: [PATCH-next v3 11/11] cgroup/cpuset: Integrate compute_partition_effective_cpumask() into compute_effective_cpumask()
Date: Sun, 25 Oct 2026 17:44:49 -0400
Message-ID: <20261025214449.310715-12-longman@redhat.com>
In-Reply-To: <20261025214449.310715-1-longman@redhat.com>
References: <20261025214449.310715-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Update compute_effective_cpumask() to call
compute_partition_effective_cpumask() directly if the given cpuset is
a valid remote or local partition root. This simplifies the call sites
where they are being involved. No functional change is expected.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f37d929616a6..2598a0e2d667 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1606,8 +1606,6 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	struct cpuset *child;
 	bool populated = partition_is_populated(cs, NULL);
 
-	WARN_ON_ONCE(!is_partition_valid(cs));
-
 	/*
 	 * Check child partition roots to see if they should be invalidated
 	 * when all the effective_cpus will be used up and cs is populated.
@@ -1668,6 +1666,10 @@ static void compute_effective_cpumask(struct cpumask *new_cpus,
 {
 	bool has_cpus;
 
+	if (is_remote_partition(cs) ||
+	    (is_partition_valid(cs) && is_partition_valid(parent)))
+		return compute_partition_effective_cpumask(cs, new_cpus);
+
 	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
 	if (!has_cpus && is_in_v2_mode())
 		cpumask_copy(new_cpus, parent->effective_cpus);
@@ -2268,10 +2270,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			remote = (new_prs == old_prs);
 		}
 
-		if (remote || (is_partition_valid(parent) && is_partition_valid(cp)))
-			compute_partition_effective_cpumask(cp, tmp->new_cpus);
-		else
-			compute_effective_cpumask(tmp->new_cpus, cp, parent);
+		compute_effective_cpumask(tmp->new_cpus, cp, parent);
 
 		if (remote)
 			goto get_css;	/* Ready to update cpuset data */
@@ -2352,10 +2351,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			 */
 			new_prs = cp->partition_root_state;
 			if (new_prs != old_prs) {
-				if (new_prs > 0)
-					compute_partition_effective_cpumask(cp, tmp->new_cpus);
-				else
-					compute_effective_cpumask(tmp->new_cpus, cp, parent);
+				compute_effective_cpumask(tmp->new_cpus, cp, parent);
 			}
 		}
 
@@ -3987,7 +3983,6 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	static nodemask_t new_mems;
 	bool cpus_updated;
 	bool mems_updated;
-	bool remote;
 	int partcmd = -1;
 	struct cpuset *parent;
 
@@ -3999,21 +3994,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
-	/*
-	 * Compute effective_cpus for valid partition root, may invalidate
-	 * child partition roots if necessary.
-	 */
-	remote = is_remote_partition(cs);
-	if (remote || (is_partition_valid(cs) && is_partition_valid(parent)))
-		compute_partition_effective_cpumask(cs, &new_cpus);
-
-	if (remote && (cpumask_empty(subpartitions_cpus) ||
-			(cpumask_empty(&new_cpus) &&
-			 partition_is_populated(cs, NULL)))) {
+	if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
+				       (cpumask_empty(&new_cpus) &&
+					partition_is_populated(cs, NULL)))) {
 		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
-		remote = false;
 	}
 
 	/*
@@ -4039,10 +4025,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	if (partcmd >= 0) {
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
-		if (is_partition_valid(cs)) {
-			compute_partition_effective_cpumask(cs, &new_cpus);
-			cpuset_force_rebuild();
-		} else if (partcmd == partcmd_invalidate) {
+		if (is_partition_valid(cs) || (partcmd == partcmd_invalidate)) {
 			compute_effective_cpumask(&new_cpus, cs, parent);
 			cpuset_force_rebuild();
 		}
-- 
2.56.0

