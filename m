Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715D441021
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790364105; cv=none; b=oIs+GLoKFOtjcBy9R+m2w8CXalKnnItZ4dQF145RceDnaMOXJurX8yw/e3ZiZBy4XltfW9S+5nqXSxp34xr4naiqDaT6HUQgdTvxpGoxaYCmpSxENIBGhObt922+iDTHYVPDoMsqQGpnDLCNjRPfLieYIoRg6/njyatTPLGu5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790364105; c=relaxed/simple;
	bh=AnW3FoapXOivL/XrYzT5pF2wRXd8Iw8zMnVMCQAyolo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZo2zX9wr+45o8ma+rlhPo2JfK1jv5oLj8s7QAudXxH4EoWAM6xcy+ztUCB6ft0wLsoLLDCggfKkeny21Ik1Y1uetRTuONbWtrLtuVNbSluotm+UOYOzRIGUQFDOfS6+CgBw62cseYZXA3R5/36JUo3LkumsrvAqLQp5xOXm528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nmcqFz/q; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmcqFz/q"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8631d0023daso699365b3a.2
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 12:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790364103; x=1790968903; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Jb6ew+moeljvdv7wET58Ij2hd/p8EP7Hag+x2wkklw=;
        b=nmcqFz/qyOukKj34wtiHPfe3qgKtVZfvOidqK217MgnoZleXmfwJcyIcKX6jN0szhg
         z5c9mUsleUxRpujUCS1P6eHIVH3DpQiN/Q7fH2XCLjxBYLqTcyhjL36K3E5EWSuaFTes
         gso2OgKzumbGFolOS7269W1nOMkh2oLlKbnxdXHf8YWHKVSq/BWuIgs/9NDatJKFZAxD
         FmlFhqyqgyvM55Pt3nucmo4DMsMQEhNg0uQXYL8STnnPlqtL8nvtt0OLfWP684jdu1LO
         zAz1ODZEOtDHRoasIQbhNI61Xcf6qDH+rI4sVUzsMChYj+Uw5/Q3Sx9TLVtf0IiKaLd+
         //IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790364103; x=1790968903;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Jb6ew+moeljvdv7wET58Ij2hd/p8EP7Hag+x2wkklw=;
        b=GgbJ82GXKOOfQr/Qjv6G4Mn3o7kc8CUSZCejsuw0s/MPs8blwN4/quPduj76D0vmiS
         Vwf44pK7a3nwdCWEY23ozV2EW3Tu2q1BKvoC5FZ/j4fm1/Lk4lyozLdBf/z81NwVOZ4e
         xXlUD+7wJQqqst88Qjgi0dA9wawqexs71pJZhpyAUS2PuTh2qhtF6gkwhzaBSwG0EBCz
         y/CCyZSCOUGytgEMteSMTtoiDjONdHL110VTmiKtyLDFy5v+ezIE4XVKuIqIxLEeaATK
         3HfhTIviqY2Q+O117lKbotOt+1hGLJGxs58zXLeSGZ9NVujiCuiMM+tA4iZdamIOGF2y
         XPZg==
X-Forwarded-Encrypted: i=1; AKwUvBwjjJPoBqACiN+f7Ao+6Ze0za9jvmqUfDoWYgTL71sZhFNRMhlaInaO4gnjNL6Mqux3FQDLocee@vger.kernel.org
X-Gm-Message-State: AFuF++lUmXiAUY//RzXDOD2KKICY9kEWbn9koeOMjS3aqTxvmNcYmUUl
	kQQemyCHKEq4qvD+zCJJXZh+gRLEgjnzO+x+owtJB1U5oMPr9qC3g16x
