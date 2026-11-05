Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793843317;
	b=YQfN3SWT6kcaj89YGZNAOZ0jaVsiy6bMcvGh7WfZKsFQiAFGsdeMz4RzsMkEItXwbkg4
	 dwk4T7HciWKR2Ux/Oay5CLZYXMa1iYRfywxUJpsuV7WHxL6W9lXvdjhbftF2XumVw19IS
	 sfslIg0sH1kF43SxOdK+e1nbnFtqzcSGfmCwrnmP1pJ3cWbxXER2nDVtKZr8W+ImyOusJ
	 pEKvaRQeRh219PqEq4j4JgMkgT/gdArnOnoig8vrGQ2L2ESxYQP9W7m078THNWgS/Yd0C
	 Er5jI/vPlrb17sygOiYf40SWSIjsj4E1h+bQALkRHo97d7jOSABdPiXLCVRRXPCPLLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793843317;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sQkjxX3K1joAq68TfOUhRaY9yTvSWkChu+qzeIISQGI=;
	b=5T+noxfW+Pcoc6v0zU98LkfcYhtID/kZICwaqIkwFXHBVSOiOoGHCuMKm2tIwuFXxq08
	 iRTzzj54rs8JtRRxHEYSuOiA/L7n/FXj2S2k9/mdqOMEVJqwepPgmSki9hD7v8s1CZZGa
	 1mSWTQS+G5rt2A1lEkeiIDO6x2f3x+tEDX/kZ+/X9sMkBcHIFRhhd9kN+Nt/d/b/59xwy
	 SCvTN2Nf/N1k4e5Qq0+CpW5P/locchFVxjb4X8naS3HJC0YouIzjv01HD3/62Pwl59XR2
	 P2k60ika8DNyb3xeAo2X3tMeHd/U8Nze0sUJLhosT+cf8EHuhKroUZujD5T00WvpSEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bj6MbLCe;
	arc=none smtp.remote-ip=95.215.58.239
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C5606A328
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 01:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 133C5606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bj6MbLCe
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=E+Tnnknq496cXrkg+nZvAVLx4JY0DVaLftLc8cBxV7o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793843313; v=1; x=1794448113;
 b=Bj6MbLCe42vYTLjGG2GoPahv/cBkkaGFa15VL9LAyQs2zARA+S7dw2BtKaWofKCwoCT3DCB7
 /p32Ia1MzTYptErzDopKP17SIwpt4yRpYYS+9OQQ3G4ifSyh28A+6E5FpaoFrjQLRKFbDgSYY1x
 aV7ReBKBjjc7D9qJmjieIemo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db3cfca7bcba751d;
	Thu, 05 Nov 2026 01:48:33 +0000
X-Mizu-Trace-ID: db3cfca7bcba751d
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>
Date: Thu, 5 Nov 2026 09:48:23 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Dave Chinner
 <david@fromorbit.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev>
 <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/5/2026 4:56 AM, Barry Song wrote:
