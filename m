Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793843904;
	b=5HE8H+s92O05FaW7kaRSe6qaOzTSIqDWY16JuJSuqNtMiy/I03RHfcQCVNMikyBoVn1e
	 vQLJlcwlWBtlceT/hjj8+nwOf2wYg1rcXnr2Si3NeKK4GGaRY23A/6Z7wFx/62I9PD7eB
	 xQq+y4ZVkJkCknxxjg/C8yWrSXIy/Bw6tQp1B6z0nZLJRgr18corV3y67Fi9q4Eo2RhnD
	 6X7CEOO1mT7vD0NhH7+U9RK+BWqjm/jZDS5/0VbWTI42Zr8QU+LvsEasOoCYfQ3+8tEAa
	 XutQBq8iE68ccPhtKHbOyI63/Zbv1tlxt6b3n3KLfzN0e78bZBBTrIm9F1D2zQC4J6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793843904;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=kkfpYua5cYTgKG0pQiNdMFsj1/CFOQNS4WMIfupofhA=;
	b=4gwNN164RIStBK1vLNVMzQtker0DHRa0vOsuG68zABiDOPKM7ogj0C2JZqtS5y5VWEvC
	 2J8SYBDT1eCF/sVNsZiP71VJOhkwh3rnIKoZwpLj+gyahBmlbjP00E0drbCG/qxbL/9Hh
	 Ez6hbMslKa4OM0cpFzdjruCyEW3BbWURCMKEb7CEBUK3qpNmSziWvIwx2hW+Hyz4xc9Na
	 UtJpPSxGwe3Nn9GZD2TXHHxUBGjBPLEHzSATCM1lnc0Rnq8gnBRHvy4o0UsrFEELs0fnO
	 tkKmjGnLEluFpMjTWY3rmR+niEWv96N44P6gdMkvLE9oB7VbfPiYKzmuhBQPXnsO5aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JCJnDqsr;
	arc=none smtp.remote-ip=95.215.58.227
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7E8606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 01:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C7E8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JCJnDqsr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gZlY+lL7fdgfCyQVenuD4E5PVkQaAHWWt10XOZ4LvLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793843901; v=1; x=1794448701;
 b=JCJnDqsr5gDCg4Ok7Z+jJ84EBXR21P1ESBXhE5mntiy0NMDTOc3tWKQjnPLh7QLvulPSZwQo
 1xuTTuhBlkGiHw/IxWKPXHEbawARxARw/nhRlYonqvxxxoheRGUGyiGjazg6d4OyFKL5SQll0+6
 v1AL4qqFT6e8vZwyRZcoNGuo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id d8b7aae3e53a8f40;
	Thu, 05 Nov 2026 01:58:20 +0000
X-Mizu-Trace-ID: d8b7aae3e53a8f40
X-Migadu-Flow: FLOW_OUT
Date: Thu, 5 Nov 2026 09:58:10 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
Message-ID: <auvisj8NeTJ8FunG@MiWiFi-R3L-srv>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev>
 <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
 <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>
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
In-Reply-To: <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>

