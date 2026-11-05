Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793909247;
	b=LZRk9L1TULa3+kE8trm0WaHWPp1JAzeOZ+xWeJ9wHQ641DwEf7//Ne7A7hxG8HMqq4vv
	 UOFonCGQAzqf5hWnm/fg3LxcUhK1tpYB+mBWRr+FLWkc1naOhQKAFdXbEjbi4CZ9yVdrv
	 Xlbh6ZDxW1Jr3+RCSDnzUzearTDQkd+b6Jt7j2knbMpoNCRqg0dnDyU+DL5J4ldUxiIfA
	 q/ehXuHO7DP41Y4COaz0cKTFD+71pxzxjSoknaHocFgaYGO+XO7vmQiLY4ukkReKXVFtw
	 SQR9DNim4XTYmWouzRSIx501uBEyHr0vC/J6jf7KuvF3vqxItxBspvt8vnfbACRyvaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
	b=libMdqbkJs/xb97Z1BY6OLriN+CkdAPx6aruTPkcKOh8cK5jxHIPIZW1+om2D6x47gKl
	 g4/+twxr682IS5jsTNbNagG90RWTEEedCzlSzy5jro2eNkEf9qBYHOO2Xvm3vWaqF8Bf5
	 Df+MsGXOc8nnmXfzcG8WHGGsI3nkoZnllcNHMYlkYIrcebYykrYsea0Ia0XsDPVsUBQco
	 ++PO/OXGbzH+pKIo7IQQWzY7IGU3g1Arbyjo00SLKR4o16CQaVXFG6crs+sHr3U47Q1BO
	 eME0jVhUQ/k/Cu1A4PpMgvBV6LkjvMIQQL0sYQNNlp65PrFT6Apc2F9FLiILy1k5dbw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JiPYHnsf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F73606A32F
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 20:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6F73606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JiPYHnsf
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48afbd2c386so1604891f8f.3
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 12:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793909245; cv=none;
        d=google.com; s=arc-20260327;
        b=LqJ8Yx+Dib0/utzJe/i6mXxIg5sodnoLJkzqsuSRPK767wxRg4J7ZILK1Gnrsl8Ha0
         k5uATVwf2STnF+Muy9dEcuHASWotQ7IJWxIbm7KjBNN2UgOYUb41WCgo3OnRg/UFWOo2
         lxt7eKCJskQlQ/Utw9gIihexRR74JMf6nder/DtmIBn9I7SZR0Grbs1RAuIgpn6vdBB8
         oKHafwDQqRnDwysTh11X7MjSP+qG5dtspGs6GAHK2jlsoyGtsGpmZ4uLJOrnUZoQ3RBU
         ZaBRvh9y2cvoIZZOfjazjxUBABKqgNJTMtwcMBh9DZ2gf9853sKxInyx/x/RmnYueAlQ
         Tlcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        fh=wfFfB6nTyh9DX7PWkB0nBA2yWRnoultpryRHMcMblLs=;
        b=d0vNFXAWQqpf/+mfUTb0IH+h68g81izttVxKKWP2XcXdhNPc/Tx5vkynConxrKmn3M
         jK9BeAT0qb44JqdcrIG8nN+XKXuuNWZD2nd7DpQwT4I5OK11xWf2EDxqmy8aUdePug8b
         afH642nK3KQ5Dzac7O645BtOyIEQkPIBPqGD7RGY2w9uffc8BO3CNC2LPZkF4hK2cTkE
         kOunlm8R5bv3bt8h7/jAwJBAFl4AiMHnAAdz9NU7x1EM6ZTMrkr9P6Xky4h1lNQNpvE+
         zs5mi1DONccbKEcsdow6+czLyv+JxiV0MWpLXcDVpDkanJRY0pNqHh8dvf9gTkK1kfYP
         CGYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793909245; x=1794514045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        b=JiPYHnsfnELyHV6kc+hUMlk9VSkQ9LD40EN1KPIEQTG537cTjhkhH44BkTsufArkF+
         D01a5/JjZgMGJ/V12Kd88DI8EOpwRuZIKLBiKhqszgdBg8wVHsV31vyw8azWnEXIRI7c
         EifZdOuwfhlWi4xHW8+u9QN6e1hI1MquS63VV1NR8NST9mh6kH41jStvx8TDVGfEwY8C
         NRNyrQofZX3+SrWLZEB6BjRtHzzrQgTXIRnkMv7H93xvi3ALmxiyP6+EeDZYxouALXBW
         DbpT7KlCl0MPhgA6C61PRnWkAVRL5bXPd9Yu6/OhyFpiBh5NXnyYSakpf0x8ESgg+kz8
         ox2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793909245; x=1794514045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        b=RQDPKsIVaSW66yc79gZzmGY7Cun1yEHB6osdGRcyFsP6dT4VyO3fDbuWSdz9MmThsn
         +BYDR0enozauMe7TpLte0POw4ur+bRs0Wfw77V0H/23lOKaiKQP48CEr69O+311IPXOr
         gQz6XlwlC5/+6pXIMKExju8eUwC2AGCvEJRqBXevcIqv7oSP80MyGWRogHNC0qjYFdVq
         fodMGxVMY0P9z6K/TErUYj5B0wB8VSYmNxZXOjwRk0YSimmISJ9U/tfjoScgXG2ax63T
         8hUYRzqO3fNg4MwLW1Rz/0i+O3AWR0Lw8dbjhJEY9Zdvicm3ylqeUKe+qpm/WlkNltQ6
         R1Yw==
