Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E742336895;
	Thu, 10 Sep 2026 06:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789023012; cv=none; b=kft2xAfmwwfIihcV6N44k4xLdE1wUzbhqI/8TTJtruesX7C3sP/KVyGyXJ5Ez9indyZCIzdGfL/tnBSxGwLM5J306yeRwKyuFQSHEdiy/RFprR54gVZUZMT6oikin5qLlcg0yEbVt+pRNmL0Gnf7QUI9gsZCubykAvXos3+bSdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789023012; c=relaxed/simple;
	bh=XTL9mON0pd/wakpVxUVxRk0rc+fRRgy1XEM1PDJO/sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q6rF5XYk9nY0XxNPQb7uCfMo5hJ16dLn+dhjDLXewQO6uOPYAGsOkWwPa8+XnMZ9pIoHlq3wkyIdtNP+R+hnEqu5dQGiCbwIa8AVloNP/pnEyBzeHTJyif2zn0oIyRLayyfi/EkE5EbSP4PDOvs4q0g2TtyIAsAKLvBHZoBCDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jxLPQhec; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jxLPQhec"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5VXTx833385;
	Thu, 10 Sep 2026 06:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YxXplc
	T0yl9G0tuxGaFkbXMxp42IkZDUY31wnTmuVwE=; b=jxLPQhecIqGOuMLAYJd24M
	SoZY8nHUx/rs7RYAvnoPzXKAO5DgELR+AHPpBXTlmfs3LZlEK3COcGirtc2Nmmab
	Bv5gs7Dx4CF1bivm1IF4oIqHTtt4vO+cyMKMfQH0NwqnzRcz6tooQxjKSxmn+b8S
	mk1pa0GD9LYuqzD7EPclVmgDlbI44atiRgNCGEFYHy3tcf1O1+KgcQ+fO9Cmzhal
	jix6qUt0MDYvko2fu8TfdYyqBJ9KZGQWXNky/WsV6qBwJKaIF5TqNa7DX2aXZvNk
	sclyOA6+zIFIVNIKW9dpt3/EpRTdtMqM1YpiCMUl7Nun7hBiquzM+IZCKsLJ91SQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q2uv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68A6fErh016039;
	Thu, 10 Sep 2026 06:50:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkcr3ay2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68A6o2e838273444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 06:50:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 671852004D;
	Thu, 10 Sep 2026 06:50:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9020720040;
	Thu, 10 Sep 2026 06:50:00 +0000 (GMT)
Received: from [9.123.7.154] (unknown [9.123.7.154])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 10 Sep 2026 06:50:00 +0000 (GMT)
Message-ID: <015c7b09-3f20-46f8-9133-0fe1f4f90983@linux.ibm.com>
Date: Thu, 10 Sep 2026 12:19:58 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] selftests: cgroup: Add dmem_selftest helper module
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
 <20260831-kunit_cgroups-v6-1-63b6c7695287@redhat.com>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260831-kunit_cgroups-v6-1-63b6c7695287@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WzQPgARJfBkrPCFJg99b5OepypStie9U
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX50ieA06Zemkn
 h2Ca2piIFZx6kyN+OjvxhFXsn/dtAyjKNycGVE80wNPKYdDAQRKHVRPqROP/w9yzk2DKn5PBBtu
 3WIhX12SOgEE3bQppe+NNIllnsDOjCo=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa2531d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=6k8FuFMU-wUc9U5Hs5cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX43UwZxPNZLuh
 x9e98ZrIDEvD84e4MYP9JeXRmAYDQjK+eOeHDKTRZejGOarBrieWMK2V3XxpM5qip/p4ITrj4if
 Cxpe3vJ/wfzNUkJKINMDmRBw16uIhP1qcUx3Z3TvYhp2QIf2pCVYClKea7Hupm/RcZb8n4Vwcby
 /4Q+ZrQ8Zw01q67CCrfV/DhHTI2ZlPsWw+ox8NHBCo08LpzObW4w4IROIQ2g9iNrNoWECwpD/M9
 c+65IqWkbYc0YGuN7FmDfPkSH7+cWcrM1MGg5SyQl2C52Myb0uCx9g3g6kL2OPNT1ZiEjEMhnt9
 1s4vU6fSV5Ps824klCZMlR71JMfTW1Gg3oCVAN3LN5EIQD3cSJ3lgyS4q+1fte1ke6UkKCxx+Qo
 /h3ISRqUCA/Qj9izB6C9UpBxmUMN5rkXo0WemUboX55bWLdIv9mycA7hpwJ9f8vj/cVSrRqDB2T
 rdtzTgaGHqC3Jh1dFEA==
