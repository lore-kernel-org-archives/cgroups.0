Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964719;
	b=ToSX4eDa+7v+cm2f56hQSEJ0NMlBWoVwRfPsn/r30lWeyc7Raql8cVX5rTfp/JvA/2ed
	 BkR56yqGCikyC2onGD3A6gVATEP+5So+VjE7202JLKpdMX/mIFyU0boaxdqafIYG8XuyV
	 OripW/zhxdTkRooGFYVqtfsFciJhXlq59zQrfusCCS89eEUX0HTvKfM/zDOAgRnv0saZf
	 Xt/E5ECDTMFak6oU8+7p3rzo5JEFPTsOJkZ7W19bXKczun6Bi490IIS7/miZ8ucWMWgNy
	 sVopt49/8sAkncxa3OqfyNBpsRW9QdTtUP8rc4vdqTjfcmeButN6TTCseBImul+LoVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964719;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=W5UJeqWKdhvJWW7HatC5Pdmdzd0n7euy7xkyD5spstc=;
	b=jbM/q3tVfs0tzF0/N8IqmQwuHENmy8U7FL/f2v4fARL9BGTyFOy7FHhrSpR5/U9+tfx6
	 qVW8dzNda1dvH0ClaLIzU31gf5A0pgalrxb5ckUXQjy4foNZwNTBNWz3t0MC8M16iWLlZ
	 AJRkemF63WsuAzlRNv5S9heG7Tb6WRLalUPvTQr7HUvnLmO+qf0WXdWc3zTDWM6kFPnbI
	 tO3qauwwgZO1pnpj5Dt64C1IYvx/UkJUvwOhnMxLt48B8ZAzn8yeeu+KsMgG3ZLThYBga
	 4nAktJ2An8IvP5dnhyeFb/yTAFiSKllALHd2OArSlCRaMxBPOxhD61wAn7wiCRlcGTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BI3JtXSI;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169D2606A327
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 169D2606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BI3JtXSI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W5UJeqWKdhvJWW7HatC5Pdmdzd0n7euy7xkyD5spstc=;
	b=BI3JtXSIk2vJMGrl5lglEpLtybubBj8fhBuE0tA7bFfg56joaA9453oVihRNCF/cnwlPMl
	KqvCPaWk7YgyKVRjMVoDsIfmoOhpA0++xNOSxpAZFuue/gOqLlTc606U1PFFNEQMDljYnT
	FabFbet/uMKduZJOHVu9hmsRHAJXvcA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-17bve2aoP8KfojjBkEyTkQ-1; Sun,
 25 Oct 2026 17:45:14 -0400
X-MC-Unique: 17bve2aoP8KfojjBkEyTkQ-1
X-Mimecast-MFC-AGG-ID: 17bve2aoP8KfojjBkEyTkQ_1792964713
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B84741955F71;
	Sun, 25 Oct 2026 21:45:12 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 02C7C195608A;
	Sun, 25 Oct 2026 21:45:10 +0000 (UTC)
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
Subject: [PATCH-next v3 01/11] cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition
Date: Sun, 25 Oct 2026 17:44:39 -0400
Message-ID: <20261025214449.310715-2-longman@redhat.com>
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

Address this corner case by adding a new isolated_cpus_release() helper
to replace the existing ancestor_partition() helper. This new helper
will search for the furthest isolated partition root ancestor to decide
if some or all of its isolated CPUs should be removed from isolated_cpus
and also perform the removal when appropriate.

The is_remote_partition() and is_local_partition() helpers are also
moved up so they can be used in earlier functions.

There are other pre-existing problems that will still prevent the
above test case to work correctly. These problems will be addressed in
subsequent patches.

Fixes: 46b885416c27 ("cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 104 +++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 51 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 585a982249ad..bbd44782d4bf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1257,6 +1257,16 @@ static void reset_partition_data(struct cpuset *cs)
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 }
 
+static inline bool is_remote_partition(struct cpuset *cs)
+{
+	return cs->remote_partition;
+}
+
+static inline bool is_local_partition(struct cpuset *cs)
+{
+	return is_partition_valid(cs) && !is_remote_partition(cs);
+}
+
 /* Return true if isolated_cpus changes. */
 static bool isolated_cpu_update(int new_prs, int cpu)
 {
@@ -1299,6 +1309,45 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
 		update_housekeeping = true;
 }
 
