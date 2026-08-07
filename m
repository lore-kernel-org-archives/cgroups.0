Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B6932B989;
	Fri,  7 Aug 2026 02:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068241; cv=none; b=SF73lpEb3Y5y6OW7l+rOpX1ud6YoHShkUCyB0GcFRT0bMVfUhPSyKbGOzymzc/yE5tZmUrH/6rS2NJiHlKMi61u8dRBhtCLPmTxcamiYqBaNRqh+gJhZpvQ/WE6dDUwa3euvgu3c5cSjbRYrt30hwhU0g29QU3sLIxEICAx/Jv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068241; c=relaxed/simple;
	bh=KbuKbjxtfbx7nHIESpKKjrp8cIwyehTn4lG0shfBhkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oc7rf+UWTB7eVzIXn7Zfef0MsJM1MMyyzPJRnvv9EptwPwaB/tyoBI63FmGMNStK04oskWJTUOAIwxp76ulZgn18cqXqcgSocSynNJi+oKT1hfKWHxnVg7n2tsp5DANyQa7Fn6VGnLNgGADrWKdCX79Q+jHCWgD2SAzrFI8XlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GJ6cQ2Q7; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GJ6cQ2Q7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786068235; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mRc+g7yreJ6m5qhGtIHjPhu/IwmVP+LPFazu5TXEzJ0=;
	b=GJ6cQ2Q7+GuUh+vBTs47q3E6De70ovgPiDi3efn9CWCr9u7bOG+/Amk6nPK0UmJzD+Tjb3eFATT+QBd6cehUc+DklHKnLIpdqEDvntBTkfMcHFMqzvd/LuW2oOE1ggI8QlnA9kBpmzQ+ctgdKjlviFX1bu9pm4lSaHjSxhW7zGM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X8VCyTA_1786068232;
Received: from 30.246.177.19(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8VCyTA_1786068232 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 10:03:53 +0800
Message-ID: <06cd88f2-8e2a-490f-804c-93c200bd294a@linux.alibaba.com>
Date: Fri, 7 Aug 2026 10:03:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/30/26 8:23 PM, Xueyuan Chen wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
> 
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
> 
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of the
> folio.
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
