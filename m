Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011D64A8A02
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145883; cv=pass; b=dvfQAY4DpqcBSuTC1xugbRByt8abxjs3aRIQc7wdTNQG9me1ObepbPnxzYBiQS59cI5LLDrvY0ZoXJQq4IjzwEFGOPawc/lzReLyfOW+P90ctfLjiC66hSQIZRI6Ousnw+AzsXtOym9vE7Abrcf8ochrwWs5l10wJxTzLHFV+So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145883; c=relaxed/simple;
	bh=VYReojEXuXxtQgY+IrRq+iMHb665k0hg6mJkBTAX55I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJ45du7Sk7+mjTecaD7TBZBfqzTZ/uf11e+PXJS4XKbsdugqIG3ryC8bzzPBniTfyHaNqcfhfqw5S0h2eRFd2TkPeqFkdKuhFJ+2WZ6ShrsAqPChvVxkD6U5LxqjPWfUubaf6BuK2aH7KbCD+a89MwUg2AoOmZL3v/5ozKmvDOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4+WZX6p; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4+WZX6p"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485b1d2874aso57672f8f.1
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 09:57:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789145867; cv=none;
        d=google.com; s=arc-20260327;
        b=WpuDtfBnfeUo+tO4nOq898mOhKfatXhr8QmGy/f61Ae+Vj5gZn09EZA99sfwAuTXmO
         pI8aQB9uy7t4NDXPYvR3UfbxhuX/S3tvA221pYF2F6wsS1ecSn1RqMoKokPsliv3GKzr
         FzWs5LM5qagBvHn3pEMgTYI7wgZb/nMZgv3pCOYYcsF6yoiMBVOqwqxxIkzL+Dy2B05/
         v8Fak4lAqY7/vMCf43DotcpqWoYCy6/9UzKef/QsK8znCh62OeKRr7j5kVYQNG7Aj79Z
         AVHXVElXpbAyy5KnJgJWvlvQa1z7dbhGyqYZeNHgmphK4cZTFdD7BEB2OSZx2bOWJH5N
         z42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        fh=c5sbX/12w94GAeqCrl/297lAhl1eJ6tsglVNdUGkEls=;
        b=sL7BE2IbU7bCPPxlJ/1ep+TbbfhkeRzdvJkhHlHu1h0iGq+yxec1apENkZV9YHBuCr
         66YdrnJfyGCMnEu6V08BiHsWg7E6JUtV+KqkVwWFHUt5kRFQSqqgdJxJAu3hVXrU4uRf
         Ms8eJHMF+ka4KYt6n++XLdneo2BzVGVmSBpqADKwrZqmOXe+oCAW/beYDvo2wyaMFoO6
         b6hlvKy/SYlvtl2FMnmMfzi4p1NhA8iYQgYYEXZcWqIzV+7LzPSzr8RCc989S2PCgDSL
         01WTP3O+0sEYasuhBWVY4tIUlii2yc3Zt1sRicXZjR3eSPBXFLttY4g7uCnZdhQtiJne
         9NNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789145867; x=1789750667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        b=T4+WZX6p7Y0T5qqlLfLHMY3AGOt/BjCaOEg/JML0niRDp6z1+KLV5+zpNqSAH5vGAH
         FH3wh5lOpKVGQxjht9ddJf2WSPhY6/agb2NWx+OIH5ybI5qyXdsH2vEBtMgaZXSw2EJI
         Zlc8WGSnOJccWuKkyeqmk7qHPQUBF16iHHF8vwdbD/Z5qZZnTJnrNYbQLPNOUaOmcbcl
         aDpYHo3N1rbk5PjEEuKVw2KOSl5V0aEJFleseEHW2kPormCuJ39jy+7dIaNLBGS+pRfH
         GyBoNkS7rakX2RG/mjBTt+owehFYo2SgaAT5IomqqT+eQ3Qnrm8yAGR6Lf19tv6n4BHM
         sX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145867; x=1789750667;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        b=jNd7EdVCEelkvtVtaI8Y0w7zvVcJ186mt31l7yAdpt0LS0JXukZdQr3OswtZZxFaix
         SBBO92YQkoC4z+5T+/WrrIfJxSvodSBjMP4MvSN3aYWODoMz/6xvABQiK6TvN7tujvTX
         ckK8+ZQ0Bb/0KSHxes83HgrhhkxQy1w8/JV1G/o6zjA9f8Liyb7Vdm4pyRYo+kcmY2hS
         RaIs8YXwWIorIQUutZfFeLlWUhBZLhKD1DEOsXU9ZjUV3F+ybfoYjexJ/ngC+IoTGii0
         XpRRBLWcbYv13PWm3DVomA/zfftuOtOCCDy1IYLn5FiCguvt8M0Gf5Mvsp4OXawgDFvg
         fVrw==
