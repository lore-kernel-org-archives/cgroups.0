Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593DA481220
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782996925; cv=none; b=lJxEwv2YInAJ5mg5SPFPtKYHibmQB/skdWyz9aqcA1D8GZsZn6sqegoOa5j4j0aYNVZU9Zfh0TOaUE+M2jJY76+0e+lvj/meCWxMmcKcBtOZ/0YVNbF1qVlezYwT6sbpF3fWNIkThFbhgfTVN4tBQpeOOLS4Jy6rIK8ncuVPtQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782996925; c=relaxed/simple;
	bh=FAFO4v0fDln5ZjUVgM+Swe9z3E2lBEIwmFoX2n388XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrV8YGV4R/4n4PWcK7NEXvnOq3kLmGuFftcPIsVE4CTEgYUegaglmD2h2mnVc4DMtaEhx+M+q0cXoWChu+Hquuuk6JeAZWc1Qbfn7JoIdGXOuscuHvWACUSo6zU+20NfDUE7f7t3Ez40jpx3s8gtJt4hDHNiqkF98/36c4WE21Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HYZ9Nznd; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HYZ9Nznd"
Message-ID: <358e9e58-77fb-465d-9b37-65b095ef8d2d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782996922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8j/wKAAoTtOSbtNtleH6sqMek38VvCHGbrwJb6lRs0A=;
	b=HYZ9NzndEDgCtbhQ9azierm+3GOA6f4ojPx7Z7g3G1NlPwL2fhtq2w0ExPorofqPY3BMrm
	5yfRf2CgZL/uV0Oq65XrImAaSHvL747PfSJC2eKlqcOS+xpTmShAdE7NW9XlWt63UszFIk
	K1tS4Mtzx8PqK9rCXLSG2kGn1Hnbcbk=
Date: Thu, 2 Jul 2026 20:55:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/4] memcg: bail out proactive reclaim when memcg is
 dying
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com, Zhou Yingfu <yingfu.zhou@shopee.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260702120235.376752-1-jiayuan.chen@linux.dev>
 <20260702120235.376752-4-jiayuan.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260702120235.376752-4-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 7/2/26 8:02 PM, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> Proactive reclaim via memory.reclaim can run for a long time - swap I/O
> or thrashing again dominating the latency - and delays cgroup removal in
> the same way.
>
> Mitigate this by stopping the reclaim once memcg_is_dying().
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>   mm/vmscan.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 754c5f5d716a..6ae61be2fab8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7912,6 +7912,10 @@ int user_proactive_reclaim(char *buf,
>   		if (signal_pending(current))
>   			return -EINTR;
>   
> +		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
> +		if (memcg && memcg_is_dying(memcg))
> +			return -EAGAIN;
> +
>   		/*
>   		 * This is the final attempt, drain percpu lru caches in the
>   		 * hope of introducing more evictable pages.



The issuse reported by Ai is benign:
https://sashiko.dev/#/patchset/20260702120235.376752-1-jiayuan.chen%40linux.dev

We have multiple break points to return in 
try_to_free_pages::do_try_to_free_pages
'''

     static unsigned long do_try_to_free_pages()
     {

         retry:
             do {

                 shrink_zones(zonelist, sc);

                 // break 1
                 if (sc->nr_reclaimed >= sc->nr_to_reclaim)
                     break;

             } while (--sc->priority >= 0); // at most 12 
times(DEF_PRIORITY)


             // break 2
             if (sc->nr_reclaimed)
                 return sc->nr_reclaimed;

             // retry twice logic
             ...
     }
'''

