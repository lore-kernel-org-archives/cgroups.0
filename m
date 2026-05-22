Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED4925B09F
	for <cgroups@vger.kernel.org>; Fri, 22 May 2026 02:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779416870; cv=none; b=BGaai08hAspdzBSLZvAbvDmC5eL7NepHfexZS9ZPQEXLd7Lyj9G82Zs0C+MSUYQJAYfy9jqAwwLdpcTzNCgbU3bpVuaqqldHGQ3lRTf56nRT0spJpl38Y9ZyQcszZlzGTkz0EdRN6wzhuHwv6Yq6KWKoUKnl8WGuEaRb/NOrLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779416870; c=relaxed/simple;
	bh=DhpVESDQBgXXw+wOLddAcOF5ND6kknaupEmYWCM3y00=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhv7Jl+Cl6D+1VoRQV37/A05eu3b46iQju7rEGTujWsxmepJqrkkvLI03uTBMJxZyWQ56s0P4tfl8eUne8His4DY0tVfMpaW5pUq7wY1xHkviPZsjKSWRGfDFuDnGE3AdQ34kDa91UU4XDwIb7X0R44O/FAk0d942K0QrW3FdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GVpw4nkH; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GVpw4nkH"
Message-ID: <150014a5-82d0-4e53-8595-b01b3bf43832@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779416866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLflcTnDVR68YXOTUiaDyXVU/XHr7QC3203n7y7YGNA=;
	b=GVpw4nkHZflPEGjsfKYHrPnisj2uSGUz/jH04R8rFFS6qfVFmYVXCQ7eZNWVP+ct/UCMvM
	5NytgX00z3Av116TkzeRk51G4La7vdHEP5NeWrdXXv+B0nOyKtG2JlNyKk3gv3e9QSn9V9
	6YkanccAoChLgcmi7ZWHvgil1S7hpXs=
Date: Fri, 22 May 2026 10:27:38 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] memcg: store node_id instead of pglist_data
 pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-2-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260522011908.1669332-2-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 5/22/26 9:19 AM, Shakeel Butt wrote:
> The struct obj_stock_pcp stores a pointer to pglist_data for the slab
> stats cached on the cpu. On 64-bit machines, this costs 8 bytes. The
> pointer is not strictly required: NODE_DATA() can recover it from the
> node id. Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE
> as the "no stats cached" sentinel.
> 
> At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
> plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.
> 
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> 
> Changes since v1:
> - Added tags in the commit message
> 
>   mm/memcontrol.c | 26 +++++++++++++++++++-------
>   1 file changed, 19 insertions(+), 7 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

