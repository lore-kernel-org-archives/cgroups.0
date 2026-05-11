Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E5E37C0E7;
	Mon, 11 May 2026 12:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501243; cv=none; b=lvd7omCyspJfECfGSTN22xBf14corAhGGuRAyw32ARSRFy1hg3io+4ni4lufbPQSGlRNkPLp6VR5vNpv2hyozlzswg2jsmluivzs68nYLI4nGmWVRwdzoaJ0DB5oRwW6W83iWMF19fou2YZtdGifIfvaZNcn8QmH2i69P7QN+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501243; c=relaxed/simple;
	bh=HsCiTJriNz7P+UAsCex8rfRYxLoS04uNTkz3vJjdaJ8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=UJvBwo+X6ZLLAd3VTuk/4tRczh4+uzJEtGS4KonRBvFnjlFHgVH3XcRjKN5nchE+nHUq3Mv+OggcHE3lUqZEfGfUYVspJoQy9TACeEgCfgHL4Zi+gm7sHkxDC61m3P3zQEaQVFVSyPcSnE3T/VTyGWzFx4B3ogR1QreL/SfQhuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kb+fXUwn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kb+fXUwn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=N6IhCAKrZ70BhYGxpBPqHG3qjQiDxSwYn76oXPLANQY=; b=kb+fXUwnrRps0i25uPEUlLBL/E
	MsFHvv4viLdMX/QIQB70DsV7dgkKBy0yBaB1RyEUM8Ke8w+1Hzud+C2m45o0Ms3naZy6DoU37ji8U
	782cVQ/RxJDchiDDHcZCGgJBiHxpsKdsJAWVG1aGUAfgWy2aoq/mc2DbXCN5/ddl+f/WqWMF7DTSU
	MtBnViV4EJtSl8RVcdMvl66Ggcjww/8Yac4Vo+GwkwkhSUOkWNd7uDdbFk4cX9WZ9FsCOd4KN/e8P
	HQZubhwtofMRLllfYLVWN05Q7OYYJTii9lIr4q+IwY47xg5IN3SlgRQiy0tgi0wy0opJ0VxvVOpRB
	kAT3YGcQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMPPZ-000000088m1-2PbO;
	Mon, 11 May 2026 12:07:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id 1BB6D303032; Mon, 11 May 2026 14:07:00 +0200 (CEST)
Message-ID: <20260511120627.433054685@infradead.org>
User-Agent: quilt/0.68
Date: Mon, 11 May 2026 13:31:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: longman@redhat.com,
 chenridong@huaweicloud.com,
 peterz@infradead.org,
 juri.lelli@redhat.com,
 vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com,
 rostedt@goodmis.org,
 bsegall@google.com,
 mgorman@suse.de,
 vschneid@redhat.com,
 tj@kernel.org,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 jstultz@google.com,
 kprateek.nayak@amd.com,
 qyousef@layalina.io
Subject: [PATCH v2 04/10] sched/fair: Add cgroup_mode switch
References: <20260511113104.563854162@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Since calc_group_shares() has issues with 'many' CPUs, specifically the
computed shares value gets to be roughly 1/nr_cpus, prepare to add a few
alternative methods.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/debug.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    1 
 2 files changed, 75 insertions(+)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -588,6 +588,76 @@ static void debugfs_fair_server_init(voi
 	}
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+int cgroup_mode = 0;
+
+static const char *cgroup_mode_str[] = {
+	"smp",
+};
+
+static int sched_cgroup_mode(const char *str)
+{
+	for (int i = 0; i < ARRAY_SIZE(cgroup_mode_str); i++) {
+		if (!strcmp(str, cgroup_mode_str[i]))
+			return i;
+	}
+	return -EINVAL;
+}
+
+static ssize_t sched_cgroup_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	int mode;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+	mode = sched_cgroup_mode(strstrip(buf));
+	if (mode < 0)
+		return mode;
+
+	WRITE_ONCE(cgroup_mode, mode);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int sched_cgroup_show(struct seq_file *m, void *v)
+{
+	int mode = READ_ONCE(cgroup_mode);
+
+	for (int i = 0; i < ARRAY_SIZE(cgroup_mode_str); i++) {
+		if (mode == i)
+			seq_puts(m, "(");
+		seq_puts(m, cgroup_mode_str[i]);
+		if (mode == i)
+			seq_puts(m, ")");
+
+		seq_puts(m, " ");
+	}
+	seq_puts(m, "\n");
+	return 0;
+}
+
+static int sched_cgroup_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, sched_cgroup_show, NULL);
+}
+
+static const struct file_operations sched_cgroup_fops = {
+	.open		= sched_cgroup_open,
+	.write		= sched_cgroup_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 static __init int sched_init_debug(void)
 {
 	struct dentry __maybe_unused *numa;
@@ -625,6 +695,10 @@ static __init int sched_init_debug(void)
 
 	debugfs_create_file("debug", 0444, debugfs_sched, NULL, &sched_debug_fops);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	debugfs_create_file("cgroup_mode", 0644, debugfs_sched, NULL, &sched_cgroup_fops);
+#endif
+
 	debugfs_fair_server_init();
 #ifdef CONFIG_SCHED_CLASS_EXT
 	debugfs_ext_server_init();
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -565,6 +565,7 @@ static inline struct task_group *css_tg(
 extern int tg_nop(struct task_group *tg, void *data);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+extern int cgroup_mode;
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void online_fair_sched_group(struct task_group *tg);