X-Gm-Gg: AYBFou1IkmY13AJbX586q5ZMBN1urXPsO3jpdr/SnGyYYDWgodrDe2AB/di+1YWX0sQ
	T43s8YZCWgKf6M1GuW2Fr4PJqrea4rMeDEdHTj/8JlQEq4SNuQKMI1jrsG3UfP/3QX4Yu9Uvwtl
	NfVlInNvxvsL5QiPsgZbnePwvGVeeCD3/YjIWbXOrBETTTG6aY+YdjkOV+Y4ichSHEQ3H247DvM
	h4O0jy2o3GOL2UQSR8yAneth1emoAgUzH1x3nqDJBMTEYbzvH5I7nzcADqLDtWYhwKk+M1zNY24
	v8UT84Xjuoz70SMQA0wcpVB/JP6QmOPR82/D168CBJgSj6zXxWJQjG8X7beZ3Wfl6PRMyMYPwuZ
	2oV0RtWsYovN/hX2/vnETYDeTQHCBKPJ0HQMj2+OCFTmuq535oAf3t9Sk9+IMLsgFPFSB27tcB7
	9Vnjiiwa+hKLUPUpIBY8VHVwQOwDtNwOPOoPojani2RKV+O0Qug0RGfHNPG+tO27tNVowVJYzrL
	UIPj7QvPa1/G0vSzn+QpxqqAy9R56g1csEsqyU=
X-Received: by 2002:a05:6a00:10d2:b0:87c:9094:b72f with SMTP id d2e1a72fcca58-87e98789dbdmr5541733b3a.12.1790364103038;
        Fri, 25 Sep 2026 12:21:43 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feaf83e0fsm1597652b3a.37.2026.09.25.12.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:21:41 -0700 (PDT)
Date: Sat, 26 Sep 2026 03:21:30 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, 
	YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
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
Message-ID: <arbHLt-iB4RHXyWt@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araWKyJ5MENBwXCL@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <araWKyJ5MENBwXCL@cmpxchg.org>

On Fri, Sep 25, 2026 at 11:41:31AM +0800, Johannes Weiner wrote:
> 
> Thanks for your thoughtful email, Kairui.

Hello Johannes,

> > I also want to separate two things that I think got bundled together
> > here: not requiring a physical slot behind a compressed entry, and not
> > charging the raw size to the swap counter. The first one is great, yeah,
> > and it's exactly the part we want, it's what makes compression usable
> > without provisioning disk. The second one is a policy change, maybe it's
> > not needed for the first stage, charging a cgroup for the
> > memories it has offloaded doesn't require any slot to exist behind them.
> > If someone wants to run memory compression with no disk at all,
> > memory.swap.max defaults to max, so that still works fine, right?
> 
> I think what we found out over the course of this discussion is that
> people have been using memory.swap.max in two ways. Regardless of what
> we do, we will "break" one side.
> 
> (1) The usecase you're describing. Use memory.swap.max, combined with
> memory.max, to set a "total", predictable footprint of in-use
> application address space. You can mmap whatever you want, but the
> number of unique pages you can touch is limited to this sum. And you
> can control residency vs non-residency through the invididual values
> of those settings. If compressed entries are not included, this
> usecase will break.

Right, thanks for the reply! residency vs non-residency is one of
the issues here. It's also about how we consider these two kind of
resources to balance the scheduling of containers.

> (2) The use case we have. Use memory.swap.max to divide a finite space
> in storage. We only have so much space on disk, and we need to manage
> fair access. Note that this isn't about speed. We have a mix of
> containers where some use writeback and others do not. The ones who

Same for us, the usage is mixed.

> write back to the swapfile need to be able to get their fair share -
> not more, not less. Including something that doesn't actually consume

Is that writeback compression rate based? I mean for zswap, you have to
writeback uncompressable part, and then also do cold writeback through
shrinker. The compressable part is hard to predict and control though?

> this separate finite resource is also a behavioral change that would
> break that usecase. And arguably it's a deviation from how the control
> was intended and from the broader cgroup design philosophy.
> 
> I think we need to build tools to support both cases. But somebody
> will have to change how they're doing things... :/
> 

In the long term we might need something like tier or xxx_ext for
cgroup for better control of different resources? In either case I
think if we could get the building blocks more flexible, and this
actually sounds like a tiering issue? I remember Youngjun once
mentioned a memcg X tier limit which sound a bit similiar.
