Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F98D30E83F;
	Thu,  4 Jun 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780594296; cv=none; b=omMYJUugLOs7u3bIGMIzKBNBxN+BlAGB60TrDLsx1Ts84Qcfse4ZLLE0USn8y9YVFDjz2hFQhc0N8ZX5q7QkS/zy6xuqeTaiFsK3J6t+WnJr6thhl37iYiW9D9zL9y+E7j4lsrWBYZzb5KIX6//qRPxVCDCXILj8bOVqJYv/qTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780594296; c=relaxed/simple;
	bh=d9u1PCQR+M85R31RCveXCge0/Ovp24iqbZ380wHETNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfdiZ2Rs9OjPPbsmgO/XodrN3gTJvx9Ni61YXSCOf5XwH21ZEItPV+VmjNy4mLlH+K9nsm88zw7fEUhXTVf1vOfsanNWdDwUTJie5liGK1F1bHrVXoeWp6u+vGT7oFEoPlAKfTTw6eZDUtgSNivJtfi4/qPbDaJ7TOX6AbaQROM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IvaX1YOc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IvaX1YOc"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 654CF9KZ2350781;
	Thu, 4 Jun 2026 17:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Sqtrv1
	HLncVpqCeh0gffwOsf7Xjy7CA1MvVl6+RM994=; b=IvaX1YOc+Yn0NTUbNW5y1+
	1OTeDM5+rli0qcqokMZ5sK/dIqtu4FFgONqSqYtXZtcN8BinBVk9hpE5g9ENRbqY
	6W/hLHXCtFqlzmcsFN8kyW8FmsOCpthYmpKZclYLfDZ9faIi/Jo2XNM2AOMLtYe2
	vfiQCB/rLjnoCkTX+CEMeAf/ga4kJwP0isii+UDXIvXiK+/z7dFGdD53Npxa3ULm
	socNUJrKWX6XYFGfs52TWSF2RH5kkP1ZMibwdNzZTXq+kf8gl5BmjoyhPnxblb1n
	lZJUkXPGMCskTqascyYMQIm1nf6nqAz/i0TWyECajfnir+UJwUeQCVrh61COGtlQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqjqgyfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jun 2026 17:31:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 654H982v032112;
	Thu, 4 Jun 2026 17:31:20 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egbqhp1mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jun 2026 17:31:20 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 654HUnko27656794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Jun 2026 17:30:49 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F317B5805F;
	Thu,  4 Jun 2026 17:31:19 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 927DC58054;
	Thu,  4 Jun 2026 17:31:16 +0000 (GMT)
Received: from [9.43.126.215] (unknown [9.43.126.215])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Jun 2026 17:31:16 +0000 (GMT)
Message-ID: <a532857a-16d5-4bef-bbd1-3bc080363182@linux.ibm.com>
Date: Thu, 4 Jun 2026 23:01:14 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] bfq: protect q->blkg_list iteration in
 bfq_end_wr_async() with blkcg_mutex
To: Yu Kuai <yukuai@fygo.io>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Ming Lei <tom.leiming@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1780492756.git.yukuai@fygo.io>
 <89f9448c5d703e6123e1be6c8e0550c803e9c057.1780492756.git.yukuai@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <89f9448c5d703e6123e1be6c8e0550c803e9c057.1780492756.git.yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: hiKst0lvAOY567uN215Kf3pFY4SLlMWO
X-Proofpoint-GUID: VHo71Z2V2jTWbbPMRkA3Mj1XWenmAV1O
X-Authority-Analysis: v=2.4 cv=bcVbluPB c=1 sm=1 tr=0 ts=6a21b669 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=s_VrgGc-5Bb3jsANsSIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDE2NyBTYWx0ZWRfXyijdz3S37lfI
 01+mfbUgHiiMcrStRQyChzwlHt5702iNRGY3kkT3QaK+2oUZBvULNNDx8Re/KP5wtDlUhM0HRgz
 rt/VTIFUGx/VSFFUVLyfptAJFiR7414uc4BsebQet2Q/fE2gWXMvW1rZRX1CczY2KuIxK2QLTPF
 OD2yK7HscLYrVEyA5TilzB2E93xYxozCITATc4enLPaw6QsWgdNoyXBY79C0t3c3fcyDNKneAD3
 8TfErAp7AUPslt54d9jHJiSO9zuA40LubescXv3geTs7z5h0hgr9zoWGs88YNWmNhHT7Ioi4wA+
 Z98FlVCAd1q+DPScEFoFKhmDZeNvYFC/PtqDer9fVVtjcczF2ClV5bmDMrXzaXJFDOfGMM5pFbt
 G4PZYGhHMrnts1f4hWpYKwBe2LKugLhQxJAoZjXdstdRL/CoDGeyqYBfQJ2XzcRml6NhJeF+MRG
 ixKAWowK7xJeWwKNbmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_05,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606040167

On 6/3/26 6:57 PM, Yu Kuai wrote:
> bfq_end_wr_async() iterates q->blkg_list while only holding bfqd->lock,
> but not blkcg_mutex. This can race with blkg_free_workfn() that removes
> blkgs from the list while holding blkcg_mutex.
> 
> Add blkcg_mutex protection in bfq_end_wr() before taking bfqd->lock to
> ensure proper synchronization when iterating q->blkg_list.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>   block/bfq-cgroup.c  | 3 ++-
>   block/bfq-iosched.c | 6 ++++++
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 37ab70930c8d..f765e767d36a 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -939,11 +939,12 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
>   	struct blkcg_gq *blkg;
>   
>   	list_for_each_entry(blkg, &bfqd->queue->blkg_list, q_node) {
>   		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
>   
> -		bfq_end_wr_async_queues(bfqd, bfqg);
> +		if (bfqg)
> +			bfq_end_wr_async_queues(bfqd, bfqg);
>   	}
>   	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
>   }
>   
>   static int bfq_io_show_weight_legacy(struct seq_file *sf, void *v)
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 141c602d5e85..42ccfd0c6140 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -2643,10 +2643,13 @@ void bfq_end_wr_async_queues(struct bfq_data *bfqd,
>   static void bfq_end_wr(struct bfq_data *bfqd)
>   {
>   	struct bfq_queue *bfqq;
>   	int i;
>   
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	mutex_lock(&bfqd->queue->blkcg_mutex);
> +#endif
>   	spin_lock_irq(&bfqd->lock);
>   
>   	for (i = 0; i < bfqd->num_actuators; i++) {
>   		list_for_each_entry(bfqq, &bfqd->active_list[i], bfqq_list)
>   			bfq_bfqq_end_wr(bfqq);
> @@ -2654,10 +2657,13 @@ static void bfq_end_wr(struct bfq_data *bfqd)
>   	list_for_each_entry(bfqq, &bfqd->idle_list, bfqq_list)
>   		bfq_bfqq_end_wr(bfqq);
>   	bfq_end_wr_async(bfqd);
>   
>   	spin_unlock_irq(&bfqd->lock);
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	mutex_unlock(&bfqd->queue->blkcg_mutex);
> +#endif
>   }

The above change protects the q->blkg_list iteration in bfq_end_wr_async()
against list removal in blkg_free_workfn(). However the blkg insertion in
blkg_create() still doesn't use q->blkcg_mutex and so list traversal in
bfq_end_wr_async() may still race with blkg_create().

So I think we may also need to protect blkg insert in blkg_create() using
q->blkcg_mutex.

Thanks,
--Nilay
