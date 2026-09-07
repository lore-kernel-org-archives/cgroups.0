Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BAA385D6B
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 05:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760333; cv=pass; b=W9QtDVNh/U2IpoJDJz6r/SZT80xa9n0m20wh4/F4wwcs4weELYBs1/uwqEySEKfQH5ImRK2yj5izp1ryIr/mVkjzGW3HpRXvHICaRHCxP7UsAa5ct2ayEMOPB2KfqQbWJwFFafm+usHCuedXmtCl/mqEQKBnTxiY+GIER+JvC8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760333; c=relaxed/simple;
	bh=1pczd9iQAVdymvinAesH7TumAS+oq97GEzwubK4CWRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lLuDvj5+hpserLIiTBNVuBEXeHKbyQEKZpzEajLftzN/+FAPGEuVenEuSCUOCoXujq2VhEzkqsHkOiO78nr0o8BvpVz16EyHkH8B/ZpmlxKY6JrxR1aBB9Gh9Aam9pa46Cn3xHVQ0pU58uFac05b2DKEnLvM9ZoHRDlvxEGZ/zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fj+KQqJ+; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fj+KQqJ+"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so282520266b.1
        for <cgroups@vger.kernel.org>; Sun, 06 Sep 2026 22:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788760329; cv=none;
        d=google.com; s=arc-20260327;
        b=LwqYcGoqIYJZ8L0rYVgXMHeXJr7/Pfb6/UwkYcwftJ1DILAn0iEM+wpANyqF0z3Imh
         Gb1GoQPSkB9D/DidyqdDpDuGkE+q+Pjlbq55FzuubviGxp7KyYs14rYFY9SeNGkVlSqv
         K3erMn9PFAH1F/vbhNWqERO0dXlwIi8RB/VtaynA0HmGVBbkWF6oteBI+2TJinVkSC0e
         5ERZ2CDHyVNZ6GyHqteQjWYMpTyDuJfIDzBnh8nIw/+nBuMURAnYYvlvDLQy9ZdekvZ1
         7S3GTekUbT4J2zNIEVUtdf9H+xNRCdROhXI6GiWfIV/7DdxDm5ltY3Gv8kC3yMPXeo42
         tM2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=22/BwaP7SAKujHOUUdDC0Bxv5gFqHg9CGNaAxSy6VvU=;
        fh=JiRprG9NTUJx7l2WcNoFzsatgA7HcW9aryDClZJvAnE=;
        b=Xrf5H7yq0mgYYMPGEYQryW024oYMXCKo7oNHMG0gbXKsvIjo1D47/e/OZiUj9Rbdcm
         Hs0Ju/n7SbhZ0uAdtLYPbQrHwkntwaHbcZYWSYvicf/wLob62B/yjSBn9+9AJ1uMkqwo
         aXHxippizVXhm3mpbCZQdMDvWtCmK7hg+IM0KXYjqbV8ZWsM01YjCZSG1JEEHTjrLXTd
         FTBdJI8txtbFQDcqanSmfDgN1g8AViimdLDjJ/BrlblT3jShY5QXURhI2/DSUKPqh2rK
         YLHMNle96DMxR9ZnbIsqKqmmLMCbgv0GtYYgB97rxi3JPtboKYNVQVQgxOSL5d+TDYAt
         R6lQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788760329; x=1789365129; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=22/BwaP7SAKujHOUUdDC0Bxv5gFqHg9CGNaAxSy6VvU=;
        b=Fj+KQqJ+yoJbcMJytqm9aKgL3OfWC9mkQcG2eI5Uf736LZT0VXgUeh+mt0WU3TBGUR
         pPeqySK8akCXaRALKrvaPXx9S5tdyst5CyFdfKzsfktzSuNV9w11Zt3jtfPCwGIElvWE
         vl382jp8q05uB2ATYxfLFXRnnUUX1kztH83cUPW42GLOaep19MZXuHhHNSIHrhljdv3s
         P4LdvItUPqugk/Xn6W65GglqGcmLwfHVPoSWpEg7obNx6mwt5+2oPnaarr7DEMzQb0IU
         ZF9MEofwTc0mBZCmnNwOQ3U4kuDt0Ai6f8a1uqy6gevvLwrQ4goVaCIKyrUPQXbiTzWL
         eQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788760329; x=1789365129;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22/BwaP7SAKujHOUUdDC0Bxv5gFqHg9CGNaAxSy6VvU=;
        b=Wk86x/hNIpZfw2UU5n5/rUhW9ZQF1ssGhedW9J89RIWBPgWNbxiGv0gvnw88NPjIHz
         H5VcDsZh4p0luYzWAIIkOIfhxqXmw1Xlr2LQ0TXxg4UOqxq1sV3p0EJPGCv7o+2h7v/I
         f2r4uncJhF+exLrDjoz211GV7XXz5Jx4MvmbCjRkn3WBu8w9g1P3Z6Hosgbjozhd7Tgr
         jaONvvNoI/1kJBrOAUMJgl4gdMAoagZrt08xvOvhJnJsu1mjhLgo4J4by6BxLdQG4gxN
         IT5fzk55i8Foog0i15QZ2zDd5vkMEdVbyhU8q1OGDKcQ3F2hnEFGYSn+0iDoCAh58bS5
         wWiA==
