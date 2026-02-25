Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ECE2DECC2;
	Wed, 25 Feb 2026 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995676; cv=none; b=A6xg4Z5KgIWmZ/h0XyaVHAVCHg2NHc/QtZeFwVBZIqFrr6jGzKiRU1XcHRf7dvyQ0isH8v74/j2kqkHR5IngTGE2KqAPzMR0486IM77Wj5BmLMXqbvaDwk5qj+lDScm9y2Luvb6FKCc+4cflMwEaeRRpiRybLvbt/M4z4ROHH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995676; c=relaxed/simple;
	bh=7C+2eeW18G+snzuLuyCK8MnITqHMQlxg0nUjU7/nskM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjqLJJ34JJD75oEUOcDyWSGEtE6nfLUYWwLdN5E6f2voQnRtK+uQaLbZkPuIO+psJFBhjtOomKLOMPy5iM/Tq8LKxyd0Ht9ym5qt1+eAsMRkEbzFiQx11uUAKpKFBVm/iNNR+mbrX9dbRvzSiQbb1hnscoG0gQ6ueuhFdToUhXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nW59cA9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nW59cA9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7DAC116D0;
	Wed, 25 Feb 2026 05:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995676;
	bh=7C+2eeW18G+snzuLuyCK8MnITqHMQlxg0nUjU7/nskM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW59cA9y7ZDOGFLlEJf5YBu60jBnaQrFvAovOKDB+R5WD1ikQ4+75YCpWvLiY4Uth
	 1EM9NuzrlqIY4zz2M9r8edste6/pZyszM2w4hLQhsyQw7H8ouuYnzFEu5GyxBaiI3B
	 Hzw0KJUj79s/HYUWegBD65JTZBrXlQ8TMNEzBxQ0RITNsbMCPP5S/qkM6ed1pMCRQN
	 Bxra653khnAJSiH28QG8mpvPcjYzw4A3ZZj7axQY/LWa7zRGNBLZLNzljzMo5lpmjH
	 wcwW9RZDQcxenawqiPbo9LZClhhktHmTz2fWjm1dN0ID2kodIv8K7dp/GiImKZvO31
	 Ey9zdBgZ/dAdw==
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
Date: Tue, 24 Feb 2026 19:00:40 -1000
Message-ID: <20260225050109.1070059-6-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225050109.1070059-1-tj@kernel.org>
References: <20260225050109.1070059-1-tj@kernel.org>
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