X-Proofpoint-GUID: WzQPgARJfBkrPCFJg99b5OepypStie9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100068


On 31.08.2026 6:55 PM, Albert Esteve wrote:
> Currently, dmem charging is driver-driven through direct
> calls to dmem_cgroup_try_charge() (for example TTM).
> That does not give cgroup selftests a generic way to
> trigger alloc/free paths from userspace in a chosen
> cgroup, so coverage of nested dmem.max still
> needs a synthetic region.
>
> Add tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
> as an OOT helper, built like other test_modules (no extra
> Kconfig needed). Tests can insmod the .ko module to register a
> "dmem_selftest" region.
>
> Module parameters drive a single outstanding allocation against
> the calling task's cgroup:
>
>    /sys/module/dmem_selftest/parameters/alloc
>    /sys/module/dmem_selftest/parameters/free
>
> Writing a size to alloc triggers dmem_cgroup_try_charge() for
> the calling task's cgroup. Writing to free with no argument
> releases the outstanding charge via dmem_cgroup_uncharge().
> Only a single outstanding charge is supported.
>
> This provides a deterministic, driver-independent mechanism
> for exercising dmem accounting paths in selftests.
>
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2

# insmod test_modules/dmem_selftest.ko
# ./test_dmem
TAP version 13
1..2
ok 1 test_dmem_max
ok 2 test_dmem_alloc_byte_granularity
# Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