X-Forwarded-Encrypted: i=1; AKwUvBxkt06Sb4NM3r9xo13/M5GqB+MRcCTRyxs/+WbapJl5YTI/8mtp6SjG/WApD2su1UuzDkvdZoJJ@vger.kernel.org
X-Gm-Message-State: AFuF++kaNFp3iyQTcXUJhg8GxdMvIdfxRvVce4qHPXMCv2ce9zuNv9Dp
	NyhnU2R2eGSlM+JjCRRuIZNHl1ITfZQnrxS6iPBug0WcdtiQxxMBtrMuwTYBP0ds13nflYFIDDu
	ynu4hS/M88h+tgcNC9kK6blIoAl7ejWw=
X-Gm-Gg: AYBFou2LbkBRAyvssRr/XxiGA+RMoS/wEAcFT5WPim6m0PJDFHQJvNVDdY/z6OeSE3c
	0M/PQyOiQJkBLQ3RKKHo22et6X55LGNZR1/FfJNPr1fzB/CJrinjxlZTsoRNH4jEqKbG4r8eJpY
	bBUl4VKi5gL8msjLxxK0Qor5sU8HR7DNycl/7iD48sfVb3Nc/LzfRSQZeB4emazsw3XK+AvmAXH
	ZhKmaBMCiuTIFjsOBcI2U2Udf56H3H8F1oWddNgcZfQh5r16UUNKabVEZlyh/HNMcihydszdQzN
	AhZ5h7+8BrhmalThSPbpM/iggMgpy9WfHSb6Mnq1zXr5DQWa1wgHDSp8Gy6U3QCEHfEofRFZ47q
	bZjhBln0q1HU=
X-Received: by 2002:a05:6000:240b:b0:482:ea08:8c8a with SMTP id
 ffacd0b85a97d-486eb33c4f5mr10751769f8f.20.1789145866856; Fri, 11 Sep 2026
 09:57:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com> <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
In-Reply-To: <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 11 Sep 2026 09:57:35 -0700
X-Gm-Features: AcwNN1WArL_JByzG5ZwCWzeldSKlDzHuBhpFh51SZKu7QF3uO9ezUafnCe2ZS5c
Message-ID: <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
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

On Fri, Sep 11, 2026 at 9:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
>> >
> > >
> > > > 4. Data structure (xarray vs sparse vmalloc array). Even with xarra=
y, vswap
> > > >    is already on par with or beating baseline. I like the sparse ar=
ray
> > > >    idea, but why are we landing an optimization before the feature =
itself,
> > > >    without any A/B data showing the difference matters?
> > >
> > > This is where I'd push back a little. To be clear, my concern isn't t=
he
> > > size of the win, it's that VM_SPARSE isn't purely an optimization. It
> > > changes the cluster/metadata layout and avoids RCU conventions,
> > > could help avoid some future sleep while atomic limitations and
> > > it's tangled with the initial size issue too. So bolting it on afterw=
ards
> > > could mean rewriting the parts of vswap that touch it and could be
> > > costly some conflict in ideas. That's why I'd rather we agree on
> > > it now, not that it has to land first.
> >
> > I don't think the current code differs significantly from the existing
> > model, no?
> >
> > For the most part, RCU played quite nicely with the current swap code.
> > Practically, it's just:
> >
> > 1. If you have a reference to the swap entry, you can assume entry and
> > the cluster owning it is safe.
> >
> > 2. If you don't, then do not assume it's safe once you exit the rcu
> > read section.
> >
> > What conflicts specifically do you have in mind here :)
>
> Yeah you're right. I'm just a bit worried if that RCU period will be
> extended, and it's always better to make the convention as simple as
> possible. I'm already trying to get rid of the local lock, in that
> swap queue series, that is not so painful and still a bit troublesome
> for a few new use cases.

Completely understood. Your inquiry made me give it a double take - I
took Baoquan's code and hacked it on top of my vswap patch series, and
it seems reasonably simple :)

