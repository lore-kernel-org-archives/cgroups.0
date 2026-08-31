Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9371B41A4E6
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182740; cv=none; b=svvNA73cO7fVVZPwMGsUb9zsfprTDd6oSS0DJbetA4c1u7HVua0aAFQDCOyKHbmuC0e/kdeS1YZWXiWqmJIqmgcjnVnpnS5Tzc+bcBoZ8AEUI/1ANndEQz3SebuVvDpTWcyOA64qVvJMBXQ5Z7rs5H269aGXSLMASraZ8H4J0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182740; c=relaxed/simple;
	bh=8Kr2YZNNSN192SnAtC2dKJKhWLemLjQtnhC6rdjd7ao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ddaa1nUpz+k4nhNeSOR20+q4S0maJ/v5beC+Zf8pfTjGaoezlw+iTv2viAsmxy0AKS5TdzpQmgag3P68FV+VOW3fG1FsZhOmaLveGC9JWDyiRDd2E73F7kihBKHcGCm/Ivx62NsxQWPc4e065keAXpc8eKtWxJ2WYRa7FMfJCrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X4JTJmOc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4JTJmOc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788182737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fAt4QX4GgLPNS42ubuGBQ665ezuuMkEG/rcgHIK/9M=;
	b=X4JTJmOcuBfMNl6uL4/7im43b6giDYmBETqZ3U8jx4ZMoacX+hbgQlevNl18aYUUyfvjcS
	X++0dUyYtqcRr/pdqhssqGhP2KBZdT56E4sUvbKtl/jn5t+s9PIzBaO2LO/MYJqCfmwf1z
	dpDHGITImbqixeW4seGe46Dwej05MMs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-wtKlriVgO4uE57ic7aKn9Q-1; Mon,
 31 Aug 2026 09:25:35 -0400
X-MC-Unique: wtKlriVgO4uE57ic7aKn9Q-1
X-Mimecast-MFC-AGG-ID: wtKlriVgO4uE57ic7aKn9Q_1788182733
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB3C61945CBE;
	Mon, 31 Aug 2026 13:25:24 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC70840E;
	Mon, 31 Aug 2026 13:25:22 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 31 Aug 2026 15:25:13 +0200
Subject: [PATCH v6 3/3] selftests: cgroup: Add dmem selftest coverage
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-kunit_cgroups-v6-3-63b6c7695287@redhat.com>
References: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
In-Reply-To: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788182715; l=10309;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=8Kr2YZNNSN192SnAtC2dKJKhWLemLjQtnhC6rdjd7ao=;
 b=QN0ZJ18d5Obu5q1QBi7Es7NtzGNR4ZIUKCF682UWwvKNZA7VX9ER9Zyw/+D6S0KqRrn6EWJFx
 lzOOjLFgko8AnmHLAK5wF8aT9/bIDTPJPKguL/zs+Keucprco+ajnsw
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Currently, tools/testing/selftests/cgroup/ has no
dmem-specific test. This leaves dmem accounting and
dmem.max enforcement largely unvalidated without a
production driver.

Add test_dmem, driven by the dmem_selftest helper module
parameters (alloc/free) on the dmem_selftest region.
insmod the helper before running the tests.

The tests cover:
- test_dmem_max: nested hierarchy with per-leaf dmem.max
  values and verifies that over-limit charges fail while
  in-limit charges succeed in dmem.current.
- test_dmem_alloc_byte_granularity: non-page-aligned alloc
  sizes, dmem.current equals the requested byte count, and
  free-to-zero behavior.

Limits are read with cg_read_key_long(). The helper is stat'd
in main() so a missing module skips the whole test instead
of each subtest.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 tools/testing/selftests/cgroup/.gitignore  |   1 +
 tools/testing/selftests/cgroup/Makefile    |   2 +
 tools/testing/selftests/cgroup/test_dmem.c | 314 +++++++++++++++++++++++++++++
 3 files changed, 317 insertions(+)

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..ea2322598217 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -2,6 +2,7 @@
 test_core
 test_cpu
 test_cpuset
+test_dmem
 test_freezer
 test_hugetlb_memcg
 test_kill
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index a08661320a07..d01e8eb1ead2 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -11,6 +11,7 @@ TEST_GEN_MODS_DIR := test_modules
 TEST_GEN_PROGS  = test_core
 TEST_GEN_PROGS += test_cpu
 TEST_GEN_PROGS += test_cpuset
