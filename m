Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0F73A782D
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 23:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789083219; cv=none; b=qwch8vzrp1WKt1cwJiO1IhwnFDQI1W/uA77ytz4gyh0FNbfTEGwyF1iwKOFtrQ+6NI8d3o8r/PGRPBQkEoLHOkQFOGyixISUzMOI+iGogvLeuECaBrP4wxJ8rB1QihxcCnuIWH0RgGCRpEvv/RizXPS5jKAuJnLai5sYWpqxlo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789083219; c=relaxed/simple;
	bh=66qI0vpHG962sS/UMWH0GFqxWqyTWVi17oz4qjDDGzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ9/8JYZFkFs/8RBGUxQ/KEeAllavbIHae5AFGzwhJUwY0gO9cUUd5RCpzfeC2HxB+tjKChvoiW4Kf4qCO638A51qtWmCJxqHXpBxpLz7EuhFqp/1my6ISy9bQCL+lF2AxQj1hijhZcm5YkheWinugEhHu4Ny+jH1ABk8SoKgq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JL5kg1qd; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JL5kg1qd"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4ae61629fso286891a12.2
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 16:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789083214; x=1789688014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PjUXb2rSTUzrLWfAMZJGZKA79/RCMm1RRL9dx3vd09Y=;
        b=JL5kg1qdaA0ro1nF03qCRCwy8TR0oNYYE6Uvgjn9365+LycPqUamnWxzdYR97E8tas
         ghwCN8tXcmGncFYrmmKsYCwzaNu7gm6+2W0NFto4vKIkWkEDYZfyh+2t85gIeSOUxBYE
         wHK61toKAtgtHS5SB49X0+a7BBJ58rGAvr3VjoLGBzDg8c59Q5GbN88E6JXKFPb5XBIk
         oLlCrPFQA21Ksy/PV32VMwtY/kWWcLoe3/h37NogAAcXqStfA+ao0ZSn/HdJAfswCZRl
         BsUMTbhtiOTCtbb8nvJT/3+JBFYcwxpICD7PEwOrQopoqWMCmcsLYoTlF7/umOCMEw7L
         mhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083214; x=1789688014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PjUXb2rSTUzrLWfAMZJGZKA79/RCMm1RRL9dx3vd09Y=;
        b=QT+T8EYYzWDCnQbbVn9L7oi8Dy9y4WMyqPDxsFlBgp7H7g1bM+qmkrhS9aRJv6khJF
         u54w2MgV+bx9X5X3xSQDw/lOzpsB5G9P/zTPpTHMqB4zu3Nqb36JiSK8SSqLzDvMuGt8
         5Qn0aLjVZME5NyvJ6X7v2f3D9vvfrpNMhSTChJp1sZ5VR3nC7T5Qpu5xUoyNnl7gq1zg
         TN7HNmNagN0KRuJITv2x3474IOXifRbtH5TXRq+pyqDB1hWDbNmflo2RALgKqzAYrG6e
         dmIfyahULN8vBjFdUQVD8LkrpuJTZhwJLDL62J75VsuCSdpeZ23Z+gjbH4IBOwUmPXbN
         BSog==
X-Forwarded-Encrypted: i=1; AKwUvBxjS12bWn0yDbuwSFXlWpAgVea6CCXH1/X1CxKBwsbMbL0FCa6X6/hTsXzY97ODTj7Tk3T/Dxtl@vger.kernel.org
X-Gm-Message-State: AFuF++kM6b/+b4C7hHfJiMkqb2gXU7Egx2CTpLyOvGxYijWcR10y2Tq3
	oHtkofocJfgRYEcPwJyX7p7FtU7B8jSfj6GMeSh8Zv+VTHlDB2g7H433