https://lore.kernel.org/all/20260910232704.3364879-1-nphamcs@gmail.com/

Seems to slot in quite nicely. I mean, we're converging to the *same*
architecture, just different data structure. We can switch down the
line - it just would require a lot more testing, benchmarking,
evaluating, etc. to adopt this.

> >
> > I think a lot of these wins come from the fact that the zswap's xarray
> > specifically is *really* bad in certain paths. For instance, in the
> > free path (swap_range_free() -> zswap_invalidate()), there is no
> > batching behavior, so we walk the tree from scratch for each entry
> > rather than using an xas iterator for the entire batch. That goes away
> > in the current vswap model, because the xarray manages cluster rather
> > than entries, so you just do one tree walk + one flat array walk.
>
> Right but with vswap replacing zswap, isn't the performance is still
> basically unchanged according to your test (or just a little bit
> faster)? My test still doesn't show a measurable improvement.

Yeah in my test it also improves in some cases but not others. But
FWIW, the xarray-less approach does not outperform the xarray-version
yet :) I tested with the old coupled design, only replacing xarray
with a per-cluster flat array - so basically Baoquan's design but
without the vmalloc overhead. It performs basically on par with the
xarray (where it wins, it matches xarray's wins, etc.).

And I tried my best to keep the old code intact (all the
swap_is_vswap() that Baoquan disliked was for that too haha). That
make sure physical-swapfile-only users, and those who still disable
vswap at boottime, has no overhead.

>
> > zswap and swapfile coupled, but only remove the xarray and replace it
> > with the flat array in swapfile's cluster struct. I observe the same
> > win, basically (especially on the usemem benchmark).
>
> Yeah, merging the zswap xarray into cluster should buy a lot of
> performance gain, the only concern is the cluster it self is in a
> xarray tree so if your vswap space gets huge, could that somehow
> become an issue? Zswap used a split xarray, and swap also used to have
> a 64M partition for the swap cache xarray, which is gone after the
> swap table.

Hmm not in my testing so far, both in production and synth-benchs, and
we have some pretty big swap users.

As long as the xarray does not lock us into any model, we can always
optimize further IMHO. There are several axes of scaling - another one
is raising the size of the cluster.

>
> ...
>
> > > We were also discussing the limitation of the global cluster cache in
> > > that thread, so I paused my other work for a while and posted the swa=
p
> > > queue series first. That one is orthogonal on purpose, and helps both
> > > swap tier and vswap, it reduces the overhead enough to cancel out
> > > the layering cost due to missing caching for either:
> > > https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resend-0-6=
8d3d925578c@gmail.com/
> > > (this is V2, V1 is earlier - thanks to Lian for keeping this going!)
> >
> > Ah that! I sort of tabled that as a nice-idea-but-still-optimization :P
> >
> > I'll spend some time thinking about the design and reviewing it. In
> > the long run, it will get things more simple, but another thing that
> > should not be a blocker, correct?
>
> Right, definitely not a blocker. I think the swap queue could be
> merged after tiering and other stuff, as an optimization, just to
> demonstrate that we don't need another layer of cache; we can just use
> the devices directly without any cache above them. It will also
> deprecate plist; with the only plist rotate user is gone, we can get
> rid of a large chunk of common plist code.

Look forward to seeing more of this! It was a personal request from
me, so I appreciate that you look into this.

>
> ...
>
> > > The two interfaces aren't equivalent, xswap has its limitations, but =
a
> > > couple of xswap's properties look genuinely better to me. Runtime
> > > on/off rather than a boot parameter is better, more flexibility and
> >
> > I would also like to point out - I *do* have a runtime parameter in an
> > older version of vswap (v3). There is also not a lot of engagement
> > from folks in that version - no one expressed any interest in that
> > runtime knob in particular. Only Johannes made the case that a boot
> > parameter is superior, so I switched over. I think his reasoning makes
> > sense at the time FWIW, and it also removes the need for CONFIG_VSWAP
> > (which in turns remove a bunch of useless stubs - saving 100 LoCs), so
> > I figure folks will prefer less code and less userspace decisions :)
> >
> > v3: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.=
com/
>
> Ah, thanks for the reminder.
>
> > Regardless - do you have a specific use case in mind where a runtime
> > knob would be useful?
>
> A boot time bool will cause real trouble for us, at least. We have
> many VMs with fixed boot images and fixed cmdlines. However, the VM
> itself is used by different customers, some are ZRAM only users, and
> quite a lot don't want any kind of compression (e.g. their data is
> dense compression is just waste of CPU) and prefer plain swap. So I do
> hope we can have a runtime tunable instead of modifying the cmdline
> and rebooting or rebuilding the base image for different cases, and we
> have already seen that a runtime toggle isn't hard at all.

