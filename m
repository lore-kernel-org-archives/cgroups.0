Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695135;
	b=ysFar5U9FUZteb+msmjy5LaZt+76HXsWHqgRdaMUNJarFuzO3ax1vZxiH9MizxZ2zD1m
	 4MC3MHrAJQTfq/dmMmTF7w1sG7pFcxtDmyorT7lOVDmSSNGCvxDlMaaid51e8ZVCtrLVz
	 HQjvIs5HbHPvYFq3VzBUNv92Q1r/MzSF+OKlYRLlku56RcEPdnEBCnHkvIILjEtNTZQrZ
	 n3Fkj5R432Bn0b6jLPteMmA3GBcGQRfTiF6UjUwo2T3BT9XHZAxQX2YmF6bbdMbvpIAkG
	 s6DKtfrSIa/wBfPFpRhl4mSt898JqRq89ZdIbTc6OmAywRievknkegVbAJnPHwr7Zrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695135;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=qeqwFlyJpg/hyC5+cDpsscxjxixuGz6INW/VspMuWu8=;
	b=1c6wJaq8TfMs2wqAW2Aou1KDjxyZgY6LzSj39tZpedWRQp1mOZt5ugWiV9f+fE0xBO5h
	 DkqfQh//GFTSnBFOU4lOfGnTQojJrMapFWNAiANCYxRquWfk1IiRVGPxDXR+ajsy4ACVI
	 O1KMCfDR9rsm5BfETgx8SQYScGVlquikWaDDHB5tEz6dIRUAn1HaRqvMdALCeA/F9ipeW
	 sAA4IZftrXyWMoGp2D8b8puWOJBKGLv3dpwnwtFeuq0/DbZ7Icc+3aHBAPIwYqA3FzfKG
	 rvW2RIhP2SYXiq5Mg1FP1LfbwZ84Zb8/qHHjeeN/r3sxxfob2rNyt0L3IT+4QLHHmSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.74
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180FF606A33D
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 180FF606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OSN5qGHgqiHVh7/05xFfowZL4pMsF7I9FTtrXt2Dh7Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695132; v=1; x=1794299932;
 b=ROPqMjXI5XlPI4j2+AMYhgpbz8V4jO1vsprSWBij54GaljEpun6cdUgvud1esw4g1ip9qwvg
 fsTAQ9gdAlNWK7zqvCd/jneT7dLIbvPehxzOCbiFFcMIHZx1ClxtmYq+gcr3R7jTmQ9V53IVzlH
 yyMf7sjmzypXX+cjR/BV8gP0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c2bade759b0e2b73;
	Tue, 03 Nov 2026 08:38:51 +0000
X-Mizu-Trace-ID: c2bade759b0e2b73
X-Migadu-Flow: FLOW_OUT
Message-ID: <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
Date: Tue, 3 Nov 2026 16:38:39 +0800
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
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/3/2026 2:48 PM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 10:58 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>> youngest generation. There is currently no tracepoint on this path, so
>> the moment a new generation is created, and how the min_seq of each type
>> trails behind it, cannot be observed as it happens.
> 
> We might be more interested in why aging is triggered rather
> than the exact moment when max_seq is advanced.
> 
> With your patch, we get:
> 
> ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
>             a.out-93      [001] d..1.   278.276539:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=4 anon_min_seq=2
> file_min_seq=1 nr_anon={0x0,0xf016,0x12,0x0}
> nr_file={0x1886,0xb,0x4c,0x0}
>           kswapd0-50      [000] d..1.   278.422400:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=5 anon_min_seq=2
> file_min_seq=2 nr_anon={0x5,0xccb6,0x3439,0x0}
> nr_file={0x4ae,0x4f,0x55,0x0}
>           kswapd0-50      [000] d..1.   278.508003:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=6 anon_min_seq=3
> file_min_seq=4 nr_anon={0xccb6,0x3d29,0x1,0x0}
> nr_file={0x0,0x59,0x7,0x0}
>           kswapd0-50      [000] d..1.   280.046056:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=7 anon_min_seq=4
> file_min_seq=5 nr_anon={0x3bf3,0xcbbd,0x23e,0x0}
> nr_file={0x0,0xb,0x1,0x0}
>           kswapd0-50      [000] d..1.   280.124876:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=8 anon_min_seq=5
> file_min_seq=6 nr_anon={0xcafd,0x3e31,0x0,0x0}
> nr_file={0x0,0x5,0x7,0x0}
>             a.out-96      [001] d..1.   290.629014:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=9 anon_min_seq=7
> file_min_seq=6 nr_anon={0x0,0x10615,0xb,0x0}
> nr_file={0x331,0xb,0x9a,0x0}
>           kswapd0-50      [000] d..1.   290.653098:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=10 anon_min_seq=7
> file_min_seq=7 nr_anon={0x15,0xef23,0x18c4,0x0}
> nr_file={0xb,0xb8,0x55,0x0}
>             a.out-96      [001] d..1.   290.684875:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=11 anon_min_seq=8
> file_min_seq=9 nr_anon={0xeee3,0x1afb,0x2,0x0}
> nr_file={0x0,0x76,0x4,0x0}
> 
> You can see that the youngest generation is always zero,
> because you're just getting the newly added youngest
> generation :-)
> 

Hi Barry,

Thank you very much for testing and reviewing.

> This somehow suggests that the information is redundant, as
> there is always a zero there.
> 
> I suspect we'll need an additional tracepoint to show why
> aging is triggered and at what sc->priority it happens.
> 
> But do you know why you trace the moment just after aging
> is completed, rather than the reason why aging is needed?
> 
My original goal was to pair it with mm_mglru_scan_folios, to see how
the aging window of each memcg moves. The per-generation anon/file
nr_pages were added following your suggestion on v1. I put it at the
end of inc_max_seq() because of the restart there, as max_seq and
min_seq are only final after that.

You make a very good point that the reason for aging is also
important. So I'd like to discuss which way is better:

1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
  decision in try_to_shrink_lruvec(), reporting why aging is needed
  and at what sc->priority.

2) Replace mm_mglru_inc_max_seq with a single tracepoint in
  try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
  the reason, sc->priority, swappiness, max_seq/min_seq and the
  per-generation nr_pages before aging. The youngest generation is
  not empty at that point, and the new window after aging can still
  be seen from the following mm_mglru_scan_folios.

Which one do you prefer?
-- 
Best regards
Ridong

