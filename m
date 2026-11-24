Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795480331;
	b=CRrZaOgtYD6SyPF8yh2bZT5GoIRkOSecMJQ7RHHQohsHW9ZWVK8Fdh8+2dHLzKMiecGm
	 jCoVQayAxDaaX6n+MNfBg8rgcAClNUeMegn1K7Ckh1HxiRrGSdljMf64dQENZ0kluoSbF
	 KDeiSB8+gU9+oknlhnXzLcIa0PgWBfSy2NhP0PG4ROT8Gsu4fB+mY4tEM4dKCYl5PkPMa
	 tbxgs6faBfCIVKAC6cyCQfVoIdDm7y/xDoPYT/WG7Ph6dHC4BNY6ktBsPyha00NA3LTUs
	 QrqUL+hYCbXhOcYeI2lwlIHWybDbp6j2JNxQFs8C4hlevbcu4VwK+5N6MEq+hxkWlfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795480331;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=eKWVen9daKTJsoD/eXPcUoAAKSeQd3877rfSkKBgQW8=;
	b=IwCSSwOdl7d1zvYa3vr61EOcXI6HsjwRAGnQIPC3CA0TZRJan8LPEFQa5SBZnAeUpPKb
	 Oiwc/klcCGdkTTIL9/Nn3M/GfGnydayuniV/BQLIvkRZixiB9OSl+bDbdi5lzqqX5QUf2
	 mBwXcyYi38UKBw3ZldBwp6QQSIvDFXyFVro8/30fo5gBfoeFw5EjAcsm+mr4uJzUuHvDN
	 zAPVt4CwlI2lbltvD/I2qOqysfW2P4R5UOIG+FzdMxKIkVaiir3KDfiWdqAVZWZHdvqt3
	 0AltpH9hhGRxmdnlvFqGN+bpDRoWmEXTWTJma9+XsxIBTWdNlnAyiuvXfvbiVCo7wdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HirhgVmX;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14106606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 00:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14106606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=HirhgVmX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795480329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eKWVen9daKTJsoD/eXPcUoAAKSeQd3877rfSkKBgQW8=;
	b=HirhgVmXhKuO8cP/NpW7KffywXBo/WAPAPzBAxCQxM25TnxWlekCY3lb8voJbaesRGPJ7o
	EbIhQEWchZh3XWX0c2YZZCNYd3/nZWLari4N8GcFt2I2DXTdBbwYjwFuG3WB8m10fBF0Hg
	ONcjdkgrpKqKDEW9/1HBEg6vAXs5Qkw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-wU5SBA5wO7axXUgiWwgM-w-1; Tue,
 24 Nov 2026 00:32:04 +0000
X-MC-Unique: wU5SBA5wO7axXUgiWwgM-w-1
X-Mimecast-MFC-AGG-ID: wU5SBA5wO7axXUgiWwgM-w_1795480322
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58B1D19560AD;
	Tue, 24 Nov 2026 00:32:00 +0000 (UTC)
Received: from harpatil-mac.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F36F81801A60;
	Tue, 24 Nov 2026 00:31:54 +0000 (UTC)
From: Harshal Patil <harpatil@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Harshal Patil <harpatil@redhat.com>
Subject: [RFC PATCH] mm: memcontrol: let a cgroup opt out of HugeTLB accounting
Date: Mon, 23 Nov 2026 19:31:45 -0500
Message-ID: <20261124003145.80705-1-harpatil@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Since commit 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory
in memory controller"), cgroup v2 can be mounted with
memory_hugetlb_accounting, which charges HugeTLB folios to the memory
controller. The option is global: it applies to every cgroup on the
machine, or to none.

That is a problem for hierarchies that give a workload a HugeTLB budget of
its own. Kubernetes is one [7]. A pod requests huge pages as a resource
that is separate from memory and comes from a preallocated pool. The
kubelet turns the request into hugetlb.<size>.max, and sets memory.max
from the memory limit of the pod alone. With the option on, a pod with
memory.max=96M and hugetlb.2MB.max=64M that uses 64M of huge pages and 80M
of other memory exceeds memory.max: it is OOM-killed, or gets SIGBUS when
it faults a huge page. Raising memory.max by the HugeTLB limit does not
restore the old behaviour either, because the pod can then use 160M of
non-HugeTLB memory while the scheduler placed it for 96M.

