Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DBB381EA3;
	Fri, 17 Jul 2026 19:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315600; cv=none; b=egL660SrZXEuIsLpFnWzSdvBpzPdlZng9px8rK1uHxRSU+47Hbwo7EKJh+nHHwW3VRB/0k4dzHdrE4BL8lWGpcPvryTm/L/Zs8INPTr2Yx0B0Qjh4rQsmWveCUUeSdRsFazQmz4ka98zOzOECZ/BcYTit64hLTMlQyOzLsCIKSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315600; c=relaxed/simple;
	bh=QmLE8pA16iwvkESsKuDi/Klu9rtgOqVX7vI60wepmqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wrun69+jYncRlo+uUDJj5dDe4DWWPCNgmmyfBXy4bvQ0E+pQHPfh9Rdu4OXB7e+BTCnA+Er7kmRC+NEf07y7qiq6YUZ2J0gL9k9kvnLoupP+l5NmEDWLDLzAkWyPjed3KSwVB78iLPJ85wyHeI508cY+wX3Y4DzQPsbVLhKye20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fdBaiNGG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fdBaiNGG"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HHC7Ka2614668;
	Fri, 17 Jul 2026 19:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=89syRl
	J5f4RK2+c7tG9GpAaWSoEXbJLopmcI9DrtT/U=; b=fdBaiNGG7XZZAsG80ct/Cv
	Rj9WKL4P0I5LixUez6dRnGyWWJ7f6qoIc+WsUsUBVLmOUYVpUBMd7GlaCEKjYM1/
	cAISyCWZHv5BwOL1ifokD4bGa5OKiIasYS4DTzQQa2fIFCcuEP2FM7W3J2cIJqeC
	/XEDVP4GbRRiTEqrT/WXj3Lp88VPkjKIRzpLLhHv+sim0DaBdldOnPOcWspa4T38
	BkheyhLFbpafLcxWcOkayh2PcPkx8NcprfXliAAhrq29c9iCCT4/K2BLn84NoKCs
	VTW7ntRTYvRLOfmEB9eAK+gsFMz6oWN/u+r737IBSk7SJw9/nEhXY2gAZFgSnWHA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegc70p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 19:12:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HJ4aCZ010039;
	Fri, 17 Jul 2026 19:12:17 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc1nhtyk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 19:12:17 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HJCHoU57737610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 19:12:17 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDEA258055;
	Fri, 17 Jul 2026 19:12:16 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1255758043;
	Fri, 17 Jul 2026 19:12:10 +0000 (GMT)
Received: from [9.43.55.154] (unknown [9.43.55.154])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jul 2026 19:12:09 +0000 (GMT)
Message-ID: <6baae2af-640e-48bd-9909-977cd316c8d5@linux.ibm.com>
Date: Sat, 18 Jul 2026 00:42:08 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 01/17] nvme-multipath: retarget failedover bios
 from requeue work
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Alasdair Kergon <agk@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
        Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>,
        Josef Bacik <josef@toxicpanda.com>, Yu Kuai <yukuai@fygo.io>,
        linux-block@vger.kernel.org, cgroups@vger.kernel.org,
        linux-nvme@lists.infradead.org, dm-devel@lists.linux.dev,
        linux-bcache@vger.kernel.org
