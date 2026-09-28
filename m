Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA141A508
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576086; cv=none; b=sE11+oin1OX/tR2zD1hzoR2VRpXQ1Nvvb63r+0Z2tuZugjJPwhAOC6zMhaSfKsb2bbWgFfTaLPOXRBpt/tf+Zim6Iwm7F1MgCqEOLA+mjeenS9IP/QxsZvenpx1NkGP0+055puMRnKB/3oBwnIF3U97HGmrMjTZN7g75ia7NMVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576086; c=relaxed/simple;
	bh=UCFUk147JwUFVYjXeYUCRdWoewnJvL3Q1qa2fY4mraw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgeC/ANt0w49znAumjL6iLK6/dzMKLhWKT7Ciy/tSD+dL++s8LXj9LmF1Tk8K3tlIV36g047TkohynXTgQ46AgEEw+u+kDc3dKWT1pr+wUL+3dkqfK013A3m6X2W5kHaePzHQ84OdYJV1s2GAkWU5YMK0wkLgAWDZTpp4aYp6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aZKUbMbm; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZKUbMbm"
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0b6200eb0so1953194a91.2
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 23:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790576063; x=1791180863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XaC6DkyMRoZdb4oAVjU9pdXNfcIMayAmSL3fDY/VEnU=;
        b=aZKUbMbmU7dwJ3QP/KtbaMm/fAX/Xt99c5Tmv2HrDENOkRhjovj28plhhHTjt3gbrL
         wiA8luk/Xxw/gRt2hmdM4r/UObGxBFNtPGHmTsI81STH8ty5K7vu57KBbFxwu2WolNg/
         UHAuVjBHjL86F0H9Sbc7NVTx2sh3FXGrMJfPwmfuyPua9FsmoYWxuE8HMlvYLe28BLKb
         jvA4P54SGvf/APzlQjLCrn0Jxqw3uf1rxhBFKraogx5qVibybmGb1Md4j0hGHjc3BulL
         bKSvKHtNYLrv1KQMsaE/uW1Q8Rdu84LK9HY5qlmDed+fuxJEZlvQrz4C8/YbLMWCQTah
         LmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576063; x=1791180863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XaC6DkyMRoZdb4oAVjU9pdXNfcIMayAmSL3fDY/VEnU=;
        b=VFhEvZ2IoxJ24jRnbakgCyIIBYNt7EroISZMizZzVh0MtVW1JcfNKiC3B7BhWIaAGC
         dHYqE1ttxu+Dd761mfl/fEfZfD0A/JYuqh4jHWHghSaa4nzgEQ/RviysrU4bTHPKyRNU
         OfyU4TPfHjr2yCJ3WtIdtI6LBQHPflE8s9DEZFUNYEd7d54LG2xYZp1tA71E79bKXTlK
         8vureAO4mBhGttYCN/44ksBFfCLLAuXEQAeoWAm588kNGFW+K/Linp9XPwUkggasG4uK
         T1x36FYxr0+Nsn62ZA0AJu5iFgjRD9vSlX/CIqkXsTV0p0GHd4JYeIivz3diwsGLjtRG
         Xlkg==
X-Forwarded-Encrypted: i=1; AKwUvByEN1DWKKuF5o95ixW/BHu8HxWTWGEsO7HQtYXX+7FbggF7uJJJwiAuveyhQHC3PkT6TZRDBayc@vger.kernel.org
X-Gm-Message-State: AFq9FYKHvWrEYEF/oGOzLIjheFtaeASvzdOziOspKcGLX5P1tBJodMtE
	0u+Wx2WWLxMsPOFjihqOrfi43e3yzjNRT4AVkWW/WYuCrDdsdaGkFGHE
X-Gm-Gg: AYBFou0EM5T+OmxxEjc45rRH9xg8WKgP1KHgmvvHeqniK/2cR1j63XaN4KetPB7+xt6
	YX2NTSJV0FKygMVpl1qA8FsQOKZwunnO7r3JBXjL3qs9CQItOXyV99tr2m2Ebu7rarbD8oj5A2Q
	P2F606dg3TOGRsSaPkGjwg+/+V/qCWUuxv/4BgUrz5IYgRwSb/fp5mSQSJjQjcP+4BOB0ut8gR3
	dEOANGXADcoxj9AUjl4///EUBuFebpf6cXIsmhGlencR//cEkLRLGLwoHNwP+kmfvbADzSPhKA5
	Nocu+IOKCYetQqRDfqiMCLOtlNPCmtJHOe9xvB0EVw2QVQ0TYaCvzyEKXMk00DwlGmq3R0YBuUu
	+SLQt1ZYe1wB3Y/6tTzR+npQvq4QtmIYWNodoHDUt3CK16uaELP12zAQC/Mvb8IoOamE4OUwquu
	6eeBRd4+LMo8TmBaCASUt69M8bnc+xxdAsFJel0kC66dL9u6WZkFT6NI5LkpydBc0v9HwBfNeRc
	q3OsiBJGWx2laR13fq4gbSm+Fml6KPa8ZmdkJR+J0cO/zWQCJmPbZpnO6R5L8TBvu8dE9p504oQ
	u60=
X-Received: by 2002:a17:90b:560f:b0:3a0:9aa4:f9bf with SMTP id 98e67ed59e1d1-3a0bb552f06mr6777589a91.12.1790576062923;
        Sun, 27 Sep 2026 23:14:22 -0700 (PDT)
