Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A4363096
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 05:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787118683; cv=none; b=mvG7mQZg3Oix5AWMdCmW6vVue5kXYUsY1r09xq0i5fUIhGBY9XL7gtBNMb43jI8rKw8bZNrCU6ujIIzM4VDvniscCS6fIqg1KBf56bxTNGQ7MoCPourXlv8fZG6dbPW7x6AfZw0z+ONYfJUty8lLp1puCe5otRT/t9ci5Y6imZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787118683; c=relaxed/simple;
	bh=GutywA5AAqyAglt6L6YV6043p4VoA3ACM1z8cRfshbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VukD6mU9i3RGDkod2S2IvvcAF644XIrIzIUZ/UHA9NCtMp8atPbC+OILMzmFqxI8hUUy1ZQbiqExX4Qj/Rlu2DVvpbT4xjzMvSNLrdYNDAQxTjOxlarPovF4JwlGENk/KmDTZkOZWMqxvg2aroNBqZbwOctOatVNBZf2n5ZIBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JHuOx3y1; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JHuOx3y1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GutywA5AAqyAglt6L6YV6043p4VoA3ACM1z8cRfshbM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787118678; v=1; x=1787723478;
 b=JHuOx3y1jaYJa0ZwYGWqjxLdTgCrm16w0oOjsCQhIU59PAUqGgRsm1Vp58Ob5hakJePVLZae
 RvIXyqF4N/WITBUgcBABQO7wsEbq83Hh/NJCWPxSBmK+zhk1XZYFkVSmTFy3AcalbjqxSZG5J2F
 +2fTWYigXgiyieLEU/jYTRRY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id bfce453c5b9e4543;
	Wed, 19 Aug 2026 05:51:18 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 13:51:05 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset
 promotion (MGLRU-FG)
Message-ID: <aoVESTB1u6CiFlgm@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
 <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
 <CAMgjq7C1nFb92FGE+uSapZZS+14R95OG9w8ji+ZBkF=fOQ2Eag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7C1nFb92FGE+uSapZZS+14R95OG9w8ji+ZBkF=fOQ2Eag@mail.gmail.com>

On 08/18/26 at 03:40pm, Kairui Song wrote:
> On Tue, Aug 18, 2026 at 3:12 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> > ...snip...
> > > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> > > +{
> > > +     int max_gen, min_gen;
> > > +     int type, refs, gen, new_gen;
> > > +     unsigned long new_flags, old_flags, max_seq;
> > > +     struct lru_gen_folio *lrugen;
> > > +     struct lruvec *lruvec;
> > > +
> > > +     type = folio_is_file_lru(folio);
> > > +     lruvec = folio_lruvec_live_get(folio);
> > > +     lrugen = &lruvec->lrugen;
> > > +
> > > +     old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > +     do {
> > > +             new_flags = old_flags;
> > > +             gen = lru_gen_from_flags(old_flags);
> > > +             refs = lru_refs_from_flags(old_flags) + 1;
> > > +             new_gen = gen;
> > > +             if (!(old_flags & BIT(PG_lru)) || gen < 0)
> > > +                     goto out;
> > > +
> > > +             max_seq = READ_ONCE(lrugen->max_seq);
> > > +             max_gen = lru_gen_from_seq(max_seq);
> > > +             min_gen = lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
> > > +             if (gen == max_gen)
> > > +                     goto out;
> > > +
> >
> > I am a little confused about the new mechanism. In the current mglru, it
> > does have the issue both mm walk and fd read set PG_referenced at the
> > 1st access, this is a obvious drawback. Now with the change, the ref
> > count is clearer, while the mm walk and fd read accessing is still mixed.
> > Imagine the cases below:
> >  - one fd read; then mm walk; directly move to max_gen;
> >  - one mm walk; then several times fd read; promote to next gen;
> >
> > Can I understand the final effect as:
> > 1) explicti ref count;
> > 2) more drastically promote mm walk based on the mixing ref counting;
> >    - compared with the old behaviour: move to next gen when 2nd mm walk
> 
> Hi Baoquan, Thanks a lot for the review!
> 
> The old behavior is move to max_gen on walk access (unless it's the
> first access of a folio), and only protect non-mapped folios with PID
> refaults. Now, the non-mapped folios are also promoted after multiple

You are right. For old mm walk access, the gen passed to folio_update_gen()
is lru_gen_from_seq(max_seq). Then it's the same as the old behaviour. I
was mistaken on reading code, and was surprised when I got the wrong
perception.

It's great I was wrong and the performance improvement is a lot.
When I reviewed this patchset and tried to understand it and esp
compared it with the old mechanism, I realized mglru-fg adds quite
a bit of complexity:

old (before MGLRU-FG):

- aging walk (mapped folio):
  - 1st access: set PG_referenced
  - 2nd access: move to max_gen, set PG_workingset; proactive
  - LRU_REFS_MASK not used for page-table accesses
- fd read (unmapped folio):
  - refs accumulated in LRU_REFS_MASK (1→4)
  - at refs=4: set PG_workingset; lazy promote, no gen bump
  - protection only via PID refaults at eviction; passive
- PG_workingset: once set, kept until reclaim/clear_refs
  → tier stuck at 3 regardless of current hotness
- refs cleared on every gen bump (folio_inc_gen / folio_update_gen)
- isolate_folio: if !PG_referenced, refs cleared

new (MGLRU-FG):

- aging walk (mapped folio):
  - 1st access: gen+1 (was: no gen change)
  - 2nd access: move to max_gen; proactive
  - access in max_gen: refs accumulate 3→7 (capped, no further promote)
  - after aging advances (folio falls behind max_gen): promote again, refs capped back to 3
