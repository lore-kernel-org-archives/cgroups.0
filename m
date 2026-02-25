Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB58352C4F;
	Wed, 25 Feb 2026 05:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995718; cv=none; b=EwrwlP3RdGSWDBsGQs1DLmE3wBftDU0FGBAqmTIw61zIGhSM0EQ9/F8/CD9LmcPNdvcJ65NcHw8IaAjfW+SxVWv1tsLByY1KkG50B27/TJW4euVYpAne6OBGGpE6Ty5Xk+E3H4DK5zWl5UCECmGPzogCO0jnLY7ZBjmdO94SVf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995718; c=relaxed/simple;
	bh=7C+2eeW18G+snzuLuyCK8MnITqHMQlxg0nUjU7/nskM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOtpSuncwQlMoR15UUZgksmVqAyrt9GssNfaU6EotLdMwIjL89brN/TFSC4tHNz8SPz0XRzfsGzoP2BFriwJAWbusAXz3RA6ijkLSrglw91QOr0yYX0hHfgihtUgUMsVR7UHgRwt0X+GsIQezAkbMrW5w/I1PvTSUg1HDyzk6F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aA01c65N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aA01c65N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B5DC19425;
	Wed, 25 Feb 2026 05:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995718;
	bh=7C+2eeW18G+snzuLuyCK8MnITqHMQlxg0nUjU7/nskM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA01c65N1QR2gQRYP5f/c4Pi7IGn/Pbg0Z7AC0Gf6Y8pm/qAsWKG9MDlYoc0NNvcT
	 /+6MF1eHQODPQU3Sr6XtBMUFhWSv13BbiChwfU3zLOis496qFcYqhvNTzNjWraVRQ1
	 n9mkGFSoAUeUimtAzKmqcl8Q81H/zCB/8c8BCR9mwUK60Yl/LPAjTWslza7tam4H9R
	 FB48GoHDhxN3NpxFBcVvh8s7IMkUlxX1XoQ+jtqnMOh8VsRsqnzxv6E69CfcSwJllP
	 SbdmGz9KLkH331qAv4FF29jTeBCVAEfU6pjU0VekGa6XsA2dvG9TUYg1M/O4veWPCP
	 Bq+THBvpBEJsA==
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
Subject: [PATCH 05/34] sched_ext: Update p->scx.disallow warning in scx_init_task()
Date: Tue, 24 Feb 2026 19:01:23 -1000
Message-ID: <20260225050152.1070601-6-tj@kernel.org>
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

- Always trigger the warning if p->scx.disallow is set for fork inits. There
  is no reason to set it during forks.

- Flip the positions of if/else arms to ease adding error conditions.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index edc88c1f744d..a136773461ea 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3028,7 +3028,10 @@ static int scx_init_task(struct task_struct *p, struct task_group *tg, bool fork
 	scx_set_task_state(p, SCX_TASK_INIT);
 
 	if (p->scx.disallow) {
-		if (!fork) {
+		if (unlikely(fork)) {
+			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] during fork",
+				  p->comm, p->pid);
+		} else {
 			struct rq *rq;
 			struct rq_flags rf;
 
@@ -3047,9 +3050,6 @@ static int scx_init_task(struct task_struct *p, struct task_group *tg, bool fork
 			}
 
 			task_rq_unlock(rq, p, &rf);
-		} else if (p->policy == SCHED_EXT) {
-			scx_error(sch, "ops.init_task() set task->scx.disallow for %s[%d] during fork",
-				  p->comm, p->pid);
 		}
 	}
 
-- 
2.53.0

