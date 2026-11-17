Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922094;
	b=MwdAPnAI0Ss5o5h5IQbQz0jqlgurxNGnP6BxzjIrN8Uwh155ZWIO4+YLpvZ1eEEBNHp4
	 fF+qPk5DHgbOZYFKjdzqM/YAGxOQF9887X2ieMRVTOTO1XJc5X38UtJxSiC5ivF2BL1Ht
	 dPHXeo9okQy/j1yggsSucDIrTDxf+rBaavMWe0sTkyl7db+I3pxZtc9BDfvag6WhHsCHu
	 DHGcdT/QA707eOaXEq5LanLcCzdghMA008A2Tam+L0uAhOqluJR+UNdGyykCRqKADTV5v
	 64jku/aUv8VD1dTvYw1U8WOSPxxLS1D5RteqHXsHHP5eJomxtoxTQf4fREl5uf3JGGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922094;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Developer-Signature:X-Developer-Key:
	 X-Scanned-By;
	bh=nWfT+TkPmcOCNK9Mn78Al4VOB4gVYxq/KkmumWJeJfw=;
	b=XUKtxZrbNDLPZ0NZ5HbSwOdfOm9gfxx2Y0vec37HwpOxBNfAGKMA/DXgjXr32MPXhkRC
	 e7bu3zJe007OwcZf3+7YChH2rybcqxbg0mUzHyhu/YUvC+aX8FRA+fRtgNl2mu49Yydmk
	 +Ommb0kAYPyuyZLlJzm7xCZLGcW3RLYCJMcqsQNqjz7MmKSi5GjaYPc+y79XxCKNBGuqb
	 +ZqiyAq+DtqmE7t/ky1Z3z6xUyY83eUN7eEXq9qxN2EPXco+zF75xN1/+mY/QSDy8c+ek
	 +REyQl1hdd+F56Ojqa/ad06NeiFtMbY7bMtDAtvpbw/puqMewQE2AzsqL8lhDdAQwnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UXlF47ew;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4C1606A32A
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 13:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC4C1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UXlF47ew
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794922092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWfT+TkPmcOCNK9Mn78Al4VOB4gVYxq/KkmumWJeJfw=;
	b=UXlF47ewLCg80H+UuD3TaEvhSzFQqO7sf1HnL37JTqq/1NLoURwTLv/tLa092CQkVxp7SV
	Ru+wVla3JP/oLo9d03J5OAvgX2s9Hsh8A4rgFj6M8KWLOT8/1KscehAfVG9zqjgPrjncjl
	g6m0GO6d2OLlSUt3XmklTBWtz7E0NzQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-oRL3huSHNtmKoM-8-njT1w-1; Tue,
 17 Nov 2026 08:28:05 -0500
X-MC-Unique: oRL3huSHNtmKoM-8-njT1w-1
X-Mimecast-MFC-AGG-ID: oRL3huSHNtmKoM-8-njT1w_1794922083
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 880311800540;
	Tue, 17 Nov 2026 13:28:02 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 957B7195B3C5;
	Tue, 17 Nov 2026 13:27:58 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 14:27:46 +0100
Subject: [PATCH v7 1/3] selftests: cgroup: Add dmem_selftest helper module
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-kunit_cgroups-v7-1-5bcbfe17f323@redhat.com>
References: <20261117-kunit_cgroups-v7-0-5bcbfe17f323@redhat.com>
In-Reply-To: <20261117-kunit_cgroups-v7-0-5bcbfe17f323@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Maarten Lankhorst <dev@lankhorst.se>, 
 Natalie Vock <nat@pixelcluster.dev>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Albert Esteve <aesteve@redhat.com>, echanude@redhat.com, mripard@kernel.org, 
 R Nageswara Sastry <rnsastry@linux.ibm.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794922072; l=7355;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=cOJrMzEzabCnmqM+iZPp7QVb9cB4mcTN/+vMCh+ZR1g=;
 b=McXDMPtuiFBJtpWy/5Ppc8N3VAWSTTpaNSTkQaNGteufdBfLNyQRYh5OGbtnOQdL/CdIHU+HP
 hyqpI2B8DBpAMXiHx93S01HSAYgmkZDn3LSaHWH1Vu76mKWRX3MjmWI
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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

Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
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