X-Forwarded-Encrypted: i=1; AKwUvBxXNItU2jWp4RGOTAaQKYggxtOyUji1Be/Jx8E0uijZdcVWCRy+CO2i6ErOtBymPRNvj7edBfIT@vger.kernel.org
X-Gm-Message-State: APuU4Z9x81A/jNGtVYF1GN4hpQ+jD2glbAxSod5krkMzcXkpSOPIfOsA
	NYGchdHXYY3GSWpG43HxXVE6QLAJQi6fsAiPmshEcSYo1nJSZPdZue59rYnOpu1rWeNGwKirh3U
	fONEojAmlY5Bl6WalRMGgPfx5c943BxQ=
X-Gm-Gg: AYBFou3Oy0Z+/Bm9YM2lUdQIe/CFdlV96rczBedjwFeiReXObyCXbhqG6/WcelGlD50
	lM/XMeXJ+kDSK/K5OO5RRpUTGVB2XXOYZkzqQYGULsv5MEPW+QrwutZrPDYl0J2ozXCDI3DUlIN
	VIFac8puWc7Unya3VLv/I0FAQ12drpf9uomZ67hQW9Ggst7vcpaJY4uuwgWkBlTR/P/kbW31rNC
	9Iypn44z75oZX6Yn8BKZbW0JmA4Ja9Xc4KAUAp3aEo8HuilYohHZx4Y2etPZ0Fl8GMZKtcI6wL5
	qKbJAwNqArhws/YCQ33MiWCrkxn+u2wbQhtKBatLULA2GTcFOXenEy2WwiRI5APRZz1bvL0TXUl
	7ZK3IRCxxOXlscM6wT+HaUmlnp5nT3USzvPS7Rv4aslu/xmtLhqSCfpvR6NAWVGLPqZAVZeUKJZ
	r6IB0laD7M4NuZLPOiAw==
X-Received: by 2002:a5d:6f0f:0:b0:48d:ecba:3cf8 with SMTP id
 ffacd0b85a97d-49277e91e8dmr1303438f8f.43.1793909245094; Thu, 05 Nov 2026
 12:07:25 -0800 (PST)
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
 <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
