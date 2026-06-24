Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633A138A73F
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 06:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284171; cv=none; b=lJYu4B4we9QBGCSoLu0niGnriTqwe07KUYHKcHtuWUBQuR3omBzZJLnmhC1Guqx21sbtgHmpDshEnZr1OzxVYrH3C1dWZI62tQwp+l/A6d/Jws51uC/X+wnrfYbBpTRvtYq/QnCETa3/pwkvhrXRyr1Ms8z6yV2NpJXB4zV3zGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284171; c=relaxed/simple;
	bh=XvCPrJWKdLdlYov3Sh7q1/9+eldMQc6A62fSz0sYeVI=;
	h=From:Subject:To:References:In-Reply-To:Content-Type:Cc:Date:
	 Message-Id:Mime-Version; b=LDmk7eDQdwQk+2OmQ+7tyfc700EtLNs3IIA82chR73ZEFE0H1ZDEe2MH2Rs9gnEQLErTMjgZcorJk1ppILM23okX6PFc4gy9B+QWQu4BIEtQujtR8B7bHVWmhK1Bz2pk2yfi0MMU0iF3TKw+aeWhmqJkaWkg1AkoAE7fkBSdhJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=nqHx9nB6; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="nqHx9nB6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782284165;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2n4xYMnOuMUY1cMr3fiqxiefs2pC62hsUTAG2Mk/2QU=;
 b=nqHx9nB63nR2AZAdZxqy9gHsxFaroRQxoRGQXge6wAKC5R/QoQxQX2Ll2eXQ3XElp2W2zE
 minU8LrUPIEOCyjGVgqPLuoVz2zFSNZMyjRUBYIzp1gtp6QAuKUzfa7ihg/NanbJR7cdxt
 rmPAaxLgcRAPkGZtWDOMmI61f25hTNQzOrzo/VRQ8Y1bsi39usZ1rM3Rbw/Ckee0D03KPj
 CKTbCFcGTdzje3fNOJ13sGG8bgsbJKGmNTiMfRRC86EK/7IvW+j5cegGsje8FvUl5LRL7f
 CvwqkAT2pQMizWPdmi5QmbQWoAF7Do8vbKZEsE/Hf+dMoTiE6Xx379MDEFNtMw==
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 1/2] md/linear: add fault-tolerant mode for unraid-like setups
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Wed, 24 Jun 2026 06:56:03 +0000
X-Lms-Return-Path: <lba+26a3b7f84+f5c9df+vger.kernel.org+yukuai@fygo.io>
To: "Yu Kuai" <yukuai@kernel.org>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Jens Axboe" <axboe@kernel.dk>
References: <20260624064625.1743650-1-yukuai@kernel.org>
In-Reply-To: <20260624064625.1743650-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: "Zheng Qixing" <zhengqixing@huawei.com>, 
	"Christoph Hellwig" <hch@lst.de>, "Tang Yizhou" <yizhou.tang@shopee.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Ming Lei" <ming.lei@redhat.com>, 
	<cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fygo.io>
Date: Wed, 24 Jun 2026 14:55:58 +0800
Message-Id: <fdd769ae-5854-41cd-a7ff-5cfa888b9a13@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

Please ignore this patch, this patch is supposed only used downstream.
Ai somehow generate the cmd to send it together with the patchset:

blk-cgroup: fix blkg list and policy data races

Same for the other ext4 patch.

Sorry for the noise. :(

=E5=9C=A8 2026/6/24 14:46, Yu Kuai =E5=86=99=E9=81=93:
> From: Yu Kuai<yukuai@fnnas.com>
>
> Add a module parameter 'fault_tolerant' that changes how md-linear
> handles disk failures. When enabled:
>
> - Disk failures are isolated instead of failing the entire array
> - I/O to failed disks returns -EIO while healthy disks continue
> - The array remains operational with reduced capacity
> - Failed disk count is tracked and shown in /proc/mdstat
>
> This enables unraid-like functionality where individual disk failures
> don't bring down the entire array, allowing continued access to data
> on healthy disks.
>
> The fault_tolerant parameter can be set at module load time or
> dynamically via /sys/module/md_linear/parameters/fault_tolerant.
>
> Signed-off-by: Yu Kuai<yukuai@fnnas.com>
> ---
>   drivers/md/md-linear.c | 63 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 55 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c

--=20
Thanks,
Kuai