> ---
>   tools/testing/selftests/cgroup/Makefile            |   1 +
>   tools/testing/selftests/cgroup/config              |   1 +
>   .../testing/selftests/cgroup/test_modules/Makefile |  17 +++
>   .../selftests/cgroup/test_modules/dmem_selftest.c  | 146 +++++++++++++++++++++
>   4 files changed, 165 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
> index e01584c2189a..a08661320a07 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -6,6 +6,7 @@ all: ${HELPER_PROGS}
>   TEST_FILES     := with_stress.sh
>   TEST_PROGS     := test_stress.sh test_cpuset_prs.sh test_cpuset_v1_hp.sh
>   TEST_GEN_FILES := wait_inotify
> +TEST_GEN_MODS_DIR := test_modules
>   # Keep the lists lexicographically sorted
>   TEST_GEN_PROGS  = test_core
>   TEST_GEN_PROGS += test_cpu
> diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
> index 39f979690dd3..2ee0488c3d65 100644
> --- a/tools/testing/selftests/cgroup/config
> +++ b/tools/testing/selftests/cgroup/config
> @@ -1,5 +1,6 @@
>   CONFIG_CGROUPS=y
>   CONFIG_CGROUP_CPUACCT=y
> +CONFIG_CGROUP_DMEM=y
>   CONFIG_CGROUP_FREEZER=y
>   CONFIG_CGROUP_SCHED=y
>   CONFIG_MEMCG=y
> diff --git a/tools/testing/selftests/cgroup/test_modules/Makefile b/tools/testing/selftests/cgroup/test_modules/Makefile
> new file mode 100644
> index 000000000000..dd8a17313cec
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_modules/Makefile
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0
> +TESTMODS_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
> +KDIR ?= /lib/modules/$(shell uname -r)/build
> +
> +obj-m += dmem_selftest.o
> +
> +# Ensure that KDIR exists, otherwise skip the compilation
> +modules:
> +ifneq ("$(wildcard $(KDIR))", "")
> +	$(Q)$(MAKE) -C $(KDIR) modules KBUILD_EXTMOD=$(TESTMODS_DIR)
> +endif
> +
> +# Ensure that KDIR exists, otherwise skip the clean target
> +clean:
> +ifneq ("$(wildcard $(KDIR))", "")
> +	$(Q)$(MAKE) -C $(KDIR) clean KBUILD_EXTMOD=$(TESTMODS_DIR)
> +endif
> diff --git a/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c b/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
> new file mode 100644
> index 000000000000..a763a156f13f
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_modules/dmem_selftest.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Kselftest helper for the dmem cgroup controller.
> + *
> + * Registers a synthetic dmem region so tests can trigger allocations
> + * from the calling task's cgroup via module parameters:
> + *   /sys/module/dmem_selftest/parameters/alloc
> + *   /sys/module/dmem_selftest/parameters/free
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/cgroup_dmem.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/mutex.h>
> +#include <linux/panic.h>
> +#include <linux/sysfs.h>
> +
> +#define DM_SELFTEST_REGION_NAME	"dmem_selftest"
> +#define DM_SELFTEST_REGION_SIZE	(256ULL * 1024 * 1024)
> +
> +static struct dmem_cgroup_region *selftest_region;
> +static struct dmem_cgroup_pool_state *alloc_pool;
> +static u64 alloc_size;
> +static DEFINE_MUTEX(alloc_lock);
> +
> +static int param_set_alloc(const char *val, const struct kernel_param *kp)
> +{
> +	struct dmem_cgroup_pool_state *pool = NULL, *limit = NULL;
> +	u64 size;
> +	int ret;
> +
> +	if (!selftest_region)
> +		return -ENODEV;
> +
> +	ret = kstrtou64(val, 0, &size);
> +	if (ret)
> +		return ret;
> +	if (!size || size > DM_SELFTEST_REGION_SIZE)
> +		return -EINVAL;
> +
> +	mutex_lock(&alloc_lock);
> +	if (alloc_pool) {
> +		mutex_unlock(&alloc_lock);
> +		return -EBUSY;
> +	}
> +
> +	ret = dmem_cgroup_try_charge(selftest_region, size, &pool, &limit);
> +	if (ret == -EAGAIN && limit)
> +		dmem_cgroup_pool_state_put(limit);
> +	if (ret) {
> +		mutex_unlock(&alloc_lock);
> +		return ret;
> +	}
> +
> +	alloc_pool = pool;
> +	alloc_size = size;
> +	mutex_unlock(&alloc_lock);
> +	return 0;
> +}
> +
> +static int param_get_alloc(char *buffer, const struct kernel_param *kp)
> +{
> +	u64 size;
> +
> +	mutex_lock(&alloc_lock);
> +	size = alloc_size;
> +	mutex_unlock(&alloc_lock);
> +	return sysfs_emit(buffer, "%llu\n", size);
> +}
> +
> +static const struct kernel_param_ops alloc_ops = {
> +	.set = param_set_alloc,
> +	.get = param_get_alloc,
> +};
> +
> +module_param_cb(alloc, &alloc_ops, NULL, 0644);
> +MODULE_PARM_DESC(alloc, "Allocate (charge) SIZE bytes against the calling task's dmem cgroup");
> +
> +static int param_set_free(const char *val, const struct kernel_param *kp)
> +{
> +	mutex_lock(&alloc_lock);
> +	if (!alloc_pool) {
> +		mutex_unlock(&alloc_lock);
> +		return -EINVAL;
> +	}
> +
> +	dmem_cgroup_uncharge(alloc_pool, alloc_size);
> +	alloc_pool = NULL;
> +	alloc_size = 0;
> +	mutex_unlock(&alloc_lock);
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops free_ops = {
> +	.flags = KERNEL_PARAM_OPS_FL_NOARG,
> +	.set = param_set_free,
> +};
> +
> +module_param_cb(free, &free_ops, NULL, 0200);
> +MODULE_PARM_DESC(free, "Free the outstanding dmem selftest allocation");
> +
> +static int __init dmem_selftest_init(void)
> +{
> +	static const struct dmem_cgroup_init init = {
> +		.size = DM_SELFTEST_REGION_SIZE,
> +	};
> +
> +	selftest_region = dmem_cgroup_register_region(&init, DM_SELFTEST_REGION_NAME);
> +	if (IS_ERR(selftest_region))
> +		return PTR_ERR(selftest_region);
> +	if (!selftest_region)
> +		return -EINVAL;
> +
> +	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
> +	pr_info("region '%s' registered; parameters alloc/free\n",
> +		DM_SELFTEST_REGION_NAME);
> +	return 0;
> +}
> +
> +static void __exit dmem_selftest_exit(void)
> +{
> +	mutex_lock(&alloc_lock);
> +	if (alloc_pool) {
> +		dmem_cgroup_uncharge(alloc_pool, alloc_size);
> +		alloc_pool = NULL;
> +		alloc_size = 0;
> +	}
> +	mutex_unlock(&alloc_lock);
> +
> +	if (selftest_region) {
> +		dmem_cgroup_unregister_region(selftest_region);
> +		selftest_region = NULL;
> +	}
> +	pr_info("unloaded.\n");
> +}
> +
> +module_init(dmem_selftest_init);
> +module_exit(dmem_selftest_exit);
> +
> +MODULE_AUTHOR("Albert Esteve <aesteve@redhat.com>");
> +MODULE_DESCRIPTION("Kselftest helper for cgroup dmem controller");
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(test, "Y");
>
-- 
Thanks and Regards
R.Nageswara Sastry

