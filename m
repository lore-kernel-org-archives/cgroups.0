Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE44A99AD
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365826; cv=none; b=MqoH40DBeHoruBUx+kZMJTYAXzjqxt7rqDlwnP+267LH6Rchha3PcuOzT5ZO87BKfO55jRzgDsb2nhI77W9ODLlkawJXtfaLrW8T28SOFXyklQVAyDwWOag9m4Z+Ini7x7Q1LNZFHqOIyNv7XZL9wckh01Zkx5nZ6Sg30Mm5cLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365826; c=relaxed/simple;
	bh=MvzGmB5M3KwwWdgcRhErFJ3CEHCYccyXT8hULlFhA/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MM4E1V8jQY7MPpcB1ChL3QRVQI5TlGpB7PojrxBTZJeH79hRIDgXjwriwGsxDLcy8PMyATzKeXj/MG/Kh2B0Ri1ekofaVCiEqGA8+m+XIfJDm3J7UoiTiHDFhYNVRveJ9QMPzXqOjJRVkee0SwGfXT7byI6YJOS4cfcfwQbL3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZCZY9/ou; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZCZY9/ou"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495437bb891so231925e9.1
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788365818; x=1788970618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sNc40VDRvQIJSYaBEgVXINcg1PcRLw4VS1qTwcd8gXA=;
        b=ZCZY9/ou/3ZQ1uOggqaSdpB93HmQRbJRTe4gZ0gnpnKV5rY6XCz4kbZmWSCakOTnaK
         FjleICOVI4pe7Ob46yTbtz4lOX2P+Z8QAziRyB6a+zJc3dtr8e6bF2v8QT4jw8PvocOj
         pPoHBxIZ9mVIni2XWjxxgPudYgdLI1ZfrjzWvml9hqrxRk97uAsHOHlWjrV9bnQc7H16
         VE4qHTdz55y2H9D4scZZ1bAWPkh9tPn+uGM/RYZ9GH4m+IuiPUZuKGeUwrF96lmke7Qd
         PsJww4CRfPVn3UlUv/UaQGGXOvnFt0ggAEJ+bbfE2jmOySo17flwyfG3o++IETwhKWWc
         qM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788365818; x=1788970618;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sNc40VDRvQIJSYaBEgVXINcg1PcRLw4VS1qTwcd8gXA=;
        b=nQwVXdfQsY6B93hrm0+nLZX+vCf6ATVR75sgWMN3BCQfBbuOoGnDu8clOa64K3zWmr
         d6G2BASsysp7ZY+2XlkPCxlOjS6hDN9VIJbCt4uJJqjCXPTNzOlZ+dDMnMVL/53yHemL
         wBUPT0++QH00CUfD7EzDCJmDA21A+gZwRhIRzhFmdVL8RvjCI7I4t2GkRPvoD++NTLGA
         bE8AiapGLyN8+YUANxoYUnKzLUSilcvFdSDdppcI1713v5+ZgGqlVIAUuDgZ/luzV++g
         x0x5glUpN2Ibp0ppIwPNUPxHBm7U5dcD/5j9sHPMTdL1vY3FQ4Ri8RGAG/Q9Mgh+rm+I
         xCQQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMSqY0iwMcf7BxC6ySl/VvINvZwYZF+1I2PeyG/5C0eQYmeNQuizNaBm4bEtw8JNZ7kSK+YS0u@vger.kernel.org
X-Gm-Message-State: AFuF++lwx3xNIPWN3ZoRKn6Ocayxqo5mEc6InRjJdLuTJ+7ICMm3sjTk
	pdhlC/fVL5SGrESBIqJFjQYfvZqqDdL60j2yk+aNzlswHb0ZmtXaTloUyPAPIwd+npg=
X-Gm-Gg: AR+sD13GmajvpEGIGI4F6DyMvxEyT84dSiA3wBJL6AqFY+GsoqbnaB7Qy2dEVN/vQAk
	0oPKIpyOWrrjePk/1DdDj41Ws3x0DS/NHG3t+LV1I85Gfg+QfY/cJRHYzXrH2JGGYrXPMkE6VSw
	VM0zhSyAAsnBrfCCotBpl5Os4Azg0d8wPMqbbJLXhjXa7pK+nPrCPQGcL7p90iPmgfnyXjHWeHg
	nUxsHDf39w7Khi6qTG30WxAdh5qCnlKwWUszJ0LfqFi3XMAdQ+5DPaYOdzuAPEnQlcvWxEjbYJ5
	VHGJUj/x54FXUXRuXBtEBGnfUwZ6yTf78KfMTuEVl5AQlArNDTriILJjJYFyBeUW4pSLeAFln6B
	GRh9fNOxOCw8PrXf7ef9Se6y482bxMoo1I5h6wi0eBEASgRgpl6x09yrS0ubI2zVRzL+W6iJkJK
	nHjb6J2rbPv0xTSZtd/KDM/cwNGD7l1drViK50zZcBbFHt35g0DHw=
