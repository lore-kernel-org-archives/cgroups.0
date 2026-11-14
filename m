Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.65
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645133;
	b=cuuVflycjgAkOb3RtpLAvS66k35FkwAX15GiIC55mox3XO5gfLNmtNX2ZvZUN/77Jg/1
	 qg50ZnOYr5Ft0bXYhEybud9lt6RCIJkgDzjjJW7yV27hFyv2S/CAw6yEiQl4qzzZi5JV7
	 ytHZ1uzx8oqW+0DRws+nYcJMYjMcnewd2h3haKcVS03vBPCYaU2PEmRl8RzQl1zkOXN0+
	 VxgbAPg84vTBx4+rgPeyTgfLcjxcjzeSV4db/xZUX4qyyVVGYQ83UkzIBlNNiR41VmFrm
	 TJEDFeWID9grBHaWW+4oyMkOUL1cJs91Z9ANgxCX7WgEAj2mX6sBH6aNpjVDBE6cC2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645133;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z/1KRHnpy4WP7AIAeOnyvUZACqkAdqwB5MWEKSkwyLI=;
	b=ubDxscaXAqdbZ7cRq7o0LYkCbQfvt2cj/k3fH1uv3DjRC7WSt4HmfWlZ5EMWHfas77yz
	 JiUTwsbCQzAo+8fhsUiuFBH6XamO4Scykxs6CJKvQZVOiSn7YatUX5djXrSQO9R0ZN5U3
	 1PPk6alB1xMfWGVN9Ce94pJfRLS7LF04KpuG5BewVZlEMtRfKj5FUBGity9NbvCdQX2MZ
	 gYsYg1F7lG26jABIYXYAKr3ma+zT/ZvzHwOfz0ZNjjS+QVxO5BfCMVx66sdOsbfpkcICM
	 pXaB7G2lom9S5OLbTgVb9HE2MFyBybns5m30xQFDJHHLA0NBs2kLpyJGya5fEN9MxIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M3UsyoNw;
	arc=none smtp.remote-ip=95.215.58.65
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF392606A8A0
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF392606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M3UsyoNw
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OTpOHJopI81MGLoixnCiMqM8q5plRAu4FvsyYNM+aqo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645130; v=1; x=1795249930;
 b=M3UsyoNwWg879/f4A3t9Jv2UJiOmwBiVjJN1ewSN5JYY1UVWknstLOAytqS7lW4I8WoeNEAs
 0MX2alw69GmWI8wXEyHDKBsZq4Mt2mehCxAd9tXHwLkS2uU1p8ZimJXcUVpK4jbU9+YdEBJd4Sg
 6lx8nAyxJQ0vbwy1q7LL8K2Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8fe1d53c0f728473;
	Sat, 14 Nov 2026 08:32:10 +0000
X-Mizu-Trace-ID: 8fe1d53c0f728473
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 07/12] cpuset: introduce validate_local_partition()
Date: Sat, 14 Nov 2026 16:31:19 +0800
Message-Id: <20261114083124.1340140-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

Add validate_local_partition() to check the requirements of a local
partition in one place, so that local partition enablement and update
can share it:

1. The parent must be a valid partition root, otherwise PERR_INVPARENT
   or PERR_NOTPART is returned.
2. If both cpuset.cpus and cpuset.cpus.exclusive are empty, return
   PERR_CPUSEMPTY rather than reporting an invalid cpu list.
3. A root partition is not allowed under an isolated parent.
4. Optionally, the user exclusive CPUs must not overlap with any
   sibling. A valid partition has passed this check already, so it is
   only needed when an invalid partition is to become valid again.
5. validate_partition() for the common checks, including the
   housekeeping conflict and tasks_nocpu_error() checks.

It is marked __maybe_unused until local_partition_enable() starts to
use it in the next patch.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7a3e797aee52..78ca3c39c029 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1983,6 +1983,67 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	partition_disable(cs, -prs, cs->prs_err, tmp);
 }
 
+static bool is_user_xcpus_exclusive(struct cpuset *cs)
+{
+	struct cpuset *parent = parent_cs(cs);
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool exclusive = true;
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, parent) {
+		if (child == cs)
+			continue;
+		if (!cpusets_are_exclusive(cs, child)) {
+			exclusive = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return exclusive;
+}
+
+/**
+ * validate_local_partition - Validate for local partition
+ * @cs: Target cpuset to validate
+ * @new_prs: New partition root state to validate
+ * @excpus: New effective exclusive CPUs mask to validate
+ * @excl_check: Flag to enable exclusive CPUs ownership validation
+ * @tmp: Temporary masks
+ *
+ * Return: PERR_NONE if validation passes, appropriate error code otherwise
+ *
+ * Important: The caller must ensure that @cs's cpu mask is updated before
+ * invoking this function when exclusive CPU validation is required.
+ */
+static enum prs_errcode __maybe_unused
+validate_local_partition(struct cpuset *cs, int new_prs,
+			 struct cpumask *excpus, bool excl_check,
+			 struct tmpmasks *tmp)
+{
+	struct cpuset *parent = parent_cs(cs);
+
+	/* The parent must be a partition root */
+	if (!is_partition_valid(parent)) {
+		return is_partition_invalid(parent)
+			? PERR_INVPARENT : PERR_NOTPART;
+	}
+
+	/* Report the empty user cpumasks instead of an invalid cpu list */
+	if (cpumask_empty(excpus) && xcpus_empty(cs))
+		return PERR_CPUSEMPTY;
+
+	/* A root partition is not allowed under an isolated parent */
+	if (new_prs == PRS_ROOT && parent->partition_root_state == PRS_ISOLATED)
+		return PERR_ISOPARENT;
+
+	if (excl_check && !is_user_xcpus_exclusive(cs))
+		return PERR_NOTEXCL;
+
+	return validate_partition(cs, parent, new_prs, excpus,
+				  tmp ? tmp->delmask : NULL);
+}
+
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
-- 
2.34.1

