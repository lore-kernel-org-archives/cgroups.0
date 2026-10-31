Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793480572;
	b=h9WbJQnEDe4EqO2+BAiIG+UNbVZq5Aj97DwPNnRYLseBMMD9vG7ksiU8l+bvmeincP84
	 nWnzScWpHQmAcJbki+abtqPBEVB0AynHdIrvNEMFWvQvUPObFq4edfbg473RgMSblHJ+g
	 6ffBKNDHnhx6IYIaiLGb7A1ovJ5HY9oWjuTDqsZvlIK7bdQevU9jg//JYeP/h/wAvglyg
	 8SqVaStql1pdN6TUJVBkd87KSUKHe/UEH9QL0Pfw+1VugV8rafQDSLyo2R6wuFJeGD334
	 ozxA8i95xTpTMfUpVYLHuShgLcAee22zJm9ln5v31eKhUcwqodZ6HFB+2efjHW8Xtrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793480572;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=JovmbRKKM9xZ3bzkOvnYz4tRy1n03KhMCiMLiQXxNrY=;
	b=LWakcLU3Dh8FEl38yIPzI2XPotbGdwhjHrOMWfxIlwp+yC9CjnVT/QDDBjlP1VkgXH0R
	 YYhLK7PssUBkrxw8LzElYv6gn89UNrVjm0K8X4cV+JOapIWobzIQ52WARgcMyh8cTC2zz
	 47l25x10WJdkQnRGAp1r+PGmQR9JQQrPy4Q4T+CZbYhn1Jzof69Ydi1Jx1sGnZQc9S/zt
	 c7AdUKaAP0mgo8laolh5Czb6xxy7GjE/2pBR6yTsI/uetnoT3cp7T68rFeRQWjOzzgp0W
	 wnaKRFoATA/K5ESmP9+9Q+3pS2lPzT3K7cVnPPOqXPWiLWdfzudfblYabrFkJZ0r3FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iaL8/2dm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCCA606A31F
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaL8/2dm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880041F00A1A
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793480571;
	bh=JovmbRKKM9xZ3bzkOvnYz4tRy1n03KhMCiMLiQXxNrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iaL8/2dma4L2E5r6CldXJPvKqp8fRpEetqR8UoiqvMhoMOwGzo04tlrKZ3hw8EDxx
	 cm57XH3+C30FHetLJsF+AU5ydcWWignbnOVFSCy0PIfJwSsEVfg3skS30rwWyifbPv
	 U2DodA5o6IN77nFMpvde1QBph7M3eFFfIV+uZR5G+3JWsajtB3rmlGcjGU5bJFvyro
	 wJBN8iIVuhoZKq9Sw6xHp2MABjFjNgMzgfQxODk65Rq7NP58URXO4T3qf/UqfXlamp
	 MNCknK2zE8IQ2p5CWIYCBUDbnrUU7S4noc9BOPlq+4B1pL2x3E6pFx0OyAuy/R6Qht
	 ielu/hDoaTKCw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f2b8cf037so159893085a.1
        for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 14:02:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5mEoNBErnVWMqTjT3SCsWUGJcC7CVbmzAWgzwhipTrfNuWZg8vALAze1DIOXt3JEYoMjcl/aK@vger.kernel.org
X-Gm-Message-State: AFq9FYIQINRiczlfnIKgTracsRJh5ozuAmHnGC/I6U5ORbUFTe31jDVd
	WlNTVvceuU2ULu69UE/pdS7wc/4GZHw0zMQYiWXbTwiX2tFO1pQyQftmRh6twFoMZLHjmCgnLW5
	oMoLeIuYQsHooFCjF3leLzHqWDEkxRmM=
X-Received: by 2002:a05:620a:8393:b0:93e:c12c:4416 with SMTP id
 af79cd13be357-94421805919mr873994685a.82.1793480570337; Sat, 31 Oct 2026
 14:02:50 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031090041.58574-1-ridong.chen@linux.dev> <20261031090041.58574-6-ridong.chen@linux.dev>
