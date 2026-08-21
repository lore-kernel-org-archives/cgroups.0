Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06F93769ED
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787334727; cv=none; b=Kod1WmTpmZ6CE1SYu8vM3FO9Lcv8iD2LyGMn9XdoGA9I3xuhBRtt8agAwqoB9FnnTJgjISUy6qlGUx5JKgLDIhNcS4L8x48UWJg40BOAjaXU0ajUjWwTOobZdVfu9tAChVQcPUIPqiRzf/vL7g222TnVnjyT2mc4WYCMNZo+JQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787334727; c=relaxed/simple;
	bh=1pvGTs3ZuXmXJcXyBInIycLsQJ5XhcmpJ2/G1c6L4ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XggE6dKq4HmKf6U1zlNB5LbBZ2hZlXaFGJNMMNkg8K4GpOzl+IZXlCItizfAhtXLGO9caSQX8uS7CxAYETeYcbTMKExGAW+b1Cd2zgKyYY9wuyB97TVc4zqKbhiaU25r2SobLRTsho6U3lpneChUuNGKdHJTIihxhKvrTE43ZoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=MoxSiwjz; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="MoxSiwjz"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0cea8883so10605601cf.1
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 10:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787334723; x=1787939523; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z4r9Jbt/bO7UeLYNwfXFrbJjchGvrclBSzHl6eH4LNA=;
        b=MoxSiwjzzip8dSfzw97CKcJ2gBCYHMtPQvNLQVXkZd9ORlig1x6szzPG19rFI5v9Op
         TCG6nT1nyYHrYk3H56E7q3a3kEgMVc/DcL2C9ckyogg3SRuB9QImLNpspXDGMGJLsOjG
         rwOmN0+odKBdmSWZbNEfPfKO3iZQOhxRSdTJerpY9A3H7makdmNOViAYVgV7cPSknj2Y
         +5DtVkO45mAqEaNAthJGTwa2Wj4g2LBIdhO2JFYz4ajdnBwdCQ3FYAF2aA/IdCROKit7
         RzlBqyJ7f7eHAEbdPCEXy6i1rMzCHKmVnTEcw4/23FqlwNT1s8+bEMUjwsmey85OOHh0
         gwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787334723; x=1787939523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z4r9Jbt/bO7UeLYNwfXFrbJjchGvrclBSzHl6eH4LNA=;
        b=bhrs4LoiY+Ek8hQslfAO36zQY+0D7NYXsZ5FlyQVwrXddO3q4U9aPhATVCjtWkX/Bg
         HzS+7Miflfj/fRBpskGBFyyfZGo3W2xbyoEc79zULbwwg+wUetbTgpwfAor3wSqNQx+y
         dh1dp04nGGL2clw465fCgVu0WgOWWIE2EqMqtQeBHt8b2gl7VE/dwm3bh32HciKqbavA
         Bvr0xhmyfnWNrKwBtdmbktRCwfDEAqiM9FWvBYNOZLUrrBQCr7yf2TVi+YrAIvYX1evb
         XYPz16inXAeYyVjFzUgKXVqfy3LX464tvzJTnTL1u6UnfcqNwNzK29OCflblHfj1LOHH
         QmFA==
X-Forwarded-Encrypted: i=1; AHgh+RpUs7iJ/Z94h93h6uiGBchVzqccbv0On+w3IaovS3tkwQdm9eYBifVf+T8Nknf4F6s02tFRaFWi@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ7TsRBFySwI1SR+Odgw+6q7D9fMeNmsM3Wzqg4UFKdUQOTxGW
	vRcAJGLRfauZUKKxmWyzJFgTwu7BWToXjEotoBc+aw+Ix0IbM8x7SpthG9yE1bUrxss=
X-Gm-Gg: AR+sD10IWu7mWwusB631IDpM3NZLMp2rGEX+hGyoj40henRkosKeVAGeKvgTaNWqYbo
	+T/hl9/XmhHaJQ2UikQgjKKJdZvdiXNh/YVg/cp3e70LeApuZJLOV1UsZQen+hCZAvD3nteMEew
	6hxADduUaRRNSFOlGbQdRXOXjmJn9tzZQ41ruVzql9KoF11rDUitsThWaVc4a0lrMfJEDagjQo/
	/d2jmFyupV/xMN40IF33fgZ7gmw2p+I6H+fKmKWtondnde+NJiVnK8eyyLXo+AYQpYQ68g1D3zx
	SUtDxuu3B7T6ZNfwS0LWRQpbNZa8OBMBSqcmElNDAloV85yv1CtawQnLgLnSdaxQYWvAPlEBx19
	Smj7hAsHHhhrqeMSAEGgKhC+e3tHdMjy4F3rI/rOK1VH3zwprFQZkzfK6qH7z4r7h8g8XCH5yU+
	YCB0cz1lPv/cQ3DtG50nM8V4jvYKJIonVOaUFBdw7zHg7fv8Y8X0qOIpKQs98p0Kb4pJJEDQ==