X-Gm-Gg: AYBFou0pL15uwq5Rx9mIYs/NxgmuL+pSDTdQUgPRE/2lHXhidR1LoGRqQFYwmLUZ6dy
	jEVIZRzlF5U6qeH8QdeVzUkmDKJSeFbWlAu3SKvT7AjtQ+A231MKy4Iy3q+3xqQuGKxutXdlHu9
	bUPSKCYLNTnXlrUl7s1Q0GwwNeXyFzUnCFCu8EM0dAEzeUc0e7oqSd1iYpTWdXEI+78tNoO+Zvi
	iMr4j44ZK17mbyTPZ4DWvd8uG5cOIUWPQgrqw5sQ/rJLjghbTB4VNkDQjI2j+65Ywj4bze24nYC
	rn0y1UWqtXNkajon5MQWVdynN/U3PbQ+xcCLJyQZ+pNwJorgignAXWrOwr5jOD8ZENwAjTfN3ZA
	9WM2waenERHrrSrvWMS6oORgt/tQ3GTdldXosSxu5iOGBMTt3noCM0eqUfLLTS+Y6AoYukVmmxC
	3G6XmGfehMU7/E+Izpujr2gQIML9ipIQP1AiE6XIM2rvEg+hCaQn5NLGViRdslIg0h2oTE1C+Yf
	4Qd
X-Received: by 2002:a05:6a21:113:b0:3cf:a7a5:e310 with SMTP id adf61e73a8af0-3daed2c08f3mr2423764637.9.1789083213776;
        Thu, 10 Sep 2026 16:33:33 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:45::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e9a8a9sm1254950eec.13.2026.09.10.16.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:33:33 -0700 (PDT)
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
Subject: [PATCH v5 2/4] selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
Date: Thu, 10 Sep 2026 16:33:01 -0700
Message-ID: <20260910233303.1063501-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910233303.1063501-1-ziyang.meme@gmail.com>
References: <20260910233303.1063501-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add test_memcg_stat_cross_cpu, which verifies that flushing a memcg
subtree produces the same statistics through the BPF memcg kfuncs and
cgroupfs.

The existing cgroup_iter_memcg test only checks that selected values are
non-zero.  That can pass even when aggregation is incomplete, and it does
not exercise a hierarchy with charges spread over multiple CPUs.

Build a multi-level cgroup tree, charge each leaf from several CPUs, flush
the subtree once from a sleepable cgroup iterator, then compare every
reported value with memory.stat.  Also check that the root value equals the
sum of its leaves.

Probe all required kfuncs and sleepable iterator support before running.
Bound CPU fanout and aggregate memory use so large systems skip cases that
would exceed the limit instead of exhausting resources.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   8 +
 tools/testing/selftests/cgroup/Makefile       |  46 ++
 tools/testing/selftests/cgroup/config         |   5 +
 .../selftests/cgroup/lib/cgroup_util.c        |  82 ++
 .../cgroup/lib/include/cgroup_util.h          |   3 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         | 101 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  18 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 755 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 9 files changed, 1022 insertions(+), 25 deletions(-)
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
index e01584c2189a..cb999bc2c875 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -20,9 +20,46 @@ TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
+# Resolve Clang early so the optional BPF test can be selected.
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
+# Ignore ELF images without .BTF; raw sysfs BTF needs no check.
+VMLINUX_BTF ?= $(abspath $(firstword $(foreach v,$(wildcard $(VMLINUX_BTF_PATHS)),\
+		 $(if $(filter /sys/kernel/btf/%,$(v)),$(v),\
+		   $(if $(shell $(READELF) -S "$(v)" 2>/dev/null | grep -F .BTF),$(v))))))
+# Accept either a supplied header or usable BTF.
+HAVE_BPF := $(and $(or $(VMLINUX_H),$(VMLINUX_BTF)),			\
+		  $(shell command -v $(CLANG) 2>/dev/null))
+
+ifneq ($(HAVE_BPF),)
+TEST_GEN_PROGS += test_memcg_stat_cross_cpu
+BPF_SRCS := memcg_stat_cross_cpu.bpf.c
+# Replace lib.mk's link rule below.
+OVERRIDE_TARGETS := 1
+endif
+
 include ../lib.mk
 include lib/libcgroup.mk
 
