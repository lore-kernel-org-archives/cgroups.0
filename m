Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF14D98E9
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790352722; cv=none; b=Kong1WU05C22mZiLZgjDYj2uVf4SZHCzD5Pq2QNBTV/QWfgMJWByTyl8Twa3zmrtgVOXNERvsedR/CbZLSbnb5J7fWhLHhMtUhc5CUrxVnVWsZfLQdBxqJZum+1hsX1FHy/Ucana2Ecf9actQeGnP8qaZZg4W+evSmnGWdKusA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790352722; c=relaxed/simple;
	bh=BpEQji9jR4mgu2ZnPWYlQIYoeXbmuBYgLQUpGfoTXa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeE5S6wkx2eJFfR/blOjIwl45j0lx2NMALq71vpByC6uZWkPhfpNrAXnaz0QvdWPx9s7h5ByMVQqvSpLmwxbV2IBIqn+7pqn2a5ZqNij1I8lOHux8tr3YXkS71GmuA2A7OuMmz5ftwirE4Z4/qy0MHJuLerQA2UKHc62Q9XHJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jBco6D7f; arc=none smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jBco6D7f"
Received: by mail-yx2-f40.google.com with SMTP id 956f58d0204a3-67413c9dcf1so695663d50.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 09:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790352719; x=1790957519; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j9nOJpfojSiNlh1Tat5QQ66I1mxc2XU83wW7ASM+ClE=;
        b=jBco6D7f8s7t8FfIHOX9mWMWK+cgoKohiW65Jajh6yxaR+9exV8LjGyIYHLgU22GWD
         McCvtZ0MEpZYF4ZT8whxdRveiaHuxF/lZm+HcrWtqntwIaLg4tzGfG3uyT1bGhPPFqvf
         GJjwtxqMNS5pqfCO+3LB5yYFeahT4zg5dKF8naPncqeXmT+0+TKFHfBH+qKIQ42RL63U
         EhWSQuarh+LWD082WqGHFyZkqhajl4o1uo+09R2kPY/yvyWqv5ASJL8AsPvt+3r2Q2Pl
         Np/D+xTZ9Vzg5CPggoysGi8WKQZzmfe9XChbBIVY5iqopyajP+tHY1F8S3eHhipJoxBJ
         zDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790352719; x=1790957519;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j9nOJpfojSiNlh1Tat5QQ66I1mxc2XU83wW7ASM+ClE=;
        b=vF3QtjDfPG62aHyJ1yi8SBVoaQCLbucdL/0cY8ROR6BwqlHt76EN/ZMOucExjxrb+G
         uDTTm2jf2oJDcQ4mYm70ZUdjhfFeCg9uJBqG88yb9yK3Tj4rGswD+RmkJZE7r6Z0agYs
         Bk9ka81lk/u6HO4Wgk52fQTsyt4A80n4kpe2Ej4oVB9WTLBp8CgbB1PBQ+j7yZZfDQxy
         vKPlG6xi74ppLNeXqRavE9A3gEvtmBSjrb1R7bOnS1/TZZTUf4ncOqQjmkHhjTBYPVLr
         60o/8sD3HH7yryNC75yOloIgoGgCG8T9UxXzb/A9COJbTCHmK+oss8SDuxSK8tJBfkPC
         MooA==
X-Forwarded-Encrypted: i=1; AKwUvBzqgi9RmaYJgRgVaCZ9O4hr+84Kn4Ocdq/kIynWepX46nMgo5uV5z7JE9qFKc6E3cZXyhrkRdxk@vger.kernel.org
X-Gm-Message-State: AFuF++kOwHVPg2ShLw/Y1RVMKzvNJdq5N56qU3XvR25s2P2Y9xoYwydl
	CoPT/yoJJkbatzylln7T4R/6zj2Xsn1rszLjoel2H9hRkRoaVxWP7jtJBaVMfGgh4IU=
