Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC4533B6C4
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790259537; cv=none; b=BgOn4b2zsW7BqgbpGo87Rz03R+MnWggLd0W1neSKJW0Ool8qIgn4iZq+yMKnMs9qSOFKBrwytyxFBgeuYXspKf539NVNWv1uz/R78xJyeiAPRGcO12e5m/60jRdb8I/Y6YceXVrUjfzq63PtgN6MpBDr74Z/vXcFAQPdxK4l8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790259537; c=relaxed/simple;
	bh=P4QXQ85m5TWrdHyiZlWFuLVVI0AIiBJP5izTUxlLlCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXWfDZFBzBRqQ2O7uXYThvDZqDeszUlCsjBSeLlUnAEuv+DXik1Yqvgario+Thh6AI0soLuIvCbQNljHv7vbLVCDRX0jsCuW9QWrGNYCf8Tufy0fTvvrypR7rSb1xuxbTGf5KyybegBJIYeov+HGwhKZbH866uhvVh2rRtuY6E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=aoHxdt0n; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="aoHxdt0n"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb3so161933185a.0
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790259535; x=1790864335; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=54F62XHPr5jXjg3/coQJmTQQL9rWGQ8xIoRYSOjr2Ds=;
        b=aoHxdt0nslo7Ra1ttXJEMgxk8vz97TYY+3603tdUuULWC8d9Ia7CJcFICFxIULVaBJ
         MqVPETT7i/O6CwON4le21zPFObZ6RtcMENogTN8tzJOwyEVLsbKQyeFBsQoVj1ofcneR
         mhnMTBodK03Uch8wnwqV8vjK0kG39vXO7CA9e05oebAY3zcPlYK1kG3aNECAS28KHez+
         emaZVPhU3GhALXyV4qtSt/okYg/Ugsbhk8UWQii6MH9HQajUeqvbIoDYJqUimnte7Gja
         Ap7XqT6Uz17N1MUcYwQqyWPhkI+U+XrMn7cfjHGaYlQIzRex5uyztbAXYwBE7WBaySuH
         9TIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790259535; x=1790864335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=54F62XHPr5jXjg3/coQJmTQQL9rWGQ8xIoRYSOjr2Ds=;
        b=Nh90+TjLp397h/54VrugOrwUUCeIeQSCQh2fd8f0rI1gQaboeW1SFo1FdkcBSfmMqf
         FbwmnMOJhvWD2eibcEaQUh+RfN6G2hevOxkIxyQnczNOv2+4gwJEI5+lqmLKSdxql0aT
         JraAOsq4nylpwQP9Umjp740Aw4dTzQF85X5rSeu1sc/1kRL39PkBR2XV3dgJr73S29wm
         /L2tWBXquww4Im6KqEIAEtuSm4xLVCYPFOBDMsGlxakYVKsyPUep0bKa5RYBoNkEDhcM
         BMKukabDS9wgEwNCfSgf/xp6b/8U5NjzogLyboQHmJ16dKrayyIE4C0PrPJm0ey0Eg1X
         jo/w==
X-Forwarded-Encrypted: i=1; AKwUvBxmD9n8jWajnWFzkxNk9jKO+g6wasJtLq8/chfNdGtrJduByPnnXRHkLQm/JvGv+DEvL3xFZWhL@vger.kernel.org
X-Gm-Message-State: AFuF++mOmU4/5m+E+qQwaEU8UWYEc2iQpQYijeygTJ6y8S+K1cSPEQzg
	bdESaee7maL8YOi3oqDhEQyjQTbOR3XPD6dnuOxTjNdIUikWnF+KdTa6wAK+VxuMM14=
X-Gm-Gg: AYBFou1fOTmRJDdAp3wrU8p31OTXBDA0zpXfmwhjWZ0PTfJBxTgfqSvTmW7wcS0wLla
	QZIQ/OSntQjd79elQpDD/aAEGUxw+xwYK7QxrxkUkON4movuF7meS4XfmXyFPF3PXzbJq6xGyGw
	mAA7H26JAD/KkFS6dUw1CaR4PENKPY0z4fUOlfTpvfnUDwVDf6S2pLLxE2F0eYzi4KRdfOIhab8
	hcUNZFX6R7HfR7NgQBMIXLf2Mo/iGmvFv18buDBYClDCi+zOfRRpPwpGbniiTLoUY0NSnXkasby
	fnx4fNxUiXewVIWvEaA1t09qN7/pnLvDyqccTe41Mi6iZ2SGLducjRlcMTmqjexKAp87b0iG6wr
	/bzPYu/SLZqrgNf9uBkkOXJY7jcWDn6DDQHgAykaHD87M7JoXuy64YdEzMPKaQQfcfGabS8vlJm
	L8tX/X4TljjM6ovnmaHZXE45P+g796lkuIB74LpBt1izEjwa4axmenydv/RsLrgK+38Q5mEdeG+
	987notpLPCtCrzCeWrLSGu7nwPDxFvgivSrUheiq3hUkXeJPuWIMF4=
X-Received: by 2002:a05:620a:3185:b0:939:ed29:8ad with SMTP id af79cd13be357-93c3625bda0mr311149485a.3.1790259534711;
        Thu, 24 Sep 2026 07:18:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2c22f729sm342356985a.13.2026.09.24.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 07:18:54 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:18:52 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arUu5gwgqmU6xeUD@gourry-fedora-PF4VCD3F>
References: <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
 <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
 <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>

On Thu, Sep 24, 2026 at 01:02:54AM -1000, Chris Li wrote:
> >
> > It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> > cgroup2") introduced memory.swap.*, it was clearly defined as charging
> > "the actual number of swap entries used by a cgroup". Please see the
> > commit log. With that, zswap still reserved a swap slot even when the
> > data never reached disk. And not to mention zram, it's backend is RAM,
> > but not physical disk.
> 
> Right, that definition matches what I have in mind. The actual number
> of swap entries regardless of the backing type.
> 
> Changing the meaning of that breaks existing users.
> 

Except that you are the one proposing the change in definition.

You conveniently skipped the message where I laid out, in detail,
why this interpretation is not grounded in either the documentation
or in the introduction of the counter.

You do not redefine contracts because "that's what you have in mind".

> > Now some deployments do use memory.swap.* as an SLO signal, and that is
> > real use cases as Chris and Kairui told. So I don't think this is about
> > who is right and who is wrong.
> >
> > To keep the existing deployment working and at the same time give the
> > physical slot its own knob, I think the solution is to add a memory.pswap.*
> > counter as you suggested. And that is not something we think of from a
> > brain storm, it comes from real deployments which already depend on the
> > current memory.swap.* behavior.
> 
> I think it is important not to break the existing usage of
> memory.swap.* behavior. I am fine with adding another counter.
> 

Then you should stop distracting everyone and propose your solution and
make the argument for redefining the counter to mean "what you have in
mind" and justify the addition of the new interface.

I think there is merit in the argument - both Johannes and Rik have
some concerns whether it makes sense.  There's something to discuss.

But the core issue here is that your use case is counter to documented
purpose of the counter, and just because you can derive meaning in
combination with another counter does not mean that is contractually
guaranteed by the ABI.

If you want to make the argument that it is, in fact, contractually
guaranteed by the ABI - then this is a different discussion, and the
introduction of memory.pswap would be tangential to vswap (though it
would enable vswap=on to be the default without breaking anyone).

Seek a way forward, not a way to stonewall.

~Gregory

