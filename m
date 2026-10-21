Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597425;
	b=dzWTxvfkSAbEQfsdME3yz6/dQYh0NZ/7pHbWcGJGwELa5BxaYbEn5pmsPR/LAHt+h68Q
	 7dW+c0txrHjqlJ7QBY3vnJYhZwcbAa4nmVUGEE4ATysPwPsxlLizxuUTjtY8TQseFOu5l
	 yFcNjsiBo3oBALU+3HLFwKmFYiaiW/3bijqh4jQyjRMWS0aZpCikQIVAeNZInXIOvtPmF
	 SJvMyokl+KAK+6Ob7+GDrXMwrCBUBr5F9zPySZlXMefqykW0OX2MCtmw+QMT62QQwQHei
	 YFK7C8zIhv80GPoHUSNhDyGeRVujQ5oxWXTF86Tj1yBjxF2niWzQ8Rg2NIZgFqpSS3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597425;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=vMgTfeSV6aKVLLmlRXsEl+/kFzSESEoJcI0d/TF1kM4dZxjq0oHK2cuDi4qAkeWTJabf
	 OKicEq9Ur1HwMUxDIJjcllD9q+d4/nyvYkCpB6qt/X5FXWlQSqmt0tL7VNZxlgHGTpMm+
	 Wsqu6hsmI77IUmzysuWL6Vai5YpLCpGtFYCx/3/AB4UDG6waE7WF0X4du475vSjMYwVF4
	 24yTC0+pdjG9LAu8LNkJUpOidr/yC0E0H9D7YJ0ZzVa0J0IulQ5LwOl5NDCodRWx5jS+z
	 aHmwQSpcjluQIL9k5kR4/MZ+HdwYLkH0xLaowz2+aIjh5er4fKfjM4l9kTy1JcI2siA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gvmN6y1P;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4908960A2633
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4908960A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gvmN6y1P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=gvmN6y1P9K9HwKGQ8KC3HdltltifE0XpB+mFLeoh6viWKLE8cjOuCwR14QJsZIY8xylSk7
	vysSn+oX14s2AVzhbOUzPpT4T6w298UyQ9A4W2o91FKXUowMnWgovA9C8yHnFs5ZpP2aW9
	Ut862bw8siZUkRwVD+4+UZHt9vpSf2g=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-wDBZPeUZOxGRl__DCtwUSg-1; Wed,
 21 Oct 2026 15:43:35 +0000
X-MC-Unique: wDBZPeUZOxGRl__DCtwUSg-1
X-Mimecast-MFC-AGG-ID: wDBZPeUZOxGRl__DCtwUSg_1792597410
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58E911800578;
	Wed, 21 Oct 2026 15:43:30 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A5751800480;
	Wed, 21 Oct 2026 15:43:23 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:26 +0200
Subject: [PATCH RFC v2 5/8] selinux: Restrict cross-cgroup dma-buf charging
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
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-5-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=2546;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Q4MDTyTx8BDPwFzxJa2XHViMR1+R79st6XMgJZaOlIY=;
 b=tDWPABumh8zVFpLL7LPjmRC9KfpiXTDnEpOD2xwgsiun8v5lOm/DwV86OfI8pRNpG8rfgsfOU
 LBY2q4iwqE5A/ROedWdus7ucF/3eMED6PEZhnoUzFbYMVxCBMAzWaLh
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The security_dma_buf_charge_task() hook allows security modules
to control which processes may charge dma-buf allocations
to another process's cgroup via the charge_fd field of
DMA_HEAP_IOCTL_ALLOC. Without a policy implementation, the
hook is a no-op and the restriction is not enforced.

On SELinux-managed systems any domain with access to a
dma-heap device node can therefore exhaust another cgroup's
memory budget without restriction.

Implement selinux_dma_buf_charge_task() using avc_has_perm() with
a new dma_buf object class and a charge_task permission. Policy
authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t client_app_t:dma_buf charge_task;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 7 +++++++
 security/selinux/include/classmap.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 30776b0107f2..8f39d91eabc9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2204,6 +2204,12 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
 }
 
+static int selinux_dma_buf_charge_task(const struct cred *from, const struct cred *to)
+{
+	return avc_has_perm(cred_sid(from), cred_sid(to),
+			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7674,6 +7680,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
+	LSM_HOOK_INIT(dma_buf_charge_task, selinux_dma_buf_charge_task),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b16425..b4ebedc6e424 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
+	{ "dma_buf", { "charge_task", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.55.0