X-Gm-Gg: AYBFou1MiOZtcE0WbeCWy6zL20ZxhaoDxztaGgWR7cKWA1cZlleDsZKjtgQAYfETYRL
	cShs3SFFxnxR17RwFIxTqs/nD8SM5cBm9R9ex6m8NDgXjyUvMDxuQNzY+TKSyBwSMt9xUv1yJO8
	xniPqCP1rKSZMHdlB96RliqQiBJtSGa460WuIpl/UVM4Qskc7A65jaSU5WdLKfIf3gRjI1/SL+M
	NYtudiTkTX6ZGTD7s7nSMQKZIW+P+h2iqi/yt7TCPIJ99c5KJccRPDX3zEs7/N4QfDTiEqR4bF4
	N11dC0f8s576ME+NoBd1KOj4vsv7Fr1mPQE6INhNu2BmQnYXfnfQDc8c2sfti91Xc3nVURF2FrW
	pOwZ34LsCimlE1ee2JW4FZ6WHSs8DbZaCmncpGaxSn8dm1EBX9janLlYZ0pai4E9J6XtqguMGxe
	zuU/d4WPa6U/eq6oMpYoLkYymVZGXXxzjYIsIC2DaJ3m2BDsKvUaHKs0LJPfxJYZstJQMFrowjA
	uEGQbcUc8bbgrGUUtU9B0tzL7IFGy/0RubSd/a8b33TFiVPmE1mCAA=
X-Received: by 2002:a53:ac99:0:b0:674:a9c:a34a with SMTP id 956f58d0204a3-6740a9ca3b9mr1852794d50.24.1790352718799;
        Fri, 25 Sep 2026 09:11:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430da86f7sm20100716d6.9.2026.09.25.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 09:11:58 -0700 (PDT)
Date: Fri, 25 Sep 2026 12:11:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Kairui Song <ryncsn@gmail.com>
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
Message-ID: <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
References: <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arUcil9kxUPiymXI@KASONG-MC4>

On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> 

First, thank you for the very nice email, this provides a lot of
missing context to the discussion and clarifies the issue.

I really appreciate you taking the time to spell it out.

I've given it a read thrice over to make sure i haven't missed,
so please don't take my trimming for skipping something, if you feel
I missed something important let me know.

> 
> First a little bit off topic, I'll be really happy if we can make
> both compressed memory and swap as separate counters (I even once
> tried to implement a zpool accounting to account compressed memory
> in some unified way, but, well, zpool got killed before I post
> that :P), or at least a way to do that, e.g. something like nokmem.
> Due to our real usage:
> 

I think we all want the same thing, just in mildly different shapes.
I really see this breaking into two core issues:

1) memory.swap is overloaded, and we disagree on its semantics

   I think there is a strong use case for both detaching zswap/swap
   and for retaining swap as a logical limit.  You lay it out fairly
   well here that you are replacing a memsw SLO mechanism with the
   counters available in memcg, and I think we need to give this
   consideration as something more than simply luck.

2) something has to pay the price of virtualization - period.

   No matter how we cut this issue, something in the stack is going
   to implement a method of virtualizing a swap entry.  Whether that's
   a virtualization layer that virtualizes every backend, or some kind
   of franken-swap device that lets a non-physical swap backend look
   like a physical swap back end without charging physical swap.

   If the history of virtualization has taught us anything it's that
   the overhead of a virtualization layer is *almost* never so extreme
   that it isn't worth the utility of the layer
   ( unless you virtualize the wrong things :] )

I also think these problems are mildly orthogonal.

We can solve the memory.swap problem without having to solve the
virtualization problem at the same time.

The virtualization issue is much more compositionally complex - we
need to account not only for ordering (tiers, priorities, etc), but
also writeback mechanics and migrations.

Quoting roman:

 > I don't think it's reasonable to add a new interface, but having a
 > patch/config option or even a mount option which changes the semantics
 > of memory.swap.max to the v1-like behavior should be ok.

It seems we're having the same discussion.  We have users who want
them decoupled, and users who want them tied together. I think boot
or build option that switches this behavior is the worst of both
worlds when the counters compose cleanly:

   memory.max = max physical ram you can use
   zswap.max  = max physical ram zswap can use
   pswap.max  = max physical storage swap can use
   swap.max   = max logical swap storage a container can use

> But with compression as a fixed part in memory.current, first the
> compression rate is totally uncontrollable, both the user and us
> will be fully *unaware* of how much memory they can *actually* use,
> that makes the planning really awkward. memory.max stops being the
> bound of what we planned or sold, anything compressed lets the raw
> footprint go past it by however much the compression ratio happens
> to give, so what we oversold is bounded by the workload's data and
> not by anything we configure. We can substract the zswap reading
> though with adaption, however it's hard to change the performance,
> OOM behavior or reclaim behavior:
> 

I do in fact this is solved by splitting the counters.

Consider:

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 0
  swap.max   = 2GB

This looks silly on its face - but it's not. This says limit total
swappable capacity to 25% of ram, and you can only offload 25% of
your total logical memory sapce - i don't care how much it compresses.

