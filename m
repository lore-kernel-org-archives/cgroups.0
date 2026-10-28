Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793151849;
	b=xIOdMbDeCfZBWVOdsU3xLlN0PMX795mVt8755HSTpn9wILKqMjj8sDIAVZE1xZX0Mxg1
	 J9k/XvxnifH9KP2+7al6QZCTzo3xUhobUuwNWbM6ZphfvkwnTKOpxQzMN9Y4NHhdnUzLX
	 CO1YwNemZSTABZTBhpONG79X7aq7zjDPqbWi1Tg+VIyigIoYwXDcFLo7K7NX3YrQPYxHl
	 jGEQOI6Q8zJOl4oGGfgjbX+/KjttBmVlj21SjLf6hmmVSXaBNyAhO1FasJGP5CK2sSRb+
	 IeBnpc0QnPO2ZLIJJZ/aff5LhxUHniAw67eP7UjdbkiQ5Q2UKUSH7NpjyauBHKRwGAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793151849;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=p1Yu6N42P3Y33cQOaPOhdbLQI9uq3/XR1N32rLOEFTg=;
	b=k11izktz/SaUa6N1shV9e3I8ZKx1lRUhcwCP7Th8FaxZeAB83YPCjeugk7PVu9mFmV7v
	 8xzck1IlzVlJFl20w0dvpPHH1WzAAkWcwBM6d9KpqWxwbjUOGWzSTqGjNtBY/i5Mw7oYj
	 R1Zw2JXi3G+N11M7/63ofgc7ckCbAEJSvx9eoiHuhR11r/kdhLedq4sqZoX/bAIg9xwAP
	 xihUxU2cfr433Q2BcWjyQzchtQPqdPU0wtVDFX7gEj8gyKsCAMxu8BS7yKanG39dGHvNx
	 h3z3O1eiUSv/Ji69+NEwGVHFoYbtWD0dpugSXsnmx9igz39Q9Nb4TOgulh8MWlS00fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RAAXiMn6;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F313606A31A;
	Wed, 28 Oct 2026 01:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F313606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RAAXiMn6
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793151845; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p1Yu6N42P3Y33cQOaPOhdbLQI9uq3/XR1N32rLOEFTg=;
	b=RAAXiMn6qP/RV192I7TMssizvmDGYJMtx7aLr+jFH6U4SYlci7vG1qaDZA6SzSKt7F9hkPiNTW7xaRXrRSZZq/mnMsu5W8YlPfLiMyC0bIHE76skswcBfp/BsK+S435rnH/j3sornKoUGRhPnqUCRv//ee9hcj0zDTXESEv/8+E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDfI.uG_1793151834;
Received: from 30.178.68.22(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XDfI.uG_1793151834 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 09:44:03 +0800
Message-ID: <00410d2d-c082-4ef3-9eb7-7d7b5d3ba964@linux.alibaba.com>
Date: Wed, 28 Oct 2026 09:43:53 +0800
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
Subject: Re: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, david@kernel.org, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
 <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
 <4C44AE80-1642-4808-ACF2-896E4B84EEAA@nvidia.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <4C44AE80-1642-4808-ACF2-896E4B84EEAA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Zi Yan,

On 10/27/26 11:04 PM, Zi Yan wrote:
> On 26 Oct 2026, at 2:26, Qinyun Tan wrote:
> 
> People are currently busy with reviewing various mm fixes[1][2].
> Hopefully we will come back to this after the merge window closes.
> 
> [1] https://lore.kernel.org/all/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org/
> [2] https://lore.kernel.org/all/20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org/
> 

Thanks for letting me know, and thanks for taking the time to reply. 

I'm happy to wait until after the merge window. Please let me know 
if you have any feedback when you get a chance.

Best,
Qinyun Tan
