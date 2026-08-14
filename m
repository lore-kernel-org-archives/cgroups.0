Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA6142903E
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693885; cv=none; b=UWcaDlFdYvTW7FfzLcHKkT9RSk14pRQ81y37snWWG9uK/F3bJNhTmmpjyOCTDTxLqv3BN4se+on+yfbjJVpUtws/KFy6GDrZmQLr5o4Et3GOFo4JiSp4cNDz2dQfxq25hNjQSIzyeAwMU/xatny8h5UizFuC/sQO8b7tE93DZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693885; c=relaxed/simple;
	bh=KNml3qylZsyyRAyRAOu7866Txel2H9cGlyuwZQXYWyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaEQKeIECsaAbM+p4rSTOvnTaIBGdLCuBuEVI9WXXXDJaY0vwSoUEyLe2Hn/UVtLJqLSIoA417Pbuss6lIobcCMrCbceenxFJPXoLbF6MvKfB8bPl5/CDm4/KuIzTDOQdkvdfJKT9LZqQk8iiGGHG1T9Kv5QQ7ypWX8VqwjJwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gf/R9ob2; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gf/R9ob2"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbedda4c154so439802a12.1
        for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 00:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786693875; x=1787298675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5iC7bId76UQW5d2bpHES0WaC9Y+qxnjqx++rvqn4Nrk=;
        b=gf/R9ob2tcXw5ITDM2Q55sfXM7Iqfjv/mp5oshtFYtglmuULHB4k/VrKpS0uSNjfU+
         O1nSmEazepmYFZNwjnG7YUw5+IV0jt3sklVz5b2elbmjnEfBTEfiXeQlkTPAbjf0/3lC
         SaA9wcIBa3K/3xYPDEHPdmas+hWy7nqXV+qHPiXsDoa40fdvxYKwhIufTJ/belcb8pds
         266LovWQSv8Wbfsh0LLJmPz2M4sdyTMXN8D7KVkA6ZXbjqzL+gr2nYyaeDjF/BHsl6Ql
         HKPw3B0yDBcNHv76OnqnMlaxDahvYXReEh8oyrmG/vMOAZbZrSKMptdHhIHMJC7pZOTM
         1GsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786693875; x=1787298675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5iC7bId76UQW5d2bpHES0WaC9Y+qxnjqx++rvqn4Nrk=;
        b=Q8tuErXnNUfyLANyMpBBW4I167fic7Dwi3q0H4rlN161S8BMVuQbs7Qtp1dOlbDvbF
         rHEgpI21guwh7EqZoNgW488WEEWZPXnzcYg9yIjW0q9FHbgjL69KOnnNjEP6W0LYCU/n
         C8JG1sXJU90CkF5k6ahbE0YQqap7Z1q/r5gsQutrRFeK3wpoILqTRdVict4eYaSdUrUd
         d/RxsVMpUbssZsrqYTv2O2a/eSI3sPCePY/svWJnRzcdKmmQw3XA5bWrAiAeX3HI3P+j
         9uBj4sHP6rw66wd2jeptqun4UkbbDEIcVq5DyC2cX7ogwNxGTQHQCAfeP6nH24yJarvK
         +9Mg==
X-Forwarded-Encrypted: i=1; AHgh+RpdP9vwNLaTQiQFJpnBHkiTVoC7PiePhPIqwOgKEPbqcdJfT3pAL8FD/7feHgHdXV58ka/14G1K@vger.kernel.org
X-Gm-Message-State: AOJu0YxiYz4UNhwzG/XXd1sGkxcE1x7lhV6+KuaNDgX5o1BAggehqCBa
	fifSZSreFa514xzp80JZWPoWK1eXRPQx4gp59dpGoWrQR8cDiyltTCvo
X-Gm-Gg: AR+sD13Esyo4e2sPFbMD6Nli4Z54+2ex5v/JMoKYJlAnGmevEBLhu2RaOxaIyIZ0BPJ
	nRF9dX3DDgvnGWZ0Bku7p+YKmg2iYfXKpKFGJqb+WhVGFdSJ6+fHrwTXV2kBB08l9FVBqwdyp6s
	v6rQ6XbysBk3x6iCnnFRdjd7Se0KUeYp8FRhKP8pHZR8aDJVdrrYDBL0jKjKIRlc7/TnSz8Vw1J
	IXQuVd0PfNwp8X/tHY1Mj2pthIfa5PqvPA7yZHLhf0bCwOBWZEnvCZhq1Yhh47xc8N6dM6odDkj
	w7lO2Vo3yP9gR5jElSD1UjUNoEbgVhs1TDnx/Ql0i9KY68mbRHiMj7JwTrG42jr80XjdYsAYGz2
	pE3QautYBCNDgtXh2v5TGZqCRw+KdVQsnulMrLxGPQwoSWu691j4Mi2g1vh+AGR1pjyK+TjxPXc
	zKtmhTU/tY0SMqumYI2lr33mpWU3ah37s3OKfFtaoewWzAC8s8ldgYef8=
