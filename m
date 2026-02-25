Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BB36C598;
	Wed, 25 Feb 2026 05:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995729; cv=none; b=q6Fo5IG2VuFre4VYS84/2BVc8IPCXsB++gwhmCLU9WMxUheEDYbsNVDzz1nOP33/XAGoVsboe9jieroGZmNzGfFCW0FXpc+KU5o3w7MXprPSNEc4KpZTHlJjVuGCTwciJB+PILjt6USUrFKAtk4P/yZYtCG39kJguhYJlq/9oyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995729; c=relaxed/simple;
	bh=78W9E5VoKOH0MhqlfJeeYcbnJzFOFRCC2/kU4D5M7bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH/UOOsXwov1yPs6tbN7ZMEGjKLBu+OwQgacrWRcBLJKx/5brqy8/r5HAs7UXYajF9M75sH8EcVN/DgOzNb/FgPKXtgfIh1AbbZ7xy68QrW0dbIGf3XnvZQLnIDUxAP6I5Q/h32APTgoIdTKQGZXVSVrxEnzOEOldR9X2dAJfaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLcKv4Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLcKv4Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89405C116D0;
	Wed, 25 Feb 2026 05:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995729;
	bh=78W9E5VoKOH0MhqlfJeeYcbnJzFOFRCC2/kU4D5M7bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLcKv4Twa+OuVxnMoeJqCrjMX+8ldUpwIamk4fNia9uCS6WG+rTUbK5ZjuFPh5zKc
	 r5NfDxODocEpxO3O2+0o9lKniPsW0GoUcRI1dmGNP47/4TzycQf5ql2kyDVq71TPft
	 8/HQu/iW1TeUhzNLtJQCUPQP/q2ndvpDUrecxZ7GNtSqYTL+8w25vm93NcH9SPSWoy
	 pCGq5wM42TTb4ZctfBW9bygfK89sJlj/MKhiKqG73iylec09IacU57OtYZf0w4oe1P
	 WXxeqc84m48ltkDv0SEqbD+cwP9lopqFh0SPKm9YujM9NwBJFMCxhErvbrvLcSF9mS
	 l/VUjL7Q6c/Ig==
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
	sched-ext@lists.linux.dev
Cc: void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	emil@etsalapatis.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/34] sched_ext: Make scx_prio_less() handle multiple schedulers
Date: Tue, 24 Feb 2026 19:01:32 -1000
Message-ID: <20260225050152.1070601-15-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225050152.1070601-1-tj@kernel.org>
References: <20260225050152.1070601-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call ops.core_sched_before() iff both tasks belong to the same scx_sched.
Otherwise, use timestamp based ordering.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 5d13b9b93249..3d46e6e125c7 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2805,16 +2805,17 @@ void ext_server_init(struct rq *rq)
 bool scx_prio_less(const struct task_struct *a, const struct task_struct *b,
 		   bool in_fi)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch_a = scx_task_sched(a);
+	struct scx_sched *sch_b = scx_task_sched(b);
 
 	/*
 	 * The const qualifiers are dropped from task_struct pointers when
 	 * calling ops.core_sched_before(). Accesses are controlled by the
 	 * verifier.
 	 */
-	if (SCX_HAS_OP(sch, core_sched_before) &&
+	if (sch_a == sch_b && SCX_HAS_OP(sch_a, core_sched_before) &&
 	    !scx_rq_bypassing(task_rq(a)))
-		return SCX_CALL_OP_2TASKS_RET(sch, SCX_KF_REST, core_sched_before,
+		return SCX_CALL_OP_2TASKS_RET(sch_a, SCX_KF_REST, core_sched_before,
 					      NULL,
 					      (struct task_struct *)a,
 					      (struct task_struct *)b);
-- 
2.53.0

