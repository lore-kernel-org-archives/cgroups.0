Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793908439;
	b=J1lmcdcywySjqix9/15I9ZuQ45JU5CMGJcyTYwzvA1yTGnoA5JuxV+VZejNyA1ssNxSt
	 OqqOJRM6oSVtzfroCZhEnnB3xgf54ugJZAHosUreej8dRjqWhuAXxgXYrVJ7cZo7k2hnG
	 mV4/e/aplrOwseWSNdKWa2FCzXPPjKI5Pn9VzHntBL2261fZ/fgWt1JM9Ix7/ey6VDTCo
	 UnfRKzGl7JB6ivpxccRpK8Dq10aQ9AaV1C25v/G35qdngT2NPLEJhFjQvb2Cltc5iHI6c
	 TJGCb4TNUw/foANdj1cCg+FVaqe+BjS81F6L/wB5Qe6Dy44jtO9/zlxfvPy1f5CNuHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
	b=A6SR/E780G/FnW9jTv447qJbrl2sj+YLoYFzR5L6vE8gdDSBWQXnivFSPjeghdhBWFD7
	 jfEbrfHmZI19CrSsSdOW6ewaCsDqb/3u6OHIzQgRXaYMcrMtHjkcbfIcIYeWRpGjr6TzL
	 xnhz9mvaO9M9YaXCeTVP4g/CRUo3EK5gr9WU9K7ilfwdsiY+XG1JjTD+H5B+zdvMz+5b4
	 f0EUlqL6ZLq5q3tL4anf7d/pOOJ9wU7Nq4EFPvlztaGK0ofgKhg5SLCdSA2bPTciLzNOK
	 Vbh8Bfrj9ut9C7Kg3aK3HHYS7ODi2t2ndxvXNULQQ0a3h9hOCErSxPc6KgJaRK3bUvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rPJeK+dx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77667606B9C3
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 19:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77667606B9C3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rPJeK+dx
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so22649665e9.2
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 11:53:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793908438; cv=none;
        d=google.com; s=arc-20260327;
        b=XzlRXphNhpOZ4UpA0ssKXGhfPmAWhFQ5c48oyuRktvHXmqvTWimuqfZKlzDgG58ZZi
         XlCWNGZQkGqJA/ShzizbZK534CUeplHoY9mrECPS8CSbvQgePbrPCgyGkAFfzqFYQ3d7
         aH1++2UM9VGZvZucsDQYQK35Q+J4itLbpzRjJCFB7gZk6fKcNAPHIh+FLnWZqzHNy2XB
         1toJU9cixwVXNMg0MFr3gr3ln/KeFHMBOnTbmZiwUuSvOrwUoV6hho97lOJZbKRtQ8bd
         xUiz2WWLap3a8r7E397P9HPM87bkfxNADifTiR/lMdTfW1BPbE1Ap0diCL6DzQD5ToY/
         e5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        fh=klwSOPvOIComGRE6loY7FQLHAIJwFSRb8837WO0dD4o=;
        b=FKGuTuxqs4F4GIV5RIgJO9F44TTPq7EKGUlN96OOAvfQZtFUmnHQWXmZSAVPLX9y4K
         pN5Du4yK5EpSIqHwoOjTrCfSiTGoTwKNEFUkgH3l+m/n9Y09r/2gW76kk1/TrRf9WrW1
         J36ujpYinmp2GKG7xNFoF9R2116UU2RCEyxXs8jTPlG+2eNStu7WSsydZvqCy8qb3wl8
         UiMI19AhL72e+fA8/4rfRwHd2y1uXMXTKoDx/h4O3zMK93SV02tvOJXbyQFeyLKUM3l4
         QtKftgmSjbFeTvsV6xgDOS15S4yoX7Jubw2lk+RF3WAINaQ6mD/hgQhgnqoprFUFn2O9
         tgoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793908438; x=1794513238; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        b=rPJeK+dxd3KHvhf3dJ6yjjs/fIeP1xDq23YnecFAyVzqOgxfj5H1WhD+hpX6gQcD4r
         LxWBkADKLWcM1ge5NpbOelBKI/p28FTOx9Jnrksd8G08p+AIpUYD6DiLwRpOkgV3u8vG
         Hts1A073AqWS+lPyO1btj3nxPZ1aBLPLw9ip+DC4KW93mIyT9uH0Yz8D+B42/fZbLUcv
         epSFXp8qyuqH4mx8/kXDBUp/0D+Tg9HMpSLuGJqErEEAPgJu4r7gdlW4+SaeR0j9YfQV
         ENQ43+8LCaNdPCdANmqUq5TOZOD8rcPMVe0JN7laMAZoiH/h5Jf8tUCPnIAfml28+qp7
         HqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908438; x=1794513238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        b=EGve1zkQLF6FiSJy4lP2NLNdE2dOLi05LuBbsBFXbHFOFgLt9ruljWOHrDRk7DhyMp
         NRKqI1I75YCpwGp9etaOu+xZiw4Wg+NH6E/0hiDu+0a3FfvToO9N94adUvsTjxBwkTlq
         X0g4Kom4yrDqE97BN7ufkaHgIbLuoq/RT8ZAeyjrb9D3PTBPiF3O6BOciEI+EK4elTh8
         gCd17NykAF5/uzMurEhpXs7+Om9FmYJIlXQ+qrSpml5AdGwlQXqXjP5YsXP9NQGYqm2A
         F2Klu/tp9NhAj+GDehRP9iv2bNKMpi7R5MABysi61TPgdMnKADSIB+xC20aur3KLAJvM
         9MPg==