X-Received: by 2002:a05:622a:8603:b0:52e:1e5:45d6 with SMTP id d75a77b69052e-52e01e57d27mr28511781cf.6.1787334723252;
        Fri, 21 Aug 2026 10:52:03 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2906afsm67569666d6.25.2026.08.21.10.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 10:52:02 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:51:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Song Hu <husong@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <aoiQPrudvYZ76ZSD@cmpxchg.org>
References: <20260817131843.45121-1-husong@kylinos.cn>
 <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
 <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>

On Thu, Aug 20, 2026 at 03:18:39PM -0700, Joanne Koong wrote:
> On Tue, Aug 18, 2026 at 11:35 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Mon, Aug 17, 2026 at 6:53 PM Song Hu <husong@kylinos.cn> wrote:
> > >
> > >
> > >
> > > 在 2026/8/18 00:04, Shakeel Butt 写道:
> > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > > >> cgroup rstat hierarchy synchronously with force=true, which skips
> > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > > >> with zswap.max configured, a container takes the global rstat lock
> > > >> on every swapped-out folio.
> > > >
> > > > Any reason you are limiting zswap through zswap.max?
> > > >
> > >
> > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > can soak the pool and crowd out the others.  zswap.max is the only
> > > per-cgroup control over that share; memory.max bounds the total
> > > footprint, not the share of the pool.
> > >
> > > >>
> > > >> zswap_shrinker_count() had the same pattern and switched to
> > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > >> kernel cycles under osq_lock on a 96-core machine.
> > > >>
> > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > >> before the patch and 198,968 times after, while
> > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > >> attempt count almost exactly; the remainder comes from other stats
> > > >> readers in the swap path.
> > > >
> > > > This is a known issue. Using ratelimited interface also comes with a drawback
> > > > that the kernel may react on stale information and the consequences might be
> > > > unneeded oom-kills.
> > > >
> > > > There was orthogonal discussion on moving zswap limit enforcement away from
> > > > rstat. Yosry, any updates on that?
> >
> > I am not actively looking into that, but Joanne was looking into
> > AFAICT. I will respond to the thread there and CC Song as well.
> >
> 
> For this zswap stat, I ran some benchmarks comparing 4 approaches
> (switchable behind a runtime knob [1]):
> a) rstat + forced flush       (baseline aka what the tree does today)
> b) rstat + ratelimited         (Song's proposal)
> c) hierarchical per-CPU   (Yosry's idea from [2])
> d) page counters              (following what all the other memcg limits do)
> 
> For the setup, the benchmark creates a cgroup chain at depth X with
> memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
> every level, and spins up 20 processes there that each allocate 100
> MiB, fault it in, and touch every page four more times. With that 2000
> MiB against the 1 GiB memory.max, it triggers reclaim continuously and
> makes the swap traffic go through zswap. The machine I ran this on had
> 80 CPUs.
> 
> I also ran it with no memory.zswap.max set (ie no reads triggered,
> only update path runs) - as I understand it, this is the configuration
> that is more often used in practice.
> 
> These are the results I saw:
> 
> kernel cpu time (in ns) per zswap store, zswap.max set
>                       a)                     b)            c)                d)
> depth 1        567,116          35,604     35,841     34,995
> depth 2      1,082,007          35,507     37,803     36,209
> depth 4      2,153,329          37,591     40,117     39,893
> depth 8      4,211,692          34,963     41,070     44,211
> depth 32    15,728,220       53,575     94,685     65,946
> 
> kernel cpu time (in ns) per zswap store, no zswap.max (update path only):
>                         a)                  b)              c)            d)
> depth 1         34,787          34,062     34,930     35,630
> depth 2         34,913          35,061     36,404     36,360
> depth 4         36,422          36,809     36,922     37,483
> depth 8         42,177          34,440     36,679     40,793
> depth 32        55,309          55,321     57,671     59,190
> 
> c) and d) are for the most part pretty comparable to b) without
> introducing the staleness problem of b). Between c) and d), I think d)
> ends up outperforming c) as the # of cpus and depth gets larger.
> 
> I'm seeing that all the other memory limits (eg memory.swap.max,
> memory.max, etc) are already using page counters. Is there a reason
> the zswap stat can't? If not, does it make sense for the zswap stat to
> switch over to using page counters?

Thanks for running these.

I used the vmstat counter on the assumption that setting zswap.max is
rare and the counter is maintained anyway for memory.stat.

But I never actually tested it. The assumption was that surely walking
ancestors on a quick if (max == PAGE_COUNTER_MAX) continue would be
much cheaper than page counter atomics at every level. And so I'm
surprised by your results.

But that was the sole reason. If it doesn't stand up to benchmarking,
no objection to streamlining the control to a standard implementation.