The accounting was made opt-in because such setups exist [1][2]. But the
choice is made once per machine, by whoever mounts cgroup v2, and systemd
mounts it with the option since v259 [3]. A workload manager that runs
under that systemd cannot keep the separate accounting for the part of the
hierarchy that it owns. That a mixed machine would need a more localized
control was raised when the option was added, and deferred until it came
up [4][5][6].

Add memory.hugetlb_accounting, a file on non-root cgroups that defaults to
1. Writing 0 keeps HugeTLB folios used by the cgroup and its descendants
out of their memory accounting. The folios do not become unaccounted: they
are charged to the parent of the cgroup, or to the parent of the topmost
ancestor that opted out. Charging the parent, instead of skipping the
charge, has two effects:

 - The cgroups above keep the complete picture that the mount option
   gives them, up to the root, whose memory.stat still counts the folios.

 - A cgroup cannot use the file to escape a limit of an ancestor, so
   writing it needs no privilege beyond the permissions of the file.

The file is not delegatable. Like memory.max, it is a setting that a
parent makes for its child; a delegatee could otherwise move the HugeTLB
usage of its own cgroup out of the limit that the delegator put on it.

Folios keep the charge that they got when they were allocated. A change of
the file only affects folios allocated afterwards, in the same way as a
remount with or without the mount option.

Extend the hugetlb memcg selftest to check, in a three-level hierarchy,
that the usage is charged to the parent of the topmost cgroup that opted
out, that a descendant cannot opt back in, and that the root counts the
pages in every case.

Link: https://lore.kernel.org/all/CAPTztWY8eDSa1qKx35hTm5ef+e13SDnRHDrevc-1V1v7-pEP3w@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/ZRQQMABiVIcXXcrg@dhcp22.suse.cz/ [2]
Link: https://github.com/systemd/systemd/pull/39486 [3]
Link: https://lore.kernel.org/all/ZRrI90KcRBwVZn%2Fr@dhcp22.suse.cz/ [4]
Link: https://lore.kernel.org/all/20231002162133.GC5054@cmpxchg.org/ [5]
Link: https://lore.kernel.org/all/CAKEwX=OwrMNMAvve9a965mBJm8as+njtXE993VcnKXdccd5GEw@mail.gmail.com/ [6]
Link: https://github.com/kubernetes/kubernetes/issues/144131#issuecomment-7104174643 [7]
Signed-off-by: Harshal Patil <harpatil@redhat.com>
---
Hi,

When memory_hugetlb_accounting was added, Michal asked what would happen
on a machine that runs a mixed bag of containers, some of them not ready
for the new accounting [4]. Johannes and Nhat said that more localized
control could be added on top of the global flag if it ever came up
[5][6]. I think it has now, in Kubernetes [7], and this is my attempt at
that control. I would like to hear whether it is the right shape before
I take it any further.

Some background on how we got here. I work on Kubernetes. Huge pages are
a separate resource for us: they come from a preallocated pool, a pod
asks for them next to its memory, and we set memory.max from the memory
limit alone and hugetlb.<size>.max from the hugepage limit. That is the
kind of setup the option was made opt-in for [1][2], and we never opted
in. But systemd v259 started to pass memory_hugetlb_accounting whenever
the kernel supports it, with no way to leave it out [3], and Ubuntu 26.04
ships that version. So our users got the new accounting with a distro
upgrade.

For example, for a pod that asks for 96M of memory and 64M of huge pages,
Kubernetes sets memory.max=96M and hugetlb.2MB.max=64M. With the option
on, that pod is OOM-killed when it uses its 64M of huge pages and then
80M of anonymous memory, and in the other order it gets SIGBUS on the
huge pages. Both run fine with the option off. I wrote up this and the
other cases, with the tests behind them, in [8].

I first looked for a way to deal with this in Kubernetes, and tried a few
things with the same workloads.

The obvious one is to set memory.max to the memory limit plus the
hugepage limit. The pod above then runs, but its memory limit no longer
limits memory: with no huge pages in use it ran with 152M of anonymous
memory under a 96M limit. That changes what the limit means for every
existing pod.

Adjusting memory.max as the HugeTLB usage changes does not work either.
Even with a 50ms poll, anonymous memory allocated right after the huge
pages still hits the old limit. This is the polling scheme that Nhat's
cover letter for the mount option describes as "cumbersome and buggy"
[9].

