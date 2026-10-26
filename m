Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793030382;
	b=qkupRYRWZz4fKFDnz+ccB0NpmoTVvhH49V/ztK+knWl8URgpJhqVCqcrfJI4zb8q/Fuv
	 m69QhhuTtbRKINbWnst//fFtlPo/5Ba8On1Gew4ZsLTYau7e0jZrd/RH74WVKpeJTdH5k
	 j+wv+VHfMtkd5ywKLIA3DZl6OLDxCtw9QUN6IdDtmQ73C2t5UqIT1UaCbMWu+unKUagjG
	 tlCRvbEsrvfDOvv4cmjF6tPsacr38IkT+VFLRcbh6HCBWxIEVme2iixfvEW46oVTtDxmp
	 kTnXlsNkevDTvEGUaYzIWVCm/0QFTJLXPND0wbCLpERMCwp1jn+A63wcO7sB9CsHr2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030382;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
	b=tIk9RBg4gMDCAxirEcZtgxaorKG4APXR9UgiHs6z40l0hRhVSuH6WdTICqsvVt+loBw0
	 lWv+auwrhrHBehjCEgHWG5Ki77KMwDSHlHxKYLUF0JIjp9ViN3jQ/I6ksKk9gD/hGJJ12
	 5F2ejQ9ki+U3J7VGoLXh+1R+oxYXKzJqEeaHxpuoqaVKUwmbIKSqM5XF65f873eamBPaV
	 RYlQ5239r6DxXmauzGEzCX7MMk83qnWZ3qRjM0LsxVHrIfUTYpST0UOGeUS0DqLv2ULbt
	 79knV0+1VhR5aqq/Pt7kfeW+kpG11yCyi4voypOFXrF5/hiGLM0x+oYT+4bajkTMwBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DA2DFM4Z;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC3606A323
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 15:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3EC3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DA2DFM4Z
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0f59a5fdeso25149507b3.1
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 08:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793030381; x=1793635181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
        b=DA2DFM4Zd3DOn2rt+kh83wezos2v0REG1XBW8LFLLBucRuH1ewVDcBRpeIc/cXC2Xs
         7VCHLH5eKztHc4b5PSpP1vK3Ftl+HVFCdBZhec+u8t0H1io2Rjo9DyCYSYUe25Ng06pu
         8n3mNhSAeI4OlaM/BsKCs1dmuUh41uQ6DSiOhMvVQFDZjw2aklrToGPlvb5xBIVC3n7s
         MweAB/I92iNIGbpXBjFmxYmIeRauLL08XpuKgDD/Qm04Ec2TzYZ9fOxNZ+OLUf+fyObt
         Wzj/7fUqwNW0JUqF2aiIsqOG7hoHkR6cCxJdgYkeHIJjEfGzw99NuN1QkiORSq+XzVZ+
         BM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793030381; x=1793635181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
        b=25TT/xUeA9/r+fjYGruqKanIKndx331xee5BZrN61x+kAJT0p22zZZUl6oUF7dLYM1
         U+BHodK1l2pq8BGdumOXBACV02frXq7+5t7lNaAMJjt4K6kFzYCBibXnUcSGar1mF8+9
         c5f9S1dSJfheaS1oQwVYwSnVAPYbf1C0XYYYPJlLjVwnMzSOAUFMeDtNn/vzbrmTM7Io
         px57acllyvzhon1T/2SL48gDQe6x7fIoEI5N1ThKjsmBtCKyvk8Yx8vGZi5tNqBqTAfJ
         VleZf0GJ3BhB5Vzh0Nv/2nwE1Z65d2Rs+vu2Hea2WNzmny4UqZnV9iiPJhb6tVwF4yCX
         Z/NQ==
X-Forwarded-Encrypted: i=1; AKwUvByeZG6nanIkDfw06ou1Yt6yWo6C3fEHJg6oO3r0MgPDwQL48i+2ejezouMbxwZktsEBtOSbZNmA@vger.kernel.org
X-Gm-Message-State: AFq9FYIa6g6VXRfa0W+Hj5/mnbgtQUd+0wVT07akczUFoEZloa89HWSv
	KTkbm60uhb2ASzaEEmGi/7FuUzCQkMlvCFI0HMcmlGBxzvuhCje0614P