Ah yeah I see. But before moving back to runtime parameter, do you
think we can come up with a heuristics for this that have does not
require userspace input? In v4, I'm doing this at folio_alloc_swap()
time:

a. If the cgroup enables zswap, then always go vswap.

b. If zswap is not available for the cgroup, then bypass vswap, and go
straight for physical swap entries. My intuition is that we are not
buying anything for these zram users, as we need a physical swap slot
anyway. Thanks to your design, both can co-exist in the system now -
that's something I actually did not envision possible in the original
version of vswap. Pretty cool eh :)

Would something like this fix it for you? ZRAM users will not get
vswap indirection overhead at all, because it would bypass vswap :)
Down the line we can revisit this decision - for e.g, if there is a
use case for vswap-on-top-of-swapfile. There might be other interface
that makes more sense.

>
> > > doesn't conflict with what vswap is trying to do. Some other of these
> > > differences involve design decisions rather than just surface knobs,
> > > and those are the parts we're stuck with once they ship.
> > >
> > > So a few current interface difference of vswap and xswap I've noticed=
 are:
> > >
> > >  - default size: somehow also tangled with VM_SPARSE, which
> > > needs an initial virtual value. It's super cheap if not zero cost
> > > (the only cost is occupying some vmalloc area, which is fine
> > > I guess?). But we still have to pick a number, could be large
> > > enough to satisfy everyone?
> >
> > 8PB? ;)
>
> Right I saw that at V1 :).
>
> I'm not sure if this is the reason that is in conflict with VM_SPARSE
> in your mind? Techically, at least for 64 bit, we can just apply the
> same limit to VM_SPARSE, for 64 bit machines we have a lot of virtual
> space to consume and that should be fine (VM_SPARSE is just the
> cluster map, which is much smaller compared to swap space).
>
> And another thing is do we really need that much in any case? Will
> things like, e.g. 64 times the physical memory (max pfn) be enough? I
> know Baoquan suggest just use the physical memory size. So that could
> be tunable, it's really easy to tune, just a number.

Potentially, but we have many users at Meta. There's a huge diversity
of machine types, workingset size, access patterns (both frequency and
file:anon split), compressibility, etc.

Tuning even just one number, but for a combinatorial explosions of
these factors, cost a lot of time and effort. This is a per-host
property, which often means big hosts with multiple services
co-located cannot decide alone.

And even if sysadmin lets users decide this value, it's very likely
they'll get that wrong (improper tuning or just copy the config from
another place), which in turns cost engineering hours to go chase that
down.

So I always lean towards as plug-and-play as possible. And as I said
earlier, it's easier to add knobs than to remove them (or ask users to
stop using them).

>
> For things like an extremely high amount of zero folio swap, I think
> remapping the zero folio it self is definately a better idea instead
> of wasting a lot of SWAP entries and metadata in the long term
>

I don't disagree here.

We tried doing that in the past, but it was slightly buggy. It might
be solvable, we just don't have the manpower to deal with this yet :(


> > >  - boot vs runtime toggle: I believe a runtime toggle is better. It
> > > can still be tuned on boot via cmdline, but it offers the extra
> > > ability to turn it on without modifying a base VM boot image or
> > > kernel.
> > >  - growth / limits: as talked above.
> > >  - charging semantics
> > >  - there could be other longterm design decisions on top of these as
> > > we talked in above.
> > >
> > > Once these settle, I think the picture will be clean. Your writeback
> > > logic and swap table integration are solid, while Baoquan's VM_SPARSE=
,
> > > previous preparation with swap ops give us a structural foundation. A
> > > clean long-term architecture means getting the core structure right,
> > > let's try not treating this as a race between series.
> >
> > I've reached out to Baoquan as well, but I figured there's value in
> > both discussions in big and small groups, and especially since there's
> > a chance some of us might not be coming to LPC. Let's see what we come
> > up with.
>
> I'll be there this year if nothing goes wrong :), I hope we can come
> up with something.

I'm excited to see you and the rest of the swap cabal too :)
