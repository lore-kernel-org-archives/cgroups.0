Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FEE3D348C
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 20:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752705; cv=none; b=HeLzYtIIYrmiTE1sZ1blqgqvCsvdg7bEWQ5J9GrYRJ1QNP2kFpJYT5sO68FU46VA5RY4WXAXJ7/ibS4rkFev4RFdV7AcdJraxo62eE6WyZR1pGnnnynSSKajiN6RwM/PAC2SoFM8Z9Kuw1IS31MfeRvw7GR7nFrL27ABeY+GHZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752705; c=relaxed/simple;
	bh=Sv1yin451FNf9IBjRzFJe2OiUZg4U4oZrwcgx94tkak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qhQfIneIa9FDRtYFJCwONURxpjvwIinjIlMG1YpRiWDrGjGPvH84pMCuH/MN2lApnXB+GzLopW6cg1jDZAx+vHO891I3FQKGRun4WeWW7NeiyTJe/6T6Ps+vAjT76iyNzcz/ExCCv6FX7Npv30ki1weB9OeKjGVegdp4Loudrk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1BPvpNW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1BPvpNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81F51F00ADB
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784752703;
	bh=Sv1yin451FNf9IBjRzFJe2OiUZg4U4oZrwcgx94tkak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X1BPvpNWr7GEwW43TDS8VWCrIpskjHDIP2lT+X8LXuU6TwRlX9GTXQRXAjV//ySlM
	 P5Lu7sD/gF+JeXFlOae/XeqcfP+gjOt8pq0x//nOHWZjnDJenxl7tLLEnugrPbNfBl
	 B6V5IIzeTbFrjtrRf0vJYbNAoSa2ncA08zERRcd9IuaQsFSLa/QKr2O4wFMydSIco4
	 8IC/KliAwPwYhCm88pXIc2occfPnzq0GmnPd+jPxa9QoxhM0T3oOcMXzxu6VqwKpdG
	 jTyliNPWujiZNFaIo4q41fXhukRwIYSkKHfY3YKuqbbBlcWlqHnxzS2P9uHSa1UxnS
	 plSglyu7GoDoQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15e03c2763so1437499666b.0
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 13:38:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq5ctp2mEFVWo2UCsy/FDAXkEnuGLJTb88R365EsuZvqU8C/k9HW9Hjj5qYF2Q9/xSJXSFIQPV2@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4+J91TpJYyE+aiTPLgFKkhCXjfGSnEJ73YvHGjkCzLUIdeYSS
	gXYqrUpX2JwYEptJc/h7LAlGTQY0B27e0IqIMThblM8pXzWlSDkoJtqYMlcPhrnmiF0Ix3PWAWP
	WKb13yaIaEWkGzuhXqOfNH8A0mkJH/SI=
X-Received: by 2002:a17:907:1c26:b0:c16:242a:4744 with SMTP id
 a640c23a62f3a-c1c30e5a414mr272454266b.17.1784752702639; Wed, 22 Jul 2026
 13:38:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bG6ddP6-dgXpGBRGnCH49oTMPwkJmF--+gefmy+zBo-w@mail.gmail.com>
 <oocwnxqgd4klrem6hkya3sddqoxkosml4ysz23if4j7wj2qdwi@5skgc4ftu7io>
 <CAJnrk1ZU40tRDq0z3yM0+yv=KhiZ-fNjUTO=ccv1tuc0xDx2Vg@mail.gmail.com>
 <4fsrafuhoqgoirlt2sy6vk2ljvb3tdps4hqbcrm5qc2pr6tlaf@tboejm2wdq2s>
 <CAJnrk1b65ypz4bdtd1rTQBYOpOEP+DcoZJUSL87jVDssW1A+pw@mail.gmail.com>
 <nv2h2dd2xoj4zjfvnhsxud2p5e2uw3og22ovqureik4pey72qb@i75tn5ttavfo>
 <ue5xd6f4nfggwodfhbqaispmr5aq2dyszezvy26bl4rtsk6xii@uceqazdioj3o>
 <CAJnrk1bwabyWY+rzzSKfKWp3rivcQm=zae3xzNSZc2hnLj6-Aw@mail.gmail.com>
 <aljxUvui60dm3yvj@linux.dev> <CAJnrk1aTx44=jy0ODHY2sHh16bKsYkwBKj_O-MsnZYjXGW2cCA@mail.gmail.com>
 <alpfQxaYs5hQ0BaU@google.com>
