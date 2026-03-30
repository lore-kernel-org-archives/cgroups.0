Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D7F288D0
	for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 21:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905492; cv=none; b=KgAWOBehpsUFEJ5LpAG6XjkyHOvhlqgOONcA/doOm693FuIyAlW0fHOJptJiKytrIc1xbhTW0RE5IFQxEvNwPXsmRI2BQZzfSDRpR+VmRY+IPmPkeI4PUaoPrG+7KfcnqoWPHP0olkusdPcSb3LuGlMah0WYwrFK1jBnC2r/l58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905492; c=relaxed/simple;
	bh=gST/9RRrMQTtXqyOvwpjZs+8sip20ZbFBGJzGchU/jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLHJlHLsfsWNKFTlDMP9BI0Pkm7a033Jw9dZHELOQB/IYhyw5gQuuU06aafwXejz3iSU9mwICGgkdNFB6BtRZIiAROQJpOio8XMlRLNfY8VM+w8Jh6xsw1SHDMPiudUXH+ghoypLGpJoQdcPjms9Km1mkgXqh2xErI2T5gTMExg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tDkSvbLf; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tDkSvbLf"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4042905015cso3024635fac.0
        for <cgroups@vger.kernel.org>; Mon, 30 Mar 2026 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774905490; x=1775510290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpynBP+G3ZnDHhHUsVCEALCguQRacTThLF+4zfYVNbU=;
        b=tDkSvbLfF5r/zlVNRlxJFgk+bYMyvRYlhgTVJC+jUlh8tpX6p0HOsbbTJq4LJhOwxg
         JgoVKfOhi0JZGKZ9HXN9bTl8IN8/yG1j1tnZS9IpyucGsCcOej9cTJrCtJUCADRxo9D0
         ykeCQhFdXQiFTFv9VyZuiq3n6WvqUTZUcbczuh5rWYf41cwAPdmQtpESIDq9Q2LggxiT
         /+NxNM05q3qAS59aDXyRtbxr3Oa6tckAYXDmmQkQ9iy41jWEnGNhIhrjpLUq42nOTZMY
         g6xGaXDJuPoreP/jbTKv+EVLJxhxaZ+9JJTHkLYvsr3nTHHQabVsJ77OEr1ZIJL77HQq
         ATTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774905490; x=1775510290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpynBP+G3ZnDHhHUsVCEALCguQRacTThLF+4zfYVNbU=;
        b=o5pz4FinXNWFjyozmEjczT7D7tfGzSOZiImwPmRQM75AyPcR5cdhmFz7G6zdbeK7Z4
         +CdV7zpEZgqJxBbfNL1hmHpUw9qauupDgAKYK3pDrBRLZ9M45uo9kQzUTnMHXTFZkD01
         uvJFWZfKt9O0eYRLhDclFzW0jPsFBKi883VHP8dUB4q+0PlLkyoYMbLOmotGvhtxkFOJ
         r4xCYEWFHSulyWtR5D8bGrUTTLVDGhgP5/i0zBDOlxwikamFs3xJxMh7B3XkJFJvKKAe
         7DynivWQ/WwwLJBF72ha2wmoqgebcGQieuWyryfjH+InQrxlhRiQFzuUxWIjMf4S4U1Z
         51mw==
X-Forwarded-Encrypted: i=1; AJvYcCXrZuAetnjOkP6Qn029m0rzp36Bqd5/FXyaRlegs8CCWV/IQgfWMUY9LClEQZMD49exXSBTZwyg@vger.kernel.org
X-Gm-Message-State: AOJu0YxM0zVMOZ3BnU1p8w3SoYLvWs+BaVjAkv+4eQfrkI2Y/eHQM23a
	AGQxhdQgBXXOO18KICwxXSjLbOKVTvaAfRB63JOQ/QKFjxf3/ghDdVIy
