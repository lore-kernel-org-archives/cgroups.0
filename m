Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468687;
	b=3EEibH38m85yPDxLge091rVyTGtYtmlmyMVAyzKqJIdOYgBjn8fd7PeXX7vSwnPYdzp7
	 3MLdXnyza+reoIPlwSih97XDLKYc54G3lzbOaHVVdl5ch54RDMdKfUn+9mIMDuKUjCeeZ
	 kjf1pXUzkMuZO6fps5GhkViS78wlm2wCNEvz52KfDNMhDvKqpp3M8JC6gxN+FHmFM9cgK
	 85Iu8Al0kLRRFapcnlvdCxPoP3LLmpaNdLFItI1Of2zt3gDz71CDsWMIXRdB+RpCCZJQW
	 hS/o7Qw8TNPaXqOBW3ZQPHr364MJs3FS/xXNjj9vwFlkJyw7lZt3cabV8GBKk3o8Hmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468687;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n7phiI5MOCuSreoAbHviRAlrFOddERLDGFoxihWgBaM=;
	b=tmU7eS6axhocol/W45bqv8wL0f794muxgwhAfGCV6+JWVc8uS7dHhnY0qa0HuyI3IgOq
	 dv29RXUfDSiXXy098gKuiliwsECFSXWO/Z3G+9ME1gq324340ymSuDs3hVu0PUWGkJHky
	 1Wki3bV4hulKC4PP1jfkoAzWltg/tbyEuT2N6nbJbYmL7Yc6zBOvJhxruYZbnRG24Ho52
	 3GuUnsGVnApatot7MMLpA1TeLy9U35r2+AJxt9Tmo/1SvceLFXFqMNhNO33Jg8jcKZvXu
	 4ygradSSCPNaIjOIX8CxJGtMi3XtJWOX90WenFnK/ZbwFHk2Sz1KAWRvgXmuIhv0qxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Qhed/2Do";
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378B9606A319
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 03:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 378B9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Qhed/2Do
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ab4178ee33so2100318a91.3
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 20:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792468686; x=1793073486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n7phiI5MOCuSreoAbHviRAlrFOddERLDGFoxihWgBaM=;
        b=Qhed/2Do9ugJEXNgKxu7Hm7bSamTvJz1kIX3kAef0kC0/YZommCRdCUhZToELUbO/f
         ucrsQ0yUiKJEgRCaU6Pke3dG34JJRow44MW8fsJwSheyZaryevUqMtTxnmmZHN9a0ZfK
         N0eco8ilLEaD22+U0FCGYmonSHUBCHQ9/Zp22T1R3OiUWm9Y3wFZIPE/wPGMty6vgSZf
         tI4hCx4RsoyDbPQ3H6xO6Xv/IdMhHNsGLe4j8HM7Fr8GbeUFotxZTyahIxMxBR3HtMsw
         2AOy1KQvS2BTF4jLAiRXcHigfhu+rpaGQDFVJUxohIzoHOhRJAAgXP7gjcfLhlqWC/L0
         nARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792468686; x=1793073486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7phiI5MOCuSreoAbHviRAlrFOddERLDGFoxihWgBaM=;
        b=i+78JeIq3eyyTCOpuuxnYT588PF07hSlWM/A5i9DZ5804GdzalzZMYID8sSFXBKPGp
         91ES578jwkWbv47Vd+iw+lVAhdvkfv35HzLTmOAjDQPDnP5ETnPWALN0JvYmdeVPkVi4
         A9DwmI+TFrfER8KDCpj6erGJID+68iReI2bmZcpmHN3NK25A/n09C2iwaDz3ZvZkr5rt
         H9AvUCS05IMNqXgrZJG+G6WsGk62l/fQJQW2bd176MKZH7mnxdA3cx007gZfeuWX3enY
         Y6+Q+hm27spAoUvMUywkMVcURNEWnKGvaTAW+lxmGVshXvFsnKJ3Y7fuM5LhNuHdlV94
         2shw==
X-Forwarded-Encrypted: i=1; AKwUvBzBSViidV8Fu7lQHW9oAtiA8lZ/bEDvMr81WiqQbLkPAVGu8y83WSRLl8ewuLYk/BhqRnN0ZR0w@vger.kernel.org
X-Gm-Message-State: AFq9FYIU2A6BKhOsAd2kNlgyskn9XTK80+0HotEZRxwUnoW5758pMn+M
	qV6aJyCAqLYXDcx6VSekLqOrFIX9jwHtEDmFODyMriRnmowD7j7biZCN
