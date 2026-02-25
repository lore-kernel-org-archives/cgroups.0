Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1052D876B;
	Wed, 25 Feb 2026 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995674; cv=none; b=pZrYV3hX9kJJg4J/IXXOSzVMDedv0fy2GMuIQdqXQ4FpnMgJULXJuEmralFtFvwtkraYNOur/OHYbYvgZqk7Xu5FR/FitK6xcNKX76S0pVXoiFDadAY/TXEtpWjeqpfWrimUsAa1JZzqcSf+iGHIMFg76mkp/YE3iqPiLf4gzG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995674; c=relaxed/simple;
	bh=jUl6gnrkvDeq7jxlxPhGwDFU5y6TZIsFSFNiP3mvHJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kh+l6nP3+4LoOAmWQdn/d43U2l9FJ0B7GEJNqYgc9yU7ZXs3BwVJv7IYVnxvnUOz9B8KkSrqn8dMVvpgMTO2yX/tKQGkVMllG8xaEPk968N+bpdnp35DyksPU+/EWWXIWlmrLhN5SXOViA9NfpSYBtndr4DrsL3zaH1u4HE64t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnuI2kvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnuI2kvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9239C2BCAF;
	Wed, 25 Feb 2026 05:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995673;
	bh=jUl6gnrkvDeq7jxlxPhGwDFU5y6TZIsFSFNiP3mvHJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnuI2kvqDk68Fh80hgfXQfrUiD3IDeW7hwFMUzBkdO3VWhuRG9NAmgAjVcFo8iMIt
	 3KZnlHjFnPR+Dnqhc3L2FXbYK+l1RZgxmqnpoZaHEfieNk0x3VqNljApjWqz4bBMPA
	 fQuzwta2uBRCSetd2IQux1W/gJJ+2tX9jRR53ZNbQQMZQAqYJtT2vmbMSAI2AB+Li0
	 DcqLsvp+Ru0GZZwfOscJDZeZ5ANR+ArNb5urQPNcdpP0ZGCPOfzuCJSchzzM2Rfu4K
	 drexPtfbHzU0yMMtReGL4HhRWQqiGqXOOAMrNvZ6mufjHvGqX8pxGhyuXQBC2c5XbG
	 e2aHV+KAQfp9Q==
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
	Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 03/34] sched/core: Swap the order between sched_post_fork() and cgroup_post_fork()
Date: Tue, 24 Feb 2026 19:00:38 -1000
Message-ID: <20260225050109.1070059-4-tj@kernel.org>
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

The planned sched_ext cgroup sub-scheduler support needs the newly forked
task to be associated with its cgroup in its post_fork() hook. There is no
existing ordering requirement between the two now. Swap them and note the
new ordering requirement.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/fork.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..eb839b207cd4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2463,8 +2463,12 @@ __latent_entropy struct task_struct *copy_process(
 		fd_install(pidfd, pidfile);
 
 	proc_fork_connector(p);
-	sched_post_fork(p);
+	/*
+	 * sched_ext needs @p to be associated with its cgroup in its post_fork
+	 * hook. cgroup_post_fork() should come before sched_post_fork().
+	 */
 	cgroup_post_fork(p, args);
+	sched_post_fork(p);
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
-- 
2.53.0

