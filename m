Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795173412;
	b=pMuiM8ywU7bHfrD5Dv/QjBKziVfKf6g9URhPYVlu9LxP/El3+evxmlbzAi+NtUzcX0G8
	 XT/LSRt54WW8ni0BHOdjKL7OMBAX1qxi039jx+GD0ydo2DhxbQ2H5xbe1JUu4185vEp9N
	 ngo39BEu+iGLDM5EWBScf7lE3zTu63TIuFkcjr3hC1U1ZqVg9S/+oYnBbdy00kxTxB/J+
	 SiWzYr6P9/sywYQhuus6bCjwqH0cgfLIPsBdOIytlNr3987eIH2gmIY3E3ezQ/DUQH+aQ
	 195Dlwn/wqrJLSPsly4oFy720R0rhaDVOSTyKN11RCzf1HN9S7cIOAGCgWpn7Egrn7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173412;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
	b=KgeM3fImJxcHBRrLkm8AFb9Q+MNF36vCPilsbWgW+HZ0mTYXglUh/L+qL+TEpCcCEDp5
	 SvGczG7D5bDbEwnBZ4jsMRsnEUWIEesFrXi7GXeFvlJhbXIGmv4IvGRVZWOHkQQ52RUgk
	 0quAPfworTuYM+TB1n83BrQKHLFY3E3xK6uo/45ToOzmX4GpVamRXi+bn6Lf1YMnNKFxa
	 fyG5G//po5JTCGGy+sYsK5OTN8ZN+HTvVL7v6wVUl3vR6ZzTadyxMynVFASofNYy62OVq
	 LhUmT7u5h/P096LZ+w+mpYjyc5pcqXB4gCyz/IxJ8vqXOedcOBc3RP7E5uB0N8101Pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dg0qNTaw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910BF606A332
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 11:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 910BF606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dg0qNTaw
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5133831027so114299566b.2
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 03:16:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795173410; cv=none;
        d=google.com; s=arc-20260327;
        b=F1ogKOFohvARzqyG7Oph64qPtqI+BBhq4qScTUM9zEoPlPqSKkH2Vbs7jYRPjd17qN
         A6tT+BoeaYvH4hF8jZaaQjBhk7YtqdbyGEd52MGU6zwlhyP1NgCx0lP3vY43RpNOR04V
         6+P5+k1/i/RrjTSmaGSeJrmI7vHdNGi6Wwsy8S0vJt2m2jEmSj3Gm9SyLZ1LFTvPlWFn
         v45ikT5L+a+nga4w8mKROlHevnft9m8VbXWmYXYArxu2pD7GqT/8mQjO3S/ahmZsbUeH
         pFYiQd9llABcCHoVptaYiB3xWT+jQ6Y083OjsTOtEJ4fWZcUDtkoEZMHG1KdYpuMT/jW
         Tz0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        fh=hQdvr/Ylkymp9bwyhTd7wr9T1XTXUtWScrB7IC7WGTQ=;
        b=KTANw0J05nar6/uV/CIdb8luRD9BYZwdzYS7xYdGYQBIyyJrY4gOuh2Bnd+A+0FZrx
         qVtCTQv3UY/ar3pxm3AOA6tcAFy4mn9m9OMG17gTVUQvBLqpL4V5D/+JL8hzaseVxAl7
         sKUUW/J48wyhxfF8PcsD4wNGvSn6LISYfJ+Jx91RPY59OR0n9ZjUn+9IJFWDxI0s65bS
         lV8v8xvOJ4PLfGhpPa0LNdgtkaL6zwWjAP5YmvAqg3T6XqSdr6niykycS5fmlwG/7QCW
         hjh9y4oZTC9BE/BYlMJDBdpWRo6jbX16DnmOfe4nD5prcBO2Gr0BgLsDp8xj8SX+4sTZ
         o61w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173410; x=1795778210; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        b=dg0qNTaw1I2FaQAtzF9Y7WtNR27A4Rv9Gpi6OeW4VqDaX+wfWjw4ofghPyRQkqlbX3
         QBPsfWsfquSDRqV0JKcgNBvei06W6DbpFeVHjNn/yIXk5cn3hBKOfU2ovzx6qaoswy45
         N3lS2HywAUUOlvpAM0RiyBr2j8lbDIdVIunwVAXI9YP3Z9nNOPxtpGAY+NtZuFHBAjMQ
         KNODN0cu1psGJpIR9i9C3P/sbOssnq865mc2HSWIPpz+3JuSvJVs/h5G5ZZnj6tPOvc9
         AmNmtgavvxMNUJK3wCyQrWliBPcdDTKyZhWwEf8RdanEMh1JyuFchDfRuOF1fJVOq6tD
         MrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173410; x=1795778210;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0NaMGQ4Owpl3Co7yhqKVZHVr+kTFNUk1Lb3ecw2usVA=;
        b=MU8WGUnqNqxXAyWVRjystV9jYe/hTqSD0bVY3fFB4ixIH8fyj+sUrwyxbBWgxqTr/h
         wGdfldTzN37Sn87urFe/4CzVbqnZUzODC7RQdXhMOe4jOgAnJhtKHGM/MsG56mGLO/DL
         yV/8zZ0UfJg/FRMrgybUstUfEGXhJkScj+0aOSzgStJ6WxABYFJybNhrUql0cRwh/xEl
         ynrd7pxfr0oPKejCdGVNdb0wHM5z6+ecvyrX8Z4UpdLGCfhquW7xrGr0qazF+GY9fTZa
         dKmTw6udEw6AiEooOhF/Qv9DHONH/R8oqN6XDaNsJJq7+PyoxgaI5/5JHFi5Q4gE6SPH
         o0qg==