+ifneq ($(HAVE_BPF),)
+include ../lib.bpf.mk
+
+# Restore lib.mk's rule for non-BPF tests.
+LOCAL_HDRS += $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
+$(OUTPUT)/%: %.c $(LOCAL_HDRS)
+	$(call msg,CC,,$@)
+	$(Q)$(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
+endif
+
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
@@ -33,3 +70,12 @@ $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
+
+ifneq ($(HAVE_BPF),)
+# Keep in-tree UAPI headers private to the BPF test.
+$(OUTPUT)/test_memcg_stat_cross_cpu: private CFLAGS += -I$(top_srcdir)/tools/include/uapi
+# Link cgroup_util and the skeleton against the in-tree libbpf.
+$(OUTPUT)/test_memcg_stat_cross_cpu: test_memcg_stat_cross_cpu.c \
+					$(BPF_SKELS) $(LIBCGROUP_O) $(BPFOBJ)
+	$(call bpf_link,$@,$< $(LIBCGROUP_O))
+endif
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..1f585ed9a596 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,8 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_BPF_EVENTS=y
+CONFIG_DEBUG_INFO_BTF=y
+CONFIG_DEBUG_INFO_DWARF4=y
diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..ca12d794c092 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -54,6 +54,88 @@ ssize_t write_text(const char *path, char *buf, ssize_t len)
 	return len < 0 ? -errno : len;
 }
 
