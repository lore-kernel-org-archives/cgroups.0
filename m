Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0A647127E
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663051; cv=none; b=cdEoBbIcvSFIoq/MaVYahT0pU4SP4XRqvUjBZjz4Z5pLPK68wZ9/gTeFUsJeQWudKksRYCu+ni98L15xKWwkbBo5KChYhdq4X/TCt79pr4OSuC82TCD+O5Sc2R4GI5BOla8QyMBCcZF8oIOcFAcNOHYGLZQIBjLTC5vgRYzDLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663051; c=relaxed/simple;
	bh=PgS9JP49KRubnOGo4U0CKVq7k4HPr57KeS+gHavni98=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YnJ6TygWCafkssj4ieS+kId4dw3kv9+PFXYEEeOpF9zABRBVmpPEy+/x1xpYYs3VjnWrhlYAY45vY/EiwdXouEblCkWEbISOMcA9ieYhH96yLmrjhxVBN17nEWf+ZVOPRRqQOJZK9ZAR6+9PyIX4AGKBHN5WNuWs70ZSv1L2CkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=UEvVSpL7; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="UEvVSpL7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663045; x=1785267845; i=natalie.vock@gmx.de;
	bh=DYcSdZWB9cUb8Hh63GP3e+TbB/yHWk8rJ1Ztz37ALBQ=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UEvVSpL7RhpcPWRDTntafEApw7S8BcTGETp8uSB3ZEbNnnwQgBEQ4TPh2KPwyx2V
	 PaDveKb9ivNxPTVFsKlpTmEMl1a7Y04NmJA9FjMVwiSGH0NA97GxU0Go77yxufK4r
	 YZkIOYYgRV7jS7UpAEyojEHMausEWN408shWx5qL3Voiut4vLtq9JcSTqAcsatf5J
	 ptnrspX3syWpvPgVYYKvte4JYIhobAb997dIORz2qiVem8DuaOohMc+rs9s8DcTW2
	 DWfqOGgd8wMK8bStY3t2dCiwr7sSIXVHI0AieEVCHe3n7EtTNV6rfSXL/TJlqdpP5
	 iYxcDtQZZL+mRfLGyw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M3DNt-1wig120w8r-000K3L; Tue, 21
 Jul 2026 21:44:05 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:21 +0200
Subject: [PATCH v7 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-2-97c4b1014315@gmx.de>
References: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
In-Reply-To: <20260721-dmemcg-aggressive-protect-v7-0-97c4b1014315@gmx.de>
To: Maarten Lankhorst <dev@lankhorst.se>, 
 Maxime Ripard <mripard@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 =?utf-8?q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Natalie Vock <natalie.vock@gmx.de>
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:s/C5j5krAkwdP1EV4D855wQUmkgi70BkaYfGzuHEAZr+SHfMWy/
 VLMGfpWAHpeKn/p0XHpIkYWiJ1kvfQ11/yGayqbFqKOKdhePYYaMq1vtQ9ouzgbcy2tIJnZ
 mnmp5tRo7VCm0eQwzKRrNLYioujsqGb38JV7Vu1pWs/lmXGOQwWBZT62vaXj+fYsV27NpVf
 WrWh90LTmzES1RqBLsLww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3Mv/OBPK4ZQ=;LiLG/RO0jVgnf1NFzUF+WVEw/n4
 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
 =

This helps to find a common subtree of two resources, which is important
when determining whether it's helpful to evict one resource in favor of
another.

To facilitate this, add a common helper to find the ancestor of two
cgroups using each cgroup's ancestor array.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
=2D--
 include/linux/cgroup.h      | 21 +++++++++++++++++++++
 include/linux/cgroup_dmem.h |  9 +++++++++
 kernel/cgroup/dmem.c        | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f2aa46a4f871e..83a17ded1c516 100644
=2D-- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -623,6 +623,27 @@ static inline struct cgroup *cgroup_ancestor(struct c=
group *cgrp,
 	return cgrp->ancestors[ancestor_level];
 }
=20
+/**
+ * cgroup_common_ancestor - find common ancestor of two cgroups
+ * @a: first cgroup to find common ancestor of
+ * @b: second cgroup to find common ancestor of
+ *
+ * Find the first cgroup that is an ancestor of both @a and @b, if it exi=
sts
+ * and return a pointer to it. If such a cgroup doesn't exist, return NUL=
L.
+ *
+ * This function is safe to call as long as both @a and @b are accessible=
.
+ */
+static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
+						    struct cgroup *b)
+{
+	int level;
+
+	for (level =3D min(a->level, b->level); level >=3D 0; level--)
+		if (a->ancestors[level] =3D=3D b->ancestors[level])
+			return a->ancestors[level];
+	return NULL;
+}
+
 /**
  * task_under_cgroup_hierarchy - test task's membership of cgroup ancestr=
y
  * @task: the task to be tested
diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index 1a88cd0c9eb00..9d72457c4cb9d 100644
=2D-- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -28,6 +28,8 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state=
 *root,
 			   struct dmem_cgroup_pool_state *test);
 bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
 			   struct dmem_cgroup_pool_state *test);
+struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dme=
m_cgroup_pool_state *a,
+							       struct dmem_cgroup_pool_state *b);
=20
 void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
 #else
@@ -75,6 +77,13 @@ static inline bool dmem_cgroup_below_low(struct dmem_cg=
roup_pool_state *root,
 	return false;
 }
=20
+static inline
+struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dme=
m_cgroup_pool_state *a,
+							       struct dmem_cgroup_pool_state *b)
+{
+	return NULL;
+}
+
 static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_sta=
te *pool)
 { }
=20
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 9df3b33c65046..edb4c04d09dfe 100644
=2D-- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -762,6 +762,42 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_st=
ate *root,
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
=20
+/**
+ * dmem_cgroup_get_common_ancestor(): Find the first common ancestor of t=
wo pools.
+ * @a: First pool to find the common ancestor of.
+ * @b: First pool to find the common ancestor of.
+ *
+ * Return: The first pool that is a parent of both @a and @b, or NULL if =
either @a or @b are NULL,
+ * or if such a pool does not exist. A reference to the returned pool is =
grabbed and must be
+ * released by the caller when it is done using the pool.
+ */
+struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dme=
m_cgroup_pool_state *a,
+							       struct dmem_cgroup_pool_state *b)
+{
+	struct cgroup *ancestor_cgroup;
+	struct cgroup_subsys_state *ancestor_css;
+	struct dmem_cgroup_pool_state *pool =3D NULL;
+
+	if (!a || !b)
+		return NULL;
+
+	ancestor_cgroup =3D cgroup_common_ancestor(a->cs->css.cgroup, b->cs->css=
.cgroup);
+	if (!ancestor_cgroup)
+		return NULL;
+
+	rcu_read_lock();
+	ancestor_css =3D cgroup_e_css(ancestor_cgroup, &dmem_cgrp_subsys);
+	if (css_tryget(ancestor_css))
+		pool =3D get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
+					    a->region);
+	if (!pool)
+		css_put(ancestor_css);
+	rcu_read_unlock();
+
+	return pool;
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
+
 static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
 {
 	struct dmem_cgroup_region *region;

=2D-=20
2.55.0