X-Gm-Gg: AYBFou2viD02/kl8cM+f7+ibGcQOdtOkGVv5N/1vzzpgaHbUxuo3mJaJPtPujTI9cTx
	NLGgXfSMXfIn1gVkZZhhbzqYEpqfkW0oMfW1JasvZnE4D+grM/EeMy0Mw99B4OMMsT9j5ZFVoMh
	zE/ehAO8F1nkmj5rKbLQOBoB8mAmLS95VI58apBjr5ezF0RC2uAD0C+lV7+RkOtLA2AdTvtIkRm
	cWxE4ifUDDUqkcgv2uIo0/7YmrRiGOFJtAE7CtU2+2tlgahZrBtl0DxfYuTtVEPVI0uVlhvxBOy
	4rHBBpErpjHkdTRaU+g8xhPDGO2EUox3sZVfAnCrRfn1ZcbWf9mtnZU0ZiU4OS1a5bRO3L0dKbL
	mUBdOrkw2WiLqQRwLm+f6MQWgpAS3ud1NgWYVUnwJe3GJnwQUyBosZYN5vtpWIsa0dbyNYlSiqN
	JcMMjt9icZ72MSnKed4sFrkhPOufLgfa2lRV4qr7QzwaZhbFmy2gIJNUstVFk/uI/jgEorAaDvl
	GdAbnOv2ls=
X-Received: by 2002:a17:90b:3b91:b0:3ac:8897:7ba3 with SMTP id 98e67ed59e1d1-3acef5dcc29mr7504914a91.62.1792468686375;
        Mon, 19 Oct 2026 20:58:06 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60f90a6bsm1863509a91.13.2026.10.19.20.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:58:05 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Yi Tao <escape@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: serialize migrations of newly forked processes
Date: Tue, 20 Oct 2026 12:57:59 +0900
Message-ID: <20261020035759.3110170-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
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

With favordynmods enabled, a cgroup.procs migration takes the target
threadgroup's cgroup_threadgroup_rwsem for writing. A process fork holds
the forking threadgroup's semaphore for reading. These are different
semaphores when fork creates a new process.

copy_process() publishes the child's PID before cgroup_post_fork() links
the child to its css_set. A writer can find the child in that interval,
take its uncontended semaphore, and migrate it while child->cgroups still
points to init_css_set and child->cg_list is empty. Migration links the
node into init_css_set.mg_tasks. cgroup_post_fork() then adds the same
node to the intended css_set as though it were unlinked, corrupting both
task lists and their css_set ownership.

This regresses the fork/migration race fixed by commit b12b533fa523
("cgroups: add lock for child->cgroups in cgroup_post_fork()") and
restored again in 2012 after the lock had been removed. The old task_lock
protection was later superseded by global css_set and cgroup threadgroup
locking. The change identified by the Fixes tag narrowed only the migration
side back to a per-threadgroup lock, recreating the different-process
exclusion failure.

Take the new threadgroup's semaphore for reading before the child becomes
visible and hold it through cgroup_post_fork(). Use a nested lock subclass
because fork already holds the parent's semaphore. CLONE_THREAD children
share the parent's signal_struct and remain covered by the existing lock.
Migrations of unrelated, fully initialized threadgroups remain concurrent.

An AI coding assistant was used to identify and reproduce the regression
and to develop and test this fix.

Fixes: 0568f89d4fb8 ("cgroup: replace global percpu_rwsem with per threadgroup resem when writing to cgroup.procs")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 kernel/cgroup/cgroup.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f534c0473a469..faccc793325e5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6880,6 +6880,31 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 	return cgrp;
 }
 
+/*
+ * A new threadgroup gets its own cgroup_threadgroup_rwsem.  Once its PID is
+ * visible, a cgroup.procs writer can find the child and lock that rwsem even
+ * though cgroup_post_fork() has not linked the child to its css_set yet.
+ *
+ * cgroup_can_fork() already holds the global read lock, which keeps
+ * cgroup_enable_per_threadgroup_rwsem stable.  Lock the child's rwsem as a
+ * nested instance until cgroup_post_fork() finishes.  Threads share their
+ * parent's signal_struct and are covered by the existing read lock.
+ */
+static void cgroup_fork_child_lock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		down_read_nested(&child->signal->cgroup_threadgroup_rwsem,
+				 SINGLE_DEPTH_NESTING);
+}
+
+static void cgroup_fork_child_unlock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		up_read(&child->signal->cgroup_threadgroup_rwsem);
+}
+
 /**
  * cgroup_css_set_fork - find or create a css_set for a child process
  * @kargs: the arguments passed to create the child process
@@ -7045,6 +7070,7 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 			goto out_revert;
 	} while_each_subsys_mask();
 
+	cgroup_fork_child_lock(child);
 	return 0;
 
 out_revert:
@@ -7079,6 +7105,7 @@ void cgroup_cancel_fork(struct task_struct *child,
 		if (ss->cancel_fork)
 			ss->cancel_fork(child, kargs->cset);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
@@ -7176,6 +7203,7 @@ void cgroup_post_fork(struct task_struct *child,
 	if (unlikely(kill))
 		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, child, PIDTYPE_TGID);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