Received: from yupeng-XPS-15-9520.. (c-73-169-192-12.hsd1.wa.comcast.net. [73.169.192.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9892dbfsm18864088a91.11.2026.09.27.23.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:14:22 -0700 (PDT)
From: Peng Yu <yupeng0921@gmail.com>
To: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Peng Yu <yupeng0921@gmail.com>
Subject: [PATCH v6 1/3] cgroup: track the effective css in each cgroup
Date: Sun, 27 Sep 2026 23:14:15 -0700
Message-ID: <20260928061417.1574676-2-yupeng0921@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928061417.1574676-1-yupeng0921@gmail.com>
References: <20260928061417.1574676-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track the effective css in each cgroup and make cgroup_e_css() and
cgroup_get_e_css() use it. When a css is brought online or offline,
update the effective css of its cgroup and of all descendants.

Signed-off-by: Peng Yu <yupeng0921@gmail.com>
Assisted-by: Claude:claude-fable-5 [Claude Code]
Assisted-by: Claude:claude-opus-5-5 [Claude Code]
---
 include/linux/cgroup-defs.h |  2 ++
 kernel/cgroup/cgroup.c      | 53 ++++++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 3754d697854b..5bbe6025fc77 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -555,6 +555,8 @@ struct cgroup {
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
 
+	struct cgroup_subsys_state __rcu *e_css[CGROUP_SUBSYS_COUNT];
+
 	/*
 	 * Keep track of total number of dying CSSes at and below this cgroup.
 	 * Protected by cgroup_mutex.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2d532bf2c0c7..69b0f0cf2f3e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -548,20 +548,11 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
 struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 					 struct cgroup_subsys *ss)
 {
-	struct cgroup_subsys_state *css;
-
 	if (!CGROUP_HAS_SUBSYS_CONFIG)
 		return NULL;
 
-	do {
-		css = cgroup_css(cgrp, ss);
-
-		if (css)
-			return css;
-		cgrp = cgroup_parent(cgrp);
-	} while (cgrp);
-
-	return init_css_set.subsys[ss->id];
+	return rcu_dereference_check(cgrp->e_css[ss->id],
+				     lockdep_is_held(&cgroup_mutex));
 }
 
 /**
@@ -585,17 +576,10 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 
 	rcu_read_lock();
 
-	do {
-		css = cgroup_css(cgrp, ss);
-
-		if (css && css_tryget_online(css))
-			goto out_unlock;
-		cgrp = cgroup_parent(cgrp);
-	} while (cgrp);
+	css = cgroup_e_css(cgrp, ss);
+	while (!css_tryget_online(css))
+		css = cgroup_e_css(cgroup_parent(css->cgroup), ss);
 
-	css = init_css_set.subsys[ss->id];
-	css_get(css);
-out_unlock:
 	rcu_read_unlock();
 	return css;
 }
@@ -2131,12 +2115,17 @@ void init_cgroup_root(struct cgroup_fs_context *ctx)
 {
 	struct cgroup_root *root = ctx->root;
 	struct cgroup *cgrp = &root->cgrp;
+	struct cgroup_subsys *ss;
+	int ssid;
 
 	INIT_LIST_HEAD_RCU(&root->root_list);
 	atomic_set(&root->nr_cgrps, 1);
 	cgrp->root = root;
 	init_cgroup_housekeeping(cgrp);
 
+	for_each_subsys(ss, ssid)
+		RCU_INIT_POINTER(cgrp->e_css[ssid], init_css_set.subsys[ssid]);
+
 	/* DYNMODS must be modified through cgroup_favor_dynmods() */
 	root->flags = ctx->flags & ~CGRP_ROOT_FAVOR_DYNMODS;
 	if (ctx->release_agent)
@@ -5856,6 +5845,22 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	BUG_ON(cgroup_css(cgrp, ss));
 }
 
+static void cgroup_update_e_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *d_css;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	css_for_each_descendant_pre(d_css, &cgrp->self) {
+		struct cgroup *dsct = d_css->cgroup;
+		struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
+
+		if (!css)
+			css = cgroup_e_css(cgroup_parent(dsct), ss);
+		rcu_assign_pointer(dsct->e_css[ss->id], css);
+	}
+}
+
 /* invoke ->css_online() on a new CSS and mark it online if successful */
 static int online_css(struct cgroup_subsys_state *css)
 {
@@ -5869,6 +5874,7 @@ static int online_css(struct cgroup_subsys_state *css)
 	if (!ret) {
 		css->flags |= CSS_ONLINE;
 		rcu_assign_pointer(css->cgroup->subsys[ss->id], css);
+		cgroup_update_e_css(css->cgroup, ss);
 
 		atomic_inc(&css->online_cnt);
 		if (css->parent) {
@@ -5895,6 +5901,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_ONLINE;
 	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
+	cgroup_update_e_css(css->cgroup, ss);
 
 	wake_up_all(&css->cgroup->offline_waitq);
 }
@@ -5966,6 +5973,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 {
 	struct cgroup_root *root = parent->root;
 	struct cgroup *cgrp, *tcgrp;
+	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
 	int i, level = parent->level + 1;
 	int ret;
@@ -6010,6 +6018,9 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp))
 		cgrp->ancestors[tcgrp->level] = tcgrp;
 
+	for_each_subsys(ss, i)
+		RCU_INIT_POINTER(cgrp->e_css[i], cgroup_e_css(parent, ss));
+
 	/*
 	 * New cgroup inherits effective freeze counter, and
 	 * if the parent has to be frozen, the child has too.
-- 
2.53.0

