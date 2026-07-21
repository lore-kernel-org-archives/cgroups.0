Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19A6399015
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663063; cv=none; b=kEnjMJot7SkVFG3pcX4Z9jr4DxcwFvL/Ra9TMDJD9quCZb0HbprC14R/udmv5grNjLhZu+truejo0clTJyxRwEbvbrkAcVdatRoXqBqeGFoRShOk+6cwDwwz2H6CnRMxmf/1C1xBxJ99gIpCcqhYJPLjcz77xDnb86GbpEBe4cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663063; c=relaxed/simple;
	bh=kQ1ef6RXiwbN4PfYdRKOqd/5li9UgdFa/NLzPQqdLG8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YD2DAQtNNuqMA/sTt3zqPKOem+7aDPg85p4yC+BgCc0tWVSJcA0i4cM6o5LTSI3WJCvltp7nmSHNsjxoVtlB2IvCBTWNQeRmjBg2zyGDyTbmonhEVQHfKLQUnSA99nmjw8HVH7mi2i/tjXDoH7u5jgU+MVCClVD4ObwclnQrXo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b=oB9VW1nZ; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=natalie.vock@gmx.de header.b="oB9VW1nZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784663044; x=1785267844; i=natalie.vock@gmx.de;
	bh=rvOLpPeggrnQGCkfz4hEj5v00yC++2NmdD80paJaoGw=;
	h=X-UI-Sender-Class:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oB9VW1nZXkLtfl9lU1oyey0JkdA6ZZJ8uqx9ILCJhY3gUCNIPLCONlnNHc3Ig5/p
	 sVuuYmBANxTpPQx9/39Ng2/YB9BIlw8dLM7myjaseqi9UamtaIFYOJts1XIB87gEj
	 g4pLCYZk9gEmotIv0Y0bcwB/P1HvDTbA5KS+hfOltQUZrqZFZ6p8Pg+tojBVH4swb
	 u5WD/wSLolUERmHFhF0nRJdbFBwznLEgN+76bEIxeo4Lrr7WIPBKl643Yw2fod1Uu
	 Bf85aN9rP3Qn9G6huwE0aYCjqdOYTHXRQzHSW89Vaou2cxPKe49TIv9wGEv94+0pW
	 WRf+MqTgW9kkkBBIzA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MBDj4-1wrEjt47Ti-009Mbs; Tue, 21
 Jul 2026 21:44:04 +0200
From: Natalie Vock <natalie.vock@gmx.de>
Date: Tue, 21 Jul 2026 21:43:20 +0200
Subject: [PATCH v7 1/6] cgroup/dmem: Add queries for protection values
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <20260721-dmemcg-aggressive-protect-v7-1-97c4b1014315@gmx.de>
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
X-Provags-ID: V03:K1:KkWl0yR7lDvU7cD93JF20f9f1ll2fN48tGDZbZuR4lkuWFQEUBo
 nkIIvpZCTA2vwayD0mDgYAIuiQOivXhE1Wr8lHXDbl98QnK9fVY+SlH1SnwUQwutqeGG38s
 qpqRcJDAiXZAkmnVyvfvcafka8FZyG5Sqk3ZUqrDqatVTmYf2RZqnUxJf1Q/54VQSc7y0gw
 S/SWbJCrTFvSWwrBKptaw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wDPvKuiWHwI=;J8KhdW27QW0ESqPoNMEXGF9PUvr
 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
 ntLXj4l1mfisg5hg5tcSV

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

