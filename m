Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83C42A7BB
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831962; cv=none; b=nDTX7lMwDrETjSUrR0U9F7W1ebEgM+f3pDM/xhqT+uAwPg9hSLRdMeHlK2RMpgnE7/RsTHklXRukHI4BXyVSfsmPkL7V2e1JfhSdxfeM3KxZSbHGiN0BHZod/XCG+vYmFg9t2BoTeYC8COP0DqsjjRnsS1ne9z0fI8AXPZl7w4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831962; c=relaxed/simple;
	bh=Vmp8du9mS29XmyjExRb6KyG/YTRrbPXlsCEfxlyAdS0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h42lCsugyyiTOQUEGjwhtYDZglm9LrKdkSF2qJewtJ/wg2pLuMIIKbxcWWMPftIJaYwAxQfqjL5tIIILkBs227U1wNOVC225r34qKq54RpJ5G1QPr43jL+0hx1lINqlWiLzt+lwxxa0ypC5jjTb7to9dlnD8lIYNbFpfjzKrtCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=I+hZdySg; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="I+hZdySg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831945; x=1786436745; i=natalie.vock@gmx.de;
	bh=pfs4bzkCrt+3sxfYw4svGfrT+uDyVPD6TwfeZrxFadU=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=I+hZdySgPePrKHf/9fnWeRau6M0Ka3+0xMHj9gJTc6wV0nLC9b+WKxX75edxagSz
	 Dc5+IbfOw2hu474LnA5EzuNXGpPuEa8TyTcO94fg1W40VIvpvZq7R7ntir6/FMz7e
	 4v4lFpsoaXe1ZRSvLhvroJtJ/kx61D4FcsFEPRm2x0mAV0r6D7rNYvCGjk5eJPrej
	 fWUXZSq2O9UzWtTUa1G0HeKdLhvkgtCxu4kF3t7D5ZlZsd5GkG+QDtqt8QGv1262e
	 LjlenhL7Blb69XrA9SlQ2Ns45synUBHUDnQapkl59ktec3czNsmTS2bln1wmiRmYu
	 hKB00eK8Xpfe+1B0Lw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MXGrE-1wQHZ92WfW-00Plqw; Tue, 04
 Aug 2026 10:25:45 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:17 +0200
Subject: [PATCH v8 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
In-Reply-To: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
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
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
X-Mailer: b4 0.15.2
X-Provags-ID: V03:K1:Hkfwp0qqFS//K5n7pXfAHkXq4vKFNViJmm5m4Cvh/wnWSqLmN7e
 Z/V5nJLeTc3lR0eDmW6bI8f+TvZphLYoZf7R8UGnSyP6F7iblbbMc5nYXDJ0j2uT1UEs2zm
 gWfVhnwQ5DiW7NSv3M2dzVQDaGJ2+EFjKZDIJyASIA6Orwmg7Funreyf9L6gJVNu+mw91tm
 cB3HYhjYgwux7EPNO29ZQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZUxarF8zy9o=;cg7od8jFJF0DHgrXVhgV65xFC+C
 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
 +sjJQFtKmDKAOiyw==

This helps to find a common subtree of two resources, which is important
when determining whether it's helpful to evict one resource in favor of
another.

To facilitate this, add a common helper to find the ancestor of two
cgroups using each cgroup's ancestor array.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
=2D--
 include/linux/cgroup.h      | 21 +++++++++++++++++++++
 include/linux/cgroup_dmem.h |  9 +++++++++
 kernel/cgroup/dmem.c        | 41 ++++++++++++++++++++++++++++++++++++++++=
+
 3 files changed, 71 insertions(+)

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
index 9df3b33c65046..a587611ca2235 100644
=2D-- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -762,6 +762,47 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_st=
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
+	struct dmemcg_state *ancestor_dmemcs =3D NULL;
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
+		ancestor_dmemcs =3D css_to_dmemcs(ancestor_css);
+	rcu_read_unlock();
+
+	if (ancestor_dmemcs) {
+		pool =3D get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
+					    a->region);
+		if (IS_ERR(pool))
+			pool =3D NULL;
+		css_put(ancestor_css);
+	}
+	return pool;
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
+
 static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
 {
 	struct dmem_cgroup_region *region;

=2D-=20
2.55.0

