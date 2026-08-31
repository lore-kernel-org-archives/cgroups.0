Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7E430CD5
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 13:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182743; cv=none; b=EB2Jhfwfbhyt3Km9pVeocINznJ3y1I8W/fi6AiDCwlM7OMu6Sihcu9p2+s2FBgW97v95JgPaxmABper3l6S1qdiLPR/Rsn9kVsWS1xcQpIlY5wsP5sIwEJmFrf8p3S0Dkdmom98Is+JeFcKe3L+9xlvf9d4xPIrqGDHZV3Z7iRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182743; c=relaxed/simple;
	bh=3+VoVKeZv3gsnQJua4pDGn0oOb/kZqlkTYmTWEKGOg4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ik0rdW++KqvpGirujBI2P9clfN1aOhO0lesrKnH4oSqo84huBXzY0UE9gFOhRYmJB49QCCpJAK27gWl1As0MTKpcN8J0jlbuCl98KvaLNngW/rFW/iTBMgvdQRff4QH3grRep15px9I14uayvJcOfL9ehFhxQk8zcoH8A9KmvFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6FuOvBx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6FuOvBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788182740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=obgsA+wmkoM83ZDQQaFWaWOWiW1c97++AGpx79Oxzms=;
	b=Z6FuOvBxMORUlxGo/p2VFpiN6SnssmOQPs4rlCK3VWKLqfmbV/tAa5Dgdqbc6X9N/Hh0eX
	9/b/6j8puHZDD9HofRlz1wkmIK9CNAdIIFHcVdbGcwXzn4ZiqsG7ivgYBntfueTN6zQE8B
	iber5zpDJcmb4x1hD6qHB0NICdEcm2A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-bT7zN3AnMdqPTgtdrhG5Bw-1; Mon,
 31 Aug 2026 09:25:35 -0400
X-MC-Unique: bT7zN3AnMdqPTgtdrhG5Bw-1
X-Mimecast-MFC-AGG-ID: bT7zN3AnMdqPTgtdrhG5Bw_1788182734
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E093D190B693;
	Mon, 31 Aug 2026 13:25:19 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DFA440E;
	Mon, 31 Aug 2026 13:25:18 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 31 Aug 2026 15:25:11 +0200
Subject: [PATCH v6 1/3] selftests: cgroup: Add dmem_selftest helper module
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-kunit_cgroups-v6-1-63b6c7695287@redhat.com>
References: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
In-Reply-To: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788182715; l=7299;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=3+VoVKeZv3gsnQJua4pDGn0oOb/kZqlkTYmTWEKGOg4=;
 b=vzcM11inmXYQJkP5+sVqbEHqX+yOkuj7JFbrCgN1VQ40GNiWP1dcwgS+MsRWbvpQhk6yEeQP0
 VUvNrwb8SYICR+1Zf98G68PvpIDkyeOQs/ssTUa7l9E33T/oGqjJM04
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Currently, dmem charging is driver-driven through direct
calls to dmem_cgroup_try_charge() (for example TTM).
That does not give cgroup selftests a generic way to
trigger alloc/free paths from userspace in a chosen
cgroup, so coverage of nested dmem.max still
needs a synthetic region.

Add tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
as an OOT helper, built like other test_modules (no extra
Kconfig needed). Tests can insmod the .ko module to register a
"dmem_selftest" region.

Module parameters drive a single outstanding allocation against
the calling task's cgroup:

  /sys/module/dmem_selftest/parameters/alloc
  /sys/module/dmem_selftest/parameters/free

Writing a size to alloc triggers dmem_cgroup_try_charge() for
the calling task's cgroup. Writing to free with no argument
releases the outstanding charge via dmem_cgroup_uncharge().
Only a single outstanding charge is supported.

This provides a deterministic, driver-independent mechanism
for exercising dmem accounting paths in selftests.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 tools/testing/selftests/cgroup/Makefile            |   1 +
 tools/testing/selftests/cgroup/config              |   1 +
 .../testing/selftests/cgroup/test_modules/Makefile |  17 +++
 .../selftests/cgroup/test_modules/dmem_selftest.c  | 146 +++++++++++++++++++++
 4 files changed, 165 insertions(+)

diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..a08661320a07 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -6,6 +6,7 @@ all: ${HELPER_PROGS}
 TEST_FILES     := with_stress.sh
 TEST_PROGS     := test_stress.sh test_cpuset_prs.sh test_cpuset_v1_hp.sh
 TEST_GEN_FILES := wait_inotify
