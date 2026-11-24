Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525493;
	b=z7pHtalbRQrM7tDm++kvIUy5Vg797jGiypPEjUX0MfLW+36sqCUxHhSTnfbntU3xKArK
	 fiADueDeh6fmxTSh42aZDukIh57MSbetXfqhW//vdvMJm5CKBv7MF3lCrnWQJ+5p5Lw5c
	 0zCwhc1hMrEq89HH1i0B2FdL8CmteBLmhnajEZI2PeiEkgZrMcFvcyBeiXDJCsla4LLOz
	 f71+6Ck5CKanYWrR++zTjZEeLGBkzisb0mQJYcbTTSTZgTbL0z+7MSX5M9Wt4SITKaLs0
	 GgslKFNXoH2BynOMlz+GRSlTHOBNPAeFtBFWffQ4oTjDQZjaQmdm4FMjbFmcPIKJQkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525493;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=Ray3NrLqzkhmnwJRomna+zujwV+SFq0gT4yl/osPB34=;
	b=WG763XXi2KWRacmJ1YQT97vgl5Plx6z68hbHT0Jz+ybkXfte4O2TIrbAYIjbU5etboyT
	 SEs3ysk/z+U7DiMql86YckIvLGeIezghiJQoqd/PgPBq9pMDRtV4VnSC07PFRTd4WYQNv
	 DFpLpaRXwbbYGULGEyEihT0IAgTv3zPRM3GKKlISODLZvO6XY8LzuG6e+RTZKz/bOITv5
	 Gr5Fyajr7g4gYEAG6i1hQadc2zmQPjVjhM4qw4WLrphvcF4vJygZIgVmARvO82nW3ML/1
	 3Wk0GdX7EpwKHpzOTjtnmSSUkGMrAdXuif0eS1Z/CA7ELWXGyukrW/MOxf0Br19fJIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QWLb352j;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D322606A330
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 13:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D322606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QWLb352j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ray3NrLqzkhmnwJRomna+zujwV+SFq0gT4yl/osPB34=;
	b=QWLb352j8JbSuLUikPk/6OeVejj+fuzreYYw46alxBvSyjxM9gFJgYQI9yBnpWV3LxL6gC
	PsoFR6RnJSAg0JMer4Xe0g+eX1QndBg/svT0fMqtNGAovy6FVI3WrHFNVoqc84NTYezpg7
	mX/MPlBkR/E54oLY0cxPXN8/9lEBgYM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-W_6pPIz5PB2zzCcRCZbmfw-1; Tue,
 24 Nov 2026 13:04:48 +0000
X-MC-Unique: W_6pPIz5PB2zzCcRCZbmfw-1
X-Mimecast-MFC-AGG-ID: W_6pPIz5PB2zzCcRCZbmfw_1795525483
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0157195607A;
	Tue, 24 Nov 2026 13:04:42 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 806FD195B3C0;
	Tue, 24 Nov 2026 13:04:34 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:39 +0100
Subject: [PATCH v6 5/7] lsm: Add memcg_charge_cgroup LSM hook
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
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-5-dce12fa03ad6@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=4540;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=wAbH4N9zRa57tbMNTWC7U/31ALptD+bCYR9IXI1onlM=;
 b=wT8RQTPb+Wx1Kzz+k4N6hc+R0jaP1q2GCdM7dfviV5I7mT0dDpxEZtKSRGAjIxJ9BvRVG5IEZ
 MWDH9f90Z21DlZ26uiD6RLSmRmjIhdDtZ0LuUkrqZzlfdzv7CByHf6A
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Similar to how security_current_memcg_charge_task adds an access-control
point for pidfd for the charge_fd of a DMA_HEAP_IOCTL_ALLOC or
DMA_BUF_IOCTL_XFER_CHARGE ioctl, we need a new access-control point
for the case where charge_fd represents a cgroupfd.

Add security_current_memcg_charge_cgroup(), called in
get_obj_cgroup_from_fd() when charge_fd refers to a cgroupfs
directory. The hook receives the open file of the cgroup directory to
charge (file), giving security modules a controlled enforcement point
for cross-cgroup memcg attribution policy.

The file is passed instead of the cgroup so that a module can
label-check the object the cgroupfd actually names.
get_obj_cgroup_from_fd() resolves the memory css from that same file
with css_tryget_online_from_dir(), so the fd cannot be swapped between
the check and the charge.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 mm/memcontrol.c               |  9 ++++++++-
 security/security.c           | 17 +++++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index beb339663d76..72f474596bf0 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -44,6 +44,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
 LSM_HOOK(int, 0, memcg_charge_task, const struct cred *cred)
+LSM_HOOK(int, 0, memcg_charge_cgroup, const struct file *file)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 6c6cb08bb1c6..69a309919ea7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -353,6 +353,7 @@ int security_capable(const struct cred *cred,
 		       int cap,
 		       unsigned int opts);
 int security_current_memcg_charge_task(const struct cred *cred);
+int security_current_memcg_charge_cgroup(const struct file *file);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -716,6 +717,11 @@ static inline int security_current_memcg_charge_task(const struct cred *cred)
 	return 0;
 }
 
+static inline int security_current_memcg_charge_cgroup(const struct file *file)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 41c81e492007..725a910d8eb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3223,7 +3223,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 		css = ERR_PTR(-EBADF);
 	}
 
-	if (IS_ERR(css)) {
+	if (!IS_ERR(css)) {
+		/* fd is a cgroupfd */
+		ret = security_current_memcg_charge_cgroup(fd_file(f));
+		if (ret) {
+			css_put(css);
+			return ERR_PTR(ret);
+		}
+	} else {
 		if (PTR_ERR(css) != -EBADF)
 			return ERR_CAST(css);
 
diff --git a/security/security.c b/security/security.c
index 78b462b0ece5..72cad6b1d3e7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -688,6 +688,23 @@ int security_current_memcg_charge_task(const struct cred *cred)
 	return call_int_hook(memcg_charge_task, cred);
 }
 
+/**
+ * security_current_memcg_charge_cgroup() - Check if charging memory to a cgroup is allowed
+ * @file: open file of the cgroup directory to charge
+ *
+ * Check whether the current process is allowed to charge memory to the
+ * cgroup referenced by @file. Called when userspace passes a cgroupfd to
+ * identify the charge target instead of a pidfd. @file is the file the
+ * cgroup was resolved from, so the check applies to the object that is
+ * actually charged. It must have been already validated by the caller.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_current_memcg_charge_cgroup(const struct file *file)
+{
+	return call_int_hook(memcg_charge_cgroup, file);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0

