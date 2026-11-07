Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794052914;
	b=Xt6pPN7Hg4giXel1f09x0DaF2iRrBHAAHHhiW3skvMUaAQlF3d9T2TI9jxCdDxa9VfH7
	 MBkM1zmkZTS5oL7dbpFyDJ2yvGmJ+WX6Oe1JidSlDEYn0TZ6k5ZVym9MKx1IAagTh0c9X
	 31bn1Izm+5D4fvujmv7NB4PV6npoh7+VZ4y/SKhUkY7sl1qeI3l38hN2habII08RjGGjT
	 km5S5linQkKvwG28H7H4oK9driX62mZ813yQCfjHBYWgHnQoK1BN1Ro/FRmo0+rrk1bhX
	 otTfd/enWTWJuchjxZXirMD3OjOxGL7WNkxW0bCefcUR6PZ0xSkU93nx9N5V3O9KNYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794052914;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4zXJHQrOof0QrjWFfp5nGXwh4AGVmyErckIk52+Cn9s=;
	b=BU1602Tdck3bCPNmX7l/QbxrsKhXDl+8SEVihBOsmRjrrVFFdSPnQFhiFH8hb+IEuv4w
	 f9y2/cXTdoX4yoqVXLCUsqAKdehGYkbHstmzMddZDuq3oPe4xQEt8TkaGGgxpHgFqXWZW
	 1FjKuc9W5u3kaufDvQEIS7D2zpTfcLn/eu2K+KDN04OBJ8BSKKcoxIl/5DCUZXlirWoJ3
	 tt2vi/nVDtTkUhERz4UnYEDse2/6ypgs5JC9dscfKn12KHxgiXEal3gL4Xn1XPowZhH/a
	 Ms2UiyRaWxjPJ60AKOK2W2saCkIIm8J7nL494JrYjsLe7CxVIHX60zkyJlqc94+RiLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZZrQkawp;
	arc=none smtp.remote-ip=95.215.58.200
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D3E606A32E
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 12:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48D3E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZZrQkawp
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vAZ9OUTa+eKHvjwIo0KlOg3LlEN03u/TWfSnTIragIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794052911; v=1; x=1794657711;
 b=ZZrQkawpuXCB8RrYIYXcpvSAj2uFXqXn5NjG+6WG2ix6xOnRNhWrDEzZrhjmpBahWc/1QK+H
 hTApi6WcjkgGiZywYM0BAnWEyNKTko3tEoWhL9Jdhz70ufdOPQQG8ZJdUXKbEblOdvkkzMjjGYX
 s0u2N1h+p5O/3eouyctP9ExY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a904f9a92c43d5ef;
	Sat, 07 Nov 2026 12:01:51 +0000
X-Mizu-Trace-ID: a904f9a92c43d5ef
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 4/4] cpuset: generalize the validate_partition() interface
Date: Sat,  7 Nov 2026 20:01:00 +0800
Message-Id: <20261107120100.3587595-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107120100.3587595-1-ridong.chen@linux.dev>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
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

From: Chen Ridong <chenridong@huawei.com>

Refactor validate_partition() to take the parent partition, the new
partition root state, the new effective exclusive CPUs and the CPUs to
be deleted, instead of a trial cpuset. A NULL parent stands for a
remote partition, whose CPUs come from top_cpuset. This makes the
interface flexible enough to handle both local and remote partition
validation.

The no CPU left for tasks check now uses the given parent instead of
parent_cs(cs), and top_cpuset for a remote partition, as that is where
its CPUs are taken from. The cgroup parent of a remote partition does
not give it any CPU.

The housekeeping conflict check is folded into validate_partition(). It
is skipped when the parent is not a valid partition root, as @cs can't
be a valid local partition in that case.

Use the new interface for local partition enablement in
update_parent_effective_cpumask() and in partition_cpus_change(),
replacing the open-coded checks there. The order of the checks is now
the same for both paths: empty CPUs, housekeeping conflict, then no CPU
left for tasks.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 119 ++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 60 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fc9de6e16ff5..0ec20412b3ce 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1414,6 +1414,48 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	return res;
 }
 