In-Reply-To: <20261031090041.58574-6-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 1 Nov 2026 05:02:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yarkUMWjuJ+MVw3EkNDHanDU8_LKk0Td2tO9DJUe2cyw@mail.gmail.com>
X-Gm-Features: AclHuK_IJBi8BwrNBY8KWJ9NBHd1SSJ62zreD3OjXulz7n9Nc2RkMxdC4i3O-Xc
Message-ID: <CAGsJ_4yarkUMWjuJ+MVw3EkNDHanDU8_LKk0Td2tO9DJUe2cyw@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] mm/mglru: add tracepoint for scan_folios()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 5:01=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> MGLRU's scan_folios() emits the classic-LRU tracepoint
> trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
> scan/isolate counts and the LRU type, but carries no generation or
> memcg context, so a trace of an MGLRU run cannot tell which memcg a
> given scan belongs to, nor how far reclaim has progressed through the
> generations.
>
> Add mm_mglru_scan_folios next to it, reporting the same counters plus
> nr_sorted (folios moved to a younger generation by sort_folio()) and
> the context the classic tracepoint lacks: the node id and memcg id of
> the lruvec, and the max_seq, tier and min_seq of the type being
> scanned.
>
> Now that struct scan_control is visible to the trace header, pass sc,
> lruvec, type and tier straight in and derive everything else in
> TP_fast_assign(), so nothing is computed at the call site when the
> event is disabled. The int fields are grouped at the end of the entry
> to avoid padding on 64-bit.
>
> scan_folios() is the MGLRU-specific layer where folios are actually
> scanned, so it has no classic-LRU counterpart. The existing tracepoint
> is left unchanged.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Ran a test on this:

/sys/kernel/tracing/events/vmscan/mm_mglru_scan_folios # cat format
name: mm_mglru_scan_folios
ID: 491
format:
field:unsigned short common_type; offset:0; size:2; signed:0;
field:unsigned char common_flags; offset:2; size:1; signed:0;
field:unsigned char common_preempt_count; offset:3; size:1; signed:0;
field:int common_pid; offset:4; size:4; signed:1;

field:u64 memcg_id; offset:8; size:8; signed:0;
field:unsigned long nr_requested; offset:16; size:8; signed:0;
field:unsigned long nr_scanned; offset:24; size:8; signed:0;
field:unsigned long nr_sorted; offset:32; size:8; signed:0;
field:unsigned long nr_skipped; offset:40; size:8; signed:0;
field:unsigned long nr_taken; offset:48; size:8; signed:0;
field:unsigned long max_seq; offset:56; size:8; signed:0;
field:unsigned long min_seq; offset:64; size:8; signed:0;
field:int nid; offset:72; size:4; signed:1;
field:int highest_zoneidx; offset:76; size:4; signed:1;
field:int order; offset:80; size:4; signed:1;
field:int lru; offset:84; size:4; signed:1;
field:int tier; offset:88; size:4; signed:1;

print fmt: "nid=3D%d memcg_id=3D%llu classzone=3D%d order=3D%d
nr_requested=3D%lu nr_scanned=3D%lu nr_sorted=3D%lu nr_skipped=3D%lu
nr_taken=3D%lu lru=3D%s max_seq=3D%lu tier=3D%d min_seq=3D%lu", REC->nid,
REC->memcg_id, REC->highest_zoneidx, REC->order, REC->nr_requested,
REC->nr_scanned, REC->nr_sorted, REC->nr_skipped, REC->nr_taken,
__print_symbolic(REC->lru, {0, "inactive_anon"}, {1, "active_anon"},
{2, "inactive_file"}, {3, "active_file"}, {4, "unevictable"}),
REC->max_seq, REC->tier, REC->min_seq



~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_scan_folios/enable
~ # ./a.out
[+] mapped 500 MB at 0xffff9f000000 (128000 pages)
[+] duration: 60 seconds
[+] first pass done, start looping writes
^C
~ # cat /sys/kernel/tracing/trace | grep mglru_scan_folios | head
         kswapd0-50      [000] d..1.   650.877105:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.877686:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.907558:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.907729:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.909040:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.909198:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.910520:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.910710:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D4 nr_skipped=3D0 nr_taken=3D6=
0
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.911866:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.911988:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D66 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
6
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0

The LRU naming feels a bit weird to me. We have
"inactive_file" and "inactive_anon", but MGLRU doesn't
have active/inactive lists. I guess it's not a big issue,
though, since we also use the same names in
trace_mm_vmscan_lru_isolate() in scan_folios().

For the patch:

Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