X-Received: by 2002:a05:6a20:12d2:b0:3c3:9746:1fcb with SMTP id adf61e73a8af0-3cc71dc524bmr4264915637.35.1786693874442;
        Fri, 14 Aug 2026 00:51:14 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:73::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea2fe8f1sm1433154eec.23.2026.08.14.00.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:51:13 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
Date: Fri, 14 Aug 2026 00:50:52 -0700
Message-ID: <20260814075054.507089-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814075054.507089-1-ziyang.meme@gmail.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This Patch adds a new selftest, selftests/cgroup/test_memcg_stat_cross_cpu,
which checks the cgroup flush happens correctly by comparing the bpf
read value matches the file reading.

Existing approach in cgroup_iter_memcg only checks whether the read
value is non-zero, rather than compare it with the actually ones, e.g.,

  ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
  ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");

This ensures the flush does happen and take effect, but it does not
check the flush take effect as expected. And this is why we want to
compare with the file reading: it is a stronger evidence for the
correctness of the flush function.

Besides, another check missed from the cgroup_iter_memcg is that it
contains no accumulation tests for a cgroup subtree. Currently it only
creates one children cgroup and puts the reading task in it. The flush
never have a chance to merge-up the changes in the leaves.

Another missing parts for the cgroup_iter_memcg is that it charges the
memory and then reads the stats on the same cpu, which means a (possible
broken) flush that processed only that CPU would pass the weak non-zero
test. The new tests strengthen the check by pin each child to multiple
CPUs. This increase the code length but greatly improves the test
coverage.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   8 +
 tools/testing/selftests/cgroup/Makefile       |  52 ++
 tools/testing/selftests/cgroup/config         |   5 +
 .../selftests/cgroup/lib/cgroup_util.c        |  83 +++
 .../cgroup/lib/include/cgroup_util.h          |   3 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  86 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  21 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 596 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 9 files changed, 858 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..561a3e891b98 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -6,7 +6,15 @@ test_freezer
 test_hugetlb_memcg
 test_kill
 test_kmem
+test_memcg_stat_cross_cpu
 test_memcontrol
 test_pids
 test_zswap
 wait_inotify
+# Artifacts generated by lib.bpf.mk
+/tools
+/host-tools
+*.bpf.o
+*.bpf.d
+*.linked*.o
+*.skel.h
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..01927511c059 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -20,9 +20,51 @@ TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
+# test_memcg_stat_cross_cpu needs clang and a vmlinux with BTF; build it only
+# where both exist, since every other test here needs just a C compiler.
+# lib.mk settles CLANG from LLVM=, but not before OVERRIDE_TARGETS is needed.
+ifneq ($(filter %/,$(LLVM)),)
+CLANG ?= $(LLVM)clang
+else
+CLANG ?= clang$(filter -%,$(LLVM))
+endif
+READELF ?= $(CROSS_COMPILE)readelf
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+# A vmlinux built without CONFIG_DEBUG_INFO_BTF has nothing to dump, and taking
+# it would fail this whole directory rather than just skip the BPF test.  Pick
+# the first candidate that carries BTF; /sys/kernel/btf/vmlinux is raw BTF
+# rather than an ELF file, so it needs no check.
+VMLINUX_BTF ?= $(abspath $(firstword $(foreach v,$(wildcard $(VMLINUX_BTF_PATHS)),\
+		 $(if $(filter /sys/kernel/btf/%,$(v)),$(v),\
+		   $(if $(shell $(READELF) -S "$(v)" 2>/dev/null | grep -F .BTF),$(v))))))
+# Either of the two knobs lib.bpf.mk takes instead of a vmlinux will do.
+HAVE_BPF := $(and $(or $(VMLINUX_H),$(VMLINUX_BTF)),			\
+		  $(shell command -v $(CLANG) 2>/dev/null))
+
+ifneq ($(HAVE_BPF),)
+TEST_GEN_PROGS += test_memcg_stat_cross_cpu
+BPF_SRCS := memcg_stat_cross_cpu.bpf.c
+# Suppresses lib.mk's default C link rule, re-supplied below.
+OVERRIDE_TARGETS := 1
+endif
+
 include ../lib.mk
 include lib/libcgroup.mk
 