+/**
+ * cg_get_id - return a cgroup's kernfs ID
+ * @cgroup: absolute cgroup path
+ *
+ * This is cgrp->kn->id, not st_ino.
+ *
+ * Return: ID or 0 on failure.
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
+	/* The failed probe reports the cgroupfs handle size. */
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
+ * cg_touch_pages - fault every page in a region
+ * @buf: start of the region
+ * @size: length of the region in bytes
+ *
+ * Pages are charged to the caller's cgroup on its current CPU.
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
+ * cg_alloc_anon - allocate and fault anonymous memory
+ * @size: bytes to allocate
+ *
+ * Return: Region to free(), or NULL.
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
index 000000000000..fff3b9256aa3
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
@@ -0,0 +1,101 @@
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
+/* Ensure the upper-bound checks also reject negative BPF arguments. */
+_Static_assert((enum vm_event_item)-1 >= NR_VM_EVENT_ITEMS,
+	       "negative vm_event_item must fail the bounds check");
+_Static_assert((enum memcg_memory_event)-1 >= MEMCG_NR_MEMORY_EVENTS,
+	       "negative memcg_memory_event must fail the bounds check");
+
+/* Declare kfuncs that may be absent from the build-time vmlinux.h. */
+struct mem_cgroup *bpf_get_mem_cgroup(struct cgroup_subsys_state *css) __ksym;
+void bpf_put_mem_cgroup(struct mem_cgroup *memcg) __ksym;
+void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg) __ksym;
+unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx) __ksym;
+unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
+				       enum vm_event_item event) __ksym;
+
+/* Userspace resizes this cgroup-ID map before load. */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u64);
+	__type(value, struct memcg_stat_snapshot);
+} results SEC(".maps");
+
+/* Isolate capability failures from verifier failures in the test program. */
+SEC("iter.s/cgroup")
+int memcg_kfuncs_probe(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct mem_cgroup *memcg;
+
+	if (!cgrp)
+		return 0;
+
+	memcg = bpf_get_mem_cgroup(&cgrp->self);
+	if (!memcg)
+		return 0;
+
+	bpf_mem_cgroup_flush_stats(memcg);
+	bpf_mem_cgroup_page_state(memcg, 0);
+	bpf_mem_cgroup_vm_events(memcg, 0);
+	bpf_put_mem_cgroup(memcg);
+	return 0;
+}
+
+/* Sleepable iterator: flush the root once, then snapshot each cgroup. */
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
+	/* Ignore the final post-processing call. */
+	if (!cgrp)
+		return 0;
+
+	css = &cgrp->self;
+	memcg = bpf_get_mem_cgroup(css);
+	if (!memcg)
+		return 0;
+
+	/* DESCENDANTS_PRE visits the subtree root first. */
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
+	/* Read page counters from the trusted pointer. */
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
index 000000000000..f75e341f8cb8
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#ifndef __MEMCG_STAT_CROSS_CPU_H
+#define __MEMCG_STAT_CROSS_CPU_H
+
+/* Fixed-width snapshot shared by BPF and userspace. */
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
index 000000000000..96e4a4a958ed
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
@@ -0,0 +1,755 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+
+/*
+ * Compare memcg BPF kfuncs with memory.stat over a charged subtree. Chargers
+ * spread anonymous memory across CPUs and hold it. Read BPF first so its flush
+ * is not consumed by memory.stat, then require two file samples to bracket each
+ * BPF value. Each leaf must cover its charge; root anon must equal the leaf sum.
+ */
+#define _GNU_SOURCE
+
+#include <errno.h>
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
+#define FLUSH_MARGIN		2
+
+/* Bound total charge on large systems. */
+#define MAX_TOTAL_CHARGE	(256UL << 20)
+
+/* Bound the CPUs used by each leaf. */
+#define MAX_CPUS_PER_LEAF	16
+
+#define CHARGE_WAIT_RETRIES	500
+
+static char root[PATH_MAX];
+static char *subtree_root;
+static long page_size;
+
+/* cgroupfs values in bytes. */
+struct file_snap {
+	long anon, file, shmem, file_mapped, pgfault;
+	long current;
+};
+
+struct cg_node {
+	char path[PATH_MAX];
+	unsigned long long id;
+	bool is_leaf;			/* holds a charge of its own */
+	long previous_current;		/* previous memory.current poll */
+	struct memcg_stat_snapshot bpf;	/* read through the kfuncs */
+	struct file_snap file[2];	/* post-BPF cgroupfs samples */
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
+static long n_online_cpu;
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
+	n->previous_current = -1;
+	if (is_leaf)
+		n_leaves++;
+	n_nodes++;
+	return 0;
+}
+
+/* Build @levels below @path; only leaves are charged. */
+static int build_children(const char *path, int fanout, int levels)
+{
+	char child[PATH_MAX];
+	int i;
+
+	if (levels == 0)
+		return 0;
+
+	/* Give child cgroups a memcg. */
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
+/* Destroy children before parents, then reap chargers. */
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
+	/* Keep each CPU's slice page-aligned. */
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
+static int leaf_charge(size_t want, int k, size_t *bytes)
+{
+	size_t min_pages, pages, want_pages;
+
+	if ((size_t)n_online_cpu > SIZE_MAX / FLUSH_MARGIN /
+					 MEMCG_CHARGE_BATCH)
+		return -EOVERFLOW;
+
+	/* Force more than one pending batch per CPU across the subtree. */
+	min_pages = (size_t)FLUSH_MARGIN * MEMCG_CHARGE_BATCH * n_online_cpu;
+	pages = min_pages / n_leaves + !!(min_pages % n_leaves);
+	want_pages = want / page_size + !!(want % page_size);
+	if (pages < want_pages)
+		pages = want_pages;
+	if (pages < (size_t)k)
+		pages = k;
+
+	if (pages > MAX_TOTAL_CHARGE / (size_t)n_leaves / page_size)
+		return -E2BIG;
+
+	*bytes = pages * page_size;
+	return 0;
+}
+
+static int start_chargers(int k, size_t bytes)
+{
+	struct charge_args ca = { .bytes = bytes, .k = k };
+	long prev, cur;
+	bool ready;
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
+	/* Wait until every leaf is fully charged and stable. */
+	for (retries = CHARGE_WAIT_RETRIES; retries; retries--) {
+		ready = true;
+		for (i = 0; i < n_nodes; i++) {
+			if (!nodes[i].is_leaf)
+				continue;
+
+			cur = cg_read_long(nodes[i].path, "memory.current");
+			if (cur < 0) {
+				ksft_print_msg("cannot read %s/memory.current: %s\n",
+					       nodes[i].path, strerror(errno));
+				return -1;
+			}
+
+			prev = nodes[i].previous_current;
+			nodes[i].previous_current = cur;
+			if (cur < (long)bytes || cur != prev)
+				ready = false;
+		}
+		if (ready)
+			return 0;
+		usleep(DEFAULT_WAIT_INTERVAL_US / 10);
+	}
+
+	for (i = 0; i < n_nodes; i++) {
+		if (nodes[i].is_leaf && nodes[i].previous_current < (long)bytes) {
+			ksft_print_msg("%s reached only %ld of %zu charged bytes\n",
+				       nodes[i].path, nodes[i].previous_current,
+				       bytes);
+			return -1;
+		}
+	}
+	ksft_print_msg("memory.current did not settle before the timeout\n");
+	return -1;
+}
+
+/* ---- the two readers ---------------------------------------------------- */
+
+/* Flush the subtree and collect each cgroup's kfunc values. */
+static int read_bpf(int root_fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct memcg_stat_cross_cpu *skel = NULL;
+	union bpf_iter_link_info linfo = {};
+	struct bpf_link *link = NULL;
+	int ret = -1, err, i, mfd, fd;
+	char buf[4096];
+	ssize_t r;
+
+	skel = memcg_stat_cross_cpu__open();
+	if (!skel) {
+		ksft_print_msg("skel open failed: %s (%d)\n",
+			       strerror(errno), errno);
+		return -1;
+	}
+	err = bpf_program__set_autoload(skel->progs.memcg_kfuncs_probe, false);
+	if (err) {
+		ksft_print_msg("disabling capability probe failed: %s (%d)\n",
+			       strerror(-err), err);
+		goto out;
+	}
+	err = bpf_map__set_max_entries(skel->maps.results, n_nodes + 8);
+	if (err) {
+		ksft_print_msg("set max_entries failed: %s (%d)\n",
+			       strerror(-err), err);
+		goto out;
+	}
+	err = memcg_stat_cross_cpu__load(skel);
+	if (err) {
+		ksft_print_msg("skel load failed: %s (%d)\n",
+			       strerror(-err), err);
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
+	err = libbpf_get_error(link);
+	if (err) {
+		link = NULL;
+		ksft_print_msg("attach iter failed: %s (%d)\n",
+			       strerror(-err), err);
+		goto out;
+	}
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (fd < 0) {
+		ksft_print_msg("bpf_iter_create failed: %s (%d)\n",
+			       strerror(errno), errno);
+		goto out;
+	}
+	do {
+		r = read(fd, buf, sizeof(buf));
+	} while (r > 0 || (r < 0 && errno == EINTR));
+	err = errno;
+	close(fd);
+	if (r < 0) {
+		ksft_print_msg("bpf walk failed: %s (%d)\n",
+			       strerror(err), err);
+		goto out;
+	}
+
+	mfd = bpf_map__fd(skel->maps.results);
+	for (i = 0; i < n_nodes; i++)
+		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &nodes[i].bpf)) {
+			ksft_print_msg("no map entry for %s: %s (%d)\n",
+				       nodes[i].path, strerror(errno), errno);
+			goto out;
+		}
+	ret = 0;
+out:
+	bpf_link__destroy(link);
+	memcg_stat_cross_cpu__destroy(skel);
+	return ret;
+}
+
+/* Read one cgroupfs snapshot. */
+static int read_files(int slot)
+{
+	int i;
+
+	for (i = 0; i < n_nodes; i++) {
+		const char *path = nodes[i].path;
+		struct file_snap *f = &nodes[i].file[slot];
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
+	int s;
+
+	ksft_print_msg("%s bpf   : anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
+		       n->path, n->bpf.anon, n->bpf.file, n->bpf.shmem,
+		       n->bpf.file_mapped, n->bpf.pgfault);
+	for (s = 0; s < 2; s++)
+		ksft_print_msg("%s file%d: anon=%ld file=%ld shmem=%ld fmapped=%ld pgfault=%ld\n",
+			       n->path, s, n->file[s].anon, n->file[s].file,
+			       n->file[s].shmem, n->file[s].file_mapped,
+			       n->file[s].pgfault);
+}
+
+/* Equal file samples require an exact BPF match; otherwise accept their range. */
+static bool bracketed(unsigned long long v, long a, long b)
+{
+	long lo = a < b ? a : b;
+	long hi = a < b ? b : a;
+
+	return v >= (unsigned long long)lo && v <= (unsigned long long)hi;
+}
+
+static int check_tree(size_t charged)
+{
+	unsigned long long root_anon = 0, leaf_anon = 0;
+	int i, bad = 0;
+
+	for (i = 0; i < n_nodes; i++) {
+		const struct cg_node *n = &nodes[i];
+		const struct memcg_stat_snapshot *b = &n->bpf;
+		const struct file_snap *f0 = &n->file[0], *f1 = &n->file[1];
+
+		if (!bracketed(b->anon, f0->anon, f1->anon) ||
+		    !bracketed(b->file, f0->file, f1->file) ||
+		    !bracketed(b->shmem, f0->shmem, f1->shmem) ||
+		    !bracketed(b->file_mapped, f0->file_mapped,
+			       f1->file_mapped) ||
+		    !bracketed(b->pgfault, f0->pgfault, f1->pgfault)) {
+			ksft_print_msg("kfuncs disagree with memory.stat\n");
+			dump_node(n);
+			bad++;
+		}
+
+		/* Live page counters are bounds, not flushed statistics. */
+		if (b->anon > b->usage_pages * (unsigned long long)page_size ||
+		    f1->anon > f1->current) {
+			ksft_print_msg("%s: anon above usage: bpf %llu/%llu file %ld/%ld\n",
+				       n->path, b->anon,
+				       b->usage_pages * (unsigned long long)page_size,
+				       f1->anon, f1->current);
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
+/* Accept PAGE_COUNTER_MAX values from either 32- or 64-bit kernels. */
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
+	int cpus_per_leaf;	/* K, or 0 for the bounded cross-CPU count */
+	size_t resident_bytes;	/* anon per leaf, raised if too small */
+};
+
+static int run_case(const struct testcase *tc)
+{
+	int root_fd = -1, ret = KSFT_FAIL, err, k;
+	size_t charged;
+
+	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
+		ksft_print_msg("cannot build the tree\n");
+		goto out;
+	}
+
+	k = tc->cpus_per_leaf;
+	if (k <= 0)
+		k = n_cpu < MAX_CPUS_PER_LEAF ? n_cpu : MAX_CPUS_PER_LEAF;
+	else if (k > n_cpu)
+		k = n_cpu;
+	err = leaf_charge(tc->resident_bytes, k, &charged);
+	if (err == -E2BIG) {
+		ksft_print_msg("%s needs more than %luMB to trigger a flush on %ld online CPUs\n",
+			       tc->name, MAX_TOTAL_CHARGE >> 20, n_online_cpu);
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	if (err) {
+		ksft_print_msg("cannot calculate the charge for %s: %s (%d)\n",
+			       tc->name, strerror(-err), err);
+		goto out;
+	}
+
+	ksft_print_msg("%s: %d cgroups, %d leaves, %d/%d cpus, %zuKB per leaf\n",
+		       tc->name, n_nodes, n_leaves, k, n_cpu, charged >> 10);
+
+	if (start_chargers(k, charged))
+		goto out;
+
+	/* Read BPF first; memory.stat would consume the pending flush. */
+	if (read_bpf(root_fd) || read_files(0) || read_files(1))
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
+	{ "single_cpu_large_tree", 4, 3, 1, 256 << 10 },
+	{ "cross_cpu_large_tree", 4, 3, 0, 256 << 10 },
+};
+
+static bool memcg_kfuncs_available(void)
+{
+	static const char *const kfuncs[] = {
+		"bpf_get_mem_cgroup",
+		"bpf_put_mem_cgroup",
+		"bpf_mem_cgroup_flush_stats",
+		"bpf_mem_cgroup_page_state",
+		"bpf_mem_cgroup_vm_events",
+	};
+	struct btf *btf;
+	int err, i;
+
+	btf = btf__load_vmlinux_btf();
+	err = libbpf_get_error(btf);
+	if (err) {
+		ksft_print_msg("cannot load vmlinux BTF: %s (%d)\n",
+			       strerror(-err), err);
+		return false;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(kfuncs); i++) {
+		if (btf__find_by_name_kind(btf, kfuncs[i], BTF_KIND_FUNC) > 0)
+			continue;
+		ksft_print_msg("required kfunc %s is not in vmlinux BTF\n",
+			       kfuncs[i]);
+		btf__free(btf);
+		return false;
+	}
+	if (btf__find_by_name_kind(btf, "bpf_iter_cgroup", BTF_KIND_FUNC) <= 0) {
+		ksft_print_msg("cgroup BPF iterator is not in vmlinux BTF\n");
+		btf__free(btf);
+		return false;
+	}
+	btf__free(btf);
+	return true;
+}
+
+static bool unsupported_bpf_feature_error(int err)
+{
+	return err == -EINVAL || err == -ENOENT || err == -EOPNOTSUPP;
+}
+
+/* Return 1 if supported, 0 if unavailable, or a negative error. */
+static int probe_memcg_bpf_features(int root_fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct memcg_stat_cross_cpu *skel;
+	union bpf_iter_link_info linfo = {};
+	struct bpf_link *link = NULL;
+	int ret, err, iter_fd = -1;
+
+	skel = memcg_stat_cross_cpu__open();
+	if (!skel) {
+		err = errno ? -errno : -EINVAL;
+		ksft_print_msg("capability probe open failed: %s (%d)\n",
+			       strerror(-err), err);
+		return err;
+	}
+
+	err = bpf_program__set_autoload(skel->progs.cgroup_memcg_stat_cross_cpu,
+					false);
+	if (err) {
+		ksft_print_msg("disabling test program failed: %s (%d)\n",
+			       strerror(-err), err);
+		ret = err;
+		goto out;
+	}
+
+	err = memcg_stat_cross_cpu__load(skel);
+	if (err) {
+		ksft_print_msg("BPF capability probe load failed: %s (%d)\n",
+			       strerror(-err), err);
+		ret = unsupported_bpf_feature_error(err) ? 0 : err;
+		goto out;
+	}
+
+	linfo.cgroup.cgroup_fd = root_fd;
+	linfo.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(skel->progs.memcg_kfuncs_probe, &opts);
+	err = libbpf_get_error(link);
+	if (err) {
+		link = NULL;
+		ksft_print_msg("BPF capability probe attach failed: %s (%d)\n",
+			       strerror(-err), err);
+		ret = unsupported_bpf_feature_error(err) ? 0 : err;
+		goto out;
+	}
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (iter_fd < 0) {
+		err = -errno;
+		ksft_print_msg("BPF capability probe iterator creation failed: %s (%d)\n",
+			       strerror(-err), err);
+		ret = unsupported_bpf_feature_error(err) ? 0 : err;
+		goto out;
+	}
+
+	ret = 1;
+out:
+	if (iter_fd >= 0)
+		close(iter_fd);
+	bpf_link__destroy(link);
+	memcg_stat_cross_cpu__destroy(skel);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	int feature_fd, i, ret;
+
+	ksft_print_header();
+
+	/* Probe BTF before operations that may require privileges. */
+	if (!memcg_kfuncs_available())
+		ksft_exit_skip("memcg BPF kfuncs are not available\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	feature_fd = open(root, O_RDONLY | O_DIRECTORY);
+	if (feature_fd < 0)
+		ksft_exit_fail_msg("cannot open cgroup root: %s (%d)\n",
+				   strerror(errno), errno);
+	ret = probe_memcg_bpf_features(feature_fd);
+	close(feature_fd);
+	if (!ret)
+		ksft_exit_skip("sleepable cgroup iterator or memcg kfuncs are not available\n");
+	if (ret < 0)
+		ksft_exit_fail_msg("cannot probe BPF capabilities: %s (%d)\n",
+				   strerror(-ret), ret);
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
+	n_online_cpu = sysconf(_SC_NPROCESSORS_ONLN);
+	if (n_online_cpu <= 0)
+		ksft_exit_fail_msg("cannot determine the number of online CPUs\n");
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
+	subtree_root = cg_name(root, SUBTREE_NAME);
+	if (!subtree_root)
+		ksft_exit_skip("cannot build subtree root path\n");
+
+	/* Set the plan after all global skip checks. */
+	ksft_set_plan(ARRAY_SIZE(cases));
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		switch (run_case(&cases[i])) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", cases[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", cases[i].name);
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

