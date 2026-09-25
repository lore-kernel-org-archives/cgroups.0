Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1FF3B5314
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367641; cv=none; b=uBcrMLAWAAfSXGVK5+73Pdq7dY2L1gzNqh7oltoiy/YJ6MkYXkth/nvVB6+Cs+nrJn48JrYkYYL42AAu9Qoh0w4MoCL4oODjFvFRybSP6Cq468fmbj2O3YBb9F/hx8zTVzoKw8yvFkhyXz5uMGK2jchuvGsZi1bhqokhB0QpqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367641; c=relaxed/simple;
	bh=jLtlM+dcV4vNFcRKCK3NS6KrvFDMXTg1LH4aBfPd9q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XalHZTScTqK/BFQCZhAzoyIKOMdlTeZZ5tfB/PR09RUBYoMOu9UzC5j/bh9VwgZIy6ba7QhzxjNGbDuIgCJGRSQXqJiZGDwYQzG9iXKC7qwy1tQLzSLfY8dEYd5eF2zq348waH0p+xL6W7j5q1l3fbRVdvVrR2z5zAGMgCFtVO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=LExt+f7K; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="LExt+f7K"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910ca5aa7so128892485a.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 13:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790367638; x=1790972438; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jHCr0O6x1oEoTdeKSMNckh0NZBgonxokbaxnCBlTws4=;
        b=LExt+f7K6CGlDCo+ccJ0C/qPcdEHZ7ysBk0LSmZ1AAxuQ0IpSJqmfkaPxvehYWy1GX
         JjcahiiMFDwiDdT9ZCOuIbGsbc1BKrcTkNr5cE0c0fLk7NKjN6a+3/TYrhCnCFDzIgbg
         5IxH19SIePnMUZD2kGUGHYDQN8JjCZBeu5np3a8LPTpvQLLeDGgeAQm1wGaZTMmABsNG
         AJcKz66sBUCoIMf90t4zR4Xqz22ImV38rvqGYEebOulEH6Hkzx0OeCNyxBO2AaKsF2wY
         MT+PB+/rzvj4jMNrgN0VMxsAiusjh4+tWK/csi8MKHpETLH8X0jgF2SHEsO2v3VrjF3c
         G0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367638; x=1790972438;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jHCr0O6x1oEoTdeKSMNckh0NZBgonxokbaxnCBlTws4=;
        b=rNjwV9ys1VTc8TDV6O35fdzHkCQ3AEyRBLnDbk3A7HIeqDcLC3AuRPG2Rn02fVrors
         0fkgvqnZ9Y6KUwmi1KtHUZfnKFlDZhuauq46pr+vx5qxkUE8UgDDQq1y0g9duIArXTnk
         3UtBO3csV+yB5l55JzzDretdPuluqfzGEbXpY27fqUndOcOabPjZEgjZQkSxtkQsbVeu
         M/vtv6eiD9ddJJsYE5n67mpnoy8vOiUGUVomqWROYIMses2y+Ab3mkyB+xvSkQPcrybR
         Q3dfQ8SdFy7QT/PES4ijeiSAou7C2dnd5CGKMldeHTBgsdjg9w4gR9rPHGZKi22O7Ydh
         zvuw==
X-Forwarded-Encrypted: i=1; AKwUvBwp4CVEaUcCg8kMiGk6E+uT0IaDWyqGuV002pv4JVVLrfSjYo1G+B8FBx9/uiy4zvUXifrCyIsN@vger.kernel.org
X-Gm-Message-State: AFuF++kVdYXY1yUvM0dbvEPI9n22TvAFe5Sd8jdoxNjMYm6R6CbPnOwt
	7PhB2btlvazwYONh1zftB82xMZMoP7wKZh4NFJ7LvD8d/5ynemfwWYaBzjZl25/uHJ8=
X-Gm-Gg: AYBFou0upWLqXt5tv3LGohAsrpOH23qv4q3OgSQKeygwAlQR3hXjUCN78BECgpwPbKe
	oPKFm4rc71DpLg2l/uPGgkgFlPmkZi5razcDwu27IauFV192rxoA48AHfO/6tJMsFfBoZ8b0xfX
	OCDyz2nNzn3dfXASdB/fJYfMFAqg1dcW2fkzMr4LQgx4N8k2NObiNULI4up4/F1Lz2Z/EpeX4TC
	gcHKdWpRorY26paKTcafqZwBeVv/vFhUQMjRqKjdmE0H3ZYrArGxl/OQlarqdRve/o3fpCjJItE
	ELd2rfC0YN9bU8n4dnhQNyKLrBqLjwM6zreB3oRpOOZBf11yv+lxGIBpJs182KbJtBhWOm+1Eqj
	jkQTd9UVWLT9XkOkUz+qmtFk033l7NQ4DX4yvaeKaHUNYpnOvKwOg96eXS/bJv3PUTzjXQxzJxJ
	ub8uLXa68CJE1+ipIIdSzruO911rKi4tBoZsJ7/9OJDEzujIM9LwHCr/+AmNdmU61WiwDD
