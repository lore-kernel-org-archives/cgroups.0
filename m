Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792784786;
	b=JkN6jpgkOl0QgDGdnp5nz/CquRspA4b/nAl7FNHERMKBelHL5QbSIlReduOwz1lW4iIF
	 cneiYLUAuBFiJ2/gqbFu+Oja834jtiHd6zwE26aIbU1RRzmGRulvle99BTtZy4qGPdU9I
	 7hc0HLHUAOr5U9XWAU0dnn3Vjx5hq5UtJMFlQH8zxBkii6pbboRpn6gHoyscqxK4tX8kU
	 KDyw8e+KlcTvUF5XCwsdW5hf76ErKKvt/j87g9Oy+0OUOuOPaaPxJoaGq2v9hSD5+Mzvg
	 jlu97FdIdFp7X2EEJwCAwaEDwW0DCc98536nBChBeRC9RJu9+8IxYzi+AH6+FZ2UBVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792784786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=X4WY9OI7pRLoxyt5aowUMYA8CAEnFmKkD4+RrPyHHWM=;
	b=Hb6DjtcqOK+ZBwA2AUHAKLcLCjuK4TEyJM4HRfloNWdEesTESS59LM+B60aNLbaQtv/I
	 p6uYa0L2OmkybeTcG0LWl1BdXg9pIGQnJR6l3LsTp8IQfxCH71P6gKlswhfIovHVB1mEp
	 qLyF72zAKaDcfMvQLU90verrx7h2B1QwXcFBHkHzi/qK2QNlkg9ycj6zj1l/ZH26skO8i
	 FENT4CJJ5TcrSOew/ajX7bli9gabjVi/vMdzYhqbVb8s2jpCIcFBADHTGUpbVh/w1RL69
	 fk+zwNLiq8BUVFCFA4s5i+f5R/h//KcZfy564K3Sp5+XYf1ztdV7O+F5n/rAOMCy4Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fvvumnG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A235606A31A;
	Fri, 23 Oct 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fvvumnG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7271F01825;
	Fri, 23 Oct 2026 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792784785;
	bh=X4WY9OI7pRLoxyt5aowUMYA8CAEnFmKkD4+RrPyHHWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvvumnG3ZleVbIEXiRoKq9E8XZ+Ju9N+0l9GfK9cflJ1igDFyib5MgjenSPuthEHv
	 G8M0yNiQE5w4QvYSvtZrcAEfLKEQOKRzaMVH1a/LzrhzfqQxEnsTjUnavcMPIbI1hR
	 YkoijNECkZVMrj7GKaDmkQMtpmnHa+D+GZy2TDSYp7nl9rrym8Wnnd9d9a1EudjNSW
	 MHDQ6VBdgHaLvC/PwQ0SIny9JMJrmXq5gZ/soSVsCw72buySXJ0xt+Cfs3/LWVt27j
	 My7UtniMVmolRg5MxAr3vrGyggYEjl67nVz6vp0g+jgmRtei1oiN97ItbQ4dakJBt4
	 MBTOzDt9I6CYg==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Kir Kolyshkin <kolyshkin@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: don't kill migrated processes through their exiting threads
Date: Fri, 23 Oct 2026 15:46:23 -0400
Message-ID: <20261023194623.3566511-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6cfe7cba3720e25400118d43643e55a6@kernel.org>
References: <6cfe7cba3720e25400118d43643e55a6@kernel.org>
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

Since commit da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader"), __cgroup_kill() visits every thread in the cgroup and
sends SIGKILL with PIDTYPE_TGID, so each visited thread takes down its
whole thread group.

A thread that has started exiting can stay in a cgroup after its process
has been moved out of it. cgroup_migrate_add_task() skips PF_EXITING
tasks, and the thread is only unlinked by cgroup_task_dead() after its
final context switch. mm_release() clears the thread's clear_child_tid
word and wakes the joiner well before that, so pthread_join() can return
while the thread is still in the old cgroup.

If cgroup.kill is written in that window, __cgroup_kill() finds the
exiting thread and complete_signal() passes the group-wide SIGKILL on to
a live thread, killing a process that already left the cgroup. The cgroup
selftest test_stress.sh runs into this: test_cgcore_proc_migration()
joins its threads, moves itself back to the root cgroup, and cg_destroy()
falls back to cgroup.kill on the old cgroup when rmdir() fails with
EBUSY, so test_core kills itself. KernelCI has been reporting
"with_stress.sh: line 94: ... Killed" on several arm64 boards since the
commit reached linux-next.

Keep visiting every thread, but go back to sending SIGKILL to the thread
that was found. A SIGKILL sent to a live thread still kills its whole
thread group, so both cases fixed by that commit stay fixed, and
task_can_queue_signal() drops one sent to a thread that is already
exiting.

Fixes: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread group leader")
Link: https://lore.kernel.org/all/179272264722.329188.4773475583351189022@6e52bff8000c/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

da13e0e72a73 is in cgroup/for-7.4-fixes and not in mainline yet, so this
can also be folded into it. Skipping PF_EXITING tasks in the loop also
fixes it, if keeping PIDTYPE_TGID is preferred.

To reproduce without waiting for the race in test_stress.sh, fork a child
that moves itself into a cgroup, creates and joins a dozen threads, moves
back to the root cgroup and writes 1 to the old cgroup's cgroup.kill. A
thread doing mmap()/munmap() in a loop widens the window. In a 2 CPU KVM
guest running next-20261022, 436 of 20000 children killed themselves this
way, and none did with this patch. test_kill passes with and without it,
including the two tests added with da13e0e72a73.

 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index faccc793325e5..a284225f8dc95 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4313,7 +4313,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0

