Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F5A43E4BE;
	Wed, 29 Jul 2026 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312371; cv=none; b=VOmf5FoqdavUEJdAaXYixuxedudEudO30abkfDnTVHUePCUg/4S/n4VQZPEtY/ezSaj2jkCcx887FMQsmMIdAtz9nV66X8QAvZxj7hTzcq9ABKxesN8PaD09tYj5AMDqFK73VnncFipYa1qgJGlRgTZQJI0+BVGX7hsbMoQ3uLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312371; c=relaxed/simple;
	bh=+gFpqfNECcudvjPIbSesCeekyieNQi7IJcwBqeD03OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=myOfKNEUE148cg8t+pvsDmjycdAUfY0mFWSmuJExXNUxqq8KLjTH87xPoZV3rENlQlGN+lNehaKyATglAZcj+83toQkWJQWDnZ8ncvACvj1qIwtIYOJl1tf0OLRkaBTApdM3U27yR45R6M7Ser/0EZaaP8vdq80/FM1hV4xkzk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TfBV47ky; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TfBV47ky"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7lxhm3506989;
	Wed, 29 Jul 2026 08:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Hh6dlq
	3s7Mv84Aptn3QUUc41SrWcBRIEjlF9t6u4gbc=; b=TfBV47kyMaF1dqOfYkYi47
	KpRzf/TA3G/mT3jA5l+ODnZmYkHsRucecfE1BLa5ghiCBDM7Ed11l2BCqWr1gGqt
	QcFxAf933x2skh0EE7vRnXNNbxHMXV7nosSN/vali06u1R3p+XTxS5Pn1OSU8Mtp
	zy2tRlIUSIzB5/ziFlEhKsf0D4ruIoAzn9alQzg+lRxeeSwW50dBU0fiTHZVTceq
	eQqVl3jeC/ORWEJKO41C+hMRyNvsmYRynvqbfPmp0EHckMQR+rS06AHtwmSvqzX9
	CvOvXQybP3aPHgYdnif1jJRiDeqMvM46MYfJopdRx13XlX3n85blwnRdUlMBWQqg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyj8ue0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 08:05:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66T7uFe3020041;
	Wed, 29 Jul 2026 08:05:47 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqdy9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 08:05:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66T85k6c13697764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 08:05:47 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9A6D5805F;
	Wed, 29 Jul 2026 08:05:46 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2C205805C;
	Wed, 29 Jul 2026 08:05:42 +0000 (GMT)
Received: from [9.43.67.164] (unknown [9.43.67.164])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jul 2026 08:05:42 +0000 (GMT)
Message-ID: <8d5f5b83-dea7-47cd-ab0f-61d85a3d7ed9@linux.ibm.com>
Date: Wed, 29 Jul 2026 13:35:40 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of
 bio_set_dev
To: yukuai@fygo.io, axboe@kernel.dk, tj@kernel.org
Cc: hch@lst.de, dongsheng.yang@linux.dev, cengku@gmail.com,
        josef@toxicpanda.com, ming.lei@redhat.com, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org
References: <20260724123037.3004560-1-yukuai@kernel.org>
 <20260724123037.3004560-2-yukuai@kernel.org>
 <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA2MiBTYWx0ZWRfX1vuUHFtY+Ljy
 HwEkGdSqobzBYOROGPy4LLisRFRc1lo0mZ4gouOQx4ZyDQDZaQBCQ6q+F9ZHSyzc7nhe2DuPaIX
 wNTTP367jgkBzPBN9C6C2c2w05xrV5M=
X-Proofpoint-GUID: cTEejdunoxXQ2etS0MyiRQn0t0Z-L6zl
X-Proofpoint-ORIG-GUID: R4R1nxelcaRTS2ilZOkj-XKyUvbJkGP5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA2MiBTYWx0ZWRfX4MirdZPFGc2c
 WOJGbHXXvLPO2AEHdGPm+yBTcgzr/K0yz4/p9S3cvloPwI14E/bXGFgsOwbWfdm9zrER7ztpCAq
 B314Jbja0in2QO6BS6G+43vs8dqvtia1ay5Z81pyVT5R7BYVyL7uW2eg4Q0e2V7/x7me39ZSoem
 2+Xg47dgCdv0zZ13BkvPbErCU5oMuHmQTdI3alYSvd7j+5mzyvniy3YizSvsEEs+5hINa8akV1d
 EX/FdQOcHY8u58ifb3+3+aM9DHAePvZ3WxomPB78CX+PomJg2tFHj5l86uENLZqS6H9+629oy1m
 ZyRuAeJbmwc4KSVPH/Csth4Yq1nntm94l/84Wnm34aWuC6q0A8ITDk7YKR9gyvEhxCS28UcdfWN
 ra6Aq3FIyjCe7IUHSthhydvc/W6JdOVPmLV6dlM08F/D9O6iDK7pPEu/zm6kS7hasZM5pqx46V8
 sOAh0HQBAsfQPhTNPEA==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a69b45c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pkFYtQWUJMQnR_XrdBgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290062

On 7/27/26 1:46 PM, yu kuai wrote:
> Hi,
> 
> 在 2026/7/24 20:30, Yu Kuai 写道:
>> From: Yu Kuai<yukuai@fygo.io>
>>
>> bio_set_dev(), bio_init() and bio_reset() associate a bio with a blkg for
>> its target queue. That association may have to create a new blkg, and
>> currently there are lots of callers that are under atomic context.
>>
>> Move the association out of those helpers and into the submit path, which
>> is always sleepable (submit_bio_noacct() already does might_sleep()):
>>
>>     - submit_bio() associates new I/O before bio_set_ioprio(), whose
>>       blkcg_set_ioprio() reads the policy from bio->bi_blkg.
>>
>>     - submit_bio_noacct() (re)associates when a bio has no blkg yet or was
>>       remapped to a different queue.  blk_throtl_bio() and the rq_qos
>>       throttlers (iocost, iolatency) pair bio->bi_blkg with the queue of
>>       bio->bi_bdev, so a remapped bio must be reassociated to the new queue.
>>
>>     - bio_set_dev() no longer associates; instead it drops the existing blkg
>>       when the device changes, since that blkg is tied to the old queue.
>>       bio_init()/bio_reset() leave bi_blkg NULL.
>>
>> Introduce bio_disassociate_blkg() to drop a bio's blkg reference and use it
>> from bio_set_dev(), bio_uninit() and the bio freeing path, replacing their
>> open-coded blkg_put().
> Turns out bio will be submitted by kworker for some drivers and for
> blkcg_punt_bio_submit(). Is it possible to record blkcg during bio initialization,
> as blkcg must exist, and then covert it to blkg during submission? I can use union
> for blkcg and blkg to avoid new field in struct bio.

Since blkcg_punt_bio_submit() is the only deferred submission path, and it seems to
me that all of its callers (btrfs mostly) appear to be in sleepable context, would
it be sufficient to associate the blkg before punting the bio rather than changing the
bio lifetime semantics?

Thanks,
--Nilay