+ifneq ($(HAVE_BPF),)
+include ../lib.bpf.mk
+
+# The default link rule for the plain tests, which OVERRIDE_TARGETS removed.
+LOCAL_HDRS += $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
+$(OUTPUT)/%: %.c $(LOCAL_HDRS)
+	$(call msg,CC,,$@)
+	$(Q)$(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
+endif
+
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
@@ -33,3 +75,13 @@ $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
+
+ifneq ($(HAVE_BPF),)
+# Links cgroup_util and the skeleton against the libbpf lib.bpf.mk built.  The
+# uapi include is private to this binary: the other tests here must keep
+# resolving <linux/*.h> against the system headers.
+$(OUTPUT)/test_memcg_stat_cross_cpu: private CFLAGS += -I$(top_srcdir)/tools/include/uapi
+$(OUTPUT)/test_memcg_stat_cross_cpu: test_memcg_stat_cross_cpu.c \
+					$(BPF_SKELS) $(LIBCGROUP_O) $(BPFOBJ)
+	$(call bpf_link,$@,$< $(LIBCGROUP_O))
+endif
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..356b6a533d88 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,8 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_INFO_BTF=y
+CONFIG_DEBUG_INFO_DWARF4=y
diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..0ae76e75e7f8 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -54,6 +54,89 @@ ssize_t write_text(const char *path, char *buf, ssize_t len)
 	return len < 0 ? -errno : len;
 }
 