X-Forwarded-Encrypted: i=1; AKwUvBzwEYAws5mYW8KyFa3TqzZdL6cRcWhYacXVdAmImoVS0RdXH3V60hOp7sAiwK6AvMRA6a5fI7wy@vger.kernel.org
X-Gm-Message-State: AFuF++k0SgsNw46+tB4HDBLRwbk6zsraDvTGRYIPmyGpuMrZ9bBmFW3+
	JCsoxx8EMdV8tkIRqUtEvUnC/1prU3byhNNncd9EUGmxkV47aaouVIpcEZVZ27XIB+X6NnnBEgT
	Ff0nuxaU4++cSxYVeLz/OM/8EHNMUpqk=
X-Gm-Gg: AYBFou3nWWAtbN/jOShWws6pRUr4rms8wENCqh6WByFQsCu8ys8Z1j/vZy/FxvEB2C5
	jEjJEUo9SgUDz69tubNo6WKyL6J6eejwliZMFvJ9sDsuYch5TCu1gKvy8PuyjEVjLGvTtNNZ8YQ
	s3Qy+ZoxxfK4PnPBCxXI/2dzH/nlce/RMEpeUmH5hZOXqL1ovQ199ctzYItmdEQ4JNp4CsCGpua
	XTYsZK8Ft3EIV4NUldM8rf+5djjOdPfYlplBwSnlr8plYLzGR0tjWNcH5+09qc1zlyZHlcxsR58
	bdsXfZDbAM3leaYEhTEhZ2dtRh7tlHYemNxMFJRBeGfcUJdgz5GMKhFk+TmoJrf/9SWr4Ru2eaj
	oNw==
X-Received: by 2002:a17:907:728f:b0:c26:19e3:e97a with SMTP id
 a640c23a62f3a-c2619e3ee84mr674879666b.26.1788760328843; Sun, 06 Sep 2026
 22:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
In-Reply-To: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 7 Sep 2026 13:51:31 +0800
X-Gm-Features: AcwNN1U_INQMn02v6mP531xYYMhuEgJLkzDwyU8CUqGybSQz-mJYL5CYBAKGTU4
Message-ID: <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 5, 2026 at 5:14=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks=
 -
> I need some help here.

Hello Nhat,

>
> I'd like to ask for a decision, or failing that, the specific thing that
> would get us to one. I'd much rather work against a concrete objection th=
an
> keep respinning into silence.
>
> Quick recap: today a swapped-out page holds a disk slot even when the dat=
a
> never reaches disk, like zswap or zero-filled pages. My patch series
> (latest version at [10]) puts a virtual entry in the page table instead a=
nd
> resolves the backing separately, so zswap stops reserving disk it never
> uses and can work on machines with no storage swap space at all.
>
> I've been working on this since April 2025, going through 10 revisions (6
> on the original design ([1] through [6]) and 4 on the swap-table-based
> rewrite ([7] through [10])). I also gave a talk on it at LPC [11].

Thanks for the hard work! And I mean that. Upstream work at this scale
does take a long time and it isn't a reflection on the series: the swap
cache optimization idea also took me over 2 years and changed direction
multiple times and split multiple times before it landed as
the swap table series, and the readahead unification part is
still in flight after nearly 3 years. It's frustrating and I don't think
anyone enjoys it. I mentioned this once with a longer history:

https://lore.kernel.org/linux-mm/CAMgjq7CF9RgnZCAS-+Gv0LAvkzzHk4jiok+_6-KOF=
w-o+s8E_g@mail.gmail.com/

There is also a quote from LSF/MM/BPF saying it's for improvements to
"find their way into the mainline kernel and Linux distributions in the
next 24-48 months.", suffering souls everywhere :P

