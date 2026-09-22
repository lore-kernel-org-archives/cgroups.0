Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFD2572696
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097397; cv=none; b=ls21q31MCoplzYFXIJZJ5t19gPv8crbCWrZXTNndqoY8j1OMOVBXx4/ubLIGmEM8kDnakY3dbkV8i5Rl4bInvtTpZSUoclX4EV299GCQXQiTR1BHbFBSCPmBbqaDtcL7nP621e/31HOHOvb6iNdiZOUk1M7C3tid1aPlN5WyIzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097397; c=relaxed/simple;
	bh=F9wrWhleKxmtzDbWxesfxqdYHneA06HebFTlC/eppXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nS4W9OZQD5aY/whiXMve1xzjzajnLJrFHc0A/nr0mN2ZaCjL6Atgw+7bqdOQo2K2L8A0dYMixSmZq/DO0tYu9qYSF1pRAYx94+zm/XhgLpC1AujUvW8nhfEoW/gLFe45Jw9nxywzMVLb0NZ93ungt4lQy/074juuDrP+N7BjKto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=ZH4Xw0K8; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="ZH4Xw0K8"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939656ff6d9so11740385a.1
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790097393; x=1790702193; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CJkQfQB3a9RKvj8bM5CBOZYh4CkWNCRPcTCANcgJj3I=;
        b=ZH4Xw0K8TWVxEt3LU5a0ZAvXnrqs2hWG2jpFUDzLLuhJS/3K5FQMz0vOuMG3EvZySY
         7B9YNXNP9msgSJau3yceZbUWsl5YRuMfKoM44vSwLV8HiCkZfEibnCrTXQ6KAlwwsLOL
         hplsjEvjHkBozKr9K7rlA9BeoIRqaIUdPFxxndrSpQr10abL7O/kh57mu4vvqALKx4KA
         PO8gnGJ7e/9zok1lRs2Qsu8hu+L3JzuL999xZJ2NMBB5jcS+UE5kd4JaLOblFYWwPct8
         wgD0PpGsvuyDyU98SvCudgBYnX8B1CtH5GX7szzLRcswZtW8b4FYcQIWAw/ClEIuZk2s
         2n3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790097393; x=1790702193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CJkQfQB3a9RKvj8bM5CBOZYh4CkWNCRPcTCANcgJj3I=;
        b=1HjVXYf5RrUdYAJ/ONyvZEdpmroRcon/2X03LWPZgEDfCFLny2GnTDsvrNNWI64PWi
         5y73YEjgGnHKPMLOVdxIvwDyQeOhleznjQ6VPReqZtPie91+53wJ7OZHHIQEYSM/AaPr
         cnarC/thc4PDl+9hNjrGikKbUJnqrE2FSsPTlbBjUSXz6GUZc8zmXBZIkR38A65LT4dp
         eFn4F9mFP0Y/GDwaA2QzP8kKRkQ542ctv4RzLakS9ldKVs2ZIVBkw1WXeQGJAEF0pONv
         lbq9VU0cgrOvSO93BcbRteMkGP3tZojKYOWiGYe6xN8KKjg/pcV1vqh/LyeIFzAV1SPG
         59bw==
X-Forwarded-Encrypted: i=1; AKwUvBwdtKqRbF5xaNx19oYXdgrWKTMLliYSXNR9tW/j8O3YOUxVL6mhispTSMflE8pIhAPQNWaWAXlW@vger.kernel.org
X-Gm-Message-State: AFuF++mNbnPlua4AkFG5q+6cIgQoemnNzq/U+IRzLN4KXR0ZLVYGGp3Z
	gIGj1eHbW7XetuiGu8UZyeNcuA4n/mE5Ulpz76hsJuHchgvv3qOu43UdxweGfMMPBYY=
