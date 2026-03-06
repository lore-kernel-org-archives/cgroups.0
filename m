Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD3336EAA3
	for <cgroups@vger.kernel.org>; Fri,  6 Mar 2026 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772824960; cv=none; b=WBRPNf98dykB59/NxX2NKqDJMQpsouL2rvsKm6XWGwqzUDEBm8ecUglKQwtbP3/L0rakAcqzRdUTLlqPYXT2SvcZYFXSeQugx+hYrQxifEIUIm0YaiIk7w1OIGV+SGzJjjxUojrAdPJDuCZltbjrx2GhCU7LVgbDaRTbpq54ATg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772824960; c=relaxed/simple;
	bh=TEIn2leqPGGY/1DzdNb84U/JWY83T3pQBcY3iEc8ns8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=II1tykKz87txIJIFg6xDk4pCPL6YK0IGFUL7hpJecvHHMgeVVk2A5N/Ids3Qtuy8dSLNZt/iuOwDRHGXytE9R8Z8WMf8L3+AP0LMUmiPoDol01Ity3D8fYI9rTta4fKLlGkd/RkIk6dBl5MiBQbGVcoBbIn4rSLXZArbQfhHVbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CyyfKJ7Y; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fnrjYVl/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CyyfKJ7Y";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fnrjYVl/"
Date: Fri, 6 Mar 2026 20:22:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772824957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bg/3VweDR91D2OkPYV0QQ/7hasio9/b4QIBc3FqEk+k=;
	b=CyyfKJ7YmFw6jMkQ1ILSrZYDSRYa0Jz5HIGXD+7nMk5VfgBeBa8bJRPBLze11MHl4Exd+n
	WR2RdRjdtH5efHm2pHts6P3KUwfSicLtSCu6emZSZtSTDnip2dSwgcqkp7pnsI9Xlgvooj
	bxxw75uYoXqc8+XZ3X2ExGs6PxqUAYqgZofy+vuP3unaOx754J2RfpHvJpzdHpw1dbbkgS
	crTzaK934lCn8gajn7P3w4SbCZi9YSI2yDa9wwip4P99l1licBVgJ3mHNzPaRFzXmKzXzo
	6jHzJYKC+aWf33emKnlUNy/HrW/OURRuGyznIIKxzWSaKn+2c9CKes2DTDeASg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772824957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bg/3VweDR91D2OkPYV0QQ/7hasio9/b4QIBc3FqEk+k=;
	b=fnrjYVl/MPzFqV9Wm2LIcjACSL6VHCYcHntshRdltdCXiwVFdHx12/eZAg2qJePh23BbtW
	KMIcoG72blgn0fCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bert Karwatzki <spasswolf@web.de>
Subject: [PATCH v2] cgroup: Don't expose dead tasks in cgroup
Message-ID: <20260306192235.DY60tMnM@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Once a task exits it has its state set to TASK_DEAD and then it is
removed the cgroup it belonged to. The last step happens on the task
gets out of its last schedule() invocation and is delayed on PREEMPT_RT
due to locking constrains.

As a result it is possible to receive a pid via waitpid() of a task
which is still listed in cgroup.procs for the cgroup it belonged
to. This is something that systemd does not expect and as a result it
waits for its exit until a time out occurs.
This can also be reproduced on !PREEMPT_RT kernel with a significant
delay in do_exit() after exit_notify().

Hide the task from the output which have PF_EXITING set which is done
before the parent is notified. Keeping zombies with live threads
shouldn't break anything (suggested by Tejun).

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20260219164648.3014-1-spasswolf@web.de/
Tested-by: Bert Karwatzki <spasswolf@web.de>
Fixes: 9311e6c29b348 ("cgroup: Fix sleeping from invalid context warning on=
 PREEMPT_RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 v1=E2=80=A6v2: https://lore.kernel.org/all/20260302120738.6KkDipsR@linutro=
nix.de/
   - Close the race window filtering out PF_EXITING tasks instead.
   - Document the possible race window after it has been verified.

 kernel/cgroup/cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c22cda7766d84..eef01b80ec933 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5108,6 +5108,12 @@ static void css_task_iter_advance(struct css_task_it=
er *it)
 		return;
=20
 	task =3D list_entry(it->task_pos, struct task_struct, cg_list);
+	/*
+	 * Hide task which are exitting but not yet removed. Keep zombie
+	 * leaders with live threads visible.
+	 */
+	if ((task->flags & PF_EXITING) && !atomic_read(&task->signal->live))
+		goto repeat;
=20
 	if (it->flags & CSS_TASK_ITER_PROCS) {
 		/* if PROCS, skip over tasks which aren't group leaders */
--=20
2.53.0