> On Wed, Nov 4, 2026 at 9:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Aging in MGLRU advances max_seq to create a new youngest generation.
>> It is triggered from try_to_shrink_lruvec() when should_run_aging()
>> finds that eviction is no longer possible, or that it would be better
>> to age first at the current priority. There is currently no tracepoint
>> on this path, so it cannot be observed when and why aging is needed.
>>
>> Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
>> try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
>> swappiness, max_seq, the anon and file min_seq, and the number of pages
>> in each generation for both types, as computed by lruvec_gen_size().
>>
>> The reason for aging is not reported explicitly, as the logic in
>> should_run_aging() may change, e.g. for imbalance-based aging. It can
>> be derived from the generation window and the per-generation sizes,
>> which are taken before aging, so the youngest generation is populated
>> as well.
>>
>> The nr_anon/nr_file arrays are ordered by seq rather than by generation
>> slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
>> they go from the oldest generation to the newest, the same order as the
>> debugfs lru_gen file, so the output can be read directly without mapping
>> slots back to seqs. The arrays are printed with __print_array(), so the
>> output is hex and its length follows MAX_NR_GENS automatically.
>>
>> Only the lruvec, sc and swappiness are passed in; everything else,
>> including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
>> does no extra work when the event is disabled. Reading max_seq there
>> rather than using the caller's copy keeps the window consistent with
>> the per-generation sizes read right after it, should another reclaimer
>> age the lruvec in between.
>>
>> The event marks the aging decision, not its result: the following
>> try_to_inc_max_seq() may find that aging is already in progress or
>> done by another reclaimer, so concurrent reclaimers can each emit it
>> for the same max_seq. Whether max_seq was advanced can be seen from the
>> following mm_mglru_scan_folios.
>>
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
> 
> Much better now:
> 
> ~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_aging/enable
> ~ # ./a.out
> Mapped 400 MB at 0xffff98a00000
> ^C
> ~ # cat /sys/kernel/tracing/trace | grep mglru_aging
>           kswapd0-49      [001] .....   104.277689: mm_mglru_aging:
> nid=0 memcg_id=1 priority=6 swappiness=60 max_seq=3 anon_min_seq=2
> file_min_seq=1 nr_anon={0x0,0x0,0xd360,0x0}
> nr_file={0x0,0x23e2,0x0,0x0}
>           kswapd0-49      [001] .....   104.536448: mm_mglru_aging:
> nid=0 memcg_id=1 priority=3 swappiness=60 max_seq=4 anon_min_seq=2
> file_min_seq=2 nr_anon={0x0,0x20,0xf8bc,0x0}
> nr_file={0x0,0x91a,0xbd,0x0}
>             a.out-79      [000] .....   104.689518: mm_mglru_aging:
> nid=0 memcg_id=1 priority=4 swappiness=60 max_seq=5 anon_min_seq=3
> file_min_seq=4 nr_anon={0x0,0xf8a0,0x1188,0x0}
> nr_file={0x0,0x0,0x2,0x7}
>           kswapd0-49      [001] .....   107.282038: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=6 anon_min_seq=4
> file_min_seq=5 nr_anon={0x0,0x6c50,0xa168,0x605}
> nr_file={0x0,0x0,0x98,0x18}
>           kswapd0-49      [001] .....   107.812598: mm_mglru_aging:
> nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=7 anon_min_seq=5
> file_min_seq=6 nr_anon={0x0,0xfe10,0x1721,0x54}
> nr_file={0x0,0x0,0x1a,0x3}
>             a.out-79      [000] .....   108.936872: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> file_min_seq=7 nr_anon={0x8,0x7d29,0x8c54,0xc90}
> nr_file={0x0,0x0,0x4,0x2}
>           kswapd0-49      [001] .....   108.937115: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> file_min_seq=7 nr_anon={0x0,0x7d15,0x8c94,0xcac}
> nr_file={0x0,0x0,0x4,0x2}
>           kswapd0-49      [001] .....   109.425258: mm_mglru_aging:
> nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=9 anon_min_seq=7
> file_min_seq=8 nr_anon={0x0,0xed69,0x24bc,0x488}
> nr_file={0x0,0x0,0x3,0x3}
> 
> One thing that looks a bit weird, though. For example:
> 
> max_seq=3 anon_min_seq=2
> 
> We have only two generations for anon, but we print four:
> 
> nr_anon={0x0,0x0,0xd360,0x0}
> 
> The two oldest generations don't actually exist. Ideally,
> we would print only the two existing generations:
> 
> nr_anon={0xd360,0x0}
> 
> you should be able to fix it by:
> 
> __print_array(__entry->nr_anon, __entry->max_seq -
> __entry->anon_min_seq + 1 , sizeof(unsigned long)),
> __print_array(__entry->nr_file, __entry->max_seq -
> __entry->file_min_seq + 1, sizeof(unsigned long)))
> 
> But I guess it's fine, since the two extra entries are both
> zero.
> 
> And, I personally prefer the youngest-to-oldest order,
> as we usually have:
> 
> head ---------- tail
> 
> where head is young and tail is old.
> 
> Your output uses:
> 
> tail ---------- head
> 
> But anyway, I guess this is just a matter of whether we
> read it from left to right or right to left. Personally, I
> find it more natural to read from youngest to oldest.
> 
> If you're not tired of working on this and would like to make
> a few more improvements, you could address the two issues
> above. But it is up to you.
> 
> For the patch,
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Hi, Barry,

Thanks a lot for testing and the Reviewed-by.

Updating it would be fine with me, but I'd slightly prefer the current
output, to keep it consistent with the debugfs lru_gen_full file. It
also prints a fixed window of MAX_NR_GENS generations from the oldest
to the newest, marking the ones below min_seq with 'x'. The event
reports anon_min_seq and file_min_seq in place of the 'x', so the
generations that don't exist can still be told apart, and they always
read 0. Keeping the same window and order makes it easy to compare the
event with debugfs, e.g. when looking at both while debugging.

That said, if others such as Baolin, Baoquan or Kairui also prefer
printing only the existing generations from the youngest to the
oldest, I'm happy to send another version with that change.

-- 
Best regards
Ridong