X-Gm-Gg: AYBFou2x5if/oXVwveUIP2vxetiAFHAriaQu6m6ax1DV5B08SGNgS1DdIbdty3SLplb
	146Gg+k/nMl0v8eJUx6gOGhv+rC75tSSLmBn1qiB4KwkceQ7Kiw4usCZGTHqDCbNI9pqk+K+n9j
	9anCs3cUlzRFKyWxkhsTr+vVen+KtgELkHPz1g5Q48WGTrB850c/4nT0oeNPoPV028+af7Cwqlh
	EBYPsIMjZ8+UKgJL2s6IM6SLHrv6+VWcQV3WWzsHwCBr1XgWcTZZKX0p8Q+sFpMFhDLzGwiiM10
	hapsrZEZezzBWC9LpOvtemH/w8cQ9je7zR/otZ3tnkluGR/CpQdXNoeayUzTSRHFe/IelnVF83j
	7IiZuS1UZvTxBdbVYfX3uMa/WaiDc28xCrbqyGBIwUe1ZgE6UJOhY6keRt6+HCLsDXjv2NeJKFL
	syq/tZu3Yd+7FVRnwAse5v4qz4gTuhUmYdk0blV1C2eLi9n51uJ/VAnfL/pqF/UI954w==
X-Received: by 2002:a05:620a:2993:b0:93b:c22a:e98a with SMTP id af79cd13be357-93c2509e62cmr13040785a.2.1790097393108;
        Tue, 22 Sep 2026 10:16:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24756838sm24592485a.1.2026.09.22.10.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:16:32 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:16:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Baoquan He <baoquan.he@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arK350ZCTJpVtctk@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>

On Sat, Sep 19, 2026 at 09:02:28AM -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 6:08 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> > >
> > > I found this new concept of "compression space" very confusing to me.
> > > Can you explain the swap behavior and problem using only normal memory
> > > usage reduction and latency without introducing a new term or new
> > > metrics?
> > >
> > > The normal user doesn't even know what compression space is, let alone
> > > what makes it transparent.
> > >
> >
> > Sure they do - it's the amount of memory consumed by compressed data,
> > including the metadata associated with it.
> >
> > converting Johannes statement to diagram:
> >
> > >> Compression space is not a separate resource. It's page tables,
> > >> backing pages, and swap descriptors. It's just MEMORY.
> >
> >                           Page Data (PD)
> >   [page tables][                uncompressed page                  ]
> >
> >
> >                         Compressed Data (CD)
> >   [      recovered space     ][pte][swap meta data][compressed page]
> >                               |                                    |
> >                               |---------compression space----------|
> >
> >
> >                         Memory Pre-Compression
> >  |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|
> >
> >
> >                         Memory Post-Compression
> >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> >    ^----------------------------^
> >          Compression Space
> 
> Thanks for the explanation. So the compression space is just the
> actual data store backing the zswap/xswap/zram.

It's actually the pre-compression side I was referring to. The address
space that vswap/xswap map.

If you artificially hard limit this *address space*, you are making
assumptions about (1) compression ratio and (2) how much non-residency
the workload can tolerate. You might well get real workloads hitting
that limit while you'd still have the ability to store more.

Add pressure-driven writeback in the mix, and now even compression
ratio assumptions are not useful: The stuff in zswap compresses a
certain way and the stuff that was written back is out of memory
completely.

Yet it's all mapped by that same address space.

How could anyone pick an informed size limit for this space?

How many setups hard-limit the process virtual address space to 2xRAM?
Nobody. They limit the physical memory required to back it. That's the
only thing that actually matters.

> > It's actually really confusing to represent this space as a traditional
> > swap device - built on the assumption of a pre-defined size limit - when
> > that size limit has already been defined (the memory itself).
> 
> First of all, the traditional swap counter has a very well-defined
> meaning. It is the size of the memory that, when accessed, requires a
> page fault.

That's 100% wrong.

First of all, it wouldn't work because you can still take page faults
on the filesystem.

Second, this is absolutely not their intended purpose. They are to
control access to a physically limited swapfile on disk. Because it is
a discrete, separate resource from memory. That's the whole reason why
memory and swap controls were split in cgroup2. I designed this.

What you're talking about is residency guarantees. This is what
memory.min and memory.low are for.