X-Gm-Gg: AYBFou0HXACmBqT5UqiySGVjPbLm3aIDTNoy4LE6xlicW59Ez36/54KPliQGKY50EVy
	5lDnuCSKFKYMC6DmsswlTTTWwvPx5e6uCJn995LlFz/QR9lkQoPPw3a5Q60emn8UqSu0zSs+YYI
	PYCqs8rwr8mvqdL27cQGaq5Rw+GbwcmQXVeRsI83IucOVgDJz0zNkdgN7DAiOB3ZmHu/BUqnZN5
	hdE5D0RX3lRVj/lKymz4szE+qR0fTCFVeAENehe8MUZ9b0Q8Ay8geq6TkexJqYIlxE7yrplo/gr
	22Id0PsaRc7IuykB/vsuThhPaOsfidrMRMWZbdWMDO3Jutd7euRTBjQh/oNoBxsCz8hVM41Mnbv
	lUNeeEOXDuNfeP9xZpoOxHA/NHXFJlzCuYLQyj+ymUKJkiZF0AGVuBLfQTF+bD+lkfc8QX0nUR5
	urSw6z3kqZFBT2ww0ooCbTWNMaaBtG7QjN/MCEecrS4wD7tPeerWz9AX6ksYE08uNtmxLkBfYqt
	Jd+wORLFkReXYvmQEsptBJF960ilNpp1ou4AkKuCi3wcYmVN0DuIEIWWY+lOLPcECWf3Vt2WhLI
	+yA3uwfI5Gc=
X-Received: by 2002:a05:690c:e3cc:b0:8b0:d4bb:c9e7 with SMTP id 00721157ae682-8b166c476edmr51979547b3.46.1793030379764;
        Mon, 26 Oct 2026 08:59:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166dd01c0sm32803247b3.7.2026.10.26.08.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:59:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon, 26 Oct 2026 08:59:37 -0700
Message-ID: <20261026155937.1235453-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <at8XfoqWwe9HSL9y@tiehlicka>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 26 Oct 2026 10:03:58 +0100 Michal Hocko <mhocko@suse.com> wrote:

> [Sorry for coming to this really late]

Hi Michal, no worries at all : -) Thanks for taking a look!

> On Wed 21-10-26 15:55:09, Joshua Hahn wrote:
> > v6 --> v7
> > =========
> > - Preserve two cgroup v1 proprerties that previously followed implicitly
> >   from sharing a stock:
> >   - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
> >   - Reclaim does not swap when memory and memsw have equal limits.
> > - Wordsmithing commit messages for 4/5 and 5/5 to document the
> >   cgroupv1 divergence (bounded) between memory and memsw caused by
> >   independent stock.
> > 
> > INTRODUCTION
> > ============
> > Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> > allocations do not walk the page_counter hierarchy every time.
> > Today, the stock implementation is within memcontrol code, even though
> > the operation it caches is a page_counter charge. This makes it
> > difficult to add new page_counters to a memcg and preserve the fast
> > path behavior.
> > 
> > This matters for future work like my tiered memcg limits series [1]
> > which introduces multiple new page_counters to memcg. Without making
> > stock a page_counter-level property, it means that every memcg charge
> > now goes through multiple page_counter hierarchy walks, instead of
> > being able to cache these charges.
> > 
> > To make future page_counters scalable and performant, move stock from
> > mem_cgroup to page_counter so that each page_counter can opt into its
> > own per-CPU cache of pre-charged pages.
> 
> What does it mean that each counter can opt into its own per-cpu
> caching?

So right now for cgroupv2, there's kind of a 1-1 mapping between
page_counter and memcg. I say "kind of" because there still is a
page_counter for swap, but it takes a completely different charging
path (i.e. not try_charge_memcg).

This means that currently stocking charge for memcg is equivalent to
stocking charge for the memcg->memory page_counter.

However, one of the series that I'm currently working on [1] adds new
page_counters to struct memcg to track the usage of memory
per-memcg, per-tier. The goal is to (1) track how much memory of a
cgroup lives on which tier, and (2) to limit the usage so that a single
cgroup doesn't use up all the fast tier memory alone, and shares it
fairly with all the other cgroups on the host.

