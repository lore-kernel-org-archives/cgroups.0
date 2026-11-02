Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585602;
	b=RiT2Odh2ZQm/uydbOJxywPYbBKgy52pbk8dQtOEgdmLpA6AxxAgweFaRiOtqSJHfnopm
	 8cVvYurKyngK5kz5GdMArQXt/C1lCoCkb+TH94KHOYEIz8RhAUvK8z9vOOkpOQv7IwEjT
	 ulhahexsUFcfsrllMAmZeO2cLPVQz6U9ip+AfY0iQrMqgdy6o3LlkjgcaCxel4nYv9fyZ
	 wvtOfNhcio1LRPMk72TMrKlikIhcVNySzKvj8THofE4wF+YYzUjnHZb4zJ6efZIKOUOKy
	 Lh0VgBXs0DP6OjDfUZjheQr/hvYqRLOKODt5J/hACjreoySsa6gx9XZGz4dkJYePoOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585602;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=yvz+MvufKgYbwZrvLEKvrENqTO+kH2u2+d8MLeEiziI=;
	b=X7JvR241/3AF5HbaZdCyzBauO6x1mnBwblD3jKp8UIK5vmHfFL9I2lnf3+FgMN3JBKIX
	 u6v5iAYIzrx+Njpn4vHTblK3r3rgdzZwo4T/sGu1Owi4AGHpgbgjvxFaCVYuHE8Zxt9Tu
	 jlyxMqR9jD3Z/x56vWnnAqZfabzPUyvGIstIRRfCCqJabujGI55c2rF8qb8AX0/uL08jb
	 XfahwmqT0jJSz24QO93GCCpO7DcyTYicy+qZyoExO8GFchKs92uguxzUhrme9j+4dBVR0
	 YEvSm+Cj7vSZCKUdpJ0yk5z+xOwhITWJOL0Tb3KoeH2bNuC06uck5AIZHgCbZO1PPLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Zw2xFXWL;
	arc=none smtp.remote-ip=91.218.175.251
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5C060A2604
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 02:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C5C060A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Zw2xFXWL
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kh1L9N4J0VwonxvRmIWkE389mycuzqTwy4u3dSvyNpo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793585599; v=1; x=1794190399;
 b=Zw2xFXWLjx47d25BX2FbVziM4ibfWj7pIjYmQrxrfL95ItYGXRscMVkixzrOfWc29apRYbAG
 Qe0VMc3L1HjzEAeb3kSSDGBUhFoJ1qGBO+Fseb/FwKQNUvXmOOfzkFZxGMd2Oa3MsbpQ+b4QsWH
 vlE+TZJj2eiLAlHcHWshlOBo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id d3db1ab78c0e22d4;
	Mon, 02 Nov 2026 02:13:19 +0000
X-Mizu-Trace-ID: d3db1ab78c0e22d4
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 10:13:12 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
Message-ID: <aufxuOaKZWMYqEQi@bogon>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-7-ridong.chen@linux.dev>
 <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>

On 11/01/26 at 05:21am, Barry Song wrote:
> On Sat, Oct 31, 2026 at 5:02 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> >
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> > youngest generation. There is currently no tracepoint on this path, so
> > the moment a new generation is created, and how the min_seq of each type
> > trails behind it, cannot be observed as it happens.
> >
> > Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
> > the lruvec lock is still held, with the node id, memcg id, the new
> > max_seq, the anon and file min_seq, and the number of pages in each
> > generation for both types, summed over zones and clamped to >= 0 the
> > same way the debugfs lru_gen file reports them. The nr_anon/nr_file
> > arrays are indexed by generation slot, so the emitted max_seq/min_seq
> > say which slot holds which seq. They are printed with __print_array(),
> > so the output is hex and its length follows MAX_NR_GENS automatically.
> >
> > Only the lruvec is passed in; all of the above is collected in
> > TP_fast_assign(), so inc_max_seq() does no extra work when the event is
> > disabled. Paired with mm_mglru_scan_folios it makes the full
> > aging-to-eviction window observable per memcg.
> >
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > ---
> >  mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
> >  mm/vmscan.c       |  2 ++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> > index 8148b8224422..cddf42b5849a 100644
> > --- a/mm/trace_vmscan.h
> > +++ b/mm/trace_vmscan.h
> > @@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
> >                 __entry->min_seq)
> >  );
> >
> > +TRACE_EVENT(mm_mglru_inc_max_seq,
> > +
> > +       TP_PROTO(struct lruvec *lruvec),
> > +
> > +       TP_ARGS(lruvec),
> > +
> > +       TP_STRUCT__entry(
> > +               __field(u64, memcg_id)
> > +               __field(unsigned long, max_seq)
> > +               __field(unsigned long, anon_min_seq)
> > +               __field(unsigned long, file_min_seq)
> > +               __array(unsigned long, nr_anon, MAX_NR_GENS)
> > +               __array(unsigned long, nr_file, MAX_NR_GENS)
> > +               __field(int, nid)
> > +       ),
> > +
> > +       TP_fast_assign(
> > +               struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > +               int gen, zone;
> > +
> > +               __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
> > +               __entry->max_seq = lrugen->max_seq;
> > +               __entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
> > +               __entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
> > +               /* summed over zones and clamped to >= 0, as debugfs lru_gen does */
> > +               for (gen = 0; gen < MAX_NR_GENS; gen++) {
> > +                       __entry->nr_anon[gen] = 0;
> > +                       __entry->nr_file[gen] = 0;
> > +                       for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> > +                               __entry->nr_anon[gen] +=
> > +                                       max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
> > +                               __entry->nr_file[gen] +=
> > +                                       max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
> > +                       }
> > +               }
> 
> I feel this is wrong. Can we calculate the newest and
> oldest generations from seq, then print them in order
> from newest to oldest?

Agree, from newest to oldest or oldest to newest makes it clearer.

Printing from lrugen->max_seq - MAX_NR_GENS + 1, or from MAX_NR_GENS,
both looks good.

> 
> The nr_pages[] array isn't ordered from newest to
> oldest or vice versa, as we have:
> 
> static inline int lru_gen_from_seq(unsigned long seq)
> {
>         return seq % MAX_NR_GENS;
> }
> 
> And I added a helper here:
> https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/
> 
> +static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
> + int type, unsigned long seq)
> +{
> +     int gen = lru_gen_from_seq(seq);
> +     unsigned long size = 0;
> +
> +     for (int zone = 0; zone < MAX_NR_ZONES; zone++)
> +          size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +     return size;
> +}
> 
> Maybe you could port it here as a separate patch so it
> can land earlier as part of your tracepoints series. We
> could then use it in the next version of the swappiness
> series.
> 
> Best,
> Barry
