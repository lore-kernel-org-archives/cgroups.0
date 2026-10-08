Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E612473C8D;
	Thu,  8 Oct 2026 09:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453393; cv=none; b=lyqNbOKmg2UAKAytaqGx/vkTbjTT1p4fXk3NBuEXuSR9sXf+rlzkCFuPJOlT1WgCfVux7XthqzwTpV4+OJEtyDg7EraeM6vU+C15tdEzavEXsh3UjtRLH0PoHYf88dP8Li97+0cxWPF15XbuzoWo1wiV0iT+Am+Fc2ELswleaxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453393; c=relaxed/simple;
	bh=K0gbxcm9SeCvMVubTKD3WBG9xjKGjsIfg9dh8O6d4bs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTJER9Z7xpr9mJM3CMqrlrUWjc47DYCFex/SiKbwtE8V8miqPBGXm05lMmOmKncUYS1H2yJluwcdLSUwYxe9c/X97zJti73XZ99Dv2nmjymxLOui4I8fY8+l28ZOrcNj3/5nKamqhe8UIJ48SRMeuujjXJztTWVtOIpKasL9LUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qosuhYuT; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qosuhYuT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791453388; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1c2mwR8cYOL6Ygo+f93Zr8TE7ypOMqMWTVG83TPWuJk=;
	b=qosuhYuTCUuIwQSvuCvypkcKYlu3raUTgpk6+ZCaMm+Rg552Vbhb/V+pyCmtXDmkyz0wtI71+wmkuf8qrQGZWKju0gsEoBr0ughIhSpV/0APDQcbnc5NKHAm0vtUF2UyAOiVxVMX/jVUSFm/dRn5QsP+tU8fI4eXswyldYZsnMI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XCO8HAT_1791453384;
Received: from 30.178.85.189(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCO8HAT_1791453384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 17:56:26 +0800
Message-ID: <776ea9bf-88db-44d5-a80e-eaa958294bab@linux.alibaba.com>
Date: Thu, 8 Oct 2026 17:56:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
 <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, Gregory

On 9/23/26 11:45 AM, Gregory Price wrote:
> On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
>> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
>> and is only used as the list_lru xarray index.  With
>> cgroup.memory=nokmem the assignment never happens, so every memcg
>> resolves to the per-node lists.  The next patch needs the index to
>> work under nokmem as well, so drop the copy and use the memcg ID.
>>
>> The ID works just as well as the copy did: root and NULL still
>> return -1 and use the per-node lists, and the ID is only released
>> after the list_lru reparenting, so a stale or recycled ID can never
>> reach a live list_lru entry.
>>
>> The early return of memcg_offline_kmem() under nokmem is dropped as
>> well, so the reparenting also covers lrus that stay memcg aware
>> without kmem accounting.
>>
>> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> 
> This breaks an assert in memcg_struct_check - i think you want to drop
> this line as well
> 
> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5d7a26c91610..fcba9eb55659 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5886,8 +5886,6 @@ static void __init memcg_struct_check(void)
>  				      private_id_objcg);
>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>  				      private_id);
> -	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
> -				      kmemcg_id);
>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>  				      oom_group);
>  

Good catch, thanks!  I missed the layout assertion when removing the
field.

Andrew spotted the same issue in v3 as well.  I will fold the fix in
when I send out the next revision.

Thanks for taking a look at the series!
 
Qinyun Tan
