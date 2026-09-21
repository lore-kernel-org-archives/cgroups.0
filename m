Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65838470EAC
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984921; cv=pass; b=PrkDMFxxvv4OJupLL/vtKhPML4dITfQF/irBLG6yeh9zqRAqm/hoYfZatS3WcGVYdcu3ecCCSh2gySl8PZENzlDPfcxGtNgzhdpSfAyv8WtDnvHYIZFNtK/CnVL8PxREIy1RnjAV3CER1uILJN9Dvhd+7gYyw/wpeH30Teo90Is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984921; c=relaxed/simple;
	bh=C0u7dFIOwFw7/Fou9k8GunftPf/Pv/MvXmJEJ9Wf4iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCJO3RricjY0dExIq+EpAxne7DA9zeM3qFBGS/ESsTnXS7K7PGjy+H/U9KyzGk5JV1zw1hxdBW+Fe1NNRxxGqpz9r45S28usYo1NCFrRG0pQnO1M9XVPf09rzv1FVuCAzdcTqej1ZewIIm+Aw+j71b12w0if5TPN+OjLU5AQ7uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZzlxFC1R; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZzlxFC1R"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-86ec25cf7ecso3430466b3a.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 03:01:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789984919; cv=none;
        d=google.com; s=arc-20260327;
        b=Z42n/NXAGdVnfFksQWl8p+ggcy6vgdcArq2KwuI9hvp0kNCvV/YZcYTHwUMqa1mSVe
         ijPLSSjj4cQ1LxJ0Bonn07gLmdNrYu+ev1mNN2WRiSnE2BQmOXHLVOV0UoRpzfx8EDaL
         S4JkGLVLHh3Wsk4N9eP4kq8lzoKsdcYHDTTEo0eJtjgSwa3O/sXjhEk5exRRMJVugHdw
         Iae/H4wz2z87wq0pdAoW0Yoq62GUKV3zXaL3NLUTdKTnzd4IXQg7//RtIIt2n1DDlP2o
         oXbgjFwsuaNbYNNldc1qC4RFZJjsHG+qn+UWCBNZrDNSTGpZsdrGPVwU6keDgJIkl7Iz
         awpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        fh=rrMpukLb9sr41UQZlsu3kRW8Ia8Df6aTrkPWClCMDfE=;
        b=ok/8HtI4okenAH1pSXKOTv0eDOUg5/y1KZ96uITY7y/Zkf4c/YlEONShxrT24scdUI
         ryOMU1T23SocYx0mCAfiv+58LKqFh1mHjD4xgpDBEnIg79/LnwR28E51WDK+JyCQ5ZPr
         JgGiFdHDZ8mrX7FFGrklQWHHwq0VTwHV4TUmA2dTVI5GrLHU0ocMS5a0xqVyUQz0udTL
         fujhrIzs7w1PNS1OcjxFpKKZYtB2tsxD75K4BkS8YXtwx9+GAiPs93ozAkxV7SaRMsgQ
         OFhgmdKGXvmWNWfEx1HwLUEvYFPBVlpP+r7EvFRi1bgvUxGKgvLPqx+8SLZd9iVXEzJq
         RB5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789984919; x=1790589719; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        b=ZzlxFC1R189DrN3TSnXfYhpWLK28QabWnQcJ4+wU5jN31B7nigwVthzzf4P+0COfY0
         dNEgN7ioxlGortpcWozAnFnb5zQZS8JCwof/IoT8RCNcXUraPQu0pT5/H4zM1CEtoK9n
         KzuXBAXw+l7MzSuUOIN1NMjLsKcCHTMoW8YFj0PkG/9LnvEvmsy/7rUh1rHfOoHU4y4D
         pPlO3BHVPOMcSLTicIZdiceAmKVXviv1209VCuC1KelByIo86HHO/udjGtDtEqfTmScZ
         VjX0d24IGt0LJ8DAtNt+PMW5BYO5oti1bveV9E4zlrYTTkDWG6rPfiCwsmbXToQJ2Akc
         NNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789984919; x=1790589719;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        b=Svc+aylx5XGLgrO+TtuILO5joCiyIe+Y6qPwCL7hXkUVcFPQo9m2834AON+aBu0H7G
         Vc0uGzimbK/fkymR0Sbfscy47mnXDu4G60EDzDd5Cq4kKRFlmN2FGkZWpOyl/yEqytLS
         T7tbWup1VSKiPFTCfwKmM6ljIREWPrVyqvEuNJYdsH/Tn9tJIwiDMh9ouWMcncZoZfaD
         57AoUS8H7tolBb4HKp04lR2jVYLc1D213/FMTSJHrOTvZOrTjnvPE7UY/x0XR8r0R6hc
         /5KJIw02d+fqjZKx5TmJnd0mmUN8ziPGJEH9sHL0iM/6SRUt9Q1vLCgQT2zDCJHcxeYJ
         r1bg==