Raising the limit and having a userspace agent enforce the real one
works for pods that stay within their memory, but one that does not can
stay over its limit for a whole poll interval.

Remounting cgroup v2 without the option works, and it is what we will
document for now. But it is machine wide, and it takes the accounting
away from everything else on the machine too.

So I could not find anything in userspace that gives a pod back a limit
on just its non-HugeTLB memory, and that is what existing pods are sized
for.

With this patch Kubernetes would write 0 to the cgroup that holds all
pods, and to the cgroups of host services that it puts a memory limit
on. The rest of the machine keeps the accounting that the mount option
asked for, and the root still counts every huge page.

The patch, the tests and this text were developed with an AI coding
assistant (Claude). I have reviewed them and ran the tests.

[1] https://lore.kernel.org/all/CAPTztWY8eDSa1qKx35hTm5ef+e13SDnRHDrevc-1V1v7-pEP3w@mail.gmail.com/
[2] https://lore.kernel.org/all/ZRQQMABiVIcXXcrg@dhcp22.suse.cz/
[3] https://github.com/systemd/systemd/pull/39486
[4] https://lore.kernel.org/all/ZRrI90KcRBwVZn%2Fr@dhcp22.suse.cz/
[5] https://lore.kernel.org/all/20231002162133.GC5054@cmpxchg.org/
[6] https://lore.kernel.org/all/CAKEwX=OwrMNMAvve9a965mBJm8as+njtXE993VcnKXdccd5GEw@mail.gmail.com/
[7] https://github.com/kubernetes/kubernetes/issues/144131#issuecomment-7104174643
[8] https://harche.github.io/2026/11/23/notes-on-kubernetes-issue-144131-hugepages.html
[9] https://lore.kernel.org/all/20231006184629.155543-1-nphamcs@gmail.com/

 Documentation/admin-guide/cgroup-v2.rst       |  44 ++++
 include/linux/memcontrol.h                    |   9 +
 mm/memcontrol.c                               |  78 ++++++-
 .../selftests/cgroup/test_hugetlb_memcg.c     | 210 +++++++++++++++++-
 4 files changed, 335 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02..461d041e1 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -245,6 +245,8 @@ cgroup v2 currently supports the following mount options.
         * HugeTLB pages utilized while this option is not selected
           will not be tracked by the memory controller (even if cgroup
           v2 is remounted later on).
+        * A cgroup can be exempted, together with its descendants, by
+          writing "0" to its memory.hugetlb_accounting file.
 
   pids_localevents
         The option restores v1-like behavior of pids.events:max, that is only
@@ -1478,6 +1480,45 @@ The following nested keys are defined.
 	current memory usage for subsequent reads through the same
 	file descriptor.
 
+  memory.hugetlb_accounting
+	A read-write single value file which exists on non-root
+	cgroups.  The default value is "1".
+
+	Determines whether HugeTLB memory used by the cgroup and its
+	descendants is charged to them. The file only has an effect
+	if cgroup v2 is mounted with the memory_hugetlb_accounting
+	option.
+
+	If set to "0", HugeTLB memory used by the cgroup or by any of
+	its descendants is charged to the parent of the cgroup
+	instead. If several cgroups on the path to the root have the
+	file set to "0", it is the parent of the topmost one. The
+	cgroups above therefore keep accounting for the memory, and
+	the file cannot be used to escape their limits. A descendant
+	cannot turn the accounting back on for itself.
+
+	This is meant for hierarchies where a workload manager gives
+	its workloads a HugeTLB budget of their own, with the HugeTLB
+	controller, next to a memory.max that covers only their other
+	memory. Without the exemption such a workload reaches its
+	memory.max as soon as it uses its huge pages.
+
+	HugeTLB folios that are allocated while a cgroup is exempt do
+	not show up in its memory.current, nor in the "hugetlb" entry
+	of its memory.stat, but in those of the cgroup that is charged
+	for them. A HugeTLB fault in an exempt cgroup still results in
+	SIGBUS if the cgroup that is charged, or one above it, is at
+	its memory.max and reclaim fails. The failure is counted in the
+	memory.events of the cgroup whose limit was hit and of its
+	ancestors, not in those of the exempt cgroup.
+
+	Like the limits of a cgroup, the file is meant to be written
+	by the parent, and is not delegatable.
+
+	HugeTLB folios keep the accounting that they got when they
+	were allocated. A change of the file only affects folios that
+	are allocated afterwards.
+
   memory.oom.group
 	A read-write single value file which exists on non-root
 	cgroups.  The default value is "0".