>
> Throughout the process, I've been very receptive to reviewers - including
> parties whose use cases are very different from my own, like zram users a=
nd
> the ghost-swapfile-style deployments that want zswap with no backing disk
> at all - and the current design reflects that:
>
> * Kairui asked that this be optional, not a replacement [12]. It is now:
>   vswap is opt-in behind the vswap=3D cmdline parameter, and with vswap=
=3Doff
>   the existing swap paths aren't touched at all.
>
> * Kairui also pointed out that if I kept shrinking the metadata I'd "end =
up
>   reimplementing the swap table format" [12]. I took that feedback, and
>   reworked the entire series on top of swap table.
>
> * Per Chris' requests, I've figured out ways to minimize memory overhead
>   [13]. On a zswap-only setup there's almost 0 overhead now, because the
>   vtable is merged with zswap's xarray rather than sitting on top of it.
>   The indirection is paid for by the tree we delete.
>
> * Johannes pointed out that a physical cluster backing only vswap entries
>   still had to allocate a memcg_table, which was an overhead regression
>   against my older design on the zswap writeback case [14] (since a swap
>   entry occupies multiple levels). I've also fixed this.
>
> * I've spent a lot of time chasing regressions on setups we don't even ru=
n
>   at Meta - zram in particular [6]. And if anyone's still worried after a=
ll
>   that, vswap=3Doff keeps the old swap code available.

Acknowledged, specifically reworking the whole series on top of swap
table, the memcg table fix, and chasing zram regressions you don't even
run were all real work on cases that don't benefit your fleet. Thank
you!

Roughly 80% of my own time also goes to things that don't run on my
fleet either. Desktop and Android (I do use them though), lowend and even
32bits. Upstream covers every usage case as the baseline and it's tiring,
I know what it costs. :)

> Numbers are in the v4 cover letter [10]. In terms of performance, vswap i=
s
> on par or better than baseline on zswap across memhog, usemem and kernel
> build, and vswap=3Doff tracks baseline within noise. I've even included a=
n
> A/B experiment on a real production workload (Instagram/django): throughp=
ut
> on par, latency slightly better, and the swapfile footprint for every zsw=
ap
> user on the host goes away.
>
> Now, on xswap. Baoquan's working on a series [15] that covers some of the
> same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.

My read is that xswap and vswap differ mostly in the interface, and that
both could sit on VM_SPARSE for cluster/metadata management.
Simpler and faster. There are some other issues though, see below.

> I've been reviewing that lineage since July [16] and I'd like whatever
> lands to end up with the best parts of both. From my perspective the
> differences are:
>
> 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) pl=
us
>    a per-device limit to tune afterwards. I'm not aware of any use case
>    that needs those, and I don't think users have a good way to answer th=
e
>    question anyway - sizing swap for compressed memory depends on memory
>    size, workload, and compression ratio all at once. That's precisely th=
e
>    provisioning problem vswap exists to remove. The kernel should be as
>    transparent and dynamic as possible here, and not add knobs unless
>    there's a use case for them.

I asked Baoquan the same thing, see the "Why not make both args
optional" part:

https://lore.kernel.org/linux-mm/apaw_XmqnEcY8sv7@MiWiFi-R3L-srv/

Where I've ended up is that unbounded growth is a real concern. On a
host with no memcg limit (root cgroup, and most desktop and embedded
setups), an unlimited pool means usage can keep growing, with no
admin visible ceiling at all. I'm not attached to xswap's percent of RAM
knob specifically, but I do think some kind of bound makes sense.

> 2. Writeback support. Writeback is core functionality for zswap, not an
>    add-on, and a design needs to account for it from the start. This came
>    up before, in the discussion around Chris' ghost swapfile RFC [17]: fo=
r
>    a solution here to be acceptable, it has to work with the primary
>    usecase and support disk writeback. Without it, whatever zswap won't
>    take (incompressible pages especially) has nowhere to go, and cold
>    compressed data can never leave RAM.

Agreed completely, and I think this one is settled: whatever lands
has to support disk writeback in the end. Baoquan mentioned that
what he sent is just a foundation though. I know talking is cheap
but still, could it be combined with the writeback support from the
other side? Or am I missing anything here?

> 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
>    swap usage counter. It's fundamentally a different resource from
>    physical swapfile space, and memory.swap.* should read 0 when nothing =
is
>    on disk [18]. I made the longer argument for this in [19].

I personally don't have a strong opinion on this. But I think this
needs an explicit decision from the group rather than being
inherited from whichever series merges first. Skipping the charge
when a device has a special flag isn't hard to do if the code
abstraction is done well, so this is more of a design decision
than a technical problem.

> 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vsw=
ap
>    is already on par with or beating baseline. I like the sparse array
>    idea, but why are we landing an optimization before the feature itself=
,
>    without any A/B data showing the difference matters?