X-Forwarded-Encrypted: i=1; AKwUvBwzbT/k8EqgMH9Xr55SCeqYS0fqiWmlEV+eyJRn5vMcRGEGGpiaaHbPiTgRs9AGNDaAw/LenniQ@vger.kernel.org
X-Gm-Message-State: AFuF++k1+xF5KEJmc8VtsFNyu3YIGbq/MOH3PVuRPiBWtfPbDcKhHzfK
	oCKU7oUB24moaFLtolG4eyegmV8YeJu9wr9ISPxTGvts8dSNKChCEjTC3G2RsMAk2PhE7wtQypw
	AMlcBJyGKGFHTLiBCnq1I/xDZtKsV4Eg=
X-Gm-Gg: AYBFou2NCpxsdFMAsuQz5Ce9mguyjDMg9eUOu0gcLuD3JybqsaZ6zxjZwImtxt6+JOB
	7spOVyfuY9o1cr6J5fE9qPXJ0I2a0CCxRXxdG3gnq6li45zyQajQT3zFSINKLbmG3RfxIvYymT4
	27/TRpHtW7/s1UOre7ok2d+B8SnTUSXOj67svhHkCFyOKVbu7UK+lP/E/pllGBxAjWxUetJVkFJ
	eyMtGMRpyGW987C5MGMWG7NEuhQQUMFe4rqkA0KroQtuwIGDd720FKBHqHQf1oofoIZO3GPlBwV
	XRbVtVObpQwAAvKAAGvWjKyf52b52ghNWzYYK4VpOQKQGzVMaKkWBHysZeLNLQPn4gRMdgEg94K
	EfPE7H5kfroA=
X-Received: by 2002:a05:6a00:2d93:b0:857:73c3:4466 with SMTP id
 d2e1a72fcca58-87343ea8041mr17463837b3a.21.1789984919241; Mon, 21 Sep 2026
 03:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 21 Sep 2026 12:01:18 +0200
X-Gm-Features: AcwNN1W4zNuvHUUOGHULyeGe0PhiMgbBymHHBRLY42qLX54efbcuYBMEOcf7diI
Message-ID: <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 9:02=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.net>=
 wrote:
> >
> > On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> > >
> > > I found this new concept of "compression space" very confusing to me.
> > > Can you explain the swap behavior and problem using only normal memor=
y
> > > usage reduction and latency without introducing a new term or new
> > > metrics?
> > >
> > > The normal user doesn't even know what compression space is, let alon=
e
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
>
> > It's actually really confusing to represent this space as a traditional
> > swap device - built on the assumption of a pre-defined size limit - whe=
n
> > that size limit has already been defined (the memory itself).
>
> First of all, the traditional swap counter has a very well-defined
> meaning. It is the size of the memory that, when accessed, requires a
> page fault. A page fault adds significant latency to memory access

Yeah I agree on this. Swap just about makes resources not directly
accessible by the CPU act as RAM, whether that is storage on disk,
compressed memory, or a network resource, all accessed through a page
fault. I hope we won't make this fuzzy in the future by introducing
too many magics.
