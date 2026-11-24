Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525490;
	b=3FVAXQfqdEDh8Gg6s/5MqdCGqq/hRGc3hDctXESBKwaJrJU/bGaULnApZo1QcacukHM1
	 mVN0BQJLn0H8rx6Q+xAr2M9zZiDvxFnktAea91kFet+kXmht9jfVeNwRWmAr+gdNsfwnr
	 wkp7mNm4xpGAsX5PRB6eJzVeTGvlGdefMnQxuFMzeOoEEJ4e/h3d3idvxNVa/cXpXVj2F
	 VlGpGZkHxOowb6pWnXrF8ijokUvh5WeC0sLmvnxRJycp5opv+rfKQK1iBLlJQjIg4zqCW
	 LABXVD0JMWxhwTMe6VOpVpS9j7n80xCd1wuoaFg5gziu2qxSoS6yd9tspOH7uSVvJNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525490;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=HswTGjdf/JQiD1C8e4APyGnuL3ZWYy2QAUirnegyBwU=;
	b=vP1atoikhflj91QQ3z8oZz7vJeeOjtkFs4DIY9jkQ2IvDR4MEkFfCPZ75uAGJi84uSq2
	 omZLRqCwOCsJ2qJ/tC+zFmmWkVxqmcMhy6bwJoYrWpnCElv6HfijgKkSuwsr0kuLmxPwB
	 x/ISs+2jO64QDGGAffPRYR87hyQW+lcHBQRWhlfN6n1slnrnh51cSgYsjxPZpuDa5+jSu
	 57aa4Htl2167UQfgkiAb32uWfYEleTumivHTsQOGlBNmdOw3bI6XdjNBKhADjNg8DqDRh
	 3zJYAbcCVDaqrGU8axXwQgsizPIPdDfyegekuEBnFAi1/kDnRqGrja6t8OTWSPg4TXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Rf/oaU75";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FC1606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 13:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6FC1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Rf/oaU75
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HswTGjdf/JQiD1C8e4APyGnuL3ZWYy2QAUirnegyBwU=;
	b=Rf/oaU757zvdgX4egE45bKpREoADh+EiFYAuogviB4tkzMeX4v1acTvbZraM7TQM3JRR+M
	lFaHohJbUJzUHC3P+QdfxlBiA/i1KFsldP7sB2pl48XjLDhHeVCyIIW3R/+Eb2OAV23QfN
	9iv4GU7zPbaGF3TGM3ZEj1vRH/McGCE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-pUVekPc1OTykjAYQ_c2NtQ-1; Tue,
 24 Nov 2026 13:04:40 +0000
X-MC-Unique: pUVekPc1OTykjAYQ_c2NtQ-1
X-Mimecast-MFC-AGG-ID: pUVekPc1OTykjAYQ_c2NtQ_1795525474
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E836180288D;
	Tue, 24 Nov 2026 13:04:34 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11DA41956087;
	Tue, 24 Nov 2026 13:04:25 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:38 +0100
Subject: [PATCH v6 4/7] lsm: Add memcg_charge_task LSM hook
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
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-4-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
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
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=4956;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=NnGuBHtPlbFcDr9mVBlxh1SUG8fpAWo88wvwki8PATU=;
 b=uS0w++t5HxLnwIZuPB+hzxo5pcORnM4BMlT44nBmaZYqedh+HpbmI/khYr4CwtOWXpMG6kB0V
 WKX2OV7kC1tD6weCCbhXkocdlJBhGHok7kAfR3nu4wlC+uTRW11wJHt
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Both DMA_HEAP_IOCTL_ALLOC and the new DMA_BUF_IOCTL_XFER_CHARGE ioctl
accept a charge_fd field that, when set, causes the allocation to be
charged to the cgroup named by the fd (a pidfd or a cgroupfd) rather
than the caller's.

Charging is currently limited to the caller's own memcg subtree unless
the caller holds CAP_SYS_RESOURCE. But the capability is all-or-nothing.
A process holding it, along with a dma-heap device node or a dma-buf
fd can charge unlimited memory to any other process's cgroup, potentially
exhausting that cgroup's limit and triggering OOM kills independent of
the victim's own activity or privileges.

Add security_current_memcg_charge_task(), called in
get_obj_cgroup_from_fd() when charge_fd refers to another process.
The hook receives the credentials of the process whose cgroup will
be charged (cred), giving security modules a controlled enforcement
point for cross-cgroup objcg attribution policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 mm/memcontrol.c               | 11 +++++++++++
 security/security.c           | 14 ++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..beb339663d76 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -43,6 +43,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 	 const kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
+LSM_HOOK(int, 0, memcg_charge_task, const struct cred *cred)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..6c6cb08bb1c6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -352,6 +352,7 @@ int security_capable(const struct cred *cred,
 		       struct user_namespace *ns,
 		       int cap,
 		       unsigned int opts);
+int security_current_memcg_charge_task(const struct cred *cred);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -710,6 +711,11 @@ static inline int security_capable(const struct cred *cred,
 	return cap_capable(cred, ns, cap, opts);
 }
 
+static inline int security_current_memcg_charge_task(const struct cred *cred)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf5b2672c0c7..41c81e492007 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -60,6 +60,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
+#include <linux/security.h>
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
@@ -3201,10 +3202,12 @@ static bool mem_cgroup_may_charge(struct mem_cgroup *memcg)
 struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 {
 	struct cgroup_subsys_state *css;
+	const struct cred *tcred;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	struct task_struct *task;
 	unsigned int pidfd_flags;
+	int ret;
 
 	if (mem_cgroup_disabled())
 		return ERR_PTR(-EOPNOTSUPP);
@@ -3229,6 +3232,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 		if (IS_ERR(task))
 			return ERR_CAST(task);
 
+		tcred = get_task_cred(task);
+		ret = security_current_memcg_charge_task(tcred);
+		put_cred(tcred);
+		if (ret) {
+			put_task_struct(task);
+			return ERR_PTR(ret);
+		}
+
 		rcu_read_lock();
 		css = task_css(task, memory_cgrp_id);
 		put_task_struct(task);
diff --git a/security/security.c b/security/security.c
index 4727b8347fc4..78b462b0ece5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -674,6 +674,20 @@ int security_capable(const struct cred *cred,
 	return call_int_hook(capable, cred, ns, cap, opts);
 }
 
+/**
+ * security_current_memcg_charge_task() - Check if cross-cgroup memory charging is allowed
+ * @cred: credentials of the process to charge
+ *
+ * Check whether the current process is allowed to charge
+ * memory to the cgroup of the process with credentials @cred.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_current_memcg_charge_task(const struct cred *cred)
+{
+	return call_int_hook(memcg_charge_task, cred);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0

