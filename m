Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359EF207DF7
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 01:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783992017; cv=none; b=QMZGpQpT0NHZJkqTkC/p3GI1PqdPVP3TNIyZThG+IjyYOtcb3wTt7FNCoeyfTXguQQIxIF6wKWEfDbw5LzHWq4vy6L0NgZX0OEZA6+Kg95LXHQVBansbfn7LE6wsgii6qf9E9/xyu3Tsa502uv30OeHe+MjgacdiyYcWMdO2G3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783992017; c=relaxed/simple;
	bh=PkJdQaEDMEfonIw8EEkQse6zdo9BDrmz2jybU6BcgoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+06Lxfa4N1i45fpuNjOwGE109Gd+UKY+eGoaJCc1XInSM+xkqLHz8xOmn7nkfc5K2IrilXg8fezO/MEhjQ1srJKVznk+SSPJJTsI5rXftWqIahQlJSi951KdR7zHPIWFwm9DPiEHXgh25RaZdmQVTHWaRIiR2UuyPPHdDsf8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLPVtxei; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLPVtxei"
Message-ID: <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783992013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZctEu+mX1koEkj7iSspmtkQvsQ427myBTirKB+Ofv9Q=;
	b=aLPVtxeiDDTh4DfW/RDii/1ZK3BCZDRA8W8VefSwdDDRhy2veEza0ita+eFrzjWOY5Bk0U
	vLbN3hjYA6Wa1jSjTAKTmZn8V8wZFSNkQ3PzQuisAK1lml21UZjnDRdvQqr8v7DUdU0XZf
	mMwk10gxE/Gqd1uGn2LmMbIK2S+jeTg=
Date: Tue, 14 Jul 2026 09:19:53 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev>
 <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 7/13/2026 11:08 PM, Barry Song wrote:
> On Sat, Jul 11, 2026 at 5:12 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The per-memcg swappiness knob is v1-only; v2 always uses global
>> vm_swappiness and ignores the per-cgroup field.
>>
>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
>> to memcontrol.h where it belongs.
>>
>> No functional change for v1; v2-only kernels drop the unused field.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
> With some nits.
> 
>> ---
> [...]
>>          struct mem_cgroup_per_node *nodeinfo[];
>> @@ -365,6 +366,9 @@ enum objext_flags {
>>
>>   #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>>
>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>> +extern int vm_swappiness;
> 
> This is a bit unusual. I'm not sure whether mm/swap.h would be
> a more appropriate place for this.
> 
Thank you for your reply.

The vm_swappiness variable is not utilized within mm/swap.c. 
Furthermore, since memcontrol.h does not include swap.h, retaining the 
extern int vm_swappiness declaration in mm/swap.h will result in a 
compilation failure.

-- 
Best regards
Ridong

