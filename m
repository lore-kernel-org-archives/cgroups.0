Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5417936F903
	for <cgroups@vger.kernel.org>; Thu, 25 Jun 2026 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782351619; cv=none; b=dl69oLH/P+sIe+WClpJOqvzMyKpqppPW0K6LaB4r3OW425k/Q7dv4N25sCQOKMh08Sk2Qpsw7TKjnxbyp0zV2EB6Q7jMRBKZts62NLjbptNzHcsaBL3a19GOuLNOJVN0BvcOxdp9B3b4dGWWcyI1Pd089exWz02MdxKg47P6srg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782351619; c=relaxed/simple;
	bh=fPhN981ckT3rUIhIn6KiI0pbCWI6O0di8aALFAO9cZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oc/OmhGj9rfYrSWzZXatPUV0yLhdroG3h8YGIvRZf2cmZ6T1t2K9X7/99VIHvPBidtrKyzTMID3hPTD+Uan/SKhxPTBOaIJRtyevGuGLhkQu1KL9zLi4/fcyO36JtotqL8PLI4tJ2WImijLpTxPFwlBvemairhyPRFZLQpFoRAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IGvAtgeP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IGvAtgeP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782351615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xGIrBsFuNOVmgLTC8zjUtqhGy8UPNF0ZVG8X2zk14ds=;
	b=IGvAtgePFLzTm91D7bWag3fvj2QlfaEO2Rnn4BA5c1jzVAt/1+hADMXFA+clpWqFVr+Vy2
	zFip62SLLNmjGLTuTWwcNCsjhbYnn6K/DO4BamsY7Gxabi7/Jm1REoOm4QvM36ds7Uf10o
	qFnJftJSMqq+9IHBqNdbYE9f1TmJFmo=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2] cgroup: Use data_race() for task->flags in task_css_set_check()
Date: Thu, 25 Jun 2026 09:39:44 +0800
Message-Id: <20260625013944.253318-1-guopeng.zhang@linux.dev>
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

This check is only part of the CONFIG_PROVE_RCU lockdep predicate. This
was found by KCSAN during fuzz testing. KCSAN can report a data race
when another task flag bit is updated concurrently. One report shows
pids_release() reading task->flags through task_css_set_check() while
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

tools/memory-model/Documentation/access-marking.txt recommends
data_race() for data-racy loads used only for diagnostic purposes. Use
data_race() here to mark the intended diagnostic-only access.

No functional change intended.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Changes in v2:
- Use data_race() instead of READ_ONCE() for the diagnostic-only
  CONFIG_PROVE_RCU predicate, as suggested by Tejun.
- Update the changelog to match access-marking.txt guidance.

 include/linux/cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f2aa46a4f871..b905208942bf 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -480,7 +480,7 @@ static inline void cgroup_unlock(void)
 		rcu_read_lock_sched_held() ||				\
 		lockdep_is_held(&cgroup_mutex) ||			\
 		lockdep_is_held(&css_set_lock) ||			\
-		((task)->flags & PF_EXITING) || (__c))
+		(data_race((task)->flags) & PF_EXITING) || (__c))
 #else
 #define task_css_set_check(task, __c)					\
 	rcu_dereference((task)->cgroups)
-- 
2.25.1