In-Reply-To: <alpfQxaYs5hQ0BaU@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 22 Jul 2026 13:38:10 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMwp-wxJz6AjBSEuW+vn-7ff2VwAdHpVHFAqy0skgD2OA@mail.gmail.com>
X-Gm-Features: AUfX_mzbIxhaji4ACa_s6MziyJYJfdhM5If0Ugu2QBVMrEAPT0o4Q-nTgVPbFwM
Message-ID: <CAO9r8zMwp-wxJz6AjBSEuW+vn-7ff2VwAdHpVHFAqy0skgD2OA@mail.gmail.com>
Subject: Re: [PATCH] fuse: disable default bdi strictlimiting
To: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"

> > > First let's see if the general solution is doable and simple otherwise we can
> > > explore use-case specific solutions. In extreme case revert is an options as
> > > well but I would prefer a more sophisticated ratelimiting (that Jan suggested)
> > > than a revert.
> > >
> >
> > Sounds good. I'll keep an eye out for the work Yosry's doing on this
> > and look into hooking it up to writeback if/when his general solution
> > becomes available.
>
> I am not sure if I had in mind would generalize well. For zswap, I was
> just going to replace rstat with per-memcg atomic counters, and simply
> walk the cgroup parents in the update path, as the zswap load/store path
> shouldn't be too hot.
>
> However, looking at other in-kernel flushers (including
> mem_cgroup_wb_stats()), I see they consume other stats like
> NR_INACTIVE_FILE/NR_ACTIVE_FILE, which are updated in the page
> allocation path. I am not sure if a cgroup parent walk with atomic
> updates would fly there.
>
> A more problematic one is count_shadow_nodes(), which consumes slab
> object stats. I think we definitely cannot do atomic updates in the slab
> allocation path. Although it seems like count_shadow_nodes() is a rough
> estimate and perhaps we can forgoe using the stats there.
>
> If we want a generic solution for in-kernel flushers to improve stats
> accuracy without killing performance, I think we need a heavier lift to
> rework rstat or move away from it completely.

(Adding a few more people and mailing lists)

So I experimented with a per-memcg atomics in zswap (see [1] for
context), and it appears to be too expensive even for updating the
zswap stats during reclaim / swap faults. So I think zswap will need a
similar approach to writeback and other in-kernel users.

One idea is to keep per-CPU per-cgroup counters, but on the update
side we update all the parents' counters, instead of just updating the
current cgroup's counters. Flushing the stats then only needs to
iterate the per-CPU counters and doesn't need to walk the cgroup tree
at all. There is added work on the update side, but hopefully it's
cheap enough to update per-CPU counters, and cgroup hierarchies aren't
usually too deep.

A more radical approach is to completely drop the per-CPU rstat trees.
So instead of walking the parents to add them to the per-CPU tree, we
just walk the parents and directly update the stat. The flush side
will then always iterate the per-CPU counters to accumulate them. With
this approach, the update cost roughly remains the same, but the flush
cost changes. Instead of walking the trees and flushing all cgroups,
but only doing it on CPUs/cgroups that actually have updates, we
always iterate and sum the per-CPU counters. The average flush cost
may become more expensive, but it should be more consistent and won't
scale with the cgroup tree size. I am not sure if this would be a net
win or not.

We can also choose to do the above for all the stats or only the ones
used by in-kernel flushers, the latter would probably perform better
but at the cost of more complexity.

I honestly don't have any time to pursue any of these approaches, so
this is mostly just a brain dump. But I do think we should try to more
systematically solve the stats flushing problem as it has given us a
lot of pain over the years.

[1]https://lore.kernel.org/linux-mm/CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com/
