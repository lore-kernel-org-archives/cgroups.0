Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8042D47F4
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 02:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782181807; cv=none; b=C8tGm7k0svvDtXhkh7XbIMUW6jIzXugzzX0E2TjWgPNTNYdbV4Kh81pk1lWKhQ6GK/HIb24Nk+WReKhyyHodreAWDHtvW8OLyiNEsIr2i2eIZuW+PeQ8z1vU3PCickBwS5AS0YIH+K480611iD6jlMCmRMG0Q4VSIZNaBWnPLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782181807; c=relaxed/simple;
	bh=zxXyeej4ZKaN0HsuyCoNR4Lk/nya5fqhPVDG1Ymxrj4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TlQ2LbDd1EHYCoIa5cnK9Gu69G0PG9I203H7RVztA11xLwRgtHxHaahZD1e6kN40aqETvfWLAm2sBZmS0F9EC9Q1IczPJgz613ADkEYfSFEUKQPNRSsBw33L7RE07f+VheQZUjNk8pgct7RVyM0gDcozWsUKH4Qu+OSIAH7aiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=enn/IsI/; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="enn/IsI/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782181804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mWGKirvZ5AUIVxGsMAqDNZZQE4VwpRYJ/mV7mG39AwE=;
	b=enn/IsI/ehr2hVpceDsPR4HP4Axod7dENbEzZXFmJ6lWpm9MyP7H7HSqWuYy12kBfNSyCf
	YcSb6XzHmfkMhYcigl5m4S7yXAt1DjZWqrWjlN6CnhCFAVPRGWx6srk88NK6TPncPxNFYk
	vB9jYi0Y2+zvqCxXHqUiHXiBat6llLE=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup: Use READ_ONCE() for task->flags in task_css_set_check()
Date: Tue, 23 Jun 2026 10:29:46 +0800
Message-Id: <20260623022946.525885-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

task_css_set_check() uses rcu_dereference_check() to verify that
task->cgroups can be dereferenced. One accepted condition is that the
task is already exiting, tested by checking PF_EXITING in task->flags.

This is a lockless snapshot used only for the CONFIG_PROVE_RCU debug
predicate. This was found by KCSAN during fuzz testing. KCSAN can report
a data race when another task flag bit is updated concurrently. One report
shows pids_release() reading task->flags through task_css_set_check() while
do_task_dead() sets PF_NOFREEZE:

  KCSAN: data-race in task_css() [inline]
  KCSAN: data-race in pids_release()

  task_css()
  pids_release()
  cgroup_release()
  release_task()
  wait_task_zombie()

  value changed: 0x0040004c -> 0x0040804c

The changed bit is PF_NOFREEZE, not PF_EXITING. PF_EXITING remains set
before and after the update, so the task_css_set_check() condition does
not change. This is not a race on task->cgroups and does not indicate
incorrect pids charging or uncharging.

Use READ_ONCE() to document the intended lockless snapshot of task->flags.

No functional change intended.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 include/linux/cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f2aa46a4f871..8afc4ec7f7a1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -480,7 +480,7 @@ static inline void cgroup_unlock(void)
 		rcu_read_lock_sched_held() ||				\
 		lockdep_is_held(&cgroup_mutex) ||			\
 		lockdep_is_held(&css_set_lock) ||			\
-		((task)->flags & PF_EXITING) || (__c))
+		(READ_ONCE((task)->flags) & PF_EXITING) || (__c))
 #else
 #define task_css_set_check(task, __c)					\
 	rcu_dereference((task)->cgroups)
-- 
2.25.1

