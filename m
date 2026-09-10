Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E1D33986F;
	Thu, 10 Sep 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789023047; cv=none; b=nwTxiYPLZQd0LKVD8/aXf4IDSp6HfqHcWFVq+SIdo76Ee5wXFbZi5HNYIpqeqIu0ZSrl256iADoK4ToeHHnyED+v/Djsf1zfDD/wfXvfG82pOS2OWGLnGiRVbIotaooGjjzJ6SxgoOJg/LPBztmoc497pYD69KXDh/XwjjdIHm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789023047; c=relaxed/simple;
	bh=+isLNTacvpCs6bgpp2c2tIsRjNEkqNNvOCATXraN59Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dyEm0JSBs1oBAvKuV/vQFkPxMN7H+NnbEgN2zvqNtW5jBfXCgND5rqlfGw5V9WabLbM1UGes0es7GYRShlNmqvnpRhJT5I5RJ+fUYuqIJjo3ixA0uZxIbX1TRc6jIkNzrGs/EJdettoHdICcNUVrOJVljnndUsyj+U5FoBVwVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XYyQVJC+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XYyQVJC+"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5VjCj1840830;
	Thu, 10 Sep 2026 06:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ms9zwv
	RXlvlYr/YdmtoMlOjj85FqPh2jIv46d07AyXY=; b=XYyQVJC+3h40+HxkNPRQ8E
	Lc5Btb8llGOre4vz5m3DmUvUrPszsfTpeqEXfzFBHmLrwo75ETcD9yPCUZ8hzmGk
	kXX91AmAntzqAFdjQsVRJNsD7oV4w8CS2WrSVsJm3qyeWc0snl3t7TxWb0EuLcIl
	stWPpCClQxSHNfOJEgBPV5/oSRtL0hE3mVWbVXu50Cf88dcnHLb9L7EFYM36CNIj
	M5khbpKREcbP17RSKCdtdcLPFLwQEeiUfBSuSRatFouiP3LFYPV5hwflnOEU8lkE
	NSRYw7l+wfFOqVZGOREKoB1rLFnjTo4YUatL0uyJprvoA29eIDsYNTz6/hmMUGQA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8s2v0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68A6fNCl026846;
	Thu, 10 Sep 2026 06:50:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkcr3ay9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68A6obq638273472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 06:50:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58BE020043;
	Thu, 10 Sep 2026 06:50:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89FEB20040;
	Thu, 10 Sep 2026 06:50:35 +0000 (GMT)
Received: from [9.123.7.154] (unknown [9.123.7.154])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 10 Sep 2026 06:50:35 +0000 (GMT)
Message-ID: <0a8f5c96-6fe5-4e98-91e1-2172bc4dec30@linux.ibm.com>
Date: Thu, 10 Sep 2026 12:20:33 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] selftests: cgroup: Add dmem selftest coverage
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
 <20260831-kunit_cgroups-v6-3-63b6c7695287@redhat.com>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260831-kunit_cgroups-v6-3-63b6c7695287@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nGffOIuAuJ_f7DWS_HUzbhLKqNN2XCfT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX0uPK1RCC8wpx
 Au+0YePzjHl1p+M9u5/5jv3i1XNXs0v3ujjTxD2nXZTjlx+vkMDnB30xuesFL4M+Cd966GkzkXC
 bbTRw30Mj7uLZl1OqsfayLQOquaHFJ/b7dhe/P1m8ICTQcKUIHFT15VeFDxGFBN35oRIFgkuUnv
 0XMy3o6YxSsofeHZVZjsaSdL/BJ0I6bBjcXTE9dxdMtk7/vVUIZybAkmdVfDI7qTCmxPPnxbICp
 z1Bawp0A6GrG292pwArLAM62J9+4qB8wiP+JJ7O/sQsU9i54d1rYdHj5kIn2is2Oxdl2FPiHBHv
 qpvgWEBoYdXJUR25llwR5YSsw4VXCvAh3ytANutdwYBCWT4QNWHCANQKQDnt4PClzdULhyYWAMY
 03BC03AiR1OHBN/2zkaumyfZKtG/Wx84UKrMwZGYSnlAy+pWwnX8qvDSEJeYHRIXNR1N8kAZY+q
 ABPzIDsChOHhY9+nQYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX7HxkR9H30e29
 I3iuOCUv5x9Fz1vrcG0y02q6igq/guAHoomunMF6DZeFiCOSHfzJzgFy3DbVxFnerwmjMxwOErF
 d3d3Tk6L46raJav7HCzvkXB0m4Fesuo=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aa25340 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=L9VOxkyd-HjZqvWC7icA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: nGffOIuAuJ_f7DWS_HUzbhLKqNN2XCfT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100068