When adding a new per-tier page_counter to struct mem_cgroup that gets
charged for every memcg_charge, I cannot use the stock fastpath since
the stock does not distinguish where the memory resides. It would
essentialy boil down to this pattern:

try_charge_memcg
   \__ page_couner_try_charge(memcg->tier[0])
   \__ consume_stock()

Where every path still has to do a hierarchy charge to the tier it's
charging to, whereas this patch gets us:

try_charge_memcg
   \__ page_counter_try_charge(memcg->tier[0])
          \__ consume_stock(memcg->tier[0])
   \__ page_countertry_charge(memcg->memory)
          \__ consume_stock(memcg->memory)

So that we can avoid the hierarchy walk for most charges.

I'd be happy to submit a new cover letter which better explains this
idea!

> > We get an added benefit of simplifying try_charge_memcg(), which now
> > has all the stock management handled transparently within the
> > page_counter layer.
> 
> This is quite a large change and I believe it will be really benefitial
> to have some high level design overview in the cover rather than trying to
> chase it in respective patches.

Sounds good with me. I can add the call traces above which should
explain my thought process a bit more. Hopefully the problem I am
trying to solve is evident there.

> Namely, are there any changes to the locking (which is arguably quite
> tricky to allow completely lockless fast path)?

No changes to locking. In fact this series is mostly just moving code
from mm/memcontrol.c to mm/page_counter.c, everything is essentially
the same. 

> Also what are implications to caching at different levels of the
> hierarchy? An example of cache propagation up/down the hierarchy during
> charge/uncharge/draining would be really useful to wrap ones head around
> how this is supposed to work.

This series should not have any changes for cgroup v2, including when
and where the cache is stocked / drained in the hierarchy. I can
include a snippet on how stocking currently works to add a visual
explanation, if that helps too.

> > EFFECT ON MEMCG V2 USERS
> > ========================
> > This series has no functional changes intended for memcg v2 users. We
> > preserve all draining, refilling, and (un)charging behavior, including
> > the uncharge path's refills / direct uncharges.
> > 
> > EFFECT ON MEMCG V1 USERS
> > ========================
> > For memcg v1 users, the decoupling of the memsw and memory stock means
> > that each of them now manage their own independent stocks and can lead
> > to a different size of precharged cache for each.
> > 
> > Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
> > than or equal to memory.usage_in_bytes, because memsw is a superset of
> > memory. With separate stocking, this could have been broken in scenarios
> > where the memory stock is bigger than the memsw stock, leading to
> > memory usage appearing to be inflated and greater than memsw usage,
> > even though the real usage preserves the invariant.
> 
> How can this happen when counters are always charged together?

Yeah, so this part is a little bit annoying. Let's just look at a single
leaf cgroup for example, where the limit for memsw and memory are both
64 pages.

charge_memcg(64)
	raw memory: 64			raw memsw: 64
	reported memory: 64		reported memsw: 64
	memory stock: 0			memory stock: 0

swap out 32 pages
	raw memory: 32			raw memsw: 64
	reported memory: 32		reported memsw: 64
	memory stock: 0			memsw stock: 0

free 32 pages
	raw memory: 0			raw memsw: 32
	reported memory: 0		reported memsw: 32
	memory stock: 0			memsw stock: 0

charge_memcg(1)
	raw memory: 1			raw memsw: 33
	reported memory: 64		reported memsw: 33
	memory stock: 63		memsw stock: 0

Where the last charge_memcg() causes the inversion. memsw tries to
charge a batch of 64 to refill the stock, but fails since 32+64=96
puts the memsw over its max limit. So it falls back to direct charging
where it charges the page_counter directly, and ends up with 0 stock
and reporting a usage of 33.

On the other hand, memory will greedily refill the stock with 64 pages
and since usage is 0, the batch refill will succeed, and it will report
a usage of 64.

So the idea with reporting the minimum is to report the minimum of the
two reported values, we will just fuzzily report the stocked value.
IIRC usage_in_bytes has always been fuzzy anyways, due to how much
memory has been stocked.

Thanks again for taking a look, Michal! I hope you have a great day : -)
Joshua

> -- 
> Michal Hocko
> SUSE Labs

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