- fd read (unmapped folio):
  - refs accumulated in unified refs (1→7)
  - in min_gen with refs≥2: promote gen; proactive (was: passive)
  - refs overflow >7: force promote
- PG_referenced/PG_workingset: now the low 2 bits of refs, no longer independent
- refs capped at WORKINGSET(2) by folio_inc_gen (PID protection)
- refs capped at PROTECTED(3) on promotion
- refs never decays with time; only madvise/reclaim clears
- isolate_folio: no longer clears refs

It adds more details and cases into the mechanism for us to understand
and take care of.

Another thing is now mapped folio and ummapped folio share ref counter, 
for mapped folio, it will accumulate ref counts if already in max_gen
(in folio_inc_lru_refs_walk()), and are capped back to 3 on the next
promotion. So it adds ref count but for nothing?

Anyway, thanks for great work, detailed explanation. 

> accesses.
> 
> The promotion is more proactive but not that drastic; it still
> requires 8 accesses (2^3, which overflows tier 4) to force promote one
> folio.

> 
> For anonymous pages, this also provides a more consistent and explicit
> reference count mechanism, and you will see folios distributed fairly
> among tiers now, as repeated page table access will increase the refs
> above LRU_REFS_PROTECTED. Previously, all anon folios were stuck at
> tiers 0, 1, and mostly 3, skipping tier 2 completely.
> 
> Also we reduced the bit usage by 1.
> 
> This new mechanism is supposed to work as a whole, This new mechanism
> is supposed to work as a whole; it is documented and described in the
> chunk of comments in mmzone.h (maybe not the best place but old
> MGLRU's comments are there so I just updated it inplace). I tried to
> split it into smaller parts, which doesn't seem doable.
> 
> And I think the three folio_inc_lru_refs* helper are also kind of self
> explaining on this.
> 
> > I can only see one benefit and one significant change. Do I understand
> > it correctly, and is it worth?
> 
> I think it's definitely worth it, if you look at the results in the
> cover letter :), especially the zipf access test (1.2, 1.1, 0.9, 0.8
> have similar results, zipf is commonly used standard to simulate
> realworld access patterns) and a few other cases; 90% of the
> performance gain comes from this design. I tweaked the refs &
> promotion rule many times to double check and ensure it fits well for
> different workloads.
> 
> And note that this is not an anon/file reclaim balance tradeoff issue,
> both anon refaults, file refaults, and pgpgins are reduced, meaning
> MGLRU is doing better at protecting both hotter anon and hotter files.
> 
> It's widely complaines that MGLRU was actually performing poor on
> unmapped folio protection, worse than classical LRU in many workloads
> (Not the LRU overhead, MGLRU had lower overhead, but the actual
> ability to protect the hotter cache is not good, provable with the
> zipf test in the cover letter). After this change, its performance is
> obviously better than that of classical LRU.
> 
> Attachment: a typical tier layout of a workload before this change:
>  node     0
>          35       3910      37524           0x
>                      0        238r      15596e          0p          0x
>          0x          0x
>                      1        409r       6429e       6211p          0x
>          0x          0x
>                      2          0r          0e          0p          0x
>          0x          0x
>                      3        895r      39182e       8588p          0x
>          0x          0x
>                                 0x          0x          0x          0x
>          36       3244      84684           0
>                      0          0x          0x          0x       2882r
>       6059e          0p
>                      1          0x          0x          0x        448r
>        964e          0p
>                      2          0x          0x          0x        298r
>        439e          0p
>                      3          0x          0x          0x        416r
>        721e          0p
>                                 0x          0x          0x          0x
>          37       2858     221580        4269
>                      0          0x          0x          0x          0x
>          0x          0x
>                      1          0x          0x          0x          0x
>          0x          0x
>                      2          0x          0x          0x          0x
>          0x          0x
>                      3          0x          0x          0x          0x
>          0x          0x
>                                 0x          0x          0x          0x
>          38       2183      29167         242
>                      0         12R       2499T          0x       2496R
>       4101T          0x
>                      1        322R      29241T          0x         92R
>        156T          0x
>                      2          0R          0T          0x        100R
>        144T          0x
>                      3        150R      75764T          0x        741R
>       1161T          0x
>                          20903930T    5439295Y      48822F      19595A
> 
> And after:
>  node     0
>          47       3227     197247           0x
>                      0        967r      35231e          0p          0x
>          0x          0x
>                      1        412r       6871e       1051p          0x
>          0x          0x
>                      2         12r        639e       2319p          0x
>          0x          0x
>                      3          0r          0e         49p          0x
>          0x          0x
>                                 0x          0x          0x          0x
>          48       1623      49290           0
>                      0          0x          0x          0x       2065r
>       3586e          0p
>                      1          0x          0x          0x        338r
>        836e          0p
>                      2          0x          0x          0x        352r
>        817e          0p
>                      3          0x          0x          0x        107r
>        139e          0p
>                                 0x          0x          0x          0x
>          49       1491      91927        4865
>                      0          0x          0x          0x          0x
>          0x          0x
>                      1          0x          0x          0x          0x
>          0x          0x
>                      2          0x          0x          0x          0x
>          0x          0x
>                      3          0x          0x          0x          0x
>          0x          0x
>                                 0x          0x          0x          0x
>          50       1305      10444         674
>                      0         69R       6630T          0x       1082R
>       2586T          0x
>                      1         21R       2509T          0x         55R
>        168T          0x
>                      2         71R       2322T          0x        111R
>        288T          0x
>                      3          0R          6T          0x        114R
>        619T          0x
>                          31126090T    7780753Y      72142F      27409A
> 
> For file heavy workloads, the file folios are also now fairly
> distributed amon gens instead of being stuck at tail gen. And it's not
> just looks prettier, the performance is indeed better.