X-Gm-Gg: ATEYQzywrvTrVLxtR9oaReDktq0t3cJNOLik740fwOQgyCoTgTyNuKtxsXF0aBzMlgD
	+xsLlr89bMz1EulsS2AHmDixEbsGx81w3kDT480U2pIQjVRyZgQMZmfdjgEjPRgZrCCGBMZE/jy
	5TdKmFvSehqv0IShLYPYK+PpXtwTfsi4jjgFvB16EJVghIkIdxM/mqau2ybIT+u+pz11zxHFQD5
	KgrTqRnabjYLkpocM0JW33kVwzI6jE0mR3+9alXGJoq/VLJyUNQfidmlxl/enaIGr0Fnsemz1aJ
	R3mT/Jb8F/NbbR1kSPKuLzcYyjMI9MoXtMIqnRGyRTTbuOs6Gu6egcUJ6m6tpP0U/NnqGSwdF83
	3MDrAzQPDFscRnju/v8almEV1NgfruGMIJgP5wxWomFIvTIw3b3U/FuhjOvuKGVLGnlGtPMi5Pr
	OTzCX1ly0v7VVNT45l/rFmfg==
X-Received: by 2002:a05:6870:b30f:b0:41c:6512:8419 with SMTP id 586e51a60fabf-41cec27e409mr7957130fac.28.1774905489749;
        Mon, 30 Mar 2026 14:18:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d048e1984sm5978777fac.4.2026.03.30.14.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:18:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Mon, 30 Mar 2026 14:18:07 -0700
Message-ID: <20260330211807.349539-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <acqG2Mr5ekCn2HD0@tiehlicka>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 30 Mar 2026 16:21:12 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> > On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > 
> > > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > > to give visibility into per-node breakdowns for percpu allocations and
> > > > turn it into NR_PERCPU_B.
> > > 
> > > Why do we need/want this?
> > 
> > Hello Michal,
> > 
> > Thank you for reviewing my patch! I hope you are doing well.
> > 
> > You're right, I could have done a better job of motivating the patch.
> > My intent with this patch is to give some more visibility into where
> > memory is physically, once you know which memcg it is in.
> 
> Please keep in mind that WHY is very often much more important than HOW
> in the patch so you should always start with the intention and
> justification.
> 
> > Percpu memory could probably be seen as "trivial" when it comes to figuring
> > out what node it is on, but I'm hoping to make similar transitions to the
> > rest of enum memcg_stat_item as well (you can see my work for the zswap
> > stats in [1]).
> > 
> > When all of the memory is moved from being tracked per-memcg to per-lruvec,
> > then the final vision would be able to attribute node placement within
> > each memcg, which can help with diagnosing things like asymmetric node
> > pressure within a memcg, which is currently only partially accurate.
> > 
> > Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> > seems like a win to me. While unlikely, I think that we can benefit from
> > some amount of visibility into whether percpu allocations are happening
> > equally across all CPUs.
> > 
> > What do you think? Thank you again, I hope you have a great day!
> 
> I think that you should have started with this intended outcome first
> rather than slicing it in pieces. Why do we want to shift to per-node
> stats for other/all counters? What is the cost associated comparing to the
> existing accounting (if any)?

I went and ran a few tests, which seem to show rather negligible performance
differences (phew). I wrote a kernel module that does 100k percpu allocations
via __alloc_percpu_gfp with GFP_KERNEL | __GFP_ACCOUNT in a cgroup. I then
measured how long each allocation takes across two trials, one where I do
all 100k allocations and then free all of them at once, and another where I
interleave the allocs and frees. Everything below is ns / alloc, and the
+/- is the standard deviation across 20 trials.

+-------------+----------------+--------------+--------------+
|    Test     | linus-upstream |    patch     |     diff     |
+-------------+----------------+--------------+--------------+
| Batched     | 6586 +/- 51    | 6595 +/- 35  | +9 (0.13%)   |
| Interleaved | 1053 +/- 126   | 1085 +/- 113 | +32 (+0.85%) |
+-------------+----------------+--------------+--------------+

I'll include this, as well as the additional memory overhead that Yosry
suggested to include in a v2. I think we can get more accurate accounting
by distributing the obj_cgroup pointer size across the CPUs, so I've
gone ahead and made another iteration.

Thank you again for your insight, Michal!
Joshua
