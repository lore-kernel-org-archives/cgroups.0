Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D9240A926
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 20:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790369062; cv=none; b=lgrHbonfTMtxVkgSCo3FCXJLQyAptdkKiH944XUicrgawqnVJw15/0AKgvYMdBj0kAqcJTGlDGR/X9a0pOV3ouKYTL79wXdmuU2R1KgnIcGmgLpQ3Oq5Wyn+Qwx5wjTwAdVlMxzO2JB94ITJQifT2rx/5YYaD0uub71BfNWSxuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790369062; c=relaxed/simple;
	bh=Fty3PtDIdbpGHkF+ESk4EG6R72qc9XLNp4twO0/zo8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5LJu8bZd8jqN4XP4KWlONCPlAizQ/mfCAz9mJrIkQxOBX9b8v3BWLIYwrbI1jkCP1DnhlVFgji3fvf0NjO/FMKKB9V9d2NTAbXxLmVyVo7WeOAvhmrPaDSUuymcUr/AbyNo+phH1qWTy329uvmGVqJGdytY3eJAGz2AayEx8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP4EsSUB; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP4EsSUB"
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2df4aa80a73so8028995ad.3
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 13:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790369060; x=1790973860; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lnZPCNkuYlkSQQSolmN0z74V+niIjfG3d6O9GzevQ5o=;
        b=DP4EsSUBeVQVbufwQcxosHMM4sR0btiKLHZ6+GMph54ac65jzctz74ZlDRSV+ebZJW
         m/SOXAXEs3YDPCioDcd97FPmi9rVBcDlx5OPw8M/dKX71+lUPD15yB4hLGkNyhm0foKj
         qOdoulBBe/BNdCCeKimhXUJ6lL2PP/3bcauBp6PFCmDhvw8BsuxOg6j5rWv1QbgMWVwJ
         HUDo+9yclJnHreNEgY2jJeRWp/fzKJU8r55xrh7LKHDuKFFVIgCnFadg6RH6O2yNK3U6
         HzBZExemROnXlL1VTNk64ND5eroDHF2yyP2iUHtvqDtzkC3SuQhwITd4HVv77ljBfzHb
         waNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790369060; x=1790973860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lnZPCNkuYlkSQQSolmN0z74V+niIjfG3d6O9GzevQ5o=;
        b=csN768A7cp3/Ouo2j22HqHnoSD4XxHNH/9C3J99/l4tehQV5J3QpeNVdfMaB0gmSCd
         zwEvEOeeCxVUNr6zLhdZ2s6rcmTLnGI5yyIOeierDW2Fc1+QsILRizN+aevRZggNvOCN
         mNHUR5jmz+7ir8B7y3dgkexLSUzx0xRQlz/2O9JG8+LIgdttguUtIX298N+5xsm7nWjC
         f4uxqLj1XW6AA1Iq4PHtVXZmWf4Gwm4h4ih0BWng5+EXwjsokrn7EU6ts3MSvqiLguoZ
         6ri1xSW0AkJ6h+wxg7ozHyXyU/d7ozj2gMkP3Ik1uHrvPcfaCKREAFJVUJEgGnpiOYUR
         Qrqw==
X-Forwarded-Encrypted: i=1; AKwUvBwayxJv/+iVEXpIYxt8bK8U1BT+7f+HYhCt6tSkQuO1izC3jMB7n8yFeNMgQf5Ugp6MmiZUDBmI@vger.kernel.org
X-Gm-Message-State: AFuF++l5mOCc1Aa/HAyDHtufKVP5gNhtJHwvd+wraTpD09zfUWamSQqW
	T5bVTBgN6+NU+8q6lPnFYK0edKVJCjqiG3zZkBqEMI1Mt45nDobbKSot
X-Gm-Gg: AYBFou0zLvwdTsqB1VnBWOI1WKRYQ6zLLwLt7zmy92iLN/VGl0ahhRV9wLx/IsuBnJl
	4E7N5MFJfrcVh82D8dgdIwUZmeflXy+47QYiBxVWrPmwr6Fs1wZdFttIhJtF/1bhQr8t78Qf3ch
	AoNXZOzQd6m5/EBtwzpTG3LOwvN0B0UM9kdWgC9eFi28JbHxklDfBG+EhVVJcuYdiZrzxTXKTDJ
	Nuqj9Ru3LBkjIG+kSpdE5v4GJ98YPoIxkW0HcQB2weEuRRzYtz+M6QFTmCNCEWZdw4lceOLb95V
	yxakPkGXYYsMIatn/sCmSGFIZws1DiSxaQuQTyOMFqKlZaQlONlitEeFtj7a7418pEf5hOl4Tzs
	AaKa1VtchnYZl8jT28bpAX/J5CjKquLSTXVcd1Tg+X+bzxz9BjS6vGWYcg2JUTogeVMlaI8TF4J
	7FppxSMiXz4QWDS4E1DdjipXzLOsADopbis0bH/sOobTwQ4cXFNYoRGkG/cF0fNCEzDQ9Fl0rpw
	/JbPlgfmDQyWm7wJqm2I2NwFO5n9ghAbukzLf7J5GJ0OS/9IA==