References: <20260704195124.1375075-1-yukuai@kernel.org>
 <20260704195124.1375075-2-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260704195124.1375075-2-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fOcJG5ae c=1 sm=1 tr=0 ts=6a5a7e92 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=wsQ0yCsUK8wXSUUBpyMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE5NiBTYWx0ZWRfX7GLK2X+oF4UK
 iJeThXVkVapenyQ1sH1yQzUwapeLUMHpI0huFWOiHtJfQNJGfI1AW9PqYDCDJaalWjLAb5fPOLi
 rObNeXLBOt23K3q1VQphIm/q44BHhUb9tYA9yJ+jGMcMoxH546Qrp45+rZ9OWW8bOIV28gOnzf8
 YgqxtHlNjs7EY8LYjgAz+w66QLqDLzNJRWLr3bU7ynTQdHWaMF+Rkzoo4jx2tSCcl/6BwzxuJAL
 2cKIAIrg1RbOmDJqWsbBrZTxCYTe3hXA/nWJpCOFre1tVC80M4KK457ZHB65LrwjL+HtcCTA45l
 dy7OS19z1Md04qd8NHRRFI+S3gEtVTPbXBB6IAtwJ0evAH48I8RQQBAsRfnayc1UQ3VW6qZ3IAa
 K/uOHo/6hE9GO6Ge/WtkDU1Ihthtt2FYikg6ANYHtALL0Nm7Cop0K3ps9nDTseCQvXPyu/Mjmkr
 VqllyeAwrX0XtQN112w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE5NiBTYWx0ZWRfX3W6AXglZxwK2
 ueNSOqrmJUmdULiSN5cujIrGd1QIfi3DG8VyU8jYE1kNRBV1DK8ufGsGy4tT9OWcTt+Ji7SZxpY
 Q1H/NhS0jSlO20cMPivcrWp3EeohKfM=
X-Proofpoint-GUID: qvRav-GNQoR5chPggKb6TgLJfY8amvqg
X-Proofpoint-ORIG-GUID: ya_YvUqv2298obSTDavdmuJY0HegvuO_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170196

On 7/5/26 1:21 AM, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> bio_set_dev() is about to become explicitly sleepable because it can
> associate the bio with a blkg for the destination queue.  NVMe failover
> can run from request completion context, and nvme_failover_req() also holds
> head->requeue_lock with interrupts disabled while it steals bios from the
> failed request.  Calling bio_set_dev() there is not safe once the helper is
> allowed to sleep.
> 
> The requeue lock only protects head->requeue_list.  Keep the list
> manipulation under that lock, but defer retargeting to nvme_requeue_work(),
> which already drains the list from process context before resubmitting each
> bio.  The bios remain private to the requeue list until the worker pops
> them, so moving the device switch there preserves the existing retry flow
> while avoiding a sleepable helper in completion context.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>   drivers/nvme/host/multipath.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 9b9a657fa330..76baa180ae1c 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -149,7 +149,6 @@ void nvme_failover_req(struct request *req)
>   	struct nvme_ns *ns = req->q->queuedata;
>   	u16 status = nvme_req(req)->status & NVME_SCT_SC_MASK;
>   	unsigned long flags;
> -	struct bio *bio;
>   
>   	nvme_mpath_clear_current_path(ns);
>   	atomic_long_inc(&ns->failover);
> @@ -165,8 +164,6 @@ void nvme_failover_req(struct request *req)
>   	}
>   
>   	spin_lock_irqsave(&ns->head->requeue_lock, flags);
> -	for (bio = req->bio; bio; bio = bio->bi_next)
> -		bio_set_dev(bio, ns->head->disk->part0);
>   	blk_steal_bios(&ns->head->requeue_list, req);
>   	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
>   
> @@ -684,6 +681,7 @@ static void nvme_requeue_work(struct work_struct *work)
>   		next = bio->bi_next;
>   		bio->bi_next = NULL;
>   
> +		bio_set_dev(bio, head->disk->part0);
>   		submit_bio_noacct(bio);

What happens if bio_set_dev() fails to associate a blkg? From what
I understand, bio_associate_blkg() may fail, leaving bio->bi_blkg
set to NULL. Later, submit_bio_noacct() can invoke blkcg-related
helpers such as blk_should_throtl(), which expect a valid bio->bi_blkg.
However if bio->bi_blkg is NULL then accessing it without NULL check
could crash the kernel. This is probably not a bug introduced with your
changes, but you may want to check it.

The question is, is bio_associate_blkg() guaranteed never to fail, or
should the failure be handled explicitly before the bio is resubmitted?

I also skimmed through the rest of the series. However, as Christoph
mentioned in an earlier thread, we may be moving away from non-blocking
blkg allocation altogether. If that's the direction we're taking, this
series will likely need to be reworked. I'd therefore prefer to wait for
the next revision before reviewing the other patches.

Thanks,
--Nilay

