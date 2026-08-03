Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68C495E5;
	Mon,  3 Aug 2026 06:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785739912; cv=none; b=dqw3ODmFWS2zDXu+Oc+HPLeH71PVM7Tu6cB8780GZS9bp2S0XOrdYeDLJTGfvzv8llBvyZbIZrreXJjunp2UVc40WeisYgG8q4U9OtIHb07HbLQpZzoIgTpX+H9UCzTm1aZE+PuDzwbO7NBD6gSIb7R+FD+qkwbPD0l4RUnA4kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785739912; c=relaxed/simple;
	bh=zKGUVg/NryqYKpmP/fi6Z0gKwTUnjqYriX/X55sLo7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ca5F2bow4LqhAHPQ89kQhJK8oo2LTa/e25QLpv3PCyKvIvmZ+cXE7Q/pvWTA4aQE2ipsgH32aK1fwsvd4uFEQc3o6KCzeuHpIKEWeZ4nJg/5WYVytRjrntz7N5ILxWECKmnBRW0vjLC39wEu6kJZFtyGrG+6Mjk8r8MNcVQJiEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X1fZsP6B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X1fZsP6B"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LmGet244563;
	Mon, 3 Aug 2026 06:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0AHytU
	NGthmLEgCVKy/z6GJr/Ssjt6kJkyaWbsoP/cY=; b=X1fZsP6BBOjujTr4ugA7j4
	WT3TNxJ/bAvGg6AyD34oGkSaOjfPZreXVFD4R+Qiaem0cA3Gy6DQDTSzzx5ItDF4
	/QCnRgrYOgvL9erWVqx3h+0+0qCnT5e6pXFKF1E7xI5yOX7sbP2r4XX0kZqFSKX1
	ZQDcyhdly/g22tEMJDgtNr6opQxVl+6rz8HAklKpyKpe35FjC5dWK6hvljga0+Ef
	58leEc0YX0v+6tLxj9ZTy1leE9RfJ5+GJWElb4bTGd0vaUJDRRic+CpZGJqMJMXs
	XDSOQvkmiwZmO3r75vpHbXKC3XPSbnwoUe5pqvY43OY03Jko60yTzXKTz2lv9FyQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h4q8hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:51:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6736fJeo002542;
	Mon, 3 Aug 2026 06:51:29 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4jv4ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 06:51:29 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6736pS9o8651382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 06:51:28 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEAE558053;
	Mon,  3 Aug 2026 06:51:28 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37F3258043;
	Mon,  3 Aug 2026 06:51:25 +0000 (GMT)
Received: from [9.123.7.57] (unknown [9.123.7.57])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Aug 2026 06:51:24 +0000 (GMT)
Message-ID: <431ed2f9-9fde-4ff7-9db7-51a56bec17c0@linux.ibm.com>
Date: Mon, 3 Aug 2026 12:21:23 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] blk-cgroup: fix blkg list and policy data races
To: Yu Kuai <yukuai@kernel.org>, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de,
        yizhou.tang@shopee.com, yukuai@fygo.io
References: <20260802112525.3933753-1-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfX9MHQGnu/s4Cl
 feHILuCk4a9d61q8JmfX8UZm7xT/2iBXeOyI7M8TJ7oqf38EA9to/WbADbtmsEFtJOtN4mlnvNA
 QPrrcdGM6K1bfG8s3nMNNG7tkdsoGAI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA1OCBTYWx0ZWRfXwJH1TJPrgzhe
 AtbIKo8sVOo4RzleYBy/PdaDhsqfgjjsewtf+YXDSdt28Plk4/8Hskxx4CIjogl+wbgrASf2C0j
 HwoJ1dpHl3LBoEaL/jlDljWvyXfjXQKZTz9ztGTJVpAzZTJsDa6LkZJa3dzMQ0vvyanbgPNR1Km
 0cL3y/FQXE76cKFeZTrihJDIA+Qc8Pen+xzVelEMFPxtlMMCJomsD0uorI+VIz4QtvPIjZQyQKn
 ZJdnWj5FIQMA5114iGwoWqIwQ78b88jrSkuntN8nVrDQML/A7b3nEJ2DzDzkSwch0e2i4Hhhxny
 EIATasrfw0S0m9asWKY86Lo1Oe7pE+EfdFxaawMhbDTnEoRTEB11kEwuQ3tawlDfw+Siy8EMxvb
 jN0nUPqkb0lWWGFrMOf/pV1Z86rImzWd2cU6EmfJeMbHufb1TrCqv5h6DQuRhh6pNpe68cXjO3l
 7GShgTLd+Q/fX9Ss9pA==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a703a72 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=OXP71DqVsUOFssmpANUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CAJPe-0nk7ZcBOl9jkiVMryB_qLI2SHO
X-Proofpoint-GUID: CAJPe-0nk7ZcBOl9jkiVMryB_qLI2SHO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608030058

On 8/2/26 4:55 PM, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> This set fix some problems that are reported long time ago with minimal changes,
> the blkcg_mutex refactor I'm working on can fix these problems as well, but it's
> complicated and may not land in this merge window. So I think this set should land
> in this merge window first.
> 
> Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
> blkcg_mutex.
> 
> Patches 2-3 fix races between blkcg_activate_policy() and concurrent
> blkg destruction.
> 
> Patch 4 factors the policy data teardown loop into a helper after the
> race fixes.
> 

This series looks good to me, however as I recall, we discussed about
protecting blkg_create() as well using ->blkcg_mutex. I remember the
blkg_create() is not protected with ->blkcg_mutex under each call path,
so would you to also cover that change in this patchset?

Thanks,
--Nilay