+/**
+ * cg_get_id - return the kernfs id of a cgroup directory
+ * @cgroup: absolute path to the cgroup directory
+ *
+ * This is what the kernel gives BPF as cgrp->kn->id, taken from the cgroupfs
+ * file handle.  It is not the directory's st_ino.
+ *
+ * Return: The cgroup id, or 0 on failure.
+ */
+unsigned long long cg_get_id(const char *cgroup)
+{
+	union {
+		unsigned long long id;
+		unsigned char raw[8];
+	} handle;
+	struct file_handle *fhp, *fhp2;
+	int mount_id, fhsize, err;
+	unsigned long long ret = 0;
+
+	fhsize = sizeof(*fhp);
+	fhp = calloc(1, fhsize);
+	if (!fhp)
+		return 0;
+
+	/* The probe fails and reports the size; a cgroupfs handle is 8 bytes. */
+	err = name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0);
+	if (err >= 0 || fhp->handle_bytes != 8)
+		goto out;
+
+	fhsize = sizeof(*fhp) + fhp->handle_bytes;
+	fhp2 = realloc(fhp, fhsize);
+	if (!fhp2)
+		goto out;
+	fhp = fhp2;
+
+	if (name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0) < 0)
+		goto out;
+
+	memcpy(handle.raw, fhp->f_handle, 8);
+	ret = handle.id;
+out:
+	free(fhp);
+	return ret;
+}
+
+/**
+ * cg_touch_pages - write to every page of a region so it becomes resident
+ * @buf: start of the region
+ * @size: length of the region in bytes
+ *
+ * The pages are charged to the calling task's cgroup, on the cpu it runs on.
+ */
+void cg_touch_pages(char *buf, size_t size)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	char *ptr;
+
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
+		*ptr = 0;
+}
+
+/**
+ * cg_alloc_anon - allocate anonymous memory and fault it in
+ * @size: bytes to allocate
+ *
+ * Return: The region, to be released with free(), or NULL.
+ */
+char *cg_alloc_anon(size_t size)
+{
+	char *buf = malloc(size);
+
+	if (!buf) {
+		fprintf(stderr, "malloc() failed\n");
+		return NULL;
+	}
+
+	cg_touch_pages(buf, size);
+	return buf;
+}
+
 char *cg_name(const char *root, const char *name)
 {
 	size_t len = strlen(root) + strlen(name) + 2;
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 8ebb2b4d4ec0..640778018780 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -54,6 +54,9 @@ extern ssize_t write_text(const char *path, char *buf, ssize_t len);
 extern int cg_find_controller_root(char *root, size_t len, const char *controller);
 extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
+extern unsigned long long cg_get_id(const char *cgroup);
+extern void cg_touch_pages(char *buf, size_t size);
+extern char *cg_alloc_anon(size_t size);
 extern char *cg_name_indexed(const char *root, const char *name, int index);
 extern char *cg_control(const char *cgroup, const char *control);
 extern int cg_create(const char *cgroup);
diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
new file mode 100644
index 000000000000..3c2acd49c16b
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#define BPF_NO_KFUNC_PROTOTYPES
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include "memcg_stat_cross_cpu.h"
+
+char _license[] SEC("license") = "GPL";
+
+/*
+ * Declared here rather than taken from vmlinux.h, which only has them if the
+ * build host's own kernel does.  A kernel without them is caught at run time.
+ */
+struct mem_cgroup *bpf_get_mem_cgroup(struct cgroup_subsys_state *css) __ksym;
+void bpf_put_mem_cgroup(struct mem_cgroup *memcg) __ksym;
+void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg) __ksym;
+unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx) __ksym;
+unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
+				       enum vm_event_item event) __ksym;
+
+/*
+ * Results keyed by cgroup id, which is the same value cg_get_id() returns.
+ * Userspace resizes the map to the subtree before load.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u64);
+	__type(value, struct memcg_stat_snapshot);
+} results SEC(".maps");
+
+/*
+ * Flush once at the subtree root, then read each cgroup through the kfuncs.
+ * iter.s because the flush kfunc may sleep.
+ */
+SEC("iter.s/cgroup")
+int cgroup_memcg_stat_cross_cpu(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct memcg_stat_snapshot snap = {};
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	int idx_anon, idx_file, idx_shmem, idx_fmapped, idx_pgfault;
+	__u64 cg_id;
+
+	/* The walk ends with a NULL element; return 0 so it runs to the end. */
+	if (!cgrp)
+		return 0;
+
+	css = &cgrp->self;
+	memcg = bpf_get_mem_cgroup(css);
+	if (!memcg)
+		return 0;
+
+	/*
+	 * seq_num 0 is the subtree root in DESCENDANTS_PRE order, and the flush
+	 * is subtree-wide, so one call brings every descendant up to date.
+	 */
+	if (ctx->meta->seq_num == 0)
+		bpf_mem_cgroup_flush_stats(memcg);
+
+	cg_id = BPF_CORE_READ(cgrp, kn, id);
+	snap.cgroup_id = cg_id;
+
+	idx_anon = bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED);
+	idx_file = bpf_core_enum_value(enum node_stat_item, NR_FILE_PAGES);
+	idx_shmem = bpf_core_enum_value(enum node_stat_item, NR_SHMEM);
+	idx_fmapped = bpf_core_enum_value(enum node_stat_item, NR_FILE_MAPPED);
+	idx_pgfault = bpf_core_enum_value(enum vm_event_item, PGFAULT);
+
+	snap.anon = bpf_mem_cgroup_page_state(memcg, idx_anon);
+	snap.file = bpf_mem_cgroup_page_state(memcg, idx_file);
+	snap.shmem = bpf_mem_cgroup_page_state(memcg, idx_shmem);
+	snap.file_mapped = bpf_mem_cgroup_page_state(memcg, idx_fmapped);
+	snap.pgfault = bpf_mem_cgroup_vm_events(memcg, idx_pgfault);
+
+	/* page_counter fields need no kfunc; read them off the trusted ptr. */
+	snap.usage_pages = BPF_CORE_READ(memcg, memory.usage.counter);
+	snap.max_pages = BPF_CORE_READ(memcg, memory.max);
+
+	bpf_map_update_elem(&results, &cg_id, &snap, BPF_ANY);
+
+	bpf_put_mem_cgroup(memcg);
+	return 0;
+}
diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
new file mode 100644
index 000000000000..7177ab3b9380
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#ifndef __MEMCG_STAT_CROSS_CPU_H
+#define __MEMCG_STAT_CROSS_CPU_H
+
+/*
+ * One per-cgroup snapshot, written by the BPF program and read by the test, so
+ * the fields are fixed-width rather than the long the other cgroup tests use.
+ */
+struct memcg_stat_snapshot {
+	__u64 cgroup_id;
+	__u64 anon;		/* NR_ANON_MAPPED, bytes */
+	__u64 file;		/* NR_FILE_PAGES, bytes */
+	__u64 shmem;		/* NR_SHMEM, bytes */
+	__u64 file_mapped;	/* NR_FILE_MAPPED, bytes */
+	__u64 pgfault;		/* PGFAULT, count */
+	__u64 usage_pages;	/* page_counter memory.usage, in PAGES */
+	__u64 max_pages;	/* page_counter memory.max, in PAGES */
+};
+
+#endif /* __MEMCG_STAT_CROSS_CPU_H */
diff --git a/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
new file mode 100644
index 000000000000..9946c41c7a90
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
@@ -0,0 +1,596 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+
+/*
+ * Compare the memcg BPF kfuncs with memory.stat over a cgroup subtree whose
+ * charge is scattered across many CPUs.
+ *
+ * One child per leaf faults a region on K different CPUs and holds it, then the
+ * subtree is read by a SEC("iter.s/cgroup") program and from memory.stat.  The
+ * two readers must return the same values, which checks the readers.  The flush
+ * is checked by two invariants: each leaf's anon covers the charge it holds, and
+ * the root's equals the sum of the leaves'.  Comparing the readers cannot check
+ * the flush, because a flush clears the pending-update count the next one is
+ * gated on, so the second reader returns what the first one left.
+ *
+ * The comparison is exact, which needs the subtree quiesced: only this test's
+ * children charge it, and they block once their memory is faulted in.  Global
+ * reclaim would move the numbers and the test would report a mismatch.
+ * file, shmem and file_mapped are 0 under this workload; they are compared to
+ * keep the field set complete, not because the workload produces them.
+ */
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdint.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/wait.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+#include "memcg_stat_cross_cpu.h"
+#include "memcg_stat_cross_cpu.skel.h"
+
+#define SUBTREE_NAME		"mcg_xcpu"
+
+#define MEMCG_CHARGE_BATCH	64
+
+#define FLUSH_MARGIN		4
+
+#define CHARGE_WAIT_RETRIES	100
+
+static char root[PATH_MAX];
+static char *subtree_root;
+static long page_size;
+
+/* Values parsed from memory.stat / memory.current, in bytes. */
+struct file_snap {
+	long anon, file, shmem, file_mapped, pgfault;
+	long current;
+};
+
+struct cg_node {
+	char path[PATH_MAX];
+	unsigned long long id;
+	bool is_leaf;			/* holds a charge of its own */
+	struct memcg_stat_snapshot bpf;	/* read through the kfuncs */
+	struct file_snap file;		/* read from memory.stat */
+};
+
+static struct cg_node *nodes;	/* DFS order: a parent precedes its children */
+static int n_nodes;
+static int n_leaves;
+
+/* ---- CPUs this test may run on ----------------------------------------- */
+
+static cpu_set_t allowed_cpus;
+static int n_cpu;
+
+static int nth_cpu(int n)
+{
+	int i, seen = 0;
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+		if (seen++ == n % n_cpu)
+			return i;
+	}
+	return -1;
+}
+
+static int pin_cpu(int cpu)
+{
+	cpu_set_t set;
+
+	if (cpu < 0)
+		return -1;
+
+	CPU_ZERO(&set);
+	CPU_SET(cpu, &set);
+	return sched_setaffinity(0, sizeof(set), &set);
+}
+
+/* ---- tree construction -------------------------------------------------- */
+
+static int add_node(const char *path, bool is_leaf)
+{
+	struct cg_node *n = &nodes[n_nodes];
+
+	if (cg_create(path))
+		return -1;
+
+	strncpy(n->path, path, sizeof(n->path) - 1);
+	n->id = cg_get_id(path);
+	n->is_leaf = is_leaf;
+	if (is_leaf)
+		n_leaves++;
+	n_nodes++;
+	return 0;
+}
+
+/* Create # @levels more levels below @path.
+ * Only the last level is charged.
+ */
+static int build_children(const char *path, int fanout, int levels)
+{
+	char child[PATH_MAX];
+	int i;
+
+	if (levels == 0)
+		return 0;
+
+	/* Enable memory on this interior node so its children get a memcg. */
+	if (cg_write(path, "cgroup.subtree_control", "+memory"))
+		return -1;
+
+	for (i = 0; i < fanout; i++) {
+		snprintf(child, sizeof(child), "%s/c%d", path, i);
+		if (add_node(child, levels == 1))
+			return -1;
+		if (build_children(child, fanout, levels - 1))
+			return -1;
+	}
+	return 0;
+}
+
+static size_t tree_capacity(int fanout, int depth)
+{
+	size_t total = 1, level = 1;
+	int d;
+
+	for (d = 0; d < depth; d++) {
+		level *= fanout;
+		total += level;
+	}
+	return total;
+}
+
+static int build_tree(int fanout, int depth, int *root_fd)
+{
+	n_nodes = 0;
+	n_leaves = 0;
+	nodes = calloc(tree_capacity(fanout, depth), sizeof(*nodes));
+	if (!nodes)
+		return -1;
+
+	if (add_node(subtree_root, depth == 0))
+		return -1;
+
+	*root_fd = open(subtree_root, O_RDONLY);
+	if (*root_fd < 0)
+		return -1;
+
+	return build_children(subtree_root, fanout, depth);
+}
+
+/*
+ * Remove in reverse creation order, so a child always goes before its parent.
+ * cg_destroy() kills the charging children; reap them afterwards.
+ */
+static void destroy_tree(void)
+{
+	int i;
+
+	if (!nodes)
+		return;
+
+	for (i = n_nodes - 1; i >= 0; i--)
+		cg_destroy(nodes[i].path);
+	free(nodes);
+	nodes = NULL;
+
+	while (waitpid(-1, NULL, 0) > 0)
+		;
+}
+
+/* ---- cross-CPU charge (one child per leaf) ------------------------------ */
+
+struct charge_args {
+	size_t bytes;	/* anon this leaf holds */
+	int base;	/* index of the first CPU to fault on */
+	int k;		/* CPUs to spread the charge over */
+};
+
+static int charge_leaf(const char *cgroup, void *arg)
+{
+	const struct charge_args *ca = arg;
+	int ppid = getppid();
+	size_t per, off;
+	char *buf;
+	int j;
+
+	buf = malloc(ca->bytes);
+	if (!buf) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
+	/* Whole pages, or several slices would share one page and one CPU. */
+	per = ca->bytes / ca->k / page_size * page_size;
+
+	for (j = 0; j < ca->k; j++) {
+		off = (size_t)j * per;
+		if (pin_cpu(nth_cpu(ca->base + j))) {
+			free(buf);
+			return -1;
+		}
+		cg_touch_pages(buf + off,
+			       j == ca->k - 1 ? ca->bytes - off : per);
+	}
+
+	while (getppid() == ppid)
+		sleep(1);
+
+	free(buf);
+	return 0;
+}
+
+static size_t leaf_charge(size_t want, int k)
+{
+	long online = sysconf(_SC_NPROCESSORS_ONLN);
+	size_t floor;
+
+	floor = (size_t)FLUSH_MARGIN * MEMCG_CHARGE_BATCH * online *
+		page_size / n_leaves;
+	if (want < floor)
+		want = floor;
+	if (want < (size_t)k * page_size)
+		want = (size_t)k * page_size;
+
+	return (want + page_size - 1) / page_size * page_size;
+}
+
+static int start_chargers(int k, size_t bytes)
+{
+	struct charge_args ca = { .bytes = bytes, .k = k };
+	long prev, cur;
+	int i, retries;
+
+	for (i = 0; i < n_nodes; i++) {
+		if (!nodes[i].is_leaf)
+			continue;
+		if (cg_run_nowait(nodes[i].path, charge_leaf, &ca) < 0) {
+			ksft_print_msg("cannot start a charger on %s\n",
+				       nodes[i].path);
+			return -1;
+		}
+		ca.base += k;
+	}
+
+	for (i = 0; i < n_nodes; i++) {
+		if (!nodes[i].is_leaf)
+			continue;
+		/*
+		 * Wait for the charge to both cover the region and stop
+		 * moving.
+		 */
+		prev = -1;
+		for (retries = CHARGE_WAIT_RETRIES; retries; retries--) {
+			cur = cg_read_long(nodes[i].path, "memory.current");
+			if (cur >= (long)bytes && cur == prev)
+				break;
+			prev = cur;
+			usleep(DEFAULT_WAIT_INTERVAL_US / 10);
+		}
+		if (!retries) {
+			ksft_print_msg("%s never reached its charge\n",
+				       nodes[i].path);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/* ---- the two readers ---------------------------------------------------- */
+
+/*
+ * Collect what the kfuncs report.  The program flushes at the first cgroup it
+ * sees, the subtree root in DESCENDANTS_PRE order.
+ */
+static int read_bpf(int root_fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct memcg_stat_cross_cpu *skel = NULL;
+	union bpf_iter_link_info linfo = {};
+	struct bpf_link *link = NULL;
+	int ret = -1, i, mfd, fd;
+	char buf[4096];
+	ssize_t r;
+
+	skel = memcg_stat_cross_cpu__open();
+	if (!skel) {
+		ksft_print_msg("skel open failed\n");
+		return -1;
+	}
+	if (bpf_map__set_max_entries(skel->maps.results, n_nodes + 8)) {
+		ksft_print_msg("set max_entries failed\n");
+		goto out;
+	}
+	if (memcg_stat_cross_cpu__load(skel)) {
+		ksft_print_msg("skel load failed\n");
+		goto out;
+	}
+
+	linfo.cgroup.cgroup_fd = root_fd;
+	linfo.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_memcg_stat_cross_cpu,
+					&opts);
+	if (!link) {
+		ksft_print_msg("attach iter failed\n");
+		goto out;
+	}
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (fd < 0) {
+		ksft_print_msg("bpf_iter_create failed\n");
+		goto out;
+	}
+	while ((r = read(fd, buf, sizeof(buf))) > 0)
+		;
+	close(fd);
+	if (r) {
+		ksft_print_msg("bpf walk failed\n");
+		goto out;
+	}
+
+	mfd = bpf_map__fd(skel->maps.results);
+	for (i = 0; i < n_nodes; i++)
+		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &nodes[i].bpf)) {
+			ksft_print_msg("no map entry for %s\n", nodes[i].path);
+			goto out;
+		}
+	ret = 0;
+out:
+	bpf_link__destroy(link);
+	memcg_stat_cross_cpu__destroy(skel);
+	return ret;
+}
+
+/* Read the same numbers from cgroupfs, on the same tree, right afterwards. */
+static int read_files(void)
+{
+	int i;
+
+	for (i = 0; i < n_nodes; i++) {
+		const char *path = nodes[i].path;
+		struct file_snap *f = &nodes[i].file;
+
+		f->anon = cg_read_key_long(path, "memory.stat", "anon ");
+		f->file = cg_read_key_long(path, "memory.stat", "file ");
+		f->shmem = cg_read_key_long(path, "memory.stat", "shmem ");
+		f->file_mapped = cg_read_key_long(path, "memory.stat",
+						  "file_mapped ");
+		f->pgfault = cg_read_key_long(path, "memory.stat", "pgfault ");
+		f->current = cg_read_long(path, "memory.current");
+
+		if (f->anon < 0 || f->file < 0 || f->shmem < 0 ||
+		    f->file_mapped < 0 || f->pgfault < 0 || f->current < 0) {
+			ksft_print_msg("reading the stats of %s failed\n", path);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/* ---- comparison --------------------------------------------------------- */
+
+static void dump_node(const struct cg_node *n)
+{
+	ksft_print_msg("%s bpf : anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
+		       n->path, n->bpf.anon, n->bpf.file, n->bpf.shmem,
+		       n->bpf.file_mapped, n->bpf.pgfault);
+	ksft_print_msg("%s file: anon=%ld file=%ld shmem=%ld fmapped=%ld pgfault=%ld\n",
+		       n->path, n->file.anon, n->file.file, n->file.shmem,
+		       n->file.file_mapped, n->file.pgfault);
+}
+
+/* The subtree is quiesced, so the two readers must agree exactly. */
+#define STAT_TOLERANCE_PCT	0
+
+static int check_tree(size_t charged)
+{
+	unsigned long long root_anon = 0, leaf_anon = 0;
+	int i, bad = 0;
+
+	for (i = 0; i < n_nodes; i++) {
+		const struct cg_node *n = &nodes[i];
+		const struct memcg_stat_snapshot *b = &n->bpf;
+
+		if (!values_close(b->anon, n->file.anon, STAT_TOLERANCE_PCT) ||
+		    !values_close(b->file, n->file.file, STAT_TOLERANCE_PCT) ||
+		    !values_close(b->shmem, n->file.shmem, STAT_TOLERANCE_PCT) ||
+		    !values_close(b->file_mapped, n->file.file_mapped,
+				  STAT_TOLERANCE_PCT) ||
+		    !values_close(b->pgfault, n->file.pgfault,
+				  STAT_TOLERANCE_PCT)) {
+			ksft_print_msg("kfuncs disagree with memory.stat\n");
+			dump_node(n);
+			bad++;
+		}
+
+		/*
+		 * Usage is a live page_counter read, not a flushed statistic,
+		 * so it is only a bound.
+		 */
+		if (b->anon > b->usage_pages * (unsigned long long)page_size ||
+		    n->file.anon > n->file.current) {
+			ksft_print_msg("%s: anon above usage: bpf %llu/%llu file %ld/%ld\n",
+				       n->path, b->anon,
+				       b->usage_pages * (unsigned long long)page_size,
+				       n->file.anon, n->file.current);
+			bad++;
+		}
+
+		if (n->is_leaf) {
+			if (b->anon < charged) {
+				ksft_print_msg("%s: flushed anon %llu, charged %zu\n",
+					       n->path, b->anon, charged);
+				bad++;
+			}
+			leaf_anon += b->anon;
+		}
+		if (i == 0)
+			root_anon = b->anon;
+	}
+
+	if (root_anon != leaf_anon) {
+		ksft_print_msg("subtree root anon %llu, sum of the leaves %llu\n",
+			       root_anon, leaf_anon);
+		bad++;
+	}
+	return bad ? -1 : 0;
+}
+
+/*
+ * memory.max is never set, so the counter must read PAGE_COUNTER_MAX.  That is
+ * LONG_MAX on a 32-bit kernel and LONG_MAX / PAGE_SIZE elsewhere, and the width
+ * of a userspace long does not tell us which, so accept either.
+ */
+static int check_unlimited(void)
+{
+	unsigned long long max64 = (unsigned long long)INT64_MAX / page_size;
+	unsigned long long max32 = INT32_MAX;
+
+	if (cg_read_strcmp(nodes[0].path, "memory.max", "max\n"))
+		return 0;
+
+	if (nodes[0].bpf.max_pages != max64 && nodes[0].bpf.max_pages != max32) {
+		ksft_print_msg("memory.max reads max, kfunc reports %llu pages\n",
+			       nodes[0].bpf.max_pages);
+		return -1;
+	}
+	return 0;
+}
+
+/* ---- one case ----------------------------------------------------------- */
+
+struct testcase {
+	const char *name;
+	int fanout;
+	int depth;
+	int cpus_per_leaf;	/* K, or 0 for every CPU */
+	size_t resident_bytes;	/* anon per leaf, raised if too small */
+};
+
+static int run_case(const struct testcase *tc)
+{
+	int root_fd = -1, ret = KSFT_FAIL, k;
+	size_t charged;
+
+	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
+		ksft_print_msg("cannot build the tree\n");
+		goto out;
+	}
+
+	k = tc->cpus_per_leaf;
+	if (k <= 0 || k > n_cpu)
+		k = n_cpu;
+	charged = leaf_charge(tc->resident_bytes, k);
+
+	ksft_print_msg("%s: %d cgroups, %d leaves, %d/%d cpus, %zuKB per leaf\n",
+		       tc->name, n_nodes, n_leaves, k, n_cpu, charged >> 10);
+
+	if (start_chargers(k, charged))
+		goto out;
+
+	/* kfuncs first: their flush is the one that has work to do */
+	if (read_bpf(root_fd) || read_files())
+		goto out;
+
+	if (!check_tree(charged) && !check_unlimited())
+		ret = KSFT_PASS;
+out:
+	if (root_fd >= 0)
+		close(root_fd);
+	destroy_tree();
+	return ret;
+}
+
+static const struct testcase cases[] = {
+	/* name, fanout, depth, K, anon per leaf */
+	{ "single_cpu_small_tree", 4, 2, 1, 2 << 20 },
+	{ "cross_cpu_small_tree", 4, 2, 0, 2 << 20 },
+	{ "single_cpu_large_tree", 10, 3, 1, 256 << 10 },
+	{ "cross_cpu_large_tree", 10, 3, 0, 256 << 10 },
+};
+
+static bool memcg_kfuncs_available(void)
+{
+	struct btf *btf;
+	bool ok;
+
+	btf = btf__load_vmlinux_btf();
+	if (!btf)
+		return false;
+	ok = btf__find_by_name_kind(btf, "bpf_get_mem_cgroup", BTF_KIND_FUNC) > 0;
+	btf__free(btf);
+	return ok;
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	ksft_print_header();
+
+	/* Feature gate first: a read-only BTF probe, no privilege needed. */
+	if (!memcg_kfuncs_available())
+		ksft_exit_skip("memcg BPF kfuncs are not available\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+
+	CPU_ZERO(&allowed_cpus);
+	if (sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus))
+		ksft_exit_skip("cannot read CPU affinity\n");
+	n_cpu = CPU_COUNT(&allowed_cpus);
+	if (n_cpu <= 0)
+		ksft_exit_skip("no CPU to run on\n");
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
+	subtree_root = cg_name(root, SUBTREE_NAME);
+	if (!subtree_root)
+		ksft_exit_skip("cannot build subtree root path\n");
+
+	/* Set the plan only once nothing can skip the whole run any more. */
+	ksft_set_plan(ARRAY_SIZE(cases));
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		switch (run_case(&cases[i])) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", cases[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", cases[i].name);
+			break;
+		}
+	}
+
+	free(subtree_root);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ebf796f3cff..15ba46879504 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -26,7 +26,6 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
-static int page_size;
 
 int get_temp_fd(void)
 {
@@ -56,28 +55,12 @@ int alloc_pagecache(int fd, size_t size)
 	return -1;
 }
 