@@ -1815,6 +1856,9 @@ The following nested keys are defined.
 		Amount of memory used by hugetlb pages. This metric only shows
 		up if hugetlb usage is accounted for in memory.current (i.e.
 		cgroup is mounted with the memory_hugetlb_accounting option).
+		HugeTLB memory of cgroups that are exempt through
+		memory.hugetlb_accounting is reported in the cgroup that
+		is charged for it.
 
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6..bcb6e74af 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -342,6 +342,15 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
+#ifdef CONFIG_HUGETLB_PAGE
+	/*
+	 * Charge HugeTLB folios used by this memcg and its descendants to
+	 * them? If not, the folios are charged to the parent of this memcg.
+	 * Only relevant with the memory_hugetlb_accounting mount option.
+	 */
+	bool hugetlb_accounting;
+#endif
+
 #ifdef CONFIG_ZSWAP
 	/*
 	 * Prevent pages from this memcg from being written back from zswap to
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cec..24e35d02e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1738,11 +1738,37 @@ static bool memcg_accounts_hugetlb(void)
 {
 	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_HUGETLB_ACCOUNTING;
 }
+
+/*
+ * A cgroup can keep HugeTLB folios out of its own memory accounting, and out
+ * of that of its descendants, with memory.hugetlb_accounting. Such folios are
+ * charged to the parent of the topmost cgroup that opted out. That way the
+ * cgroups above still account for the memory, and the file cannot be used to
+ * escape their limits.
+ *
+ * The root cgroup has no such file, so there always is a parent to return.
+ */
+static struct mem_cgroup *hugetlb_charge_target(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *target = memcg;
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		if (!READ_ONCE(memcg->hugetlb_accounting))
+			target = parent_mem_cgroup(memcg);
+	}
+
+	return target;
+}
 #else /* CONFIG_HUGETLB_PAGE */
 static bool memcg_accounts_hugetlb(void)
 {
 	return false;
 }
+
+static struct mem_cgroup *hugetlb_charge_target(struct mem_cgroup *memcg)
+{
+	return memcg;
+}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
@@ -4370,6 +4396,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+#ifdef CONFIG_HUGETLB_PAGE
+	WRITE_ONCE(memcg->hugetlb_accounting, true);
+#endif
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4568,6 +4597,9 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->oom_group, false);
+#ifdef CONFIG_HUGETLB_PAGE
+	WRITE_ONCE(memcg->hugetlb_accounting, true);
+#endif
 #ifdef CONFIG_ZSWAP
 	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -5221,6 +5253,36 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int memory_hugetlb_accounting_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%d\n", READ_ONCE(memcg->hugetlb_accounting));
