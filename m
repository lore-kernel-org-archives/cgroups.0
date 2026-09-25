Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B10470E84
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 20:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367665; cv=none; b=ZFVHYtfosm4qbeOQEhysLZIk11HbzpB5o1YaWQ3uOzvWv1J2ehwVZH2mfIR3MfaCnG1mBlc+c+ceegGelQIvi959ljVHwrur4eSUFJT/dFPZKJjnqIL+du5QcX+t05DAifWIxPHNIe1xgdPikue8CEHqQtDGKTMwP8S3YI+v5Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367665; c=relaxed/simple;
	bh=aQdcMnaGRWrcT2d6YZ42NdwPibTOqQqRSFGnSDUxUa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmbaqDmCN59ODsKX493uW6xgQrQqjqIMx+E1XmqwqyHBUCVgA32w4Sg21GkKh/JAahohpjPdb+tXBTxGWExJKX/1BKeli0rJy/JgvKQwOAgAJ65zz9XK1N3B9PgUhIFBAx9qqlwHUYi9gD7NKDoJIYWjRKNiAwvyr69Wm5Gwg/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AZfvwi9M; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AZfvwi9M"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccda24afso754820a91.3
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 13:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790367663; x=1790972463; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xWHZht3/sG7ZvX5La1aBebgJu63RUAKhR/+jLnkgrMk=;
        b=AZfvwi9M+WMp11YAT6155HO1GrvbdzC1CKj+dEnJN5iex4MvSpu30MiNq5bcb0X4Zv
         ojBdMZ+R+5SimlQsM66D/ihwWT6OgGpGwKkprX6pA49ZjR84c8Iq10035mDELRyEP+7W
         YAn3BSoGAOwcSXtc+c66XkNVsexbqhaKFM8s7TNrJvk421FMIzcTU0UGd0Woai16F522
         KOP2FZnNkTU+QzVMserVL/rk8rBa2MmpZugvT+XZWtSwivrSsjHczmWs63pHIJuR3++1
         kduU+XrOgqIyWjp7jHXJlovGXQvcZ96t93Vqx9o8uUPjhDgW7c0VWnTBvhfbMUkybmQY
         0jRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367663; x=1790972463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xWHZht3/sG7ZvX5La1aBebgJu63RUAKhR/+jLnkgrMk=;
        b=Tbyl2MMpoqgcJre1hu8W6hr+8Fjq0hrHfuGrEods+8FdBacGbUrCzc5318v56O5MiY
         cTcf51DNZkU7xgZulkhKSVoCJP3oy+daLTWATlUOO56pX1xxE54Ru0MIwSlHyRjd+QOa
         1kaBUaILsGQedi/HDUNL3/6rtPTLp3ecoiAeoJBbhFSQCI2URBs4fHEBaGPNf7kDteAd
         KGVs8iMSWnhwnssC07UX3GZKrdGEuzTRbPH7GbnS3jSGrYOaU2/id5f+uBE6b6xzhFWA
         2RzorR1LdqqhBu5hCePe8mCFaMUhatoTmV+zaGkAtEZ9lCEDkjQiUXfyz7VhZRXcxQsJ
         8WNQ==
X-Forwarded-Encrypted: i=1; AKwUvBycj3YLthkKf3g4SIFXyJowpjjX5yWmzXPvD+PlngQ5m1S0r56CQV0k5PaCe85on4erN7kuJNwl@vger.kernel.org
X-Gm-Message-State: AFuF++k6FwTJctFmiKKnLS8d4tD0NxBe/wLwhgZ9j4UWYLuph2hB3iPw
	4jtKn4VmBcbaIA2uEfCrPL+8C1tcbUEYHuuLw2+OjW9KTpMViJtkUC3h
X-Gm-Gg: AYBFou3jsNucUqgcO+tRiul3V71ToGWB3khoR0MuonM3HXS2r1VZPHbv6Ef8SJM8wNL
	k7xL88Jc2coSXjgPCk11Xpt4/ZGuLZ7mYGB7OXeoAtwa+7UWa3BGLQL6mW96wUwo1muwbf2h1Sx
	dIoFhJyjiNrcF6rSjKQzlN6CA3LPnCScPsFU1aZ/YCN6soX5QK7C6A5woGp66MYvVLkm6GLgEAm
	9P9fxDY4T/VzZX5+hZmZWXZovBcOFOXIf8z8CFEa8bXgCKsWIeAz/sl5qo6fUbR6XMuAe4vPToS
	ZK4HXJm8WOMOYH48mlIqwlVWnWm1P0XuUEp1MddiFlhK/IS+mTkn+Ylh2N9RBt/hHDnRuOPB9Qw
	9rlxvdo6rb/fw46w9kz9GaHDtLdpHk+/NBe6HnHK/dcGMOXww08N6qCYErH4PPRZzT3KWmFGVHn
	olw5uTT5D3OrB2LqoLqTLXfcTFCBQ8/65TRNJRvlUx4DIoOhewGjG4AIDVWVxKUWuUSbE40AfMV
	uUmDK2MeagFg50m3iZ3hwOXFELEOTsX+i9Z5FLCxq8ku5WaZQ==
X-Received: by 2002:a17:90b:518c:b0:3a0:dbfd:1a1f with SMTP id 98e67ed59e1d1-3a0dbfd269bmr214015a91.25.1790367663092;
        Fri, 25 Sep 2026 13:21:03 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99917besm5937983a91.14.2026.09.25.13.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:21:02 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:20:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
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
Message-ID: <arbUA-XwLBsty34_@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <arbGo3QTYlUD5cVW@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arbGo3QTYlUD5cVW@linux.dev>

On Fri, Sep 25, 2026 at 12:36:46PM +0800, Shakeel Butt wrote:
> On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> [...]
> 
> Thanks Kairui for very clear description of what you want and looking for.
> After reading your email, I think you want memsw support in v2. Currently you
> somehow are implementing memsw using memory.current and memory.swap.current.
> (I am assuming you need to subtract swapcache to avoid double counting.)
> To conclude, you want to use vswap (the aim is it to default) but you still want
> your way to implementing memsw keep working.
> 
> Please correct me if I missed something.
> 
> I am wondering if you really want memsw, why not propose memsw. Someone from
> tencent proposed memsw [1] previously, so why not continue that effort? I am
> pretty sure folks from Google (people who actually work on prodkernel there)
> will be happy to collaborate with you on that.

Hi Shakeel,

Right, I believe it is still being proposes as you can see there are some
previous progress, year that work need updated, let me try to do something
about it.

> 
> [1] https://lore.kernel.org/20250319064148.774406-1-jingxiangzeng.cas@gmail.com/
> 
> Setting aside the memsw conversation, I think we should go back to the actual
> vswap conversation and list down what we agree on and where we still need
> discussion and decision. (I will take a stab at it and start a separate thread
> but still on this email and will use AI for the summary.)

Right, the things here is that I think it's not hard to see that
memory.current / memory.swap and memsw (if in V2) is tangled with each
other so I'm hope we won't create blocker for the future.
