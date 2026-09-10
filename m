Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAD9336EDA;
	Thu, 10 Sep 2026 06:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789023029; cv=none; b=MQEiF0lbzUYxLdIbdGYzZSGdRcmek3Z8jAJ0/XJIIDfIaYRhLu/PFExN4TxZ4BMcz1DGBPatmEEGW+GpfIczfLSyvcuNiIHdOMQ1Ciur6mHRA++PnnYIbW1BGbY4efLr07Nbm3mxfalkwYdN8nIMyWFOdrtHueVLWA3Kw6PkKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789023029; c=relaxed/simple;
	bh=V95IRbPSRWB3sfF3TOxZ79IBZWlAH9qDMXDgYSRjlYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onsP+hr72Ud/hKEwf9MJC+mkB5RvusglRAJu2JjDNa3NlACKUNoAaJBrfCmwgyF6jrpE4M9j+6eQO2jgtu6l1FbA8Am0IU5wGoPEjUQAKRI5lrDxPEk+8TUR1RpUxuzWx8re4ERqSTtR0e49/gZoxCdH2krmAY5lpPpZ+A0FGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oIbbmuBx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oIbbmuBx"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5W9Oc834263;
	Thu, 10 Sep 2026 06:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rTNTB2
	dmt940RpyAxK2/e0axKbY5jrRwKHpScd7ByZY=; b=oIbbmuBxKLUqr9NMRSoyy0
	rv5utSI8W2HSbUf3Ic+mo5u/5ruq91db86kHfK/eDT7OTw+/h/tWMW5Q+3pyVwq2
	utZcrvaLhDj7hmk3ic2fZ6o+KYPRc17jWnNcV9LLJEMF77fIIW7yLwpr9SqNJd/u
	PAVLzdlcicLj0oOes1u66biQmQyWaL03PicwUolaKeABX9JEh814y0QdFQb4HF/U
	o3PoGUMQGx0K9ONrmNioIHJcvCiApyoFmqWWS1lthhE2wFE43MX2wsFEJoJ41vxx
	K8qMCObv2U9SxSuM10LPkknKIJWaCUq8iQkbG8YD/gzrUuQLNOAWCZ5S7fJTwueA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q2uwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68A6fFYg016055;
	Thu, 10 Sep 2026 06:50:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkcr3ay47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 06:50:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68A6oJ5v46203296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 06:50:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 912A320043;
	Thu, 10 Sep 2026 06:50:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08A5920040;
	Thu, 10 Sep 2026 06:50:18 +0000 (GMT)
Received: from [9.123.7.154] (unknown [9.123.7.154])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 10 Sep 2026 06:50:17 +0000 (GMT)
Message-ID: <f6f1d5be-c5b1-4296-828d-526f0f11ba9f@linux.ibm.com>
Date: Thu, 10 Sep 2026 12:20:16 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] selftests: cgroup: Add KB() helper
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260831-kunit_cgroups-v6-0-63b6c7695287@redhat.com>
 <20260831-kunit_cgroups-v6-2-63b6c7695287@redhat.com>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260831-kunit_cgroups-v6-2-63b6c7695287@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GR_lu9_1dfLJiD5jLaSsYU2UzO0y-Kwk
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX+NwMs8PyM0l8
 hRVPGWUKPbZXbCLGH6CiumtLQpP/la0PFSGl7t6nxssQ6mDFPGQ/G+FDRP4b78KyCp67Vbevipr
 lbGqeKmeVi4HVTSOsvFIkWoFfGbdxrk=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa2532e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=I-0HQfl2xuamNFeILUcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA2OCBTYWx0ZWRfX+HF5hPulz223
 xPImxXdGAc4ISM6zbrPr84Ai5Ft9rIpcVi1lyh81liXz1RkiNQqykBiKsAIiDHMuahv4t7qXbMV
 tLGBeVIlyvcRQL8PTw1lqOYPhESkXXoYcYomRQPnLkN1OikBdv60gD77JutUs8xl2cpYNJpxvL6
 vjKstiZUR8d0MtA4gU752nfffUyo7Knn7Jsmn/4LojiAXaqkAoyhwQIvXRhMiMhPF4JTOia8JJL
 vr5BH7Mb7W6svtLYCHNJcWdWI72fpPoji1S+iDY43s7YFnz+mWaZMuc9E71J6m0AD8CEf2lj4Zt
 DJx4abRbj2kQrfIXfLZ+gye0V91V0NGvYWqcmC4e+uEoo1JD4UupvCriStc9ktW/ptoHrwRj3Vt
 ynWlyY/qyznATi38pkVW3ytM8g7JP9Wi7Gk4lHjW9UNLTpB/fiHNltCGbCMORBmMVcIMUZ+XHHB
 SYaI/XsaamF5CJov2CQ==
X-Proofpoint-GUID: GR_lu9_1dfLJiD5jLaSsYU2UzO0y-Kwk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100068


On 31.08.2026 6:55 PM, Albert Esteve wrote:
> cgroup_util.h already has MB() and GB() for size
> literals. Add KB() in the same style so tests can
> spell kilobyte values without in-code shifts.
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
>   tools/testing/selftests/cgroup/lib/include/cgroup_util.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> index 5d39c709ac7a..0e5d7b87ad19 100644
> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> @@ -6,6 +6,7 @@
>   #define BUF_SIZE 4096
>   #endif
>   
> +#define KB(x) (x << 10)
>   #define MB(x) (x << 20)
>   #define GB(x) ((unsigned long long)(x) << 30)
>   
>
-- 
Thanks and Regards
R.Nageswara Sastry