X-Received: by 2002:a17:903:3c4d:b0:2dd:ad73:c989 with SMTP id d9443c01a7336-2df7dc4d86dmr58659805ad.33.1790369059625;
        Fri, 25 Sep 2026 13:44:19 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9144940asm15623855ad.62.2026.09.25.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:44:17 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:44:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbJ1LTzc7H4GL27@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>

On Fri, Sep 25, 2026 at 12:11:55PM +0800, Gregory Price wrote:
> On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> > 
> 
> First, thank you for the very nice email, this provides a lot of
> missing context to the discussion and clarifies the issue.
> 
> I really appreciate you taking the time to spell it out.
> 
> I've given it a read thrice over to make sure i haven't missed,
> so please don't take my trimming for skipping something, if you feel
> I missed something important let me know.

Thanks for taking the time reading this :)

> 
> > 
> > First a little bit off topic, I'll be really happy if we can make
> > both compressed memory and swap as separate counters (I even once
> > tried to implement a zpool accounting to account compressed memory
> > in some unified way, but, well, zpool got killed before I post
> > that :P), or at least a way to do that, e.g. something like nokmem.
> > Due to our real usage:
> > 
> 
> I think we all want the same thing, just in mildly different shapes.
> I really see this breaking into two core issues:
> 
> 1) memory.swap is overloaded, and we disagree on its semantics
> 
>    I think there is a strong use case for both detaching zswap/swap
>    and for retaining swap as a logical limit.  You lay it out fairly
>    well here that you are replacing a memsw SLO mechanism with the
>    counters available in memcg, and I think we need to give this
>    consideration as something more than simply luck.

Yeah there are still effort trying to push memsw into V2 upstreamly,
I even got a suggestion to hold a topic on that last year at LSFMM
but didn't find enough time :P

> 2) something has to pay the price of virtualization - period.
> 
>    No matter how we cut this issue, something in the stack is going
>    to implement a method of virtualizing a swap entry.  Whether that's
>    a virtualization layer that virtualizes every backend, or some kind
>    of franken-swap device that lets a non-physical swap backend look
>    like a physical swap back end without charging physical swap.
> 
>    If the history of virtualization has taught us anything it's that
>    the overhead of a virtualization layer is *almost* never so extreme
>    that it isn't worth the utility of the layer
>    ( unless you virtualize the wrong things :] )

Hmmm... I mean there are tons and tons of projects trying to get
rid of the overhead of virtualization, if you are referring to
virtialization as a broad topic..

With careful design we can miminize the overhead for sure, and
that's exactly why we need to do the design carefully :D

> 
> I also think these problems are mildly orthogonal.
> 
> We can solve the memory.swap problem without having to solve the
> virtualization problem at the same time.
> 
> The virtualization issue is much more compositionally complex - we
> need to account not only for ordering (tiers, priorities, etc), but
> also writeback mechanics and migrations.
> 
> Quoting roman:
> 
>  > I don't think it's reasonable to add a new interface, but having a
>  > patch/config option or even a mount option which changes the semantics
>  > of memory.swap.max to the v1-like behavior should be ok.
> 
> It seems we're having the same discussion.  We have users who want
> them decoupled, and users who want them tied together. I think boot
> or build option that switches this behavior is the worst of both
> worlds when the counters compose cleanly:
> 
>    memory.max = max physical ram you can use
>    zswap.max  = max physical ram zswap can use
>    pswap.max  = max physical storage swap can use
>    swap.max   = max logical swap storage a container can use
> 
> > But with compression as a fixed part in memory.current, first the
> > compression rate is totally uncontrollable, both the user and us
> > will be fully *unaware* of how much memory they can *actually* use,
> > that makes the planning really awkward. memory.max stops being the
> > bound of what we planned or sold, anything compressed lets the raw
> > footprint go past it by however much the compression ratio happens
> > to give, so what we oversold is bounded by the workload's data and
> > not by anything we configure. We can substract the zswap reading
> > though with adaption, however it's hard to change the performance,
> > OOM behavior or reclaim behavior:
> > 
> 
> I do in fact this is solved by splitting the counters.
> 
> Consider:
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 2GB
> 
> This looks silly on its face - but it's not. This says limit total
> swappable capacity to 25% of ram, and you can only offload 25% of
> your total logical memory sapce - i don't care how much it compresses.
> 
> You could offload 2GB of anon at whatever compression ratio you get
> and fill the dead space with page cache.  There's utility.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 4GB
> 
> Limit overall compression ratio to 2:1 and 25% of memory size.  If you
> happen to compress more, you can eat some page cache, but you're never
> getting more than 4GB of anon swapped.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = 8GB
> 
> Limit compression ratio to 4:1 and 25% of memory size.  Same as above,
> you can fill the slack space with page cache.
> 
>   memory.max = 8GB
>   zswap.max  = 0
>   pswap.max  = 4GB
>   swap.max   = 4GB
> 
> Limit logical and physical swap to 4GB
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 4GB
>   swap.max   = 8GB
> 
> Limit zswap to 25% of memory - maximum of 4:1 compression ratio
> if you don't hit that ratio use up to 4GB of physical swap.
> if compression hits 2:1 and you can use all of your physical swap.
> but you cannot swap out more than 8GB of logical memory
> 
>   memory.max = 8GB
>   zswap.max  = 4GB
>   pswap.max  = 2GB
>   swap.max   = 8GB
> 
> Limit zswap to 50% of memory, and a 2:1 compression ratio overall, but
> if you don't hit that ratio use up to 2GB of physical swap.
> 
> In all of these scenarios swap.max is exact same counter it has been for
> you, and what we get out of this is:
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 8GB
>   swap.max   = max
> 
> I don't care how much you compress, you're limited to 2GB of ram, have
> at it - and feel free to use another 8GB of storage. If your PSI gets
> too high we'll do you a favor and OOM kill you so you don't spin
> endlessly churning your swap.
> 
>   memory.max = 8GB
>   zswap.max  = 2GB
>   pswap.max  = 0
>   swap.max   = max
> 
> Only zswap up to 25% of your memory, i don't care how much to squeeze.
> 
> I struggle to think of a scenario that cannot be described
> compositionally this way - and that is without adding any kind of
> "tier" logic.

