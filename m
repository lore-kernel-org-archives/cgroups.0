Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09769439F8F
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831954; cv=none; b=gLm7Tr/6Xe6BrT/nDWqmCvNYFqZO3mLoaqmoyTGXuvET12W6efR45zFGyZBV1rKqKET0gOERMejqoUh4QljrnZfs54+KzjBuP+FVcPDgy/QFejqdizxdjV+6kqmdbb21DuNj8ayep3f3TOI7C9sBS1B1XZKoZUMr5pTBrh0UVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831954; c=relaxed/simple;
	bh=kQ1ef6RXiwbN4PfYdRKOqd/5li9UgdFa/NLzPQqdLG8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fB+0QSv8BgdXvtEUO1rOb/0q2E1Nsr4umv2hwKk20sR0VxeVDRiNSj3trKxQpDBgo0w7U+M2tbJmm9wRIJ0/bCraGWNd4qfGtd0cbkuZMas7oqY3Rr89PwhAR6r1RAvz/O4DkduUa5lX4FZscX263HNricOBBZ1QkixMcVPQJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=fIzr1ODs; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="fIzr1ODs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785831944; x=1786436744; i=natalie.vock@gmx.de;
	bh=rvOLpPeggrnQGCkfz4hEj5v00yC++2NmdD80paJaoGw=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fIzr1ODsjNIO+uUWjIuaoZqndUfhWVutIvI0rMPHouJBU0qrSMZsx6AHiMU74emm
	 R/UUifxMa3h/9c0C6ZkoT1rX/uA2U79Ed7dBuNQF7giyrCn1sYEw4uCkxGR8BHp6w
	 yMoIMCxQdLnRtCXkBBSdY1NpzRV7hNA5nlBv4uUI4Po9mABhddgaRHlwTlveYhyd3
	 b+YBKKlFiq7XYbTvYbfpgIHYvj3+smomgQ7zn/VRq1Vta0ZsLNQZC0QgNuCDMyI2H
	 zludryjOUaSpssvU4BHtGr4B3Jy7T+FMMD7i5+ACSEqA80B89sziEXp/1+Vfv2FnY
	 Hc/CBFmWOBgBzHhKqw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MNbp3-1wXjoB3Akd-00XANn; Tue, 04
 Aug 2026 10:25:44 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 04 Aug 2026 10:25:16 +0200
Subject: [PATCH v8 1/6] cgroup/dmem: Add queries for protection values
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260804-dmemcg-aggressive-protect-v8-1-07af96681bf8@gmx.de>
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
X-Provags-ID: V03:K1:aG7UpHe1S1IYBcPl6gKMAtab0B8HHxIAr/+HvICsxpSGpq56Z6y
 he+HpwJVjtMzL+8duD8ZfrWyTEaAt4ArEPpOv5ciSQqlymqrM8NEZoXQ5TAbtchhbF4LKBa
 efPsioXM2IVLg+XVrUlTlCeRd08I+AE6kYYpWJtzJkCLldedrjOz/tfXIr35RbydbbaUqMp
 N2R9R6ru+LedUQg/IG1HQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VdLTK/Sd3zw=;lTAXB/cETGsrSDnnVTVSQ+NullO
 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

Callers can use this feedback to be more aggressive in making space for
allocations of a cgroup if they know it is protected.

These are counterparts to memcg's mem_cgroup_below_{min,low}.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
=2D--
 include/linux/cgroup_dmem.h | 16 ++++++++++++
 kernel/cgroup/dmem.c        | 62 ++++++++++++++++++++++++++++++++++++++++=
+++++
 2 files changed, 78 insertions(+)

diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index dd4869f1d736e..1a88cd0c9eb00 100644
=2D-- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -24,6 +24,10 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state=
 *pool, u64 size);
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limi=
t_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
 				      bool ignore_low, bool *ret_hit_low);
+bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
+			   struct dmem_cgroup_pool_state *test);
+bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
+			   struct dmem_cgroup_pool_state *test);
=20
 void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
 #else
@@ -59,6 +63,18 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgrou=
p_pool_state *limit_pool,
 	return true;
 }
=20
+static inline bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *r=
oot,
+					 struct dmem_cgroup_pool_state *test)
+{
+	return false;
+}
+
+static inline bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *r=
oot,
+					 struct dmem_cgroup_pool_state *test)
+{
+	return false;
+}
+
 static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_sta=
te *pool)
 { }
=20
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 39930c59cb769..9df3b33c65046 100644
=2D-- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -700,6 +700,68 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region =
*region, u64 size,
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_try_charge);
=20
+/**
+ * dmem_cgroup_below_min() - Tests whether current usage is within min li=
mit.
+ *
+ * @root: Root of the subtree to calculate protection for, or NULL to cal=
culate global protection.
+ * @test: The pool to test the usage/min limit of.
+ *
+ * Return: true if usage is below min and the cgroup is protected, false =
otherwise.
+ */
+bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
+			   struct dmem_cgroup_pool_state *test)
+{
+	if (root =3D=3D test || !pool_parent(test))
+		return false;
+
+	if (!root) {
+		for (root =3D test; pool_parent(root); root =3D pool_parent(root))
+			{}
+	}
+
+	/*
+	 * In mem_cgroup_below_min(), the memcg pendant, this call is missing.
+	 * mem_cgroup_below_min() gets called during traversal of the cgroup tre=
e, where
+	 * protection is already calculated as part of the traversal. dmem cgrou=
p eviction
+	 * does not traverse the cgroup tree, so we need to recalculate effectiv=
e protection
+	 * here.
+	 */
+	dmem_cgroup_calculate_protection(root, test);
+	return page_counter_read(&test->cnt) <=3D READ_ONCE(test->cnt.emin);
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_below_min);
+
+/**
+ * dmem_cgroup_below_low() - Tests whether current usage is within low li=
mit.
+ *
+ * @root: Root of the subtree to calculate protection for, or NULL to cal=
culate global protection.
+ * @test: The pool to test the usage/low limit of.
+ *
+ * Return: true if usage is below low and the cgroup is protected, false =
otherwise.
+ */
+bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
+			   struct dmem_cgroup_pool_state *test)
+{
+	if (root =3D=3D test || !pool_parent(test))
+		return false;
+
+	if (!root) {
+		for (root =3D test; pool_parent(root); root =3D pool_parent(root))
+			{}
+	}
+
+	/*
+	 * In mem_cgroup_below_low(), the memcg pendant, this call is missing.
+	 * mem_cgroup_below_low() gets called during traversal of the cgroup tre=
e, where
+	 * protection is already calculated as part of the traversal. dmem cgrou=
p eviction
+	 * does not traverse the cgroup tree, so we need to recalculate effectiv=
e protection
+	 * here.
+	 */
+	dmem_cgroup_calculate_protection(root, test);
+	return page_counter_read(&test->cnt) <=3D READ_ONCE(test->cnt.elow);
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
+
 static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
 {
 	struct dmem_cgroup_region *region;

=2D-=20
2.55.0

