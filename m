Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906392;
	b=nX+Ocqyor1PojSPEZq1pdUEg8bYu23ySxkTOYUuz1l86BxHQnr/joLTqeDBJQBgzvhDi
	 5d89XsQSdBBhPZeJ74CvhWRhm0ELjkWxHkt6lDhXD3c0sds3JXsUmgFgQWOwi2BtTLvDE
	 xFDd2nGHJ7MNNe/JwnvoGTbc//OPnsINrHZiY1Uu1FDXhZfEEm/cO9bxbkNppMyFGCqO0
	 xuDtLJYbVzCDPEnbSn5VOXTkSefddamdlQHnmzTP9qKXB78DaAmb3084zPELIWVcNnx5w
	 IEMY0KKKQSLV5ExPqmiCKaPgq6Zy4vpjngv2okVoIflHpEMfSwgYvDejo6oKMhE0+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tewU7OdvYDlulao9yS8qTKJt8FwBJTOoYWn2c9EtvpE=;
	b=A8bW9atpmJNBA/GkJXdVBG6YtVPYYDn8jwj7d0FwaiZeBtbZNT6u7RIgG1AfnafUn97D
	 A38i/y5pnoiAQ0MuhqlZOlbzHI/lnipoiSjG1kdcA9hrJoK5E6NGsxWQt72qcpmAVEq6h
	 +TaU/62ICRlkBwB2XgCkGC7OqYIHUwHE3Mcyt1vvVG7dvfXe1kbXEc2yx+EsHLwozvbon
	 rt8p1NkXCK0KSdBtnc4opGjTp+LIAQ+EWSqfEvgxrgFHNE+IzwIsaZv8sdUXbofX6Vvpf
	 6zsmMstPO+tyUBComp09ZYxA6gDccMmJ7ObEOUlbdJPW3RjiVK+MLS9yyOPxV8HmrTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCIuyHxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5A2606A32D;
	Thu,  5 Nov 2026 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCIuyHxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22E81F00A16;
	Thu,  5 Nov 2026 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906392;
	bh=tewU7OdvYDlulao9yS8qTKJt8FwBJTOoYWn2c9EtvpE=;
	h=From:To:Cc:Subject:Date;
	b=VCIuyHxg/fUChRfVyVK4hsYjYsiea26TDmZMfpSLGZIqNblLYx6KALvflLKXpVzXc
	 Y0lraRASm63c6qNUYnlfXLuhK6ixK+Yj8DxvXobwEytsx7RrjSBwVXSqqL09tFF8tn
	 QLE5SzaOfbkJqFdojo/AU5NwnsB8DS9UK0/SzhaomVcAWItS0tAlhCxUB4U3JhjLs+
	 GfEYuPuTpVcKvJ7rLayzpQH8c6dV/MQ3zPVMVPeXqL208hZqPLPAC9piRIKsyfkUOH
	 NsHwZYvey960REIV2oAvedKmWGruXLdZQe1+Ff7P1/ayB3/nSfeLlO/8VAF+2CpAB2
	 1zehcfstfUzaQ==
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mani Tofigh <mt4022@columbia.edu>,
	Tao Cui <cui.tao@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH cgroup/for-7.4-fixes] cgroup/freezer: Fix exiting tasks left frozen forever after rmdir
Date: Thu,  5 Nov 2026 09:19:51 -1000
Message-ID: <20261105191951.3409248-1-tj@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 93618edf7538 ("cgroup: Defer css percpu_ref kill on rmdir until cgroup
is depopulated"), rmdir succeeds once cgroup.procs is empty, but exiting
tasks hidden from it can stay in the cgroup until their final context
switch. If such a task is frozen in a v1 freezer cgroup, nothing is left to
thaw it after rmdir: freezer.state is gone with the cgroup, and a THAWED
write to an ancestor clears only CGROUP_FREEZING_PARENT.

8ab6980c7007 ("cgroup/freezer: walk exiting tasks in the v1 freezer") made
the freezer walks include exiting tasks. A FROZEN write now also freezes a
hidden task in a freezable sleep on its exit path. The fix depends on that
commit, as the thaw reaches hidden tasks through the same walk.

Since 81933038f5e2 ("pid_namespace: make zap_pid_ns_processes() freezable"),
an exiting pid namespace init sleeps that way until a parent outside the
namespace reaps a zombie in it.

Thaw the cgroup from ->css_killed(), as a THAWED write to it would. A
descendant removed earlier can still hold hidden tasks frozen through
CGROUP_FREEZING_PARENT. The thaw reaches it too, as its css stays online
until its tasks are gone.

rmdir removes freezer.state only after ->css_killed() returns, and a write
to it takes no cgroup_mutex. A FROZEN write after the thaw would freeze the
removed cgroup again, so refuse to freeze a dead cgroup.

Verified with a reproducer, including under a frozen parent, from an already
removed child and with a racing FROZEN write.

Fixes: 93618edf7538 ("cgroup: Defer css percpu_ref kill on rmdir until cgroup is depopulated")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/legacy_freezer.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index bd11047f2311..1792523d119a 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -382,6 +382,24 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	 * CGROUP_FREEZING_PARENT.
 	 */
 	mutex_lock(&freezer_mutex);
+
+	/*
+	 * A dead cgroup must not be frozen.
+	 *
+	 * rmdir thaws the cgroup from freezer_css_killed(), but freezer.state
+	 * stays writable until rmdir removes it a moment later. A FROZEN write
+	 * in that gap would freeze the cgroup again, and nothing could thaw it
+	 * after that.
+	 *
+	 * A freezer.state write doesn't take cgroup_mutex, but testing
+	 * cgroup_is_dead() without it is safe. rmdir marks the cgroup dead
+	 * before the thaw, so a write that takes freezer_mutex after the thaw
+	 * sees it dead. One that takes it before the thaw may still see the
+	 * cgroup alive, but the thaw then undoes its freeze.
+	 */
+	if (freeze && data_race(cgroup_is_dead(freezer->css.cgroup)))
+		goto out_unlock;
+
 	rcu_read_lock();
 	css_for_each_descendant_pre(pos, &freezer->css) {
 		struct freezer *pos_f = css_freezer(pos);
@@ -403,10 +421,25 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 		css_put(pos);
 	}
 	rcu_read_unlock();
+out_unlock:
 	mutex_unlock(&freezer_mutex);
 	cpus_read_unlock();
 }
 
+/**
+ * freezer_css_killed - Thaw a freezer cgroup being removed
+ * @css: css being killed
+ *
+ * Exiting tasks hidden from cgroup.procs can still be in the cgroup when it is
+ * removed, and a frozen one has nothing left to thaw it once freezer.state is
+ * gone. Thaw the cgroup as a THAWED write to it would. A frozen ancestor keeps
+ * the tasks frozen through CGROUP_FREEZING_PARENT until the ancestor is thawed.
+ */
+static void freezer_css_killed(struct cgroup_subsys_state *css)
+{
+	freezer_change_state(css_freezer(css), false);
+}
+
 static ssize_t freezer_write(struct kernfs_open_file *of,
 			     char *buf, size_t nbytes, loff_t off)
 {
@@ -466,6 +499,7 @@ static struct cftype files[] = {
 struct cgroup_subsys freezer_cgrp_subsys = {
 	.css_alloc	= freezer_css_alloc,
 	.css_online	= freezer_css_online,
+	.css_killed	= freezer_css_killed,
 	.css_offline	= freezer_css_offline,
 	.css_free	= freezer_css_free,
 	.attach		= freezer_attach,
-- 
2.56.0