X-Forwarded-Encrypted: i=1; AL+hErEkQ/R0409RkHYdqH/O5/4MlMo01XAAT7k2E4rbSi/zu2mDJ9d/iVK8f07S6zcogetB5xgMOdMf@vger.kernel.org
X-Gm-Message-State: APuU4Z9eO2stATHjzX+b26yzyi/ZpFM+qcnF8sq2wdCf03Dnxb/fCCcm
	tkLbe/IimG0sqzvbEejhVgdLAZ2NcEBKCE7/jfhSqWog8SW79SinLjTRqF5ZUEQRFt+ka+VFch1
	/aeVqMGADmsutOQzRoxizNTzaBI5I450=
X-Gm-Gg: AYBFou1AMwyd2M66JuLBZu5LANbuMP8DujNVM/+5JzKAPb7qhsuRPnI3HMHrFC9wrW2
	3XeN/4NmWyZQRvww9P++OU4iSZyQS/fUD2E96ZUoMGtm8jtHlCz1imvmpQDm+HgSfW/afET4+cL
	mFQnsqdCN8lGqXket+PxHbYYX8P06Oq3UbIRFvfo9FteOt9CZaKJXP2YImcezCfN9K9uPxpmj6h
	MZ611wT0oi9qtGeVf4ki1eM6K+vQGZyW8Q9vxNI/HJNL2WFFpjxUljiQMkXChzYno2/7p5e/Rhz
	2theT0it9e3NCdYAXiiIizZm9Jhre0a8S79LOFyszxHehVElUpUvJ7FMQy1kxLJxV6PvQnb6SKt
	zmlM/zmP/UNMIbgVqWG67J5of/z0GBo0zj1nPg7bmGh7QJ4S3Lmdq2y2ouELMG1z8lXQZWA==
X-Received: by 2002:a17:907:73cd:b0:c40:38b5:d784 with SMTP id
 a640c23a62f3a-c513a614467mr280155766b.22.1795173409664; Fri, 20 Nov 2026
 03:16:49 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 19:16:12 +0800
X-Gm-Features: Aa3M54pc2xETNqoexA8P5jVd0jSnzthhaZdG2Uuuwphbutgg3FiGQAMnp8Ovueo
Message-ID: <CAMgjq7Dd=Y+GekSD9WO5oGdoa+S1eG3T-U=VsCexopvb723zFA@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 7:40=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote=
:
>
> > This series implements MGLRU-FG following the idea proposed at LSF/MM/B=
PF
> > this year [1], based on current mm-new. Depending on the workload, it
> > improves the performance or reduces IO by roughly 10% to over 50%,
> > fixes multiple long-standing issues with MGLRU metrics, and drops one
> > page flag.
>
> This is looking really good - great stuff.
>
> Review is thin, so I'll remain in wait-and-see mode for now.  What do
> people think?
>
> I told LLM to put this series through its paces.  The performance gains
> were confirmed (actually muchly exceeded) and it couldn't find a way to
> break anything.  It found a smallish slowdown in writes to clear_refs,
> which doesn't seem very important?

Thanks! Glad to see another positive report. And yeah I think
everything is fine.

The reply below is a bit long (and 99% not LLM generated :-), so
TLDR: We fixed a long standing "bug" here in with a small (IMO)
interface performance drop, and that interface's user was already broken
(which we fixed), and I think the performance can be easily recovered too.