On 31.08.2026 6:55 PM, Albert Esteve wrote:
> Currently, tools/testing/selftests/cgroup/ has no
> dmem-specific test. This leaves dmem accounting and
> dmem.max enforcement largely unvalidated without a
> production driver.
>
> Add test_dmem, driven by the dmem_selftest helper module
> parameters (alloc/free) on the dmem_selftest region.
> insmod the helper before running the tests.
>
> The tests cover:
> - test_dmem_max: nested hierarchy with per-leaf dmem.max
>    values and verifies that over-limit charges fail while
>    in-limit charges succeed in dmem.current.
> - test_dmem_alloc_byte_granularity: non-page-aligned alloc
>    sizes, dmem.current equals the requested byte count, and
>    free-to-zero behavior.
>
> Limits are read with cg_read_key_long(). The helper is stat'd
> in main() so a missing module skips the whole test instead
> of each subtest.
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
>   tools/testing/selftests/cgroup/.gitignore  |   1 +
>   tools/testing/selftests/cgroup/Makefile    |   2 +
>   tools/testing/selftests/cgroup/test_dmem.c | 314 +++++++++++++++++++++++++++++
>   3 files changed, 317 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
> index 952e4448bf07..ea2322598217 100644
> --- a/tools/testing/selftests/cgroup/.gitignore
> +++ b/tools/testing/selftests/cgroup/.gitignore
> @@ -2,6 +2,7 @@
>   test_core
>   test_cpu
>   test_cpuset
> +test_dmem
>   test_freezer
>   test_hugetlb_memcg
>   test_kill
> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
> index a08661320a07..d01e8eb1ead2 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -11,6 +11,7 @@ TEST_GEN_MODS_DIR := test_modules
>   TEST_GEN_PROGS  = test_core
>   TEST_GEN_PROGS += test_cpu
>   TEST_GEN_PROGS += test_cpuset
> +TEST_GEN_PROGS += test_dmem
>   TEST_GEN_PROGS += test_freezer
>   TEST_GEN_PROGS += test_hugetlb_memcg
>   TEST_GEN_PROGS += test_kill
> @@ -27,6 +28,7 @@ include lib/libcgroup.mk
>   $(OUTPUT)/test_core: $(LIBCGROUP_O)
>   $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
>   $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
> +$(OUTPUT)/test_dmem: $(LIBCGROUP_O)
>   $(OUTPUT)/test_freezer: $(LIBCGROUP_O)
>   $(OUTPUT)/test_hugetlb_memcg: $(LIBCGROUP_O)
>   $(OUTPUT)/test_kill: $(LIBCGROUP_O)
> diff --git a/tools/testing/selftests/cgroup/test_dmem.c b/tools/testing/selftests/cgroup/test_dmem.c
> new file mode 100644
> index 000000000000..3793664678b9
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_dmem.c
> @@ -0,0 +1,314 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test the dmem (device memory) cgroup controller.
> + *
> + * Depends on the dmem_selftest helper module
> + * (tools/testing/selftests/cgroup/test_modules/dmem_selftest.c).
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <linux/limits.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +#include "kselftest.h"
> +#include "cgroup_util.h"
> +
> +#define DM_SELFTEST_REGION	"dmem_selftest"
> +#define DM_SELFTEST_ALLOC	"/sys/module/dmem_selftest/parameters/alloc"
> +#define DM_SELFTEST_FREE	"/sys/module/dmem_selftest/parameters/free"
> +
> +static long dmem_read_limit(const char *cgroup, const char *ctrl)
> +{
> +	return cg_read_key_long(cgroup, ctrl, DM_SELFTEST_REGION " ");
> +}
> +
> +static int dmem_write_limit(const char *cgroup, const char *ctrl, long val)
> +{
> +	char wr[64];
> +
> +	snprintf(wr, sizeof(wr), "%s %ld", DM_SELFTEST_REGION, val);
> +	return cg_write(cgroup, ctrl, wr);
> +}
> +
> +static int dmem_selftest_alloc(long bytes)
> +{
> +	char wr[32];
> +
> +	snprintf(wr, sizeof(wr), "%ld", bytes);
> +	return write_text(DM_SELFTEST_ALLOC, wr, strlen(wr));
> +}
> +
> +static int dmem_selftest_free(void)
> +{
> +	char wr[] = "1";
> +
> +	return write_text(DM_SELFTEST_FREE, wr, strlen(wr));
> +}
> +
> +/*
> + * First, this test creates the following hierarchy:
> + * A
> + * A/B     dmem.max=8M
> + * A/B/C   dmem.max=2M
> + * A/B/D   dmem.max=1M
> + * A/B/E   dmem.max=75K
> + * A/B/F   dmem.max=25K
> + * A/B/G   dmem.max=8K
> + * A/B/H   dmem.max=0
> + *
> + * Then for each leaf cgroup it tries to alloc above dmem.max
> + * and expects the request to fail and dmem.current to remain
> + * unchanged.
> + *
> + * For leaves with non-zero dmem.max, it additionally allocs a
> + * smaller amount and verifies dmem.current matches the requested
> + * size exactly (the controller accounts in bytes, with no page
> + * rounding), then frees and verifies dmem.current returns
> + * to the previous value.
> + */
> +static int test_dmem_max(const char *root)
> +{
> +	static const long leaf_max[] = {
> +		MB(2), MB(1), KB(75), KB(25), KB(8), 0
> +	};
> +	static const long pass_sz[] = {
> +		MB(1), MB(1), KB(4), KB(4), KB(4), 0
> +	};
> +	char *parent[2] = {NULL};
> +	char *children[ARRAY_SIZE(leaf_max)] = {NULL};
> +
> +	_Static_assert(ARRAY_SIZE(pass_sz) == ARRAY_SIZE(leaf_max),
> +		       "pass_sz doesn't match leaf_max length");
> +	long cur_before, cur_after;
> +	int ret = KSFT_FAIL;
> +	int charged = 0;
> +	int in_child = 0;
> +	long v;
> +	int i;
> +
> +	parent[0] = cg_name(root, "dmem_prot_0");
> +	if (!parent[0])
> +		goto cleanup;
> +
> +	parent[1] = cg_name(parent[0], "dmem_prot_1");
> +	if (!parent[1])
> +		goto cleanup;
> +
> +	if (cg_create(parent[0]))
> +		goto cleanup;
> +
> +	if (cg_write(parent[0], "cgroup.subtree_control", "+dmem"))
> +		goto cleanup;
> +
> +	if (cg_create(parent[1]))
> +		goto cleanup;
> +
> +	if (cg_write(parent[1], "cgroup.subtree_control", "+dmem"))
> +		goto cleanup;
> +
> +	for (i = 0; i < ARRAY_SIZE(children); i++) {
> +		children[i] = cg_name_indexed(parent[1], "dmem_child", i);
> +		if (!children[i])
> +			goto cleanup;
> +		if (cg_create(children[i]))
> +			goto cleanup;
> +	}
> +
> +	if (dmem_write_limit(parent[1], "dmem.max", MB(8)))
> +		goto cleanup;
> +	for (i = 0; i < ARRAY_SIZE(children); i++)
> +		if (dmem_write_limit(children[i], "dmem.max", leaf_max[i]))
> +			goto cleanup;
> +
> +	v = dmem_read_limit(parent[1], "dmem.max");
> +	if (v != MB(8))
> +		goto cleanup;
> +	for (i = 0; i < ARRAY_SIZE(children); i++) {
> +		v = dmem_read_limit(children[i], "dmem.max");
> +		if (v != leaf_max[i])
> +			goto cleanup;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(children); i++) {
> +		if (cg_enter_current(children[i]))
> +			goto cleanup;
> +		in_child = 1;
> +
> +		cur_before = dmem_read_limit(children[i], "dmem.current");
> +		if (cur_before < 0)
> +			goto cleanup;
> +
> +		if (dmem_selftest_alloc(leaf_max[i] + 1) >= 0) {
> +			charged = 1;
> +			goto cleanup;
> +		}
> +
> +		cur_after = dmem_read_limit(children[i], "dmem.current");
> +		if (cur_after != cur_before)
> +			goto cleanup;
> +
> +		if (pass_sz[i] > 0) {
> +			if (dmem_selftest_alloc(pass_sz[i]) < 0)
> +				goto cleanup;
> +			charged = 1;
> +
> +			cur_after = dmem_read_limit(children[i], "dmem.current");
> +			if (cur_after != cur_before + pass_sz[i])
> +				goto cleanup;
> +
> +			if (dmem_selftest_free() < 0)
> +				goto cleanup;
> +			charged = 0;
> +
> +			cur_after = dmem_read_limit(children[i], "dmem.current");
> +			if (cur_after != cur_before)
> +				goto cleanup;
> +		}
> +
> +		if (cg_enter_current(root))
> +			goto cleanup;
> +		in_child = 0;
> +	}
> +
> +	ret = KSFT_PASS;
> +
> +cleanup:
> +	if (charged)
> +		dmem_selftest_free();
> +	if (in_child)
> +		cg_enter_current(root);
> +	for (i = ARRAY_SIZE(children) - 1; i >= 0; i--) {
> +		if (!children[i])
> +			continue;
> +		cg_destroy(children[i]);
> +		free(children[i]);
> +	}
> +	for (i = ARRAY_SIZE(parent) - 1; i >= 0; i--) {
> +		if (!parent[i])
> +			continue;
> +		cg_destroy(parent[i]);
> +		free(parent[i]);
> +	}
> +	return ret;
> +}
> +
> +/*
> + * Alloc non-page-aligned byte sizes and verify dmem.current matches
> + * the requested size exactly. The controller charges the byte count
> + * passed to dmem_cgroup_try_charge() with no page rounding, for this
> + * helper and for production drivers. Then free must return usage to 0.
> + */
> +static int test_dmem_alloc_byte_granularity(const char *root)
> +{
> +	static const long sizes[] = {
> +		1, 4095, 4097, KB(75) + 1, MB(1), MB(1) + 1
> +	};
> +	char *cg = NULL;
> +	long cur;
> +	int ret = KSFT_FAIL;
> +	int charged = 0;
> +	int in_child = 0;
> +	size_t i;
> +
> +	cg = cg_name(root, "dmem_dbg_byte_gran");
> +	if (!cg)
> +		goto cleanup;
> +
> +	if (cg_create(cg))
> +		goto cleanup;
> +
> +	if (dmem_write_limit(cg, "dmem.max", MB(16)))
> +		goto cleanup;
> +
> +	if (cg_enter_current(cg))
> +		goto cleanup;
> +	in_child = 1;
> +
> +	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
> +		if (dmem_selftest_alloc(sizes[i]) < 0)
> +			goto cleanup;
> +		charged = 1;
> +
> +		cur = dmem_read_limit(cg, "dmem.current");
> +		if (cur != sizes[i])
> +			goto cleanup;
> +
> +		if (dmem_selftest_free() < 0)
> +			goto cleanup;
> +		charged = 0;
> +
> +		cur = dmem_read_limit(cg, "dmem.current");
> +		if (cur != 0)
> +			goto cleanup;
> +	}
> +
> +	ret = KSFT_PASS;
> +
> +cleanup:
> +	if (charged)
> +		dmem_selftest_free();
> +	if (in_child)
> +		cg_enter_current(root);
> +	if (cg) {
> +		cg_destroy(cg);
> +		free(cg);
> +	}
> +	return ret;
> +}
> +
> +#define T(x) { x, #x }
> +struct dmem_test {
> +	int (*fn)(const char *root);
> +	const char *name;
> +} tests[] = {
> +	T(test_dmem_max),
> +	T(test_dmem_alloc_byte_granularity),
> +};
> +#undef T
> +
> +int main(int argc, char **argv)
> +{
> +	char root[PATH_MAX];
> +	struct stat st;
> +	int i;
> +
> +	ksft_print_header();
> +
> +	if (cg_find_unified_root(root, sizeof(root), NULL))
> +		ksft_exit_skip("cgroup v2 isn't mounted\n");
> +
> +	if (cg_read_strstr(root, "cgroup.controllers", "dmem"))
> +		ksft_exit_skip("dmem controller isn't available (CONFIG_CGROUP_DMEM?)\n");
> +
> +	if (cg_read_strstr(root, "cgroup.subtree_control", "dmem"))
> +		if (cg_write(root, "cgroup.subtree_control", "+dmem"))
> +			ksft_exit_skip("Failed to enable dmem controller\n");
> +
> +	if (stat(DM_SELFTEST_ALLOC, &st) < 0)
> +		ksft_exit_skip(
> +			"dmem_selftest helper not loaded (insmod test_modules/dmem_selftest.ko)\n");
> +
> +	if (dmem_read_limit(root, "dmem.capacity") < 0)
> +		ksft_exit_skip("dmem_selftest region not registered\n");
> +
> +	ksft_set_plan(ARRAY_SIZE(tests));
> +
> +	for (i = 0; i < ARRAY_SIZE(tests); i++) {
> +		switch (tests[i].fn(root)) {
> +		case KSFT_PASS:
> +			ksft_test_result_pass("%s\n", tests[i].name);
> +			break;
> +		default:
> +			ksft_test_result_fail("%s\n", tests[i].name);
> +			break;
> +		}
> +	}
> +
> +	ksft_finished();
> +}
>
-- 
Thanks and Regards
R.Nageswara Sastry