That sounds interesting, but I think this is already a mini
version of swap tiering :D

And not sure if the implementation will looks odd, e.g. like if you
adjust that midway, you get different slot of different compression
rates.?

> > And if the memory compression is really fully transparent (not
> > doable by software), yeah, that's great as there is nothing to do
> > with reclaim.  But, for now, we have to go through page fault / folio
> > allocation / map it again.
> 
> Transparent compression creates a completely different accounting
> problem.  You lose ALL ability to see the per-page and per-memcg
> compression ratio, and as a result you can have 1 container jam
> 300 billion zero pages into 1 page, and another container spew
> /dev/random to its memory - the result is the 300-billion zero-page
> consumer is the one that will get killed for over-consumption.
> 
> Unless hardware provides a way to attach a token to a particular page
> (either by out of band reporting or some architecture extension that
> reports this as it is written), this problem won't get solved.
> 
> Until then, don't count on having anything more than a logical-view
> of offloaded compressed ram consumption.

Right, thanks for the info, I don't have any transparent compression
hardware so not aware of how that part works, the software based
one is being very commonly used though.

> 
> (this one of a few reasons it should not be serviced by the swap
>  subsystem, but I digress).
> 
> > So For example, if we already have
> > memory.max == memory.current or under high pressure, then now
> > doing any read from the compressed part would need to some
> > require further eviction first to make place for the decompressed
> > new data, this is not like any kind of "real" memory, something
> > feels not right here.
> >
> 
> This is in fact how numa balancing works on tiered systems.  You eat a
> fault to migrate a page to the socket, and with tiered counters you are
> required to drive reclaim to get that promotion. (Presently this isn't
> true of global pressure, migrations will happily fail).
> 
> In practice, we find this is acceptable but could be better if we
> allowed the promotions to occur asynchronously outside the fault path,
> but this has other trade offs (loss of locality information).
> 
> Anyway, this is exactly like real memory, just a bit more stringent
> (a "Swap migration" cannot be allowed to fail, while a promotion can).
> 
> I have also experimented with this particular issue in compressed-ram
> forcing promote-on-write instead of letting the hardware-compressed
> memory be written to uncontended (which is a RAS nightmare).
> 
> In practice, if you are decent about proactively reclaiming your
> workloads, or if fairness is enforced across workloads, this kind of
> issue is not as big an issue as it looks. Fault time can be minimized.
> 
> Some partially simulated data:
> 
>                       Cost of a page fault
> backend                   p50       p90       p99	max
> disk swap-in (NVMe)       59 탎     70 탎    145 탎     1.63 ms
> swap-cache hit          1.13 탎   1.15 탎   1.25 탎     79.9 탎
> zswap-in (zstd)           26 탎     31 탎     44 탎     0.27 ms
> cram write-fault        2.10 탎   2.24 탎   2.43 탎       70 탎
>   (promotion)
> cram read               0.13 탎   0.14 탎   0.14 탎     14.7 탎
>   (read-in-place)

...