X-Received: by 2002:a05:620a:40ce:b0:939:a9d4:7022 with SMTP id af79cd13be357-93c43b5acadmr649894985a.8.1790367637558;
        Fri, 25 Sep 2026 13:20:37 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c448b06c9sm260456585a.11.2026.09.25.13.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:20:36 -0700 (PDT)
Date: Fri, 25 Sep 2026 16:20:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Gregory Price <gourry@gourry.net>,
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbXkEQ1cwOVMqEy@cmpxchg.org>
References: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araWKyJ5MENBwXCL@cmpxchg.org>
 <arbHLt-iB4RHXyWt@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arbHLt-iB4RHXyWt@KASONG-MC4>

On Sat, Sep 26, 2026 at 03:21:30AM +0800, Kairui Song wrote:
> On Fri, Sep 25, 2026 at 11:41:31AM +0800, Johannes Weiner wrote:
> > 
> > Thanks for your thoughtful email, Kairui.
> 
> Hello Johannes,
> 
> > > I also want to separate two things that I think got bundled together
> > > here: not requiring a physical slot behind a compressed entry, and not
> > > charging the raw size to the swap counter. The first one is great, yeah,
> > > and it's exactly the part we want, it's what makes compression usable
> > > without provisioning disk. The second one is a policy change, maybe it's
> > > not needed for the first stage, charging a cgroup for the
> > > memories it has offloaded doesn't require any slot to exist behind them.
> > > If someone wants to run memory compression with no disk at all,
> > > memory.swap.max defaults to max, so that still works fine, right?
> > 
> > I think what we found out over the course of this discussion is that
> > people have been using memory.swap.max in two ways. Regardless of what
> > we do, we will "break" one side.
> > 
> > (1) The usecase you're describing. Use memory.swap.max, combined with
> > memory.max, to set a "total", predictable footprint of in-use
> > application address space. You can mmap whatever you want, but the
> > number of unique pages you can touch is limited to this sum. And you
> > can control residency vs non-residency through the invididual values
> > of those settings. If compressed entries are not included, this
> > usecase will break.
> 
> Right, thanks for the reply! residency vs non-residency is one of
> the issues here. It's also about how we consider these two kind of
> resources to balance the scheduling of containers.

Ack.

> > (2) The use case we have. Use memory.swap.max to divide a finite space
> > in storage. We only have so much space on disk, and we need to manage
> > fair access. Note that this isn't about speed. We have a mix of
> > containers where some use writeback and others do not. The ones who
> 
> Same for us, the usage is mixed.
> 
> > write back to the swapfile need to be able to get their fair share -
> > not more, not less. Including something that doesn't actually consume
> 
> Is that writeback compression rate based? I mean for zswap, you have to
> writeback uncompressable part, and then also do cold writeback through
> shrinker. The compressable part is hard to predict and control though?

It is compression rate based. And yes, the exact composition of what's
in zswap and what gets written back isn't very predictable.

We don't really care at the cgroup level, though. The goal at that
layer is isolation: a container gets a slice of memory and disk swap,
and the most important thing is that it stays within those confines
and doesn't become a noisy neighbor to the others.

We do care about workload health, too, but that sits one layer above
it. For example, we monitor memory pressure. If a workload expands
hard into (z)swap and starts thrashing, we kill it. But if it just has
a very large set of cold data that gets pushed into (z)swap without
any thrashing, we don't really care. Let it run. Maximizing
utilization in this case is more important than predictable capacity.

There is one exception, but it's narrow: when we run out of disk swap,
things can become very unstable. Especially when the workload is
mostly anon, and there is only a small share of file cache to absorb
pressure. So we kill when N% of disk swap is used.

But that's only for the cliff. If zswap didn't use disk slots, there
wouldn't be such a cliff. As long as you're within memory.max, put all
you want into zswap. We only kill if you start thrashing.

Neither of these need additional kernel interfaces. Just psi and swap
usage metrics that get polled every few seconds.

I think you could easily extend this mechanism to "predictable
capacity" by monitoring anon + shmem + a "vswap" counter and issue
kills when they go above some threshold you consider unreasonable.

It doesn't sound to me that you actually need synchronous,
cgroup-style enforcement for this? If a workload goes over, you kill
it within a few seconds.
