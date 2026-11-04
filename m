Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790612;
	b=wjOv5a27e4HoLfqgHNOZ060pj9mmQuNmFDZ77k9bwBXhbQabPyx15F2I+Qe99q3fqrc2
	 Hexq7u+2o6Meri+fTcWDps1TTimRq0woJjORwTy3Vp1+p8gAgOg9ACvgG9nS0bD4yztZ5
	 EfBotvYlXiuZnuisAStgxI85WsVSrxDKrLzR7AaIhKd7Z/rlnMsK9ytjKqRCKNhn+HCkk
	 7oLJCSvJ0qNufkOdnYR5mFiYFxnvo9rhZXbSjXgT1FBBXPqU79nxV4VdE7zcXd8sd4CnY
	 uulsF+6D7TxeWMQDuCoS2NzZ3uMImqr/8z1KPPLE+UJFo5HQQlCjrEoAHw5MksIQFjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790612;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=7n4fmWUky+vs4idCDlxPFi6+bwonkuAntrLXf3wBF2s=;
	b=Xx9aFn+xBi4VH0Ny/78Mg/WAKUfCXzR6YtUuJc3oUl5l/RL5K8IA6n8O/PgSsP0cpj12
	 knnQE1opGlT4ILyZRmdPd3cI/OqeIwefjNuYHnypsEulvriyEjphGI7MeQJx/uEOP2o2B
	 U9PVv+DAPHHAhaLefs3FFPGlC0zvIa71SHFsCkncSdawqsQEi/ihzwvEAVv7rzDp1IxuR
	 rO8kFKxu5PGobMgIP97sZNnm0t4EgKSDAvQYLAEA23/3NkVTERMPsDS9q9pOKTG15VxIK
	 ioz62jiSjwAsZ6ZGvZSVWsxWSaY3c2FV/f/1xGI8GuPoVtEQi4aKbMpQ/ZZrNkeGUcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DCl+uSuz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD6B606A330
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 11:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FD6B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DCl+uSuz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7n4fmWUky+vs4idCDlxPFi6+bwonkuAntrLXf3wBF2s=;
	b=DCl+uSuzgZk+/NcR3X0c7CITCiWK63RzqvakH3PYKaBHbnY379YPnXGOV8b8sroAlcXNH9
	8pkvs/awY5nwsWjbVu4iuahs5cUcY61QY7MT+zc9ZGFjxsvpuQCTZDy/kyFEPjqrK3y4jS
	CmuM2Hur9delHrJIg3cEGMaCUPMQtYI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-_JEk64hCPe6_t6DOQDy98A-1; Wed,
 04 Nov 2026 06:10:05 -0500
X-MC-Unique: _JEk64hCPe6_t6DOQDy98A-1
X-Mimecast-MFC-AGG-ID: _JEk64hCPe6_t6DOQDy98A_1793790599
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 339DE1955F75;
	Wed,  4 Nov 2026 11:09:59 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8F3D195608D;
	Wed,  4 Nov 2026 11:09:51 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:13 +0100
Subject: [PATCH v4 4/8] security: dma-buf: Add dma_buf_charge_task LSM hook
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-4-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=4963;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=tLPI2RsSKhsOZqNWFIvgktu7E/VbWAcyepTlyll79Zs=;
 b=OpfXZ5pArGbvxwctGkok63VwznmiQv3Kga5Ax0dbd07KXxBEYL59v+Q7plTvYbWPAprFy1Jjt
 2+uSIAOQQLUA5Np7R+aTopHWrrcSAkcmUos6/IvZSsViDc0BmpW5/X0
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

DMA_HEAP_IOCTL_ALLOC accepts a charge_fd field that,
when set, causes the allocation to be charged to an arbitrary
process's cgroup rather than the caller's.

Without an access-control point, any process that holds a handle
to a dma-heap device node can charge unlimited memory to any other
process's cgroup, potentially exhausting that cgroup's limit and
triggering OOM kills independent of the victim's own activity or
privileges.

Add security_dma_buf_charge_task(), called in mem_cgroup_get_from_fd()
when charge_fd refers to another process. The hook receives
the credentials of the allocating process (from) and the credentials
of the process whose cgroup will be charged (to), giving security
modules a controlled enforcement point for cross-cgroup dma-buf
attribution policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 mm/memcontrol.c               | 11 +++++++++++
 security/security.c           | 16 ++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..0f1138e16dbe 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -43,6 +43,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 	 const kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
+LSM_HOOK(int, 0, dma_buf_charge_task, const struct cred *from, const struct cred *to)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..89a35eb07b8c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -350,6 +350,7 @@ int security_capable(const struct cred *cred,
 		       struct user_namespace *ns,
 		       int cap,
 		       unsigned int opts);
+int security_dma_buf_charge_task(const struct cred *from, const struct cred *to);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -701,6 +702,12 @@ static inline int security_capable(const struct cred *cred,
 	return cap_capable(cred, ns, cap, opts);
 }
 
+static inline int security_dma_buf_charge_task(const struct cred *from,
+					       const struct cred *to)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e717b5663c8..dd276e1230cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -59,6 +59,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
+#include <linux/security.h>
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
@@ -5672,11 +5673,13 @@ void mem_cgroup_flush_workqueue(void)
 struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
 {
 	struct cgroup_subsys_state *css;
+	const struct cred *tcred;
 	struct mem_cgroup *memcg;
 	struct cgroup *cgrp;
 	struct task_struct *task;
 	struct mm_struct *mm;
 	unsigned int pidfd_flags;
+	int ret;
 
 	cgrp = cgroup_get_from_fd(fd);
 	if (!IS_ERR(cgrp)) {
@@ -5698,6 +5701,14 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
 	if (IS_ERR(task))
 		return ERR_CAST(task);
 
+	tcred = get_task_cred(task);
+	ret = security_dma_buf_charge_task(current_cred(), tcred);
+	put_cred(tcred);
+	if (ret) {
+		put_task_struct(task);
+		return ERR_PTR(ret);
+	}
+
 	mm = get_task_mm(task);
 	put_task_struct(task);
 	if (!mm)
diff --git a/security/security.c b/security/security.c
index 2ee276ab15c5..4a16e4076aab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -660,6 +660,22 @@ int security_capable(const struct cred *cred,
 	return call_int_hook(capable, cred, ns, cap, opts);
 }
 
+/**
+ * security_dma_buf_charge_task() - Check if cross-cgroup dma-heap charging is allowed
+ * @from: credentials of the allocating process
+ * @to: credentials of the process to charge
+ *
+ * Check whether the process with credentials @from is allowed to allocate
+ * dma-heap memory and charge it to the cgroup of the process with credentials
+ * @to.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_dma_buf_charge_task(const struct cred *from, const struct cred *to)
+{
+	return call_int_hook(dma_buf_charge_task, from, to);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0