You could offload 2GB of anon at whatever compression ratio you get
and fill the dead space with page cache.  There's utility.

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 0
  swap.max   = 4GB

Limit overall compression ratio to 2:1 and 25% of memory size.  If you
happen to compress more, you can eat some page cache, but you're never
getting more than 4GB of anon swapped.

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 0
  swap.max   = 8GB

Limit compression ratio to 4:1 and 25% of memory size.  Same as above,
you can fill the slack space with page cache.

  memory.max = 8GB
  zswap.max  = 0
  pswap.max  = 4GB
  swap.max   = 4GB

Limit logical and physical swap to 4GB

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 4GB
  swap.max   = 8GB

Limit zswap to 25% of memory - maximum of 4:1 compression ratio
if you don't hit that ratio use up to 4GB of physical swap.
if compression hits 2:1 and you can use all of your physical swap.
but you cannot swap out more than 8GB of logical memory

  memory.max = 8GB
  zswap.max  = 4GB
  pswap.max  = 2GB
  swap.max   = 8GB

Limit zswap to 50% of memory, and a 2:1 compression ratio overall, but
if you don't hit that ratio use up to 2GB of physical swap.

In all of these scenarios swap.max is exact same counter it has been for
you, and what we get out of this is:

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 8GB
  swap.max   = max

I don't care how much you compress, you're limited to 2GB of ram, have
at it - and feel free to use another 8GB of storage. If your PSI gets
too high we'll do you a favor and OOM kill you so you don't spin
endlessly churning your swap.

  memory.max = 8GB
  zswap.max  = 2GB
  pswap.max  = 0
  swap.max   = max

Only zswap up to 25% of your memory, i don't care how much to squeeze.

I struggle to think of a scenario that cannot be described
compositionally this way - and that is without adding any kind of
"tier" logic.

This does come with the fight of asking, again, to add another counter
set rather than simply making do with what is available.

> In many cases we just want a best effort compression to make space
> for low priority tasks, and do not want ordinary containers to use
> compression at the cost of lose of performance. While still has
> a fixed limit as usual. So simply disable memory compression is also
> not the plan, we do need compression to make place for other
> applications, we just don't want their real raw usage to exceed
> memory.max, and we can dynamically adjust memory.swap.max to
> control the oversold part, compression or physical.
> 

I believe this all just works, though you may need to adjust more than
just swap.max depending on what piece is oversold.  If you tick down
zswap.max - we would expect that to get written back to pswap.  So you
get to reduce your memory consumption at the cost of physcal disk.

I could see the process being

  ++pswap.max
  --zswap.max

Until your zswap.current:memory.current ratio is inline with what you
want, without having to change swap.max at all.  swap.max still acts
as your memory leak guard.

Although if you do this, you run the risk of mass compression-ratio loss
and a very fast oom if you don't ++pswap enough.

> And if the memory compression is really fully transparent (not
> doable by software), yeah, that's great as there is nothing to do
> with reclaim.  But, for now, we have to go through page fault / folio
> allocation / map it again.

Transparent compression creates a completely different accounting
problem.  You lose ALL ability to see the per-page and per-memcg
compression ratio, and as a result you can have 1 container jam
300 billion zero pages into 1 page, and another container spew
/dev/random to its memory - the result is the 300-billion zero-page
consumer is the one that will get killed for over-consumption.

Unless hardware provides a way to attach a token to a particular page
(either by out of band reporting or some architecture extension that
reports this as it is written), this problem won't get solved.

Until then, don't count on having anything more than a logical-view
of offloaded compressed ram consumption.

(this one of a few reasons it should not be serviced by the swap
 subsystem, but I digress).

> So For example, if we already have
> memory.max == memory.current or under high pressure, then now
> doing any read from the compressed part would need to some
> require further eviction first to make place for the decompressed
> new data, this is not like any kind of "real" memory, something
> feels not right here.
>

This is in fact how numa balancing works on tiered systems.  You eat a
fault to migrate a page to the socket, and with tiered counters you are
required to drive reclaim to get that promotion. (Presently this isn't
true of global pressure, migrations will happily fail).

In practice, we find this is acceptable but could be better if we
allowed the promotions to occur asynchronously outside the fault path,
but this has other trade offs (loss of locality information).

Anyway, this is exactly like real memory, just a bit more stringent
(a "Swap migration" cannot be allowed to fail, while a promotion can).

I have also experimented with this particular issue in compressed-ram
forcing promote-on-write instead of letting the hardware-compressed
memory be written to uncontended (which is a RAS nightmare).

