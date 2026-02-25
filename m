Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9077313E1A;
	Wed, 25 Feb 2026 05:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995695; cv=none; b=cPh3Q9FQmariIrx0ADm6AV9WA6vmoUusfNlqkIMn6ADyvvGMWvTosfSHQsDQbvs/DvByADsqAVSbx1xH/lRqlOPhHoCs3jaScSBbrlnrynK5n5iYDucTPUQ4h5wzPCEKoX2ieCxGj14B9CumMBItD4tyj/B2cmS3CrQVkrGK1jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995695; c=relaxed/simple;
	bh=KhOJxXjJ6O7tJ1Xlz2wkgxsoCbGBWHgNEEBYJDMSjtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bChkjXYA4jkhu+cPRlyTmJxz3h/0rnMlGsWp7cpfhfJBxOLxtn46W22vt4hveIVddJ1Q0P4d5WXzt8gzNqYPL8bOnnfL83Uq4wpuvEw57FZSPtm7eAbJBVlicfH7/5E1HGUb4DpTMYpS/c7ZSoa0BqoGR/U4P+f2EkwRSl16b5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qRKKhfXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRKKhfXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E601C116D0;
	Wed, 25 Feb 2026 05:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995695;
	bh=KhOJxXjJ6O7tJ1Xlz2wkgxsoCbGBWHgNEEBYJDMSjtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRKKhfXZZ2fdY2VVrAIj5GuNkf9OVauB0q7YkwecNHRGwaHxNdXJORge0nYaZ1p6c
	 Fx0iHTOUo7MN+y+9dVdmp/VLSyksALvG9VE70tgKTvTQCH7Gnl5PeOzlA6CAJR6vwr
	 Ubwwn+kYVI1aL3+VQoeGDeuHKiOib8Kr8FeTMdHkVfAeDk1cgXHMX6nojVW2ueC7z5
	 pQXYcurWi12qjkcaJ2r75wI+rjyCrNRp8GjWdvk3151Bnu6pGxyNZV4M32nPQbCpkT
	 1stZXsbyNOcUFzGkBdvyuctm1vL5oAzSJU21Id0Be5GObJGi8GjW+uDds1IdxcTy/k
	 a9BZE5Ho/lDiw==
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
Subject: [PATCH 24/34] sched_ext: Dispatch from all scx_sched instances
Date: Tue, 24 Feb 2026 19:00:59 -1000
Message-ID: <20260225050109.1070059-25-tj@kernel.org>
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

The cgroup sub-sched support involves invasive changes to many areas of
sched_ext. The overall scaffolding is now in place and the next step is
implementing sub-sched enable/disable.

To enable partial testing and verification, update balance_one() to
dispatch from all scx_sched instances until it finds a task to run. This
should keep scheduling working when sub-scheds are enabled with tasks on
them. This will be replaced by BPF-driven hierarchical operation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 5490bfd77c92..9551bfb0567b 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2520,7 +2520,7 @@ static bool scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 
 static int balance_one(struct rq *rq, struct task_struct *prev)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch = scx_root, *pos;
 	s32 cpu = cpu_of(rq);
 
 	lockdep_assert_rq_held(rq);
@@ -2564,9 +2564,13 @@ static int balance_one(struct rq *rq, struct task_struct *prev)
 	if (rq->scx.local_dsq.nr)
 		goto has_tasks;
 
-	/* dispatch @sch */
-	if (scx_dispatch_sched(sch, rq, prev))
-		goto has_tasks;
+	/*
+	 * TEMPORARY - Dispatch all scheds. This will be replaced by BPF-driven
+	 * hierarchical operation.
+	 */
+	list_for_each_entry_rcu(pos, &scx_sched_all, all)
+		if (scx_dispatch_sched(pos, rq, prev))
+			goto has_tasks;
 
 	/*
 	 * Didn't find another task to run. Keep running @prev unless
-- 
2.53.0