+/**
+ * validate_partition - Validate a cpuset partition configuration
+ * @cs: The cpuset to validate
+ * @parent: Parent partition of @cs, NULL for remote partition
+ * @new_prs: The proposed new partition root state
+ * @new_excpus: The new effective exclusive CPUs mask to validate
+ * @del: exclusive CPUs to be deleted from @cs, can be NULL
+ *
+ * A remote partition gets its CPUs from top_cpuset, so top_cpuset is used
+ * as the parent when @parent is NULL.
+ *
+ * The housekeeping check is skipped if @parent is not a valid partition
+ * root as @cs can't be a valid local partition in that case.
+ *
+ * Return: PRS error code (0 if valid, non-zero error code if invalid)
+ */
+static enum prs_errcode validate_partition(struct cpuset *cs,
+					   struct cpuset *parent, int new_prs,
+					   struct cpumask *new_excpus,
+					   struct cpumask *del)
+{
+	int parent_prs;
+
+	if (new_prs == PRS_MEMBER)
+		return PERR_NONE;
+
+	if (cpumask_empty(new_excpus))
+		return PERR_INVCPUS;
+
+	if (!parent)
+		parent = &top_cpuset;
+	parent_prs = parent->partition_root_state;
+	if (parent_prs > 0 &&
+	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
+		return PERR_HKEEPING;
+
+	if (tasks_nocpu_error(parent, cs, new_excpus))
+		return PERR_NOCPUS;
+
+	return PERR_NONE;
+}
+
 /*
  * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
  *
@@ -1934,18 +1976,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 
-		/*
-		 * Enabling partition root is not allowed if its
-		 * effective_xcpus is empty.
-		 */
-		if (cpumask_empty(tmp->delmask))
-			return PERR_INVCPUS;
-
-		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
-			return PERR_HKEEPING;
-
-		if (nocpu)
-			return PERR_NOCPUS;
+		part_error = validate_partition(cs, parent, new_prs,
+						tmp->delmask, NULL);
+		if (part_error)
+			return part_error;
 
 		/*
 		 * This function will only be called when all the preliminary
@@ -2424,32 +2458,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
 	return 0;
 }
 
-/**
- * validate_partition - Validate a cpuset partition configuration
- * @cs: The cpuset to validate
- * @trialcs: The trial cpuset containing proposed configuration changes
- *
- * If any validation check fails, the appropriate error code is set in the
- * cpuset's prs_err field.
- *
- * Return: PRS error code (0 if valid, non-zero error code if invalid)
- */
-static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
-{
-	struct cpuset *parent = parent_cs(cs);
-
-	if (cs_is_member(trialcs))
-		return PERR_NONE;
-
-	if (cpumask_empty(trialcs->effective_xcpus))
-		return PERR_INVCPUS;
-
-	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
-		return PERR_NOCPUS;
-
-	return PERR_NONE;
-}
-
 /**
  * partition_cpus_change - Handle partition state changes due to CPU mask updates
  * @cs: The target cpuset being modified
@@ -2463,33 +2471,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
-	int parent_prs = is_remote_partition(cs)
-		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
 
 	if (cs_is_member(cs))
 		return;
 
-	prs_err = validate_partition(cs, trialcs);
-	if (!prs_err && (parent_prs > 0) &&
-	    !cpumask_empty(trialcs->effective_xcpus)) {
-		int prs = cs->partition_root_state;
-
-		/*
-		 * Check for housekeeping conflict by passing the whole
-		 * effective_xcpus as well as those CPUs that are to be
-		 * removed from cs as delmask.
-		 */
-		if (prs > 0)
-			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
-				       trialcs->effective_xcpus);
-		else
-			cpumask_clear(tmp->delmask);
-
-		if (prstate_housekeeping_conflict(prs, parent_prs,
-						  trialcs->effective_xcpus, tmp->delmask))
-			prs_err = PERR_HKEEPING;
-	}
+	/*
+	 * Check for housekeeping conflict by passing the whole
+	 * effective_xcpus as well as those CPUs that are to be
+	 * removed from cs as delmask.
+	 */
+	if (is_partition_valid(cs))
+		cpumask_andnot(tmp->delmask, cs->effective_xcpus,
+			       trialcs->effective_xcpus);
+	else
+		cpumask_clear(tmp->delmask);
 
+	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
+				     trialcs->effective_xcpus, tmp->delmask);
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
-- 
2.34.1