In-Reply-To: <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 12:07:13 -0800
X-Gm-Features: AclHuK-YXRVVfKGyxrAmqyLZlV1c129Tk-TiSLsOR0T2GgkWlVaz7555ZN3P6b8
Message-ID: <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
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

On Thu, Nov 5, 2026 at 11:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Thu, Nov 5, 2026 at 11:37=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/30/26 01:19, Shakeel Butt wrote:
> > > On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> > >> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_l=
ock
> > >> once per batch, but they update the node and memcg lruvec stats for
> > >> every folio in the batch while holding the lock. Only the LRU lists =
and
> > >> the memcg lru_zone_size need lru_lock. Updating the stats while hold=
ing
> > >> the lru_lock is unnecessary, and they make up a large part of the
> > >> critical section, as seen in [1] where a change that added just a fe=
w
> > >> instructions to the memcg stat update path cost about 2% throughput
> > >> because the LRU stat updates run under lru_lock, and the overhead we=
nt
> > >> away once they were moved outside of the lock.
> > >>
> > >> With many threads faulting and freeing memory in a single memcg, abo=
ut
> > >> half of all cycles are spent waiting for lru_lock, and the hold time=
 of
> > >> the lru_lock directly limits throughput. A perf profile with 80 thre=
ads
> > >> faulting in and freeing shmem in a single memcg shows 52.8% of all
> > >> cycles spent spinning on lru_lock, split evenly between
> > >> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> > >> spent holding lru_lock in those two paths goes to the LRU stat updat=
es,
> > >> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and t=
he
> > >> per-cpu counters. The stat updates are only 0.7% of all cycles, but =
they
> > >> lengthen the critical section that the other threads are waiting on.
> > >>
> > >> Accumulate the stat changes per LRU list while holding the lock inst=
ead,
> > >> and only apply them after dropping the lock (while still inside
> > >> the RCU read section that keeps the lruvec's memcg alive). This move=
s
> > >> the stat updates out of the lru_lock critical section and turns the
> > >> per-folio updates into at most one update per LRU list per batch.
> > >
> > > This updating of stats after dropping the lru lock does introduce one=
 behavior
> > > change i.e. race between reparenting on offlining and stats update. I=
 think it
> > > is safe and correct though. Better to document it.
> > >
> > >>
> > >> The batch is attached to the lruvec while lru_lock is held so that t=
he
> > >> LRU add/del helpers don't need to pass it down. To keep struct lruve=
c
> > >> from growing, cost_lock is moved into the hole after lru_lock, which
> > >> leaves room for the batch pointer in the same cacheline as lru_lock.
> > >>
> > >> The stats can now lag behind the LRU lists by one batch, which is we=
ll
> > >> within the per-cpu batching they already have.
> > >>
> > >> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned t=
o
> > >> CPUs repeatedly faulting in and freeing memory in a single memcg,
> > >> average pages per second over 7 freshly created memcgs per run, 2 bo=
ots
> > >> each:
> > >>
> > >>                      before    after
> > >>   shmem, 20 threads  4.74M     5.47M   (+15%)
> > >>   shmem, 80 threads  7.94M    10.33M   (+30%)
> > >>   anon,  20 threads  3.04M     3.35M   (+10%)
> > >>   anon,  80 threads  3.23M     3.41M   (+5%)
> > >>
> > >> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_=
a76izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> > >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > >
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >
> >
> > Thanks, I'm planning on queue this.
> >
>
> I'll send out a v3 today that adds the documentation Shakeel suggested
> about the race between reparenting on offlining and stats update.
>

I'm seeing that the patch was picked up yesterday into mm-new. Could
you or Andrew add this paragraph to the commit message after the
"Accumulate the stats changes..." paragraph?:

"Applying the stats after dropping lru_lock means a batched update can
race with reparenting when the memcg is being offlined. This is ok
because updates to a dying memcg are redirected to its nearest
non-dying ancestor, which is where its folios end up after
reparenting."

Apologies for any inconveniences.

Thanks,
Joanne