-static char *alloc_and_populate_anon(size_t size)
-{
-	char *buf, *ptr;
-
-	buf = malloc(size);
-	if (buf == NULL) {
-		fprintf(stderr, "malloc() failed\n");
-		return NULL;
-	}
-
-	for (ptr = buf; ptr < buf + size; ptr += page_size)
-		*ptr = 0;
-
-	return buf;
-}
-
 int alloc_anon(const char *cgroup, void *arg)
 {
 	size_t size = (unsigned long)arg;
 	char *buf;
 
-	buf = alloc_and_populate_anon(size);
+	buf = cg_alloc_anon(size);
 	if (!buf)
 		return -1;
 
@@ -195,7 +178,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	long anon, current;
 	int ret = -1;
 
-	buf = alloc_and_populate_anon(size);
+	buf = cg_alloc_anon(size);
 	if (!buf)
 		return -1;
 
@@ -420,7 +403,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 	size_t size = (unsigned long)arg;
 	char *buf;
 
-	buf = alloc_and_populate_anon(size);
+	buf = cg_alloc_anon(size);
 	if (!buf)
 		return -1;
 
@@ -1001,7 +984,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 	long mem_current, swap_current;
 	int ret = -1;
 
-	buf = alloc_and_populate_anon(size);
+	buf = cg_alloc_anon(size);
 	if (!buf)
 		return -1;
 
@@ -1793,10 +1776,6 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-	if (page_size <= 0)
-		page_size = BUF_SIZE;
-
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0-Meta