+TEST_GEN_MODS_DIR := test_modules
 # Keep the lists lexicographically sorted
 TEST_GEN_PROGS  = test_core
 TEST_GEN_PROGS += test_cpu
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..2ee0488c3d65 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -1,5 +1,6 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
+CONFIG_CGROUP_DMEM=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
diff --git a/tools/testing/selftests/cgroup/test_modules/Makefile b/tools/testing/selftests/cgroup/test_modules/Makefile
new file mode 100644
index 000000000000..dd8a17313cec
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_modules/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+TESTMODS_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
+KDIR ?= /lib/modules/$(shell uname -r)/build
+
+obj-m += dmem_selftest.o
+
+# Ensure that KDIR exists, otherwise skip the compilation
+modules:
+ifneq ("$(wildcard $(KDIR))", "")
+	$(Q)$(MAKE) -C $(KDIR) modules KBUILD_EXTMOD=$(TESTMODS_DIR)
+endif
+
+# Ensure that KDIR exists, otherwise skip the clean target
+clean:
+ifneq ("$(wildcard $(KDIR))", "")
+	$(Q)$(MAKE) -C $(KDIR) clean KBUILD_EXTMOD=$(TESTMODS_DIR)
+endif
diff --git a/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c b/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
new file mode 100644
index 000000000000..a763a156f13f
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kselftest helper for the dmem cgroup controller.
+ *
+ * Registers a synthetic dmem region so tests can trigger allocations
+ * from the calling task's cgroup via module parameters:
+ *   /sys/module/dmem_selftest/parameters/alloc
+ *   /sys/module/dmem_selftest/parameters/free
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cgroup_dmem.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/panic.h>
+#include <linux/sysfs.h>
+
+#define DM_SELFTEST_REGION_NAME	"dmem_selftest"
+#define DM_SELFTEST_REGION_SIZE	(256ULL * 1024 * 1024)
+
+static struct dmem_cgroup_region *selftest_region;
+static struct dmem_cgroup_pool_state *alloc_pool;
+static u64 alloc_size;
+static DEFINE_MUTEX(alloc_lock);
+
+static int param_set_alloc(const char *val, const struct kernel_param *kp)
+{
+	struct dmem_cgroup_pool_state *pool = NULL, *limit = NULL;
+	u64 size;
+	int ret;
+
+	if (!selftest_region)
+		return -ENODEV;
+
+	ret = kstrtou64(val, 0, &size);
+	if (ret)
+		return ret;
+	if (!size || size > DM_SELFTEST_REGION_SIZE)
+		return -EINVAL;
+
+	mutex_lock(&alloc_lock);
+	if (alloc_pool) {
+		mutex_unlock(&alloc_lock);
+		return -EBUSY;
+	}
+
+	ret = dmem_cgroup_try_charge(selftest_region, size, &pool, &limit);
+	if (ret == -EAGAIN && limit)
+		dmem_cgroup_pool_state_put(limit);
+	if (ret) {
+		mutex_unlock(&alloc_lock);
+		return ret;
+	}
+
+	alloc_pool = pool;
+	alloc_size = size;
+	mutex_unlock(&alloc_lock);
+	return 0;
+}
+
+static int param_get_alloc(char *buffer, const struct kernel_param *kp)
+{
+	u64 size;
+
+	mutex_lock(&alloc_lock);
+	size = alloc_size;
+	mutex_unlock(&alloc_lock);
+	return sysfs_emit(buffer, "%llu\n", size);
+}
+
+static const struct kernel_param_ops alloc_ops = {
+	.set = param_set_alloc,
+	.get = param_get_alloc,
+};
+
+module_param_cb(alloc, &alloc_ops, NULL, 0644);
+MODULE_PARM_DESC(alloc, "Allocate (charge) SIZE bytes against the calling task's dmem cgroup");
+
+static int param_set_free(const char *val, const struct kernel_param *kp)
+{
+	mutex_lock(&alloc_lock);
+	if (!alloc_pool) {
+		mutex_unlock(&alloc_lock);
+		return -EINVAL;
+	}
+
+	dmem_cgroup_uncharge(alloc_pool, alloc_size);
+	alloc_pool = NULL;
+	alloc_size = 0;
+	mutex_unlock(&alloc_lock);
+	return 0;
+}
+
+static const struct kernel_param_ops free_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = param_set_free,
+};
+
+module_param_cb(free, &free_ops, NULL, 0200);
+MODULE_PARM_DESC(free, "Free the outstanding dmem selftest allocation");
+
+static int __init dmem_selftest_init(void)
+{
+	static const struct dmem_cgroup_init init = {
+		.size = DM_SELFTEST_REGION_SIZE,
+	};
+
+	selftest_region = dmem_cgroup_register_region(&init, DM_SELFTEST_REGION_NAME);
+	if (IS_ERR(selftest_region))
+		return PTR_ERR(selftest_region);
+	if (!selftest_region)
+		return -EINVAL;
+
+	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
+	pr_info("region '%s' registered; parameters alloc/free\n",
+		DM_SELFTEST_REGION_NAME);
+	return 0;
+}
+
+static void __exit dmem_selftest_exit(void)
+{
+	mutex_lock(&alloc_lock);
+	if (alloc_pool) {
+		dmem_cgroup_uncharge(alloc_pool, alloc_size);
+		alloc_pool = NULL;
+		alloc_size = 0;
+	}
+	mutex_unlock(&alloc_lock);
+
+	if (selftest_region) {
+		dmem_cgroup_unregister_region(selftest_region);
+		selftest_region = NULL;
+	}
+	pr_info("unloaded.\n");
+}
+
+module_init(dmem_selftest_init);
+module_exit(dmem_selftest_exit);
+
+MODULE_AUTHOR("Albert Esteve <aesteve@redhat.com>");
+MODULE_DESCRIPTION("Kselftest helper for cgroup dmem controller");
+MODULE_LICENSE("GPL");
+MODULE_INFO(test, "Y");

-- 
2.55.0

