Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C48140F724
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365016; cv=none; b=gMswIU75xjO/AFiN9AEIOBKANDt7BTPlvxu0ontxYJtNnvRCLp9a57y3DI2E3tUIhCcJzmq3cYV5FMFxM/WW75LF9XM4MX8BROI1y0z/U6I71jqJHfcDRkfFA61K5z8f/UxDYVWDQeF2ptm0asEbOqA/YDR70kGpGyttXaWUkNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365016; c=relaxed/simple;
	bh=M4/lST7zD2Erdwe6/sNV3cFEsUbk898lwUHJrduDZXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uv9b4ejQQybfCvYjRZw2zMjGRCY0rcxvctioi492c/Z30utbeR3Z9p+iN18GUpe/uV5JNiXQx7nWwnPfhjGWWc5UyFy6REPYrTRVl1jVVaZRVaI9sD6isvQHbRe+2/duDFsqsmzUuq2Khv5plPMxAx6Hrhbw8ykpqrvvrHTtD/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BRe/E98K; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BRe/E98K"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M4/lST7zD2Erdwe6/sNV3cFEsUbk898lwUHJrduDZXw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790365013; v=1; x=1790969813;
 b=BRe/E98KZSR63+gkjFk3hcCk4237lUFu1x2KoDAA8k5aPotOm9b/w6nC2l/Ev5et+DCZVvi8
 qxNz7mPoX7PPvkBjB3x1V86N2fzl8Ogt+5xYJjhVf0TGLAiTqEjmKmLFmUhsaskLYaxulWzvJGS
 p91blrhC0QDIDgDcFfibKeY4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9b23b1b9c141f10f;
	Fri, 25 Sep 2026 19:36:52 +0000
X-Mizu-Trace-ID: 9b23b1b9c141f10f
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 12:36:46 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbGo3QTYlUD5cVW@linux.dev>
References: <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>

On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
[...]

Thanks Kairui for very clear description of what you want and looking for.
After reading your email, I think you want memsw support in v2. Currently you
somehow are implementing memsw using memory.current and memory.swap.current.
(I am assuming you need to subtract swapcache to avoid double counting.)
To conclude, you want to use vswap (the aim is it to default) but you still want
your way to implementing memsw keep working.

Please correct me if I missed something.

I am wondering if you really want memsw, why not propose memsw. Someone from
tencent proposed memsw [1] previously, so why not continue that effort? I am
pretty sure folks from Google (people who actually work on prodkernel there)
will be happy to collaborate with you on that.

[1] https://lore.kernel.org/20250319064148.774406-1-jingxiangzeng.cas@gmail.com/

Setting aside the memsw conversation, I think we should go back to the actual
vswap conversation and list down what we agree on and where we still need
discussion and decision. (I will take a stab at it and start a separate thread
but still on this email and will use AI for the summary.)

