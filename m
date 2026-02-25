Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B5376475;
	Wed, 25 Feb 2026 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995737; cv=none; b=oav/aSX6giIdKx0KE9kTyp0BO+13UZYUid7rduAKrUHoMB4Mkc6eJ2zRDTzUU6mpPDkY4ytJZnslyMZmWN+nNBlkHH8rWVyUkWHHCHPWLuBa+HBnvfmsiG1h7rVf0Hwjw9VqXnBFt98lpj9fAQy6CseYCefx89QFw9gSeP2bHak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995737; c=relaxed/simple;
	bh=3/mKhjAXqvZ0FAsZItI7vRYMA/HK0yR/LO3DfP+GPhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8CfmHyiih4dm5uUHQKF95fFi0hddpRy38b/adVgDuXft+d47OHukJ1ptHyAJoMKzR716gNuyjuwJIsvmgjgurbggxUnwKJ+x8w17oHKnV7jeDHdO+Ta9KNmWua6YAO53HZ5UxuIwDkqAHdEwjSV92SqBysG/2YbtizQmofF6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX5YaxZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX5YaxZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2694C116D0;
	Wed, 25 Feb 2026 05:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995737;
	bh=3/mKhjAXqvZ0FAsZItI7vRYMA/HK0yR/LO3DfP+GPhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX5YaxZX6WOFfrKqS5G7xyzW+RVOoldN8iQmj/+2+VUI1Zyyo7EkD854Mv2uNo2uI
	 UDIiyhmU3FVaO9yGCxWdewPWcYthJp54VFGnREMB/Q6ZSk4qxv3g3RaA2c7/ggq2A6
	 eSjb4NXImj7mW4tNey2e0y1ad1A17iMRvtdWVbux5gd+jreI2Wp6RxuVgDhVy0URYf
	 AdzpfzJfgcKG8Td/JHiqnir7qssHL2lr70LvPueKiWyzp53uM/3J67LXY7q8XMvKSc
	 0Ye0hjfkQ786sROC8kNJottKjdIJZtRftlC1e2lAzsCBfYzQPLU6MdSqDzgId9horR
	 FAxlwvCeU936w==
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
Subject: [PATCH 21/34] sched_ext: When calling ops.dispatch() @prev must be on the same scx_sched
Date: Tue, 24 Feb 2026 19:01:39 -1000
Message-ID: <20260225050152.1070601-22-tj@kernel.org>
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

The @prev parameter passed into ops.dispatch() is expected to be on the
same sched. Passing in @prev which isn't on the sched can spuriously
trigger failures that can kill the scheduler. Pass in @prev iff it's on
the same sched.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 99ef2a1cc3ac..ed1491df0829 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2388,9 +2388,10 @@ static bool scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 			       struct task_struct *prev)
 {
 	struct scx_dsp_ctx *dspc = this_cpu_ptr(scx_dsp_ctx);
-	bool prev_on_scx = prev->sched_class == &ext_sched_class;
 	int nr_loops = SCX_DSP_MAX_LOOPS;
 	s32 cpu = cpu_of(rq);
+	bool prev_on_sch = (prev->sched_class == &ext_sched_class) &&
+		sch == rcu_access_pointer(prev->scx.sched);
 
 	if (consume_global_dsq(sch, rq))
 		return true;
@@ -2414,7 +2415,7 @@ static bool scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 		dspc->nr_tasks = 0;
 
 		SCX_CALL_OP(sch, SCX_KF_DISPATCH, dispatch, rq, cpu,
-			    prev_on_scx ? prev : NULL);
+			    prev_on_sch ? prev : NULL);
 
 		flush_dispatch_buf(sch, rq);
 
-- 
2.53.0