+/*
+ * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
+ * @cs: the current cpuset
+ * @xcpus: the set of effective xcpus to be considered for removal
+ *
+ * This function is called when an isolated partition is invalidated or when
+ * some of its effective xcpus are to be removed from isolated_cpus due to
+ * changes in parent cpuset. The given @xcpus must be modifiable as the function
+ * will update its value to determine the right set of CPUs to be removed.
+ */
+static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
+{
+	struct cpuset *ancestor = parent_cs(cs);
+	struct cpuset *iancestor = NULL;
+
+	/*
+	 * Search the furthest isolated partition root ancestor available
+	 * until top_cpuset or a remote partition root is hit.
+	 */
+	for (; ancestor; ancestor = parent_cs(ancestor)) {
+		if (ancestor->partition_root_state == PRS_ISOLATED)
+			iancestor = ancestor;
+		if (is_remote_partition(ancestor))
+			break;
+	}
+
+	/*
+	 * If a furthest isolated partition acnestor is found, use it to
+	 * determine which of the CPUs in @xcpus should be removed from
+	 * isolated_cpus. Otherwise, all of them will be removed.
+	 */
+	if (iancestor && !cpumask_andnot(xcpus, xcpus, iancestor->effective_xcpus))
+		return; /* No CPU should be removed from isolated_cpus */
+
+	spin_lock_irq(&callback_lock);
+	isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
+	spin_unlock_irq(&callback_lock);
+}
+
 /*
  * partition_xcpus_add - Add new exclusive CPUs to partition
  * @new_prs: new partition_root_state
@@ -1571,16 +1620,6 @@ static int compute_trialcs_excpus(struct cpuset *trialcs, struct cpuset *cs)
 	return rm_siblings_excl_cpus(parent, cs, excpus);
 }
 
-static inline bool is_remote_partition(struct cpuset *cs)
-{
-	return cs->remote_partition;
-}
-
-static inline bool is_local_partition(struct cpuset *cs)
-{
-	return is_partition_valid(cs) && !is_remote_partition(cs);
-}
-
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
@@ -2155,25 +2194,6 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
-/*
- * ancestor_partition - Find and return the closest valid partition root ancestor
- * @cs: the current cpuset
- *
- * Return: The closet partition root ancestor cpuset
- */
-static struct cpuset *ancestor_partition(struct cpuset *cs)
-{
-	struct cpuset *ancestor = parent_cs(cs);
-
-	/*
-	 * The top_cpuset is always a valid partition root which will stop
-	 * the loop if it is reached.
-	 */
-	while (!is_partition_valid(ancestor))
-		ancestor = parent_cs(ancestor);
-	return ancestor;
-}
-
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2267,7 +2287,6 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 */
 		if ((cp != cs) && old_prs) {
 			int parent_prs = parent->partition_root_state;
-			struct cpumask *del_cpus = NULL;
 
 			switch (parent_prs) {
 			case PRS_ROOT:
@@ -2281,32 +2300,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 				 * child partition roots become invalid too.
 				 *
 				 * For a to be invalidated isolated partition,
-				 * its isolated CPUs may or may not need to be
-				 * removed from isolated_cpus depending on if
-				 * its closest partition root ancestor is a root
-				 * or isolated partition. With a PRS_ISOLATED
-				 * ancestor, the CPUs are checked against its
-				 * effective xcpus to see if any of them needed
-				 * to be removed.
+				 * call return_isolated_cpus() to remove the
+				 * relevant CPUs from isolated_cpus.
 				 */
 				if (is_partition_valid(cp))
 					new_prs = -old_prs;
 
 				if (old_prs == PRS_ISOLATED) {
-					struct cpuset *ancestor = ancestor_partition(cp);
-
-					if (ancestor->partition_root_state == PRS_ROOT)
-						del_cpus = cp->effective_xcpus;
-					else if (cpumask_andnot(tmp->delmask,
-								cp->effective_xcpus,
-								ancestor->effective_xcpus))
-						del_cpus = tmp->delmask;
-
-					if (del_cpus) {
-						spin_lock_irq(&callback_lock);
-						isolated_cpus_update(old_prs, new_prs, del_cpus);
-						spin_unlock_irq(&callback_lock);
-					}
+					cpumask_copy(tmp->delmask, cp->effective_xcpus);
+					isolated_cpus_release(cp, tmp->delmask);
 				}
 				WRITE_ONCE(cp->prs_err,
 					   is_partition_invalid(parent)
-- 
2.56.0