X-Forwarded-Encrypted: i=1; AKwUvBy761oh9xNrW+hBQPWk20Pc8TarLSCHV/wIOzoXTYepD4JsklvbnzZN8ECUgn/JVagAmYxpe2iQ@vger.kernel.org
X-Gm-Message-State: APuU4Z90oDSOJY/z3LvGNaQwDHh5KdlJUoGiG3Exj4bB+DZClI0KUJou
	0FO66UCWdCpBgeUr3wdePmzGawTXBlCvUXOSPNAUTSdicwJyodYipNj2RKWnM8U/BGOS9olwF38
	0oFCgxhhD6Fk0RXZ/JD1imZ9uGaLhn9g=
X-Gm-Gg: AYBFou0fnkq4doSOlBsHTvcxq199I6PJ/wNhCMAxWlJ6/KGHFGGndxz8C5KtAaewmuG
	T6r6Yacvtv3jgMjfoH0jYxDnHAlGJ2LRuWB/10FxvwynsnnikK1vRZ09dkLnfwjaWsP7jD9PMuq
	diMfOr/LiRUm7HQOXj1XyPfys4FJLm9fhJ/JubSSkRlWO4pq3ZzePBI4O5fHb1TbmbscIU4jhww
	+Bp8fKGFE1ao0fYlejW2gKV30rh/LWRl/obhikWs5RsvOyMuFZDmD3YFTw5FtVnsE7guj9FNuRE
	8nFBHmD+3ksHm4qd+KwSQfyGx1KLOSaA8uK58mA0YYl6qPgjvTB7e64LT6JN0VZDVhT6URpJN/W
	yWd19oB7HB+x9P21zYMq9lKQvYgqBIyClcENC5k+vEEH5H5WfhFFJ3VPAKfEq/vugwKPqLDGcf2
	x65pqp7NFNdF8l8Xr6JA==
X-Received: by 2002:a05:600c:818e:b0:4b3:9540:47a6 with SMTP id
 5b1f17b1804b1-4b6dff86e38mr2801065e9.28.1793908437547; Thu, 05 Nov 2026
 11:53:57 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev> <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
In-Reply-To: <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 11:53:45 -0800
X-Gm-Features: AclHuK83KbcAE74RZl_XlV2f3k85A7P5GaBmid_sbfdijpMH3WJv_bA5h7VKPGQ
Message-ID: <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, yosry@kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 11:37=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/30/26 01:19, Shakeel Butt wrote:
> > On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> >> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_loc=
k
> >> once per batch, but they update the node and memcg lruvec stats for
> >> every folio in the batch while holding the lock. Only the LRU lists an=
d
> >> the memcg lru_zone_size need lru_lock. Updating the stats while holdin=
g
> >> the lru_lock is unnecessary, and they make up a large part of the
> >> critical section, as seen in [1] where a change that added just a few
> >> instructions to the memcg stat update path cost about 2% throughput
> >> because the LRU stat updates run under lru_lock, and the overhead went
> >> away once they were moved outside of the lock.
> >>
> >> With many threads faulting and freeing memory in a single memcg, about
> >> half of all cycles are spent waiting for lru_lock, and the hold time o=
f
> >> the lru_lock directly limits throughput. A perf profile with 80 thread=
s
> >> faulting in and freeing shmem in a single memcg shows 52.8% of all
> >> cycles spent spinning on lru_lock, split evenly between
> >> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> >> spent holding lru_lock in those two paths goes to the LRU stat updates=
,
> >> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
> >> per-cpu counters. The stat updates are only 0.7% of all cycles, but th=
ey
> >> lengthen the critical section that the other threads are waiting on.
> >>
> >> Accumulate the stat changes per LRU list while holding the lock instea=
d,
> >> and only apply them after dropping the lock (while still inside
> >> the RCU read section that keeps the lruvec's memcg alive). This moves
> >> the stat updates out of the lru_lock critical section and turns the
> >> per-folio updates into at most one update per LRU list per batch.
> >
> > This updating of stats after dropping the lru lock does introduce one b=
ehavior
> > change i.e. race between reparenting on offlining and stats update. I t=
hink it
> > is safe and correct though. Better to document it.
> >
> >>
> >> The batch is attached to the lruvec while lru_lock is held so that the
> >> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> >> from growing, cost_lock is moved into the hole after lru_lock, which
> >> leaves room for the batch pointer in the same cacheline as lru_lock.
> >>
> >> The stats can now lag behind the LRU lists by one batch, which is well
> >> within the per-cpu batching they already have.
> >>
> >> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> >> CPUs repeatedly faulting in and freeing memory in a single memcg,
> >> average pages per second over 7 freshly created memcgs per run, 2 boot=
s
> >> each:
> >>
> >>                      before    after
> >>   shmem, 20 threads  4.74M     5.47M   (+15%)
> >>   shmem, 80 threads  7.94M    10.33M   (+30%)
> >>   anon,  20 threads  3.04M     3.35M   (+10%)
> >>   anon,  80 threads  3.23M     3.41M   (+5%)
> >>
> >> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a7=
6izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >
>
> Thanks, I'm planning on queue this.
>

I'll send out a v3 today that adds the documentation Shakeel suggested
about the race between reparenting on offlining and stats update.

Thanks,
Joanne
