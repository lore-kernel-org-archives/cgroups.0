Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786366;
	b=JkqwTdnzdBfSDtaNQjuAVs1mYke+rqK0ixpM/hTBdVyKT6wLcgWfD/GKKBe+OPAt99N+
	 F3VdUk+sB/232FieoK5LFAe1jG8S3BZnMnlp3UwWqqSLGoPbEsWYizqCAolHpxUL94YpV
	 5740v+roCoSEQJSKtes7VmPjuLKc0l6KmyeyI8GpI5PbVQds9xv3Lv22P3jK9mQEUxhD9
	 tYzywsSomT6WSYi+cMxTtCilep7DyUJIwpK3/lw8jhedVi08osihbBoIx2ho6nuY2Jo3p
	 pXXVT8jdH+Wcv9WNbGmQD2qOpHb4aWi5iOpvfRgX6qyZ/H1qiNDoNGaBEEA2VzoyHsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786366;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:Subject:To:Cc:References:
	 From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=odiS2BD1Oni7cgdjx86LxslpSgo1Mv9bXgCCqdS0J5o=;
	b=NiV446QoMW3FhOyGjVtSvIylpnOuhyeVLLk/B/IQJ5old6JCIve49D61Smo/nNPz+y5L
	 svgSJAHoKaNCKe/GhQQm18KNVkv/qNuJRPtOD6cdtyRWkiTN84AfGWvOc2cacb32j4xjV
	 TBVbfYA10nKn4/m42IqR2dlDBgrH8fzOBPrUQmr491EAL9utU1WCQk8brNMizKcUPZHXJ
	 AgYA7gvFecJrkRfeAyxT5HoFGiHLASNePN9rGnEC2k6+laTUrK+A/mxTlYaUKyUmNR+h2
	 +CrjuqelltZvYHNB80VfOHLlvmFMJSXtKnttDQ5XUhK285u1HPD0/sJbD898WYhWsGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=open-hieco.net;
	spf=pass smtp.mailfrom=open-hieco.net;
	arc=none smtp.remote-ip=115.124.28.172
Received: from out28-172.mail.aliyun.com (out28-172.mail.aliyun.com [115.124.28.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8861C606A32E;
	Wed,  4 Nov 2026 09:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8861C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=open-hieco.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=open-hieco.net
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08323395|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0105379-0.000473118-0.988989;FP=16549416186597666154|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033025068124;MF=likunyu@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.jwaRWX3_1793786352;
Received: from 172.18.25.145(mailfrom:likunyu@open-hieco.net fp:SMTPD_---.jwaRWX3_1793786352 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 17:59:13 +0800
Subject: Re: [PATCH 0/2] block: Add done_split_bio() for chained bio
 post-processing
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261030065945.88742-1-likunyu@open-hieco.net>
 <aum31_1jjv7OROxl@infradead.org>
From: Li kunyu <likunyu@open-hieco.net>
Message-ID: <d4cdf3de-4fca-fce3-2f16-03746a95ae71@open-hieco.net>
Date: Wed, 4 Nov 2026 17:59:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <aum31_1jjv7OROxl@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 2026/11/3 18:30, Christoph Hellwig wrote:
> On Fri, Oct 30, 2026 at 02:59:43PM +0800, Li kunyu wrote:
>> patch 1:  Introduce a new abstract function 'done_split_bio' and call it
>> from bio_remaining_done to resolve this issue.
>>
>> patch 2: Implement the blkcg_iolatency_done_split_bio callback in
>> blk-iolatency to correctly decrement the inflight count when the other
>> bio headers, which have not called rq_qos_done_bio(bio), complete.
> Why are you not simplify calling rq_qos_done_bio before
> bio_remaining_done?  __bi_remaining is only incremented for clones of
> various types, and the qos processing should probably happen before
> calling back into the submitter anyway.
> 
> As far as I can tell all the code here is duplicating the existing
> done code without much of an explanation of why we need another copy.
> 
> While we're at, the existing code in rq_qos_done_bio added in commit
> aa1b46dcdc7b ("block: fix rq-qos breakage from skipping rq_qos_done_bio()")
> is extremly wrong and dangerous.  Once a bio completes, bi_bdev
> is invalid, the driver could have even used it for something that is not
> a block device like md raid5 does, but it certainly does not have any
> use for the qos/iocost code.  So it really needs to derive anything
> it needs to I/O processing from the bio itself.


I identified this issue in the blk-iolatency framework under the QoS model: the
inflight accounting for split bios is incorrect. Specifically, inflight I/Os are
accumulated in the throttle function across the entire bio chain, whereas the
done_bio function subtracts only a portion of the head bio and child bios.

This patch may still have some issues; no anomalies were observed during testing
or in the scenarios exercised so far. For example, this submission adds the line
bio_clear_flag(bio, BIO_QOS_CHAIN_CHILD);.

I will continue to analyze whether a more appropriate fix can be found.

Thanks for the suggestion.

-- 
thanks,
kunyu
