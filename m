Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB235C68C
	for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792361102; cv=none; b=c6vTBQXrc/cwNPn30jgXsaNdyveEZG9y4rId/5aXE85WxwEKuGim+PklCXrPCNCao+WkYC5F97U4SNXvOvVOokpGR1wiB31iNay6l3YkcnHegYo+dyxGNMJmRrWxWHAha0MERGKGj+YtT0+Zb6TjSe6+pgI8M80GmR6BIcyAGS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792361102; c=relaxed/simple;
	bh=1o5z+qlLCr6WNpmebs43isCJRcBKwDf+btaUTUGqPuo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=khUwfAQHS3IGSXNleUtJ4e2n3vC15+ZuJpD6XkUkGnKPR1wgrLLAyyItNKfULBlZeYtQ+1slLJn2Su+ovKAqkAE2hHfc6gduf64pjRmE8KwCbOKVQCCJfHavXibvLdWZAVvn04fhWgFv3zkUd8cQvXHmVE2v2bgD8l6nmAE8HNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ar4w6/l3; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ar4w6/l3"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd67cc518a6so327835a12.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 15:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792361100; x=1792965900; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t+DBlUmYYanLk/fUhQLoMO5TIIqVDKMx0kXtXYJ5c+o=;
        b=ar4w6/l340RLtGsbX4M1KFY1vgPAR8qdXLhDTq366U4TSgT5qeobV5T1X9jMad4O1Z
         Z7VBZtr9tUrD+XvLlZtq9c+JFROkJeQfBt2lv4BzZZS19j8/0bZstbFBazEuPo+DaKUq
         jdLA4IF96bEDODNAses2J+HBLGIx0jLHmoMrb3EhmGRCx+ed5xBSVm28afpBPxMwNJbG
         mLweIFgAFRn9OrEa+95TrwjKFt71DH7lKdLpkLlMixAaBaJJ0E1vC30lXWC5tQMJghMB
         epIYZeXGRwET7OhvMjh+gDMp2E0M7wigMF2lzBJaXgYibd2pC/9B8QoxGmJxu8iKtgc6
         ah6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792361100; x=1792965900;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+DBlUmYYanLk/fUhQLoMO5TIIqVDKMx0kXtXYJ5c+o=;
        b=rphSmCsGhweR9b1KJdfEkU1v0bfHuUVMgc8PQJQpkMNBnaiUywvsuaSobjHyhq0Tpi
         XtAjJrVHl+SzjBo7RQ479Rp355Oyefi5TbTlagsOPp5H5397wls6MqANW0l4WAbdXcgg
         wws9e7ejgmQN2ZD7TT5dZe2QxSl/h2aFZvrlD5bCTCmxslgZ1kcsu9nLm4VJXXJd/zO/
         ZdihSh0aZeG8tz2UoIXgwGvsi7RtLY4eSiYIHT04FN0d2lXr5lRLbPJGzvEhMHeC8CJd
         NJqzqOHsql06H1RB/POD0mR6U/dnk3T2aimxmd+JrrO07lwi086DuQ4QmEiWSeb5od6o
         U++w==
X-Forwarded-Encrypted: i=1; AKwUvBwPIi0NfUqjZ/SHnoBudlzBTVnAwvHKRoYJVXrXsyFz3YnPgGEFq33/Kkk5lArNhOSoLna/zBz3@vger.kernel.org
X-Gm-Message-State: AFq9FYKDTvED/gQUwqvSLhIlVE31UdVaGKZwnHSlDBh9rqWrTWbPpb/c
	VAtOWD4anKpJ+E04611PtzzS7e55+jJrVPKRwp759GwBSnWCbwZmnCI/