This is where I'd push back a little. To be clear, my concern isn't the
size of the win, it's that VM_SPARSE isn't purely an optimization. It
changes the cluster/metadata layout and avoids RCU conventions,
could help avoid some future sleep while atomic limitations and
it's tangled with the initial size issue too. So bolting it on afterwards
could mean rewriting the parts of vswap that touch it and could be
costly some conflict in ideas. That's why I'd rather we agree on
it now, not that it has to land first.

Using VM_SPARSE does outsmart my earlier xarray suggestion :) There
is an interesting early benchmark from Baoquan, VM_SPARSE wasn't there
yet, but with it we can use clusters natively in the same way. It shows
about 20% latency cut and 10% throughput gain, which seems a major
improvement, and that's serial performance, not even mentioning
scalability yet:
https://lore.kernel.org/linux-mm/20260707073215.72183-1-baoquan.he@linux.de=
v/

And it matters more than most micro-optimizations: under heavy
pressure many workloads spend less than half of system time in
compression itself, the rest is mm/swap. Swap has had a terrible
reputation for good reasons, and even with zswap/zram users
have been scared of the performance.

After the recent refactor and optimization we already noticed many
users can now run much heavier workloads using compressed memory only
or fast storages, which is a real breakthrough. Every chunk of
overhead we remove there unblocks another class of user from using
compressed memory as a "secondary memory".

>
> One thing I do want to be clear about: I'm glad other people care about
> this problem. Chris' ghost swapfile and Baoquan's xswap are both going
> after the same set of problems, and that's a good sign. It means this is
> real and shared, not something only Meta runs into.
>
> What's been harder is the shape of the engagement. Alternatives keep
> getting posted and pushed that don't cover all the requirements, while th=
is
> series sits without review. I don't think I'm owed anyone's interest in t=
he
> problems I care about. But I do think working code, with benchmarks and
> production exposure behind it, deserves a fair hearing next to in-progres=
s
> proposals.

I'm sorry it has felt that way, and I don't want to hand wave it. For
what it's worth, I did review it, and I did think it could be merged
with some adjustments:

https://lore.kernel.org/linux-mm/CAMgjq7D4XsAD4NGDL7FC2kaYAQAP8PDJdn4bpzGZw=
XYtjEpJ6w@mail.gmail.com/#t

We were also discussing the limitation of the global cluster cache in
that thread, so I paused my other work for a while and posted the swap
queue series first. That one is orthogonal on purpose, and helps both
swap tier and vswap, it reduces the overhead enough to cancel out
the layering cost due to missing caching for either:
https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resend-0-68d3d92=
5578c@gmail.com/
(this is V2, V1 is earlier - thanks to Lian for keeping this going!)

Then xswap appeared with the VM_SPARSE idea and exploring it seems
necessary because getting the cluster foundation right affects
everything built above where it went. Not because the vswap series
wasn't worth reviewing.

> So what I'm asking for: I'd like us to converge rather than keep two seri=
es
> in flight. My preference is that we land vswap first, then build Baoquan'=
s
> sparse array on top of it as an optimization. That gets the feature in, a=
nd
> by then we'd have the A/B data to show whether the sparse array actually
> beats the xarray.
>
> If you think that's the wrong order, I'd genuinely like to understand why=
 -
> after 17 months and 10 revisions I still don't have a clear picture of th=
e
> objection.

I fully agree we must converge. At the moment I don't think one can
can settle that alone as there are several of us reviewing both. I'll try
to be more concrete about what I think has to be agreed first.

The two interfaces aren't equivalent, xswap has its limitations, but a
couple of xswap's properties look genuinely better to me. Runtime
on/off rather than a boot parameter is better, more flexibility and
doesn't conflict with what vswap is trying to do. Some other of these
differences involve design decisions rather than just surface knobs,
and those are the parts we're stuck with once they ship.

So a few current interface difference of vswap and xswap I've noticed are:

 - default size: somehow also tangled with VM_SPARSE, which
needs an initial virtual value. It's super cheap if not zero cost
(the only cost is occupying some vmalloc area, which is fine
I guess?). But we still have to pick a number, could be large
enough to satisfy everyone?
 - boot vs runtime toggle: I believe a runtime toggle is better. It
can still be tuned on boot via cmdline, but it offers the extra
ability to turn it on without modifying a base VM boot image or
kernel.
 - growth / limits: as talked above.
 - charging semantics
 - there could be other longterm design decisions on top of these as
we talked in above.

Once these settle, I think the picture will be clean. Your writeback
logic and swap table integration are solid, while Baoquan's VM_SPARSE,
previous preparation with swap ops give us a structural foundation. A
clean long-term architecture means getting the core structure right,
let's try not treating this as a race between series.