In practice, if you are decent about proactively reclaiming your
workloads, or if fairness is enforced across workloads, this kind of
issue is not as big an issue as it looks. Fault time can be minimized.

Some partially simulated data:

                      Cost of a page fault
backend                   p50       p90       p99	max
disk swap-in (NVMe)       59 탎     70 탎    145 탎     1.63 ms
swap-cache hit          1.13 탎   1.15 탎   1.25 탎     79.9 탎
zswap-in (zstd)           26 탎     31 탎     44 탎     0.27 ms
cram write-fault        2.10 탎   2.24 탎   2.43 탎       70 탎
  (promotion)
cram read               0.13 탎   0.14 탎   0.14 탎     14.7 탎
  (read-in-place)

Done with an uncompressed CXL memory expander as a CRAM tier marked
read-only so anonymous memory is forced to COW. There are some truly
wild outliars on some faults, but it's a long long tail.

You can expect read latencies to be some single-digit multiplicative,
and as a result the write-fault will follow, but i expect it to be
well well under a zswap-fault (no software compression, it's just a
migration).

> Another thing is that I think we has been assuming that physical
> swap is slower than compressed memory, which is not always true either.
> They all need to be read through page fault, the page fault could
> be the real blocker here rather than IO or de-compression.
> 

Generally I disagree but the data above shows you are technically
correct for extreme outliars (zswap-in max vs disk swap-in p50).

But I can understand why the point here is that you might want to limit
the total amount of swappable memory, regardless of where it ends up.

The real issue is when your hot (or warm) memory exceeds your real
memory limit - at which point you start entering a churn cycle where
every swap-in swaps out a hot page.

That shows up as stalls and PSI pretty quickly and can be dealt with
by monitoring - but I can see the desire to just have them OOM.

> I also want to separate two things that I think got bundled together
> here: not requiring a physical slot behind a compressed entry, and not
> charging the raw size to the swap counter. The first one is great, yeah,
> and it's exactly the part we want, it's what makes compression usable
> without provisioning disk.

agree

> The second one is a policy change,

Disagree.

If zswap does not charge a physical slot, then it is correct to stop
charging the counter based on the historic definition - it just was
lucky happenstance that the swap counter and logical accounting matched
up until now.

That said, I think there's a strong argument that breaking that coupling
may in fact break users - but the answer may not be to do nothing, but
to simply give physical swap its own counter and begrudingly change the
contract.

I can hear Johannes rolling his eyes at me from 3 states away :]

> maybe it's not needed for the first stage, charging a cgroup for the
> memories it has offloaded doesn't require any slot to exist behind them.
> If someone wants to run memory compression with no disk at all,
> memory.swap.max defaults to max, so that still works fine, right?
>

It becomes confusing, because we also want to use the swap counter to
control physical consumption.  To run with only zswap w/ swap.max you
must have no physical disk limit.

It is the exact opposite issue of yours.

> And I'm not asking the compression layer to have an opinion on how
> much compression or ratio is too much, just think we need a sane limit
> for container schedulers to sets on top of it.
>

I don't think it's unreasonable.  This just seems like a distraction if
we can come to a conclusion where both scenarios can be composed.

> memory.max: control the raw usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a application.
> With (memory.max + memory.swap.max) <= planned usage (and this is memsw).
> 
> We can keep the compressed part in memory.current of course, as already
> did in upstream with ZSWAP, and things can be further adapted, we
> still have:
> 
> memory.max: control the real usage of application.
> memory.swap.current/max: controls the offloaded size/limit of a application.
> With (memory.max - <compress memory> + memory.swap.max) <= planned usage.
> 

This makes me wonder whether a pswap counter functionally deprecates
zram, since the hard memory consumption limit becomes composable
(putting aside the implementation details).

i.e. is there a zram scenario which cannot be composed with something
like zswap/pswap/swap

> Just for reference. Maybe a seperate counter, tiering, is a better idea
> than changing the swap counter?

I would push back on tiering - this seems like more complexity than the
requirement warrants.  We may find memory-backed and storage-backed swap
want different solutions in the "tiering" worlds.

e.g. it may never make sense to give zswap/zram/xswap a lower priority
than a physical swap layer, and you may never really want to compose
them with one another, so why does it need to be considered?

I think if we can break this into two discrete issues (charging and
virtualization) then we get form from function, rather than inventing
hacky half-solutions because they're either incremental or provide
convenient "turn_me=off" toggles.

~Gregory