X-Gm-Gg: AYBFou2uoR2RyT9Mem570HzOgYM+ScUDjmE4ng4OqrfEgR/Xu5upkcVMmwcL5iIwIM5
	2kZqqJeddIvW0P8huIih7cIwVvYChM2drK/cJoshfOs9xKZImXSOCnm1UMVtIDyOwT22/Qm/jdI
	m2Yv9+X5Cl9DnDQ7SKYJdclDRQlk4gZC+qXimkUJX6NcqlRuJ9bC0vq4LNfrGyVgJxLYb+NsjjC
	MokqEj+twAPpvYvUH0phm2qZFhbxGVIiNd8mmqmHNUROxFB3LDC9vH28YtX+grycOyvqVg0DnfA
	5uPO8Ho06Yvz787ddLClV/SUsEPpNeMpcV3CEO2BUZSbR/3/Vb+BCTp5IK7qq8FPLojap0MWqNC
	M8/EFDiu5dnwvKWsO67BBxn/+zkSvzjBNoFY6Gm7A6qODSGDWgPiKwupmNOCypKdnOEmih5Qc23
	fhaM6AzQOxXdUvPRmunPZVD3ScUt80QtyNmFBJPvV+cWMfDG+SJJIC4RJfGpYyD9dU6FBE0YOsk
	okXttrj
X-Received: by 2002:a17:90b:1d50:b0:3ab:c80:9370 with SMTP id 98e67ed59e1d1-3aceeb95f5dmr3676275a91.20.1792361100224;
        Sun, 18 Oct 2026 15:05:00 -0700 (PDT)
Received: from [10.1.2.130] ([67.185.120.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e72c6sm17718271a91.5.2026.10.18.15.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 15:04:59 -0700 (PDT)
From: Kir Kolyshkin <kolyshkin@gmail.com>
Date: Sun, 18 Oct 2026 15:04:39 -0700
Subject: [PATCH 1/2] cgroup: fix cgroup.kill for exited thread group leader
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261018-cgroup-kill-exited-leader-v1-1-c71ad94c20cc@gmail.com>
References: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
In-Reply-To: <20261018-cgroup-kill-exited-leader-v1-0-c71ad94c20cc@gmail.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Serge Hallyn <serge@hallyn.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, 
 Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Kir Kolyshkin <kolyshkin@gmail.com>
X-Mailer: b4 0.14.3

cgroup.kill does not work in case a process' thread group leader is gone
but other threads are still running. This is because __cgroup_kill()
only walks the thread group leaders and sends SIGKILL to each of them
with send_sig(), which uses PIDTYPE_PID:

1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
   the process has live threads, but a signal directed at a single
   exiting task never takes effect: complete_signal() does not look for
   another thread to deliver it to, and __send_signal_locked() now drops
   it altogether.  The process keeps running.

2. The live threads of such a process can be migrated to another cgroup
   by writing any of their IDs to cgroup.procs, while the exited leader
   stays behind.  The destination cgroup has no thread group leader to
   iterate, so writing to its cgroup.kill does nothing at all.

In both cases the cgroup stays populated after cgroup.kill, and a
process inside a container can use this to survive the container being
killed.  This also works with a private PID namespace when the init of
the container is the process, as the PID namespace is not torn down
while init has live threads.

Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instead
of send_sig(), so that the signal is taken by a live thread even if the
task found by the iterator is exiting. Note it was pointed out by Eric
in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
switch to it, but the change was only made in cgroup_post_fork(),
leaving __cgroup_kill() with send_sig().

Case 2 can only be fixed by iterating over all threads, so this is what
the fix also does. Once a thread group is being killed, its other
threads are skipped since they already have a fatal signal pending.

I ran some performance checks and the added cost is ~60 ns per every
thread on my laptop (and less than a millisecond for 10K threads),
which seems low. The time to "populated 0" seems unchanged.

The issue was found in crun by Anthropic's OSS Scanner, and crun is
getting a workaround for it [2] (which does what we needed to do
before cgroup.kill was added).

[1] https://lore.kernel.org/all/m1v97x6niq.fsf@fess.ebiederm.org/
[2] https://github.com/containers/crun/pull/2351

Fixes: 661ee6280931 ("cgroup: introduce cgroup.kill")
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca5..efb7923f0c92 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4289,7 +4289,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
-	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
+	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);
 	while ((task = css_task_iter_next(&it))) {
 		/* Ignore kernel threads here. */
 		if (task->flags & PF_KTHREAD)
@@ -4299,7 +4299,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		send_sig(SIGKILL, task, 0);
+		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
 	}
 	css_task_iter_end(&it);
 }

-- 
2.55.0