("bug": it's just messed up metrics readings, there is no leak or
race, just these values are just no longer meaningful in anyway and
are breaking real world usage, see appendix)

A slightly (~10% end to end, that one interface only) clear_refs
writer slow down is expected, smap is the only user for that (maybe
DAMON too but it works differently and won't cause this many calls).
However, the thing is smap reading was almost broken for MGLRU in
mainline, just like K8s users have to disable MGLRU by default for
years because it keeps giving gibberish readings (See Link [20],  the
refs and workingset are tangled in PID controller / aging in a
hard-to-describe way so we see seeing unrealistic values).

This series fixed that, metric readings are now sane, stable and
accurate, close to CLRU and provide useful data for workingset
estimation, so the trivial slowdown of a lessly used interface seems
very reasonable, and we only slow down the even colder hard reset
part, readers are good as before. (We'll also need to update the tools
ABI part later, but that's too long for now, and I think we can live
with it for a little longer considering it has been broken for so long
time...)

Meanwhile, if we want better smap reset performance (I'm not sure if
we really need that, since it is costly by itself already, a whole VMA
locked walk & PTE update per page, and ruins the hotness info), we can
do this:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a2442e49aca2..45808f7ae50c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -562,10 +562,12 @@ static inline bool folio_check_lru_refs(const
struct folio *folio)
  */
 static inline void folio_clear_lru_refs(struct folio *folio)
 {
-       if (lru_gen_enabled())
-               folio_reset_lru_refs(folio);
-       else
+       if (lru_gen_enabled()) {
+               if (folio_lru_refs(folio))
+                       folio_reset_lru_refs(folio);
+       } else {
                folio_clear_referenced(folio);
+       }
 }

It should speed it up instead for most cases, I didn't include it just
to keep the code a little bit simpler. Smap and DAMON are the only two
users, so it's safe to squash this into Patch 10 "convert to LRU refs
based operations for MGLRU" directly.

In fact, if we really care about smap performance we should start
batching it instead of doing things page by page like right now, I
think that may bring a much larger speed up.

And a Appendix: Measuring the smap Referenced, and active / inactive
reading during a build test (LLM did help on this :-D ):

      =E2=94=82 smaps Referenced/Rss % min/med/max =E2=94=82 span =E2=94=82=
 stdev
CLRU  =E2=94=82  99.4 / 100.0 / 100.0              =E2=94=82  0.6 =E2=94=82=
  0.0
MGLRU =E2=94=82  38.0 /  99.6 / 100.0              =E2=94=82 62.0 =E2=94=82=
 12.3 - erratic and unstable
FG    =E2=94=82  99.9 / 100.0 / 100.0              =E2=94=82  0.1 =E2=94=82=
  0.0 - matches CLRU

      =E2=94=82 active_anon % min/med/max =E2=94=82 span =E2=94=82 stdev
CLRU  =E2=94=82   0.0 /   1.1 /  24.9     =E2=94=82 24.8 =E2=94=82  4.5
MGLRU =E2=94=82   3.7 /  96.4 / 100.0     =E2=94=82 96.3 =E2=94=82 23.7 * c=
haotic, almost random
FG    =E2=94=82   0.0 /   0.9 /  12.3     =E2=94=82 12.2 =E2=94=82  1.9 - m=
atches CLRU

      =E2=94=82 active_file % min/med/max =E2=94=82 span =E2=94=82 stdev
CLRU  =E2=94=82  34.1 / 43.8 / 52.2      =E2=94=82 18.1 =E2=94=82  4.7
MGLRU =E2=94=82   0.0 /  0.1 /  0.1      =E2=94=82  0.1 =E2=94=82  0.0 * en=
tirely wrong, always ~0
FG    =E2=94=82  24.3 / 33.5 / 42.2      =E2=94=82 18.0 =E2=94=82  5.7 - ma=
tches CLRU

Pool over 3 test run with make -j48, defconfig, ZRAM as swap, 3G memory.

It can be seen clearly that the metrics readings before FG were almost
gibberish, FG fixed that just fine. These are causing issues that
describe in the Link [20] above, and many other components. And they
don't write to clear_refs, they just read meminfo, smap is also
included here but less used.

The active anon reading for both CLRU and FG seems a bit low, mostly
because this task is under heavy pressure and aging/reclaming fast,
and FG also provides the way to tweak it in the future
(LRU_REFS_ACTIVE). And FG reporting a bit lower is somewhat reasonable
since it does reclaim better.

Note, the goal here is not to match CLRU, but CLRU was clearly doing
much better on this, so using that as an reference shows the
reworked readings are indeed normal and reliable.