+TEST_GEN_PROGS += test_dmem
 TEST_GEN_PROGS += test_freezer
 TEST_GEN_PROGS += test_hugetlb_memcg
 TEST_GEN_PROGS += test_kill
@@ -27,6 +28,7 @@ include lib/libcgroup.mk
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
+$(OUTPUT)/test_dmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_freezer: $(LIBCGROUP_O)
 $(OUTPUT)/test_hugetlb_memcg: $(LIBCGROUP_O)
 $(OUTPUT)/test_kill: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/test_dmem.c b/tools/testing/selftests/cgroup/test_dmem.c
new file mode 100644
index 000000000000..3793664678b9
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_dmem.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the dmem (device memory) cgroup controller.
+ *
+ * Depends on the dmem_selftest helper module
+ * (tools/testing/selftests/cgroup/test_modules/dmem_selftest.c).
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#define DM_SELFTEST_REGION	"dmem_selftest"
+#define DM_SELFTEST_ALLOC	"/sys/module/dmem_selftest/parameters/alloc"
+#define DM_SELFTEST_FREE	"/sys/module/dmem_selftest/parameters/free"
+
+static long dmem_read_limit(const char *cgroup, const char *ctrl)
+{
+	return cg_read_key_long(cgroup, ctrl, DM_SELFTEST_REGION " ");
+}
+
+static int dmem_write_limit(const char *cgroup, const char *ctrl, long val)
+{
+	char wr[64];
+
+	snprintf(wr, sizeof(wr), "%s %ld", DM_SELFTEST_REGION, val);
+	return cg_write(cgroup, ctrl, wr);
+}
+
+static int dmem_selftest_alloc(long bytes)
+{
+	char wr[32];
+
+	snprintf(wr, sizeof(wr), "%ld", bytes);
+	return write_text(DM_SELFTEST_ALLOC, wr, strlen(wr));
+}
+
+static int dmem_selftest_free(void)
+{
+	char wr[] = "1";
+
+	return write_text(DM_SELFTEST_FREE, wr, strlen(wr));
+}
+
+/*
+ * First, this test creates the following hierarchy:
+ * A
+ * A/B     dmem.max=8M
+ * A/B/C   dmem.max=2M
+ * A/B/D   dmem.max=1M
+ * A/B/E   dmem.max=75K
+ * A/B/F   dmem.max=25K
+ * A/B/G   dmem.max=8K
+ * A/B/H   dmem.max=0
+ *
+ * Then for each leaf cgroup it tries to alloc above dmem.max
+ * and expects the request to fail and dmem.current to remain
+ * unchanged.
+ *
+ * For leaves with non-zero dmem.max, it additionally allocs a
+ * smaller amount and verifies dmem.current matches the requested
+ * size exactly (the controller accounts in bytes, with no page
+ * rounding), then frees and verifies dmem.current returns
+ * to the previous value.
+ */
+static int test_dmem_max(const char *root)
+{
+	static const long leaf_max[] = {
+		MB(2), MB(1), KB(75), KB(25), KB(8), 0
+	};
+	static const long pass_sz[] = {
+		MB(1), MB(1), KB(4), KB(4), KB(4), 0
+	};
+	char *parent[2] = {NULL};
+	char *children[ARRAY_SIZE(leaf_max)] = {NULL};
+
+	_Static_assert(ARRAY_SIZE(pass_sz) == ARRAY_SIZE(leaf_max),
+		       "pass_sz doesn't match leaf_max length");
+	long cur_before, cur_after;
+	int ret = KSFT_FAIL;
+	int charged = 0;
+	int in_child = 0;
+	long v;
+	int i;
+
+	parent[0] = cg_name(root, "dmem_prot_0");
+	if (!parent[0])
+		goto cleanup;
+
+	parent[1] = cg_name(parent[0], "dmem_prot_1");
+	if (!parent[1])
+		goto cleanup;
+
+	if (cg_create(parent[0]))
+		goto cleanup;
+
+	if (cg_write(parent[0], "cgroup.subtree_control", "+dmem"))
+		goto cleanup;
+
+	if (cg_create(parent[1]))
+		goto cleanup;
+
+	if (cg_write(parent[1], "cgroup.subtree_control", "+dmem"))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		children[i] = cg_name_indexed(parent[1], "dmem_child", i);
+		if (!children[i])
+			goto cleanup;
+		if (cg_create(children[i]))
+			goto cleanup;
+	}
+
+	if (dmem_write_limit(parent[1], "dmem.max", MB(8)))
+		goto cleanup;
+	for (i = 0; i < ARRAY_SIZE(children); i++)
+		if (dmem_write_limit(children[i], "dmem.max", leaf_max[i]))
+			goto cleanup;
+
+	v = dmem_read_limit(parent[1], "dmem.max");
+	if (v != MB(8))
+		goto cleanup;
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		v = dmem_read_limit(children[i], "dmem.max");
+		if (v != leaf_max[i])
+			goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		if (cg_enter_current(children[i]))
+			goto cleanup;
+		in_child = 1;
+
+		cur_before = dmem_read_limit(children[i], "dmem.current");
+		if (cur_before < 0)
+			goto cleanup;
+
+		if (dmem_selftest_alloc(leaf_max[i] + 1) >= 0) {
+			charged = 1;
+			goto cleanup;
+		}
+
+		cur_after = dmem_read_limit(children[i], "dmem.current");
+		if (cur_after != cur_before)
+			goto cleanup;
+
+		if (pass_sz[i] > 0) {
+			if (dmem_selftest_alloc(pass_sz[i]) < 0)
+				goto cleanup;
+			charged = 1;
+
+			cur_after = dmem_read_limit(children[i], "dmem.current");
+			if (cur_after != cur_before + pass_sz[i])
+				goto cleanup;
+
+			if (dmem_selftest_free() < 0)
+				goto cleanup;
+			charged = 0;
+
+			cur_after = dmem_read_limit(children[i], "dmem.current");
+			if (cur_after != cur_before)
+				goto cleanup;
+		}
+
+		if (cg_enter_current(root))
+			goto cleanup;
+		in_child = 0;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (charged)
+		dmem_selftest_free();
+	if (in_child)
+		cg_enter_current(root);
+	for (i = ARRAY_SIZE(children) - 1; i >= 0; i--) {
+		if (!children[i])
+			continue;
+		cg_destroy(children[i]);
+		free(children[i]);
+	}
+	for (i = ARRAY_SIZE(parent) - 1; i >= 0; i--) {
+		if (!parent[i])
+			continue;
+		cg_destroy(parent[i]);
+		free(parent[i]);
+	}
+	return ret;
+}
+
+/*
+ * Alloc non-page-aligned byte sizes and verify dmem.current matches
+ * the requested size exactly. The controller charges the byte count
+ * passed to dmem_cgroup_try_charge() with no page rounding, for this
+ * helper and for production drivers. Then free must return usage to 0.
+ */
+static int test_dmem_alloc_byte_granularity(const char *root)
+{
+	static const long sizes[] = {
+		1, 4095, 4097, KB(75) + 1, MB(1), MB(1) + 1
+	};
+	char *cg = NULL;
+	long cur;
+	int ret = KSFT_FAIL;
+	int charged = 0;
+	int in_child = 0;
+	size_t i;
+
+	cg = cg_name(root, "dmem_dbg_byte_gran");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (dmem_write_limit(cg, "dmem.max", MB(16)))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_child = 1;
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		if (dmem_selftest_alloc(sizes[i]) < 0)
+			goto cleanup;
+		charged = 1;
+
+		cur = dmem_read_limit(cg, "dmem.current");
+		if (cur != sizes[i])
+			goto cleanup;
+
+		if (dmem_selftest_free() < 0)
+			goto cleanup;
+		charged = 0;
+
+		cur = dmem_read_limit(cg, "dmem.current");
+		if (cur != 0)
+			goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (charged)
+		dmem_selftest_free();
+	if (in_child)
+		cg_enter_current(root);
+	if (cg) {
+		cg_destroy(cg);
+		free(cg);
+	}
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct dmem_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_dmem_max),
+	T(test_dmem_alloc_byte_granularity),
+};
+#undef T
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	struct stat st;
+	int i;
+
+	ksft_print_header();
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	if (cg_read_strstr(root, "cgroup.controllers", "dmem"))
+		ksft_exit_skip("dmem controller isn't available (CONFIG_CGROUP_DMEM?)\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "dmem"))
+		if (cg_write(root, "cgroup.subtree_control", "+dmem"))
+			ksft_exit_skip("Failed to enable dmem controller\n");
+
+	if (stat(DM_SELFTEST_ALLOC, &st) < 0)
+		ksft_exit_skip(
+			"dmem_selftest helper not loaded (insmod test_modules/dmem_selftest.ko)\n");
+
+	if (dmem_read_limit(root, "dmem.capacity") < 0)
+		ksft_exit_skip("dmem_selftest region not registered\n");
+
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}

-- 
2.55.0