X-Received: by 2002:a05:600c:4745:b0:49c:ced9:ab7f with SMTP id 5b1f17b1804b1-49cee5f0dc7mr5346065e9.8.1788365817872;
        Wed, 02 Sep 2026 09:16:57 -0700 (PDT)
Received: from localhost.cz ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d1fa6sm2948395e9.1.2026.09.02.09.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 09:16:57 -0700 (PDT)
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To: Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dan Schatzberg <dschatzberg@meta.com>,
	Peter Zijlstra <peterz@infradead.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	stable@vger.kernel.org,
	Noah Elias Feldt <N.Feldt@mittwald.de>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] cgroup: Avoid iteration of dying tasks with zero refcount
Date: Wed,  2 Sep 2026 18:16:52 +0200
Message-ID: <20260902161653.1051794-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The commit 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from
cgroup_task_release() to cgroup_task_free()") extended the lifetime of
tasks on the dying_tasks list.
The iterators have provision to go through dying_tasks because of
dying threadgroup leaders or explicit CSS_TASK_ITER_WITH_DEAD, however,
it was expected that such tasks can obtain a new reference (that is
possible before cgroup_task_release()/put_task_struct_rcu_user()).
The tasks after cgroup_task_release() and before cgroup_task_free()
are subject to race when they may or may not have usage count > 0.
The iterator should not attempt to resurrect tasks whose usage count
dropped to zero. (When that happens, __put_task_struct_rcu_cb() is
already imminent and the returned task_struct would could be used
after free.)

As a band-aid, filter tasks returned from css_task_iter_next() only to
those that have positive usage count (whose reference's lifetime can be
extended).

Rough illustration of the possible race

  R (reader of cgroup.procs)         T (thread)                       L (group leader)
  ---------------------------------  -------------------------------- --------------------------------
                                                                      L exits, signal->live > 0
                                                                      cgroup_task_dead(L)
                                                                        css_set_skip_task_iters() // skips only cset->tasks
                                                                        list_add_tail(&L->cg_list, &cset->dying_tasks)
  css_task_iter_next()
    take css_set_lock
    css_task_iter_advance()
      leader && signal->live != 0
      => it->task_pos = &L->cg_list
                                     T exits
                                     --signal->live == 0
                                     release_task(T)
                                       cgroup_task_release(T)
                                       release_task(L) // zap_leader
                                         cgroup_task_release(L)
                                         put_task_struct_rcu_user(L)
                                         ...RCU...
                                         put_task_struct(L)
                                           L->usage = 0
                                           /* L still on dying_tasks */
                                           ...RCU...
                                           __put_task_struct(L)
    it->task_pos = &L->cg_list
    get_task_struct(L)
      => addition on 0
    drop css_set_lock
                                           cgroup_task_free(L)
                                             css_set_skip_task_iters() // dying skip comes too late
                                           free_task(L)
  cgroup_procs_show()
    task_pid_vnr(L)

cgroup_task_release() is not synced via css_set_lock hence the race
possibility. (I'm not 100% convinced about this LLM-assisted
interleaving, multiple css_task_iter_next() calls may be involved with
css_set_lock released.)

Fixes: 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgroup_task_free()")
Cc: stable@vger.kernel.org # v6.19+
Link: https://lists.debian.org/debian-kernel/2026/08/msg00220.html
Reported-by: Noah Elias Feldt <N.Feldt@mittwald.de>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
---
 kernel/cgroup/cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Salvatore,
I was able to trigger the issue with your reproducer on 7.1.8
(occassionally, not always). With the patch on top of v7.3-rc1, I cannot
reproduce it (different base though). If you can confirm that in your
env, it'd be good.

Thanks,
Michal

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c3a12fee7528f..112d68fe28778 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5303,10 +5303,13 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 	if (it->flags & CSS_TASK_ITER_SKIPPED)
 		css_task_iter_advance(it);
 
-	if (it->task_pos) {
+	while (it->task_pos && !it->cur_task) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);
-		get_task_struct(it->cur_task);
+		/* a task on dying_tasks with zero refcount is only valid for
+		 * RCU readers, not even interesting for
+		 * CSS_TASK_ITER_WITH_DEAD, find another one */
+		it->cur_task = tryget_task_struct(it->cur_task);
 		css_task_iter_advance(it);
 	}
 
-- 
2.55.0

