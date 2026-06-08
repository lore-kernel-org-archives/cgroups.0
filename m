Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958FD3B19A5
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 22:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780957641; cv=none; b=uIuCw52HDwk+j/o6CmX8hnCTMvjQppP+kyEzkbJ0orsfboQvj3hUdRmcgCoqkveQEXZR/c7C5ur9QScnhefkylivxx3cNoxy3Vq4AULN7RklngXov1p3O4h1iANRJCimc+pAMxOCWYxOW1rRsIkUq8BPAePXu/ef31VZUP9IlMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780957641; c=relaxed/simple;
	bh=ZnzXMKmNNQcMAsK3GQJoXlxxelkBmMuFNwdAjWqeeDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRLbUG1htP6td4LFk37AKlOLrmlIHOhSnt5V5elvI4VrnGJ8V2OMWolyFmgSY7npPF2jXVtqC/1O0lID6vxGii5Rgks0H0F9zrVgX4nuGGO9vFEJtQqXc+/h9zHHUh/202XvQ6VF9MVRt0jWrKxH0RDyakkybdgSrk0dYubKfuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvpMmVGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvpMmVGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1BE1F0089C
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 22:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780957640;
	bh=ZnzXMKmNNQcMAsK3GQJoXlxxelkBmMuFNwdAjWqeeDg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MvpMmVGoRMm3zfigrF0uV+iRgX42h36CoAm4KPvTx70waksQrU19h5rGcqgk1CPug
	 Bopifo2qojt34FmwIkzh2ghSJjAiUNaqXroRBUWNx0Hs93HFkIbvjjV51NNzVV5KLc
	 2y/MuzC032dWidywn7akmnTutYBP7iqrA0pBW+dffg9t7jLYMQr+dDRwCTzc7Jgyr1
	 Ibxb+R8UVC3j3qzBqej09gIOZB11mgKUZIt0wUawHHLZ824KQ1h3aHhKsn+QVGClm8
	 R5nAuFpmgu1ZN93yc5fFyliPwzqwrskQX1rHU7SCOklp3a8k0KKF/AAE7PeSkd5FFw
	 mondi24qgGMxw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68bac6e24fdso6574886a12.1
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 15:27:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+crhqqAfRcivUEM4GDdCIlDxFivqKqLHJWjCrBYpH7wfMp0cCkHOSdPc6IXW2R8q/9inBmHeYX@vger.kernel.org
X-Gm-Message-State: AOJu0YwRDG3DlCddK5RwSFJLesbuRakFFQuq2SxG8vhvQUegRIp++TXQ
	eAh5uJngr7lw1+FIj60piwLjaMlefe7PZqTcpm7WR2aro673sWzh7+ZuulIR4pFIxEDNitXJqIC
	4pF8d8n3XEwjv+kH+xdltBMLhhRYwkLQ=
X-Received: by 2002:a17:906:d552:b0:bf1:1d19:cf95 with SMTP id
 a640c23a62f3a-bf37077232cmr900655166b.12.1780957639295; Mon, 08 Jun 2026
 15:27:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com> <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com> <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev> <aicZ-5GX9De3MAU7@linux.dev> <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
In-Reply-To: <aictKA0XWMWbxFdN@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 15:27:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
X-Gm-Features: AVVi8CcbjjP-avdNaGSAeiW9slgw-LB5QMjLbgQUyQtJGqfa4iRAJG4WdDe98uo
Message-ID: <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"

> > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > will be use-cases where there will be a need to demote data on higher tier swap
> > > to lower tier swap. What would be the appropriate interface?
> > >
> > > BTW does zswap folks think of zswap as a top swap tier or something different?
> >
> > I haven't been following the swap tiers work closely, but personally I
> > do think of zswap as a top swap tier.
>
> Same for me though I imagine swap tiers would introduce some duplication i.e.
> different way (interface) to set limits for swap tiers for a given memcg.
>
> > Things will probably get more
> > blurry with memory tiers and compressed memory nodes though.
>
> I think there will still be distinction between byte addressable and fault on
> access devices.

Yeah, I think it makes sense to define "swap" as fault on access
(zswap, SSD, etc), and memory tiers as byte-addressable (even if you
put an SSD behind CXL and make it byte-addressable). But I also
remember seeing discussions about unifying memory tiers and swap in a
way, and it makes sense from a reclaim perspective (swap or demote
first?).
