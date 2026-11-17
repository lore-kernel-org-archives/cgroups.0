Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904848;
	b=N7Og2ZKIc1tvlPczc745kWekW6ZbBwpLa7jtFxOV5NdVuBDKSFEUs15b+eKJbykpgk7V
	 mzKsQSCFtzNTe/tSsNBNKgkuHo4PPZbPyjQr5yHDJOLvViR3vKoaBEOdKArzxZBZgrl1S
	 6AtgoRltGhxg4Yw0l/rtvEu3B/pE/gvBGOXFMoVtrZyt2McgyGMPtA/dovkAHtqyRINU3
	 ZN0rSj1SjcoOlciPVJTCznaU9eiUoVPMyvIEhTxMHUxKy++47Kee1ilHKR+a7Se0HeMnm
	 05oGggDE7168Gzh2GvrwobwQXMsngAfu/TwrgAuj1qya5jt9/+pX1JpuZjahdFJIbdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904848;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=m8T2YTuRyEX/0VfWO4yPqqkiG+xS9fKoxRnvGyNVhaM=;
	b=rwhoR+FE1+z2SWKZsEp5HwEM6r5Jr7M4qyT9BkwmWibY/Xkm53/NDuemXHyWmwbiol7h
	 aG2LYDCc1k2T5MyL3mnWkrPHz6wdugxU+VdpOFe0HBOPQEQwLpFpwEvWWmkoUPfo1P+LW
	 A8fB1zgcy5LEbB/1QbzxwgXcMn4OrLZQCF53Q3bH91iW6Bk4ltwDWbVV+yEIygRyZwcwC
	 IcDGFhZlqh7jeW5r4/7Tluhsdjin8k+H7ikmJRiZ2AV3ZUMHYYnhgxLQvYLYcppNwEndm
	 fM9MEuvz5NcbtP5Ik8/bsIv4P974CwmbXBtDQ2+cGmeiJajbCKWtvwolOax8glLHJdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JCSNIjXg;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0DE606A330
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA0DE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JCSNIjXg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8T2YTuRyEX/0VfWO4yPqqkiG+xS9fKoxRnvGyNVhaM=;
	b=JCSNIjXgf7y8nqpWx5Kxrm6dxMTCjImyjbMdnCtdzKA+YGDv90toAHM+z04mDzAMntwDDE
	sjTGiDH+8CvrQXnCZB+g9ln0H6AoWvaX55ek+Y2lXINDX2/S4K26n5VCLmOZB3/ZR6Boum
	JJ7ID2mS/Ji0GLdEIAyB4b7FUffAFos=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-Q2FCIl06NGaUlQ43OLoltw-1; Tue,
 17 Nov 2026 03:40:40 -0500
X-MC-Unique: Q2FCIl06NGaUlQ43OLoltw-1
X-Mimecast-MFC-AGG-ID: Q2FCIl06NGaUlQ43OLoltw_1794904835
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F0051956044;
	Tue, 17 Nov 2026 08:40:35 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E90CB1956047;
	Tue, 17 Nov 2026 08:40:26 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:22 +0100
Subject: [PATCH v5 7/8] selinux: Restrict memcg charging to a cgroupfd
 target
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
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-7-1ce975f2a9ad@redhat.com>
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=2824;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=VU9JS/7b9umA1xjNeFGAy8OTH728tWaENZrEvIFi380=;
 b=WJ/NRNZ0clCcqHsM69AZm5u6JI3Y1CpT9xAoxbUi4Z1g/LGgIZp79SXZD78+omqrrsZ92LR8e
 GURUikdfxDfCUtfZAbNOXe28JR0RIasrR2E881uGmm1NTY4kx3qh5Ta
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The security_memcg_charge_cgroup() hook allows security modules to
control which processes may charge memcg memory to an arbitrary cgroup
named by a cgroupfd passed in charge_fd. Without a policy
implementation, the hook is a no-op, so a domain that has both
dma-heap access and CAP_SYS_RESOURCE can charge any cgroup outside
its own subtree, and SELinux cannot say which targets are acceptable.

Implement selinux_memcg_charge_cgroup() using avc_has_perm() with a
new cgroup object class and a charge_to permission. This is the
counterpart of the process2 charge_to permission used for the pidfd
path.

The target SID is the SID of the inode of the cgroup directory the
cgroupfd refers to, so access control follows the cgroup filesystem
labeling. Policy authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t cgroup_t:cgroup charge_to;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 10 ++++++++++
 security/selinux/include/classmap.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 70de6094b2b4..fcf0b03a588d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2210,6 +2210,15 @@ static int selinux_memcg_charge_task(const struct cred *from, const struct cred
 			    SECCLASS_PROCESS2, PROCESS2__CHARGE_TO, NULL);
 }
 
+static int selinux_memcg_charge_cgroup(const struct cred *cred,
+				       const struct file *file)
+{
+	struct inode_security_struct *isec = inode_security(file_inode(file));
+
+	return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
+			    CGROUP__CHARGE_TO, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7688,6 +7697,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
 	LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
+	LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 4004c05aae5b..32dd95de509a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
+	{ "cgroup", { "charge_to", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.55.0