On 11/05/26 at 09:48am, Ridong Chen wrote:
> 
> 
> On 11/5/2026 4:56 AM, Barry Song wrote:
> > On Wed, Nov 4, 2026 at 9:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> > > 
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > > 
> > > Aging in MGLRU advances max_seq to create a new youngest generation.
> > > It is triggered from try_to_shrink_lruvec() when should_run_aging()
> > > finds that eviction is no longer possible, or that it would be better
> > > to age first at the current priority. There is currently no tracepoint
> > > on this path, so it cannot be observed when and why aging is needed.
> > > 
> > > Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
> > > try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
> > > swappiness, max_seq, the anon and file min_seq, and the number of pages
> > > in each generation for both types, as computed by lruvec_gen_size().
> > > 
> > > The reason for aging is not reported explicitly, as the logic in
> > > should_run_aging() may change, e.g. for imbalance-based aging. It can
> > > be derived from the generation window and the per-generation sizes,
> > > which are taken before aging, so the youngest generation is populated
> > > as well.
> > > 
> > > The nr_anon/nr_file arrays are ordered by seq rather than by generation
> > > slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
> > > they go from the oldest generation to the newest, the same order as the
> > > debugfs lru_gen file, so the output can be read directly without mapping
> > > slots back to seqs. The arrays are printed with __print_array(), so the
> > > output is hex and its length follows MAX_NR_GENS automatically.
> > > 
> > > Only the lruvec, sc and swappiness are passed in; everything else,
> > > including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
> > > does no extra work when the event is disabled. Reading max_seq there
> > > rather than using the caller's copy keeps the window consistent with
> > > the per-generation sizes read right after it, should another reclaimer
> > > age the lruvec in between.
> > > 
> > > The event marks the aging decision, not its result: the following
> > > try_to_inc_max_seq() may find that aging is already in progress or
> > > done by another reclaimer, so concurrent reclaimers can each emit it
> > > for the same max_seq. Whether max_seq was advanced can be seen from the
> > > following mm_mglru_scan_folios.
> > > 
> > > Suggested-by: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > ---
> > 
> > Much better now:
> > 
> > ~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_aging/enable
> > ~ # ./a.out
> > Mapped 400 MB at 0xffff98a00000
> > ^C
> > ~ # cat /sys/kernel/tracing/trace | grep mglru_aging
> >           kswapd0-49      [001] .....   104.277689: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=6 swappiness=60 max_seq=3 anon_min_seq=2
> > file_min_seq=1 nr_anon={0x0,0x0,0xd360,0x0}
> > nr_file={0x0,0x23e2,0x0,0x0}
> >           kswapd0-49      [001] .....   104.536448: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=3 swappiness=60 max_seq=4 anon_min_seq=2
> > file_min_seq=2 nr_anon={0x0,0x20,0xf8bc,0x0}
> > nr_file={0x0,0x91a,0xbd,0x0}
> >             a.out-79      [000] .....   104.689518: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=4 swappiness=60 max_seq=5 anon_min_seq=3
> > file_min_seq=4 nr_anon={0x0,0xf8a0,0x1188,0x0}
> > nr_file={0x0,0x0,0x2,0x7}
> >           kswapd0-49      [001] .....   107.282038: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=6 anon_min_seq=4
> > file_min_seq=5 nr_anon={0x0,0x6c50,0xa168,0x605}
> > nr_file={0x0,0x0,0x98,0x18}
> >           kswapd0-49      [001] .....   107.812598: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=7 anon_min_seq=5
> > file_min_seq=6 nr_anon={0x0,0xfe10,0x1721,0x54}
> > nr_file={0x0,0x0,0x1a,0x3}
> >             a.out-79      [000] .....   108.936872: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> > file_min_seq=7 nr_anon={0x8,0x7d29,0x8c54,0xc90}
> > nr_file={0x0,0x0,0x4,0x2}
> >           kswapd0-49      [001] .....   108.937115: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> > file_min_seq=7 nr_anon={0x0,0x7d15,0x8c94,0xcac}
> > nr_file={0x0,0x0,0x4,0x2}
> >           kswapd0-49      [001] .....   109.425258: mm_mglru_aging:
> > nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=9 anon_min_seq=7
> > file_min_seq=8 nr_anon={0x0,0xed69,0x24bc,0x488}
> > nr_file={0x0,0x0,0x3,0x3}
> > 
> > One thing that looks a bit weird, though. For example:
> > 
> > max_seq=3 anon_min_seq=2
> > 
> > We have only two generations for anon, but we print four:
> > 
> > nr_anon={0x0,0x0,0xd360,0x0}
> > 
> > The two oldest generations don't actually exist. Ideally,
> > we would print only the two existing generations:
> > 
> > nr_anon={0xd360,0x0}
> > 
> > you should be able to fix it by:
> > 
> > __print_array(__entry->nr_anon, __entry->max_seq -
> > __entry->anon_min_seq + 1 , sizeof(unsigned long)),
> > __print_array(__entry->nr_file, __entry->max_seq -
> > __entry->file_min_seq + 1, sizeof(unsigned long)))
> > 
> > But I guess it's fine, since the two extra entries are both
> > zero.
> > 
> > And, I personally prefer the youngest-to-oldest order,
> > as we usually have:
> > 
> > head ---------- tail
> > 
> > where head is young and tail is old.
> > 
> > Your output uses:
> > 
> > tail ---------- head
> > 
> > But anyway, I guess this is just a matter of whether we
> > read it from left to right or right to left. Personally, I
> > find it more natural to read from youngest to oldest.
> > 
> > If you're not tired of working on this and would like to make
> > a few more improvements, you could address the two issues
> > above. But it is up to you.
> > 
> > For the patch,
> > 
> > Reviewed-by: Barry Song <baohua@kernel.org>
> 
> Hi, Barry,
> 
> Thanks a lot for testing and the Reviewed-by.
> 
> Updating it would be fine with me, but I'd slightly prefer the current
> output, to keep it consistent with the debugfs lru_gen_full file. It
> also prints a fixed window of MAX_NR_GENS generations from the oldest
> to the newest, marking the ones below min_seq with 'x'. The event
> reports anon_min_seq and file_min_seq in place of the 'x', so the
> generations that don't exist can still be told apart, and they always
> read 0. Keeping the same window and order makes it easy to compare the
> event with debugfs, e.g. when looking at both while debugging.
> 
> That said, if others such as Baolin, Baoquan or Kairui also prefer
> printing only the existing generations from the youngest to the
> oldest, I'm happy to send another version with that change.

I like oldest -> youngest a little better because when I am thinking
about MGLRU logic in my mind, I would put min_seq in the left, max_seq
in the right, then wrap around from right to left.

