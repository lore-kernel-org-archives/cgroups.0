Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC8A3A785C;
	Tue,  1 Sep 2026 02:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228377; cv=none; b=t7Uw+Zwd153oOJDp3VvIXkYm2DT+MS5DVk5Ig1kFwejP0d+3KWRvEDLi6HZwd7b4FMl4k0/VkT7qcK4fKXeHp5d8VctY4RnVkNznsMOlcrfkPo4P9GPDFzc0HEBhwrY1zmjTe8x57dJKOdmGCuoJEfONPo73EsdDOayoNlh5dy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228377; c=relaxed/simple;
	bh=y//G2hfrQusFIRZMpStTygTDFgIXFnHvdvwsiKyfwsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lv9Uo+Vggq1rX/j2ihcWS6JPdgPhqVCTxujalC/uPCm0pfqKpszzTk1ApQTT4NAkyIqsqWQOquEdjiniOTMPr2JetuIpS0ik2mvsrbmwIEOmXifP/zpl7zJgBskGe1pPnYuo3brZQ0zD23s4N1HHMElkpqayyz/vPEK2w2yFMFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pixYcPIp; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pixYcPIp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788228360; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ky50rSgY5tzco+q1f2XF8OoC/+HTORaE9naTNqUCG6g=;
	b=pixYcPIpGLwwBAEq+DOnsRyJRjlASLs0wn6aqBNv/PdoPQ2RIW6htjKBFt0CXr+gsJtPJnSRggP6vsGlgQeLFC20s9y96AQyEnbi4AcLqSIpPk9/mHZCEvTYPjgieCLPlM28+bv6qYQ3iwnFl4qe48dOCaWBdLypFOdJwmkoiII=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XA0imgg_1788228356;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XA0imgg_1788228356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 10:05:58 +0800
Message-ID: <07013ca0-a7bf-40ac-837d-e60e6b6b82d2@linux.alibaba.com>
Date: Tue, 1 Sep 2026 10:05:56 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/26 2:43 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
