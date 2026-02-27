Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3292355F4E
	for <cgroups@vger.kernel.org>; Fri, 27 Feb 2026 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772174112; cv=none; b=Ub2YrUOATUFyCBxSekK414Ooce3BZEquGOArVv4pP/pz2nxcZXIvQ3qJDN92Ae/HLCBrIm9N0hBKcu3SNrZPbYkc/Du7t8Y8W4tbXjiJJ4Et8bvTV8hfKr1fNy1tBvAOjfp48HEK/h2r29kH7qaa9NqPIr9LJ4gNYjQu1O+t9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772174112; c=relaxed/simple;
	bh=pOih4NMJhrgXSmR0kGJADvCPWA8DrzT62jKsA/SHb8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVWDnAFv4ERNRjoutuZXLWqCfTkGxo0U6vKFE8Z2Z90HMt1bmaKXyui2cyz8ddnoq4Fe7UK9fUTzjoCdqTs1C+WuhgUge0jAaxkwK90afzxBq3+1hlxSC1k721iz2/xtpUCaZHJnynC0qMgcvq0gB05ClSTx4XC9/IRUHFB2l9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oNbNFsGT; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oNbNFsGT"
Message-ID: <42d6bf96-21e8-4fb9-8ab9-5487d55a6969@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772174108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hREgDO/GK7fxVC17BP0cTvROrp7Ox8m3TEHSHQrQs4c=;
	b=oNbNFsGTVjpV6/ijMYJ698tZxULUU3RWR3ZSUopIVvclQd+ODAgTXTQF2HQ/R8Db/ytri0
	Q26gOTbCPNsPOXNXMP6CFMvTZu0Jvyaouz7i5nLZKwrGWkoKrn1f2sQiJ4Mdwx8VSMtZrJ
	UFp1KtBLBWFlpE/p6YeUxCbErwtvnaw=
Date: Fri, 27 Feb 2026 14:34:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev> <aaCmpSNRZU1wIYxq@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aaCmpSNRZU1wIYxq@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2/27/26 4:05 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>> folios later, we can hold the lru lock at the node level, thus avoiding
>> holding too many lru locks at once.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> changlog:
>>   - fix a missing root_obj_cgroup conversion and completely delete
>>     root_obj_cgroup.
>>
> 
> After this patch, do we care that page/folio/slab points to the objcg of the
> same node as them for a given memcg?

Maybe not. My only concern is whether the kernel has a way of
determining whether two folios belong to the same memcg by checking if
the objcg pointers are equal. If so, it needs to be changed to check if
objcg->memcg are equal.

> 