> 
> Generally I disagree but the data above shows you are technically
> correct for extreme outliars (zswap-in max vs disk swap-in p50).
> 

That data is very helpful info! But it could be very hardware dependent,
especially with certain mitigations and hardwares, the faulting
process may slowdown by a lot. This is the right picture for most
cases, and for another example on one of our certain instance of VM, I
observed this (high pressure, batch fault):

                    component                      탎/page
page fault handling (directly calibrated)          ~1.92
swap machinery (slot, swap cache, rmap, zram, etc) ~1.04
lzo decompression                                  ~0.32

Kind of crazy that decompression only take a very minor part
of it.  While storage based SWAP goes through SPDK so it changes
dramatically according to the host, setup or spec.

BTW CRAM looks really nice from the data of yours :) !

> But I can understand why the point here is that you might want to limit
> the total amount of swappable memory, regardless of where it ends up.
> 
> The real issue is when your hot (or warm) memory exceeds your real
> memory limit - at which point you start entering a churn cycle where
> every swap-in swaps out a hot page.
> 
> That shows up as stalls and PSI pretty quickly and can be dealt with
> by monitoring - but I can see the desire to just have them OOM.

Right, monitoring is less effective from somehting that is directly
in the kernel.

> 
> > I also want to separate two things that I think got bundled together
> > here: not requiring a physical slot behind a compressed entry, and not
> > charging the raw size to the swap counter. The first one is great, yeah,
> > and it's exactly the part we want, it's what makes compression usable
> > without provisioning disk.
> 
> agree
> 
> > The second one is a policy change,
> 
> Disagree.
> 
> If zswap does not charge a physical slot, then it is correct to stop
> charging the counter based on the historic definition - it just was

Hmm, but the historical defination is the logical entry, no?

> lucky happenstance that the swap counter and logical accounting matched
> up until now.
> 
> That said, I think there's a strong argument that breaking that coupling
> may in fact break users - but the answer may not be to do nothing, but
> to simply give physical swap its own counter and begrudingly change the
> contract.
> 
> I can hear Johannes rolling his eyes at me from 3 states away :]
> 
> > maybe it's not needed for the first stage, charging a cgroup for the
> > memories it has offloaded doesn't require any slot to exist behind them.
> > If someone wants to run memory compression with no disk at all,
> > memory.swap.max defaults to max, so that still works fine, right?
> >
> 
> It becomes confusing, because we also want to use the swap counter to
> control physical consumption.  To run with only zswap w/ swap.max you
> must have no physical disk limit.
> 
> It is the exact opposite issue of yours.
> 
> > And I'm not asking the compression layer to have an opinion on how
> > much compression or ratio is too much, just think we need a sane limit
> > for container schedulers to sets on top of it.
> >
> 
> I don't think it's unreasonable.  This just seems like a distraction if
> we can come to a conclusion where both scenarios can be composed.
> 
> > memory.max: control the raw usage of application.
> > memory.swap.current/max: controls the offloaded size/limit of a application.
> > With (memory.max + memory.swap.max) <= planned usage (and this is memsw).
> > 
> > We can keep the compressed part in memory.current of course, as already
> > did in upstream with ZSWAP, and things can be further adapted, we
> > still have:
> > 
> > memory.max: control the real usage of application.
> > memory.swap.current/max: controls the offloaded size/limit of a application.
> > With (memory.max - <compress memory> + memory.swap.max) <= planned usage.
> > 
> 
> This makes me wonder whether a pswap counter functionally deprecates
> zram, since the hard memory consumption limit becomes composable
> (putting aside the implementation details).
> 
> i.e. is there a zram scenario which cannot be composed with something
> like zswap/pswap/swap
> 
> > Just for reference. Maybe a seperate counter, tiering, is a better idea
> > than changing the swap counter?
> 
> I would push back on tiering - this seems like more complexity than the
> requirement warrants.  We may find memory-backed and storage-backed swap
> want different solutions in the "tiering" worlds.

Hmm, I mean in general swap are page fault (swap entry) based, that makes
them similiar and that's the common point?

> 
> e.g. it may never make sense to give zswap/zram/xswap a lower priority
> than a physical swap layer, and you may never really want to compose
> them with one another, so why does it need to be considered?

Making ZRAM have a lower priority could make sense... Well I haven't
actually see it being used that way, but first there are users of
multiple ZRAMs indeed, and e.g. if you put offline batch tasks on the
same machine with high priority tasks, and the offline batch task only
want to finish their work, however slow is fine, and the user want to
have lower impact on CPU usage from them, with a limited storage space.
Well I have to say this looks odd and just a theory, but we have see
too many bizzard usage of the Linux kernel, there are even people
using deprecated GPU's VRAM as SWAP for CPU's RAM, and hey they
still make sense, you can easily found popular community projects
based on that.
