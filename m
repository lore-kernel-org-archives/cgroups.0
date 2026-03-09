Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4118392C3A
	for <cgroups@vger.kernel.org>; Mon,  9 Mar 2026 11:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773056646; cv=none; b=D/w3EcOiwC/NDooLB/m76Uus+rDJo0U/+Xup9s1suEMeQ3niOY5y7ThDJ77T37jzfA4ZIXSdgAlLZPPSwjhQceG8JZgxeqYaVspeaUXqLw5YVKdy2f8V/YsNacQEKkF9aJfh9fhy3nrmSs55hNkZxHEQnvRy0qILNdXbiLY8tGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773056646; c=relaxed/simple;
	bh=l7gUV/GtCaK8hjPlhe/MMllA2DGVZDYh+bnbSP02De4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLLbX1HmwRHhBIIi5Cu65c5Jj48HxP/oWfObV1i8607hUU7sOehajm6maqbd86m0IQSZ15qla8zmSlBRnfVIYAMSTE53ubVWOi2dMLW5VQUT7ZFucWqNWR4Mh04Zu3cnX4Q33taJYxH7WfBdfG5tmDyWkpYLJeNxlOmfJNdgMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kgv5Xmfz; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kgv5Xmfz"
Message-ID: <4861098d-62d9-4722-bf46-c8002e2df1dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773056642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tfeLhUszPMJByDj4ltEH4Kppb4DyMf4gLg0eSgVQYTw=;
	b=kgv5XmfzLxaR6xQcH0UHgdoYuX7w2Ho7rpaECeoSQ45gJv5zLotJuzRzMZitICfTSAeTnI
	E1dG6BQDQXHwhv3IorfYuyMDvMJqGglzdtOofFEbuvhXEKLz793KcyxpqiED37B+MgE7uw
	u7lTUlSlYuZMYaAhyMrLphU/ZjYHmDc=
Date: Mon, 9 Mar 2026 19:43:45 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg
 per-node type
To: Usama Arif <usama.arif@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
 <20260309112939.31937-1-qi.zheng@linux.dev>
 <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 3/9/26 7:33 PM, Usama Arif wrote:
> 
> 
> On 09/03/2026 14:29, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
>> from being called agagin in __mem_cgroup_free().
>>
>> Reported-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/memcontrol.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 992a3f5caa62b..ad32639ea5959 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>>   	for_each_node(nid) {
>>   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>>   
>> -		if (pn && pn->orig_objcg)
>> +		if (pn && pn->orig_objcg) {
>>   			obj_cgroup_put(pn->orig_objcg);
>> +			/*
>> +			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
>> +			 * from being called agagin in __mem_cgroup_free().
> 
> nit: s/agagin/again/

Ouch, my bad.

Hi Andrew, can you help squash the following diff:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ad32639ea5959..5fcbb651846a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4144,7 +4144,7 @@ static int mem_cgroup_css_online(struct 
cgroup_subsys_state *css)
                         obj_cgroup_put(pn->orig_objcg);
                         /*
                          * Reset pn->orig_objcg to NULL to prevent 
obj_cgroup_put()
-                        * from being called agagin in __mem_cgroup_free().
+                        * from being called again in __mem_cgroup_free().
                          */
                         pn->orig_objcg = NULL;
                 }

> 
> Apart from the nit.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks!

> 
>> +			 */
>> +			pn->orig_objcg = NULL;
>> +		}
>>   	}
>>   	free_shrinker_info(memcg);
>>   offline_kmem:
> 