+
+	return 0;
+}
+
+static ssize_t memory_hugetlb_accounting_write(struct kernfs_open_file *of,
+					       char *buf, size_t nbytes,
+					       loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int ret, hugetlb_accounting;
+
+	ret = kstrtoint(strstrip(buf), 0, &hugetlb_accounting);
+	if (ret)
+		return ret;
+
+	if (hugetlb_accounting != 0 && hugetlb_accounting != 1)
+		return -EINVAL;
+
+	WRITE_ONCE(memcg->hugetlb_accounting, hugetlb_accounting);
+
+	return nbytes;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			      size_t nbytes, loff_t off)
 {
@@ -5300,6 +5362,14 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+#ifdef CONFIG_HUGETLB_PAGE
+	{
+		.name = "hugetlb_accounting",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_hugetlb_accounting_show,
+		.write = memory_hugetlb_accounting_write,
+	},
+#endif
 	{
 		.name = "reclaim",
 		.flags = CFTYPE_NS_DELEGATABLE,
@@ -5436,7 +5506,10 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
  * already been obtained and charged to the appropriate hugetlb cgroup
  * controller (if it is enabled).
  *
- * Returns ENOMEM if the memcg is already full.
+ * The folio is charged to the memcg of @mm, or to one of its ancestors if
+ * that memcg is exempt through memory.hugetlb_accounting.
+ *
+ * Returns ENOMEM if the memcg that is charged is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
 int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
@@ -5450,7 +5523,8 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
 		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		goto out;
 
-	if (charge_memcg(folio, memcg, gfp))
+	/* The ancestors of memcg are pinned by the reference we hold on it. */
+	if (charge_memcg(folio, hugetlb_charge_target(memcg), gfp))
 		ret = -ENOMEM;
 
 out:
diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index 8c5aced81..54e34ee79 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -17,12 +17,12 @@
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
 /* borrowed from mm/hmm-tests.c */
-static long get_hugepage_size(void)
+static long get_meminfo(const char *tag)
 {
 	int fd;
 	char buf[2048];
 	int len;
-	char *p, *q, *path = "/proc/meminfo", *tag = "Hugepagesize:";
+	char *p, *q, *path = "/proc/meminfo";
 	long val;
 
 	fd = open(path, O_RDONLY);
@@ -53,7 +53,7 @@ static long get_hugepage_size(void)
 		p = buf;
 
 	val = strtol(p, &q, 0);
-	if (*q != ' ') {
+	if (*q != ' ' && *q != '\n') {
 		/* Error parsing the file */
 		return -1;
 	}
@@ -61,6 +61,11 @@ static long get_hugepage_size(void)
 	return val;
 }
 
+static long get_hugepage_size(void)
+{
+	return get_meminfo("Hugepagesize:");
+}
+
 static int set_file(const char *path, long value)
 {
 	FILE *file;
@@ -196,13 +201,197 @@ static int test_hugetlb_memcg(char *root)
 	return ret;
 }
 
+struct opt_out_args {
+	const char *root;
+	const char *child;
+	const char *parent;
+	const char *grandparent;
+	bool parent_charged;
+	bool grandparent_charged;
+};
+
+static bool opt_out_charged(const char *name, long delta, bool charged)
+{
+	if (charged && values_close(MB(8), delta, 10))
+		return true;
+	if (!charged && delta < MB(2))
+		return true;
+
+	ksft_print_msg("hugetlb usage should%s be charged to the %s.\n",
+		       charged ? "" : " not", name);
+	ksft_print_msg("%s memory increased by %ld\n", name, delta);
+	return false;
+}
+
+static long root_hugetlb(const char *root)
+{
+	return cg_read_key_long(root, "memory.stat", "hugetlb ");
+}
+
+/*
+ * Use 4 hugepages in the child. They must never be charged to the child, and
+ * be charged to the parent and the grandparent as the caller expects.
+ * memory.current is hierarchical, so a charge to the parent also shows up in
+ * the grandparent. Wherever the charge lands, the root must count the pages.
+ */
+static int hugetlb_opt_out_program(const char *cgroup, void *arg)
+{
+	struct opt_out_args *args = arg;
+	long root, child, parent, grandparent, cur;
+	int ret = EXIT_FAILURE;
+	void *addr;
+
+	root = root_hugetlb(args->root);
+	child = cg_read_long(args->child, "memory.current");
+	parent = cg_read_long(args->parent, "memory.current");
+	grandparent = cg_read_long(args->grandparent, "memory.current");
+	if (root < 0 || child < 0 || parent < 0 || grandparent < 0) {
+		ksft_print_msg("fail to read the memory usage.\n");
+		return EXIT_FAILURE;
+	}
+
+	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
+	if (addr == MAP_FAILED) {
+		ksft_print_msg("fail to mmap.\n");
+		return EXIT_FAILURE;
+	}
+	write_data(addr);
+
+	cur = cg_read_long(args->child, "memory.current");
+	if (cur < 0 || !opt_out_charged("child", cur - child, false))
+		goto out;
+
+	cur = cg_read_long(args->parent, "memory.current");
+	if (cur < 0 ||
+	    !opt_out_charged("parent", cur - parent, args->parent_charged))
+		goto out;
+
+	cur = cg_read_long(args->grandparent, "memory.current");
+	if (cur < 0 || !opt_out_charged("grandparent", cur - grandparent,
+					args->grandparent_charged))
+		goto out;
+
+	/* memory.stat is flushed lazily, give the root time to catch up */
+	cur = cg_read_key_long_poll(args->root, "memory.stat", "hugetlb ",
+				    root + LENGTH, 30, DEFAULT_WAIT_INTERVAL_US);
+	if (cur < 0 || !opt_out_charged("root", cur - root, true))
+		goto out;
+
+	munmap(addr, LENGTH);
+	cur = cg_read_long(args->grandparent, "memory.current");
+	if (cur < 0 || cur - grandparent >= MB(2)) {
+		ksft_print_msg("memory usage should go back down.\n");
+		ksft_print_msg("grandparent memory is now %ld, was %ld\n",
+			       cur, grandparent);
+		return ret;
+	}
+
+	return EXIT_SUCCESS;
+
+out:
+	munmap(addr, LENGTH);
+	return ret;
+}
+
+static int test_hugetlb_memcg_opt_out(char *root)
+{
+	char *grandparent, *parent = NULL, *child = NULL;
+	struct opt_out_args args;
+	int ret = KSFT_FAIL;
+
+	grandparent = cg_name(root, "hugetlb_memcg_grandparent");
+	if (!grandparent || cg_create(grandparent)) {
+		ksft_print_msg("fail to create cgroup.\n");
+		goto out;
+	}
+
+	if (cg_write(grandparent, "cgroup.subtree_control", "+memory")) {
+		ksft_print_msg("fail to enable the memory controller.\n");
+		goto out;
+	}
+
+	parent = cg_name(grandparent, "parent");
+	if (!parent || cg_create(parent)) {
+		ksft_print_msg("fail to create cgroup.\n");
+		goto out;
+	}
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory")) {
+		ksft_print_msg("fail to enable the memory controller.\n");
+		goto out;
+	}
+
+	child = cg_name(parent, "child");
+	if (!child || cg_create(child)) {
+		ksft_print_msg("fail to create cgroup.\n");
+		goto out;
+	}
+
+	if (cg_read_long(child, "memory.hugetlb_accounting") < 0) {
+		ret = KSFT_SKIP;
+		goto out;
+	}
+
+	set_nr_hugepages(20);
+	if (get_meminfo("HugePages_Free:") < 4) {
+		ksft_print_msg("not enough free hugepages.\n");
+		ret = KSFT_SKIP;
+		goto out;
+	}
+
+	args.root = root;
+	args.child = child;
+	args.parent = parent;
+	args.grandparent = grandparent;
+
+	/* The child opts out: its hugetlb usage is charged to the parent. */
+	if (cg_write(child, "memory.hugetlb_accounting", "0"))
+		goto out;
+	args.parent_charged = true;
+	args.grandparent_charged = true;
+	if (cg_run(child, hugetlb_opt_out_program, &args))
+		goto out;
+
+	/* The parent opts out too: the grandparent is charged, not the parent. */
+	if (cg_write(parent, "memory.hugetlb_accounting", "0"))
+		goto out;
+	args.parent_charged = false;
+	if (cg_run(child, hugetlb_opt_out_program, &args))
+		goto out;
+
+	/* The child cannot turn the accounting back on for itself. */
+	if (cg_write(child, "memory.hugetlb_accounting", "1"))
+		goto out;
+	if (cg_run(child, hugetlb_opt_out_program, &args))
+		goto out;
+
+	/* The grandparent opts out as well: only the root counts the pages. */
+	if (cg_write(grandparent, "memory.hugetlb_accounting", "0"))
+		goto out;
+	args.grandparent_charged = false;
+	if (cg_run(child, hugetlb_opt_out_program, &args))
+		goto out;
+
+	ret = KSFT_PASS;
+out:
+	if (child)
+		cg_destroy(child);
+	if (parent)
+		cg_destroy(parent);
+	cg_destroy(grandparent);
+	free(child);
+	free(parent);
+	free(grandparent);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
 	int has_memory_hugetlb_acc;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(2);
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -214,6 +403,7 @@ int main(int argc, char **argv)
 	if (get_hugepage_size() != 2048) {
 		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
 		ksft_test_result_skip("test_hugetlb_memcg\n");
+		ksft_test_result_skip("test_hugetlb_memcg_opt_out\n");
 		ksft_finished();
 	}
 
@@ -240,5 +430,17 @@ int main(int argc, char **argv)
 		break;
 	}
 
+	switch (test_hugetlb_memcg_opt_out(root)) {
+	case KSFT_PASS:
+		ksft_test_result_pass("test_hugetlb_memcg_opt_out\n");
+		break;
+	case KSFT_SKIP:
+		ksft_test_result_skip("test_hugetlb_memcg_opt_out\n");
+		break;
+	default:
+		ksft_test_result_fail("test_hugetlb_memcg_opt_out\n");
+		break;
+	}
+
 	ksft_finished();
 }

base-commit: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
-- 
2.54.0 (Apple Git-157)

