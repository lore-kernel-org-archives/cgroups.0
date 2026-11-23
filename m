Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795412056;
	b=EvCzntsx9B1V7U3JdJfjLqPAt4tOQA0H2473+kMaYcuKKWdZuFmF9VRg5heJzS7lLINj
	 sX7jYVRct4OI0TE9l9jKIh9ZXcEqwXezIEOXHPel+IvBBDi893bakSunaFiUAz4kuBShu
	 3Cathylmud4Wg+ATO6Mo51ATAyCqZumyW++zyDT8h5puEeCvOhJOVsEvyX0K87PtOxlOb
	 GhKlZjiT9J3N8FXaAIDfwAsn+SyLZO36FMQnJgq8G13gFSJD8FVFjGIRO5uKyEH/IFooj
	 x4FD3bsnPaxN9/+te5Y5E6VB1tUXJgNjAcSOASYFLcqUpiCOITtFCRpmyYeV/9lNPyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795412056;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=u7MPjZZo0hHxOyF+FFh2sYC+ZGLhQqvq6JfBXoS+DHU=;
	b=XPsEXR30q3JhF6wQqX5egFZRgcYK6seUb776fC1WNcWo2KLUx+XcyVjga+QBzAIEoeJx
	 Ep7rEHBeD+j5BgDcvSoijuC4ryiH612qxFr70FnVJ7IVbRrveKqPvwjvv5GlPyE/v0nES
	 OYnxG9oTAQ5husyNyY0HsV6ITYR1YOtdET+oAN7ipxTjBAE67YE2c3aoWGrOOwGgT73qa
	 NOpIRn8dj9aQsUaNxoUEcwBWm3/vN0+uBuneDbO9b2SZA/4bDOKpsZgX4RXOEd+4q5b7v
	 xlL4+CVhewNCFE1+6DIRcmrapP/yns1goteMZidmGP8beGcimAByJlou91h4Q+SIDhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gdcVkuV+;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09166606A31E;
	Mon, 23 Nov 2026 05:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09166606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gdcVkuV+
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795412052; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u7MPjZZo0hHxOyF+FFh2sYC+ZGLhQqvq6JfBXoS+DHU=;
	b=gdcVkuV+3DHH00++vLPvcfOU9/Er/5PwK3hLEpHrssvO9L22UOb12OJcJ1dWNLUK+Hg6mnI+5QVwPK3+uD+jO25nZONZl/YVNSR1abefEAnWgds12P/z9Qy4fCYqEsoOstrze5DqcyAToSqlM+Iai3cu02DSK0q1opodBMmhrvY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XFDCfRs_1795412049;
Received: from 30.178.67.187(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFDCfRs_1795412049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 13:34:10 +0800
Message-ID: <b8b13d36-f732-4fca-bfbd-ece900d24ae2@linux.alibaba.com>
Date: Mon, 23 Nov 2026 13:34:08 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
 <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
 <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
 <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Andrew,

On 11/21/26 11:11 AM, Andrew Morton wrote:
> On Fri, 20 Nov 2026 15:04:37 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
> Yes, it sounds like ->css.id better matches the lifetime needs.  And
> the root memcg list_lru retains index=0?
> 

Yes. With this series, index 0 still selects the root memcg's per-node
list directly. Only non-root memcgs use memcg->css.id as the XArray
index.

>> The second finding is the same race that Shakeel's patch [1] addresses.
>> It predates this series: a folio can move to the root memcg between
>> the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
>> rechecks whether allocation is needed after taking the memcg reference.
>> That also prevents the unnecessary allocation at index 0 that Sashiko
>> flagged in v4.
>>
>> Does using the CSS ID for the list_lru index sound reasonable? I'd be
>> happy to incorporate any suggestions and send a v5.
> 
> Shakeel has a couple of related fixes in mm-usable ("mm: list_lru: fix
> NULL deref when a folio moves to the root memcg" and "mm: list_lru:
> don't use a new memcg's lists for an offline memcg") so please base on
> that.

Thanks, I'll rebase the series on top of Shakeel's two fixes and send v5.

Best regards,
Qinyun Tan
