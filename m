Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F26B3CEBA9
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050263; cv=pass; b=BYK5eY5AtrpU9+DYaPF/p7cDJtfRdf+VGknkJ8/AkO0ZWGOeeiDcSxtoKK6RRl+bpI0DMv2e8N2d7abkr3FImpwhK+o4S5WdhdkSfN3XgSPLYq467pRYD+CMsmruJu9ub4F/Bm2T2ilNKInVbeImrUJTVjZHhRO9FYQeAqju0+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050263; c=relaxed/simple;
	bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PILETp9cPP5trnSNWg8/cuIXRXevfOGP6Iz5PD/uZNpm86LQVFiG4riDhcOBMpzxakPWfKmjdBtUTiSL4kZIpRBQ1aAtk6eEJNgjnpZy8Gq/NYBu5IIocYzzIM8Ow08M7GppiAmVPrGn2Eyg6kWRJe+/Z4aLIIy351YWrCKQBNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTzUo8P9; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTzUo8P9"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4957eefd361so19837685e9.1
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 14:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786050260; cv=none;
        d=google.com; s=arc-20260327;
        b=AqrDBEkW1GZFgQAMRgQ3PhExEcapiPpRfZbpkJEjlGF5gYOwciTZiKy4r/Xz5YkKRH
         RHMeArKrILYyIKRCUCIsow0lc0TOTOHOtMqPUAtmOh+bpLhrJ7THFk45jC7AcV1jBNPP
         McqzTcF92gNa1W88Q8npoJyNHynIYcxp/jzGCkYXxcU+8Z9V9qM36yVSOFDtLQVfr825
         2aC10SGvhZgEjgezWdCBooeqMr0qsWcuwDuhPd/wL0aoryWHvlUYqjXodOZpFSO5d9xN
         ZBVYOHRD0l4Wj+fai5y+ITll0iEUjT4sZl0WY/WCYR2oHWN/Ss4Vn0dKqgHfaNYljOSC
         cG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        fh=OUKMPPntcUudgHMiDH653Kb6cq4Pr4+ol5aTwtahvSs=;
        b=NujYOtWyhJ7lGdXeLECpWiksNzeZpw2Cak/INuHY3qAVOMBBKsoOc+BkWPETIl0XiD
         KVZ5VK+FnsW7P0xSOLK+BfSSGihGPINvayzzQrSGBDLdjzilHPdUWocAzbUrjzUlAbuk
         XfBwS+TNhUaK5qz4iK2B+E8xIxNnBwbfPJwuE/KiAFJYPBH4IyaXSvTAyAoazjo2M6TF
         ttNygCNHZo8ztwri7ZFhcxHGO0JQ6helsaUThqcUwnLCMWtpO2zqpxE3wJyyWm/bfDKa
         AO5JNe7gFyuhzWh9NhRd3GbB3sFt+A0+Ycs5rg1oFOUKul72bjPxJUrdBIimZr6D5zi4
         i8Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786050260; x=1786655060; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        b=YTzUo8P97m6EYpn+7T2YYPfL6Hc0rTtj52wTNGF10uPS0JqBuVg+XYnYbN/rB37lUX
         ixswBmlZIKWPXMcbA7lypkeqEZf/SP5t1mC/fVAzcXayOEOIhjpBxXH3uBiJG3x18fEC
         i20vWfXV1vy9BTAjWengd8WDxL3zVN/jUTwHoWj2oZm2e7lc1PQcoE9VDIX/YOEoEhYI
         glYK3+cZA26NCuGwxINh797hnWCuOsCtgl8ybc1lvM0KnMK1T1L2PIIOTwMgsVREg40K
         GCUz/gMLkuv0J7QIM4WJcE8sGv5chOBhJPNdDUpNY9nm1dYzDFbU6jFmwAF63jeyGUZE
         6lSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786050260; x=1786655060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8ilisN6b9rsvSV7tujnE8pXGbGA5qhlw1JHj7X5z5Dg=;
        b=LVwInzfmcyM6gxppCQs7MYupTrIInaBfFkf665NnAGRGgQ8tv++M/BydhI50H3A3ZR
         tK+h0lov8+MuZ1SdedYS69yL57gNpBN7NBJz3XwOVdUKf0BSsnIAaQkivZnu5Hk3Dko5
         YUDnNpMKgLlbaT1BnYbp79MT+djEhxJG0uJIQVI17kNxe6NNIXZ0BeIFPTE1YVNUHY0T
         v+pypZ7/Zklv/d3k2iSP61UZLeE34bCOtIYHHkw5m/tHqg4xKpVozQqX7dzOWZ6nlmnn
         xbsE2wriY6xx9mMeUXh1Bbx9LFeirg4Qgy2ZqFsO5AL4U7DjLDJgQ8fW+81x64e1msZ0
         X6+w==
X-Forwarded-Encrypted: i=1; AHgh+Rqfgxeftojks2YWPygtmNPwZin4y/HhrD4HplzJ+DZbaPrh41GpkMy62aiwdIeBCE4x/4HRiYLj@vger.kernel.org
X-Gm-Message-State: AOJu0YyKlk1YnpgtuC+ZiqCz4tHZARAL3q9LYJyXe0U9Kf6arbk2RT2w
	B6XQekvmLZfGkMuuY0+6GNXL7xuSvZ2UlT9TcZR3lsyn7Xs/fiSbPzDSyk/inoZhuHOEh8W6hw9
	GVhQmFcjIHcl8HOOWssw5yr7Y3rB4jtFPwz5B1zk=
X-Gm-Gg: AR+sD13SZT4/Ru/kCmbvaS8iqO3dxZ+ZSkXlXDhdIfQFT8bVb4Hk+PwzDdS4I1RUCSz
	NIawO0fRxKF/OmHUq4W5TruRPmeiahtov8JlSRcy10zK+FwqALiDKI2hNu8FKRVkJ99Cd7ajIUK
	VZM5kY6cKNmo8N5jjZz9KvoznHkQ1aB1mmEtG4mB3yJveMz7m/xBHhrYUQsGT2ORlM9hNaWa+rm
	7S2xWBDnxCjilmvXh2rit1pk2lmMMzxJ/WrqQbAbn5cswTv8ZthryBrajRCuORpH7IierwTn6Gx
	8kDaTTswBa21nO02T7LB+cobskHmzsbmA46AOziS527Bxj6qbf5NXzUHvavVkT94k1jVtxZhwg2
	F0HFlFo/dlclW3Ihvz9t8T1zxvOmdPy8nKsH9AB8NrngwbM8=
X-Received: by 2002:a05:600c:8b55:b0:495:3de8:33a6 with SMTP id
 5b1f17b1804b1-4994e7cdd39mr269199205e9.16.1786050259636; Thu, 06 Aug 2026
 14:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Aug 2026 14:04:06 -0700
X-Gm-Features: AUfX_mxaCgp8oYES6RNp3g9or9e5V5Tk3wVFme00shwxNtlto6HFGbmfyuWHQps
Message-ID: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
Subject: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yosry,

On Wed, Jul 22, 2026 at 1:38=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > First let's see if the general solution is doable and simple otherw=
ise we can
> > > > explore use-case specific solutions. In extreme case revert is an o=
ptions as
> > > > well but I would prefer a more sophisticated ratelimiting (that Jan=
 suggested)
> > > > than a revert.
> > > >
> > >
> > > Sounds good. I'll keep an eye out for the work Yosry's doing on this
> > > and look into hooking it up to writeback if/when his general solution
> > > becomes available.
> >
> > I am not sure if I had in mind would generalize well. For zswap, I was
> > just going to replace rstat with per-memcg atomic counters, and simply
> > walk the cgroup parents in the update path, as the zswap load/store pat=
h
> > shouldn't be too hot.
> >
> > However, looking at other in-kernel flushers (including
> > mem_cgroup_wb_stats()), I see they consume other stats like
> > NR_INACTIVE_FILE/NR_ACTIVE_FILE, which are updated in the page
> > allocation path. I am not sure if a cgroup parent walk with atomic
> > updates would fly there.
> >
> > A more problematic one is count_shadow_nodes(), which consumes slab
> > object stats. I think we definitely cannot do atomic updates in the sla=
b
> > allocation path. Although it seems like count_shadow_nodes() is a rough
> > estimate and perhaps we can forgoe using the stats there.
> >
> > If we want a generic solution for in-kernel flushers to improve stats
> > accuracy without killing performance, I think we need a heavier lift to
> > rework rstat or move away from it completely.
>
> (Adding a few more people and mailing lists)
>
> So I experimented with a per-memcg atomics in zswap (see [1] for
> context), and it appears to be too expensive even for updating the
> zswap stats during reclaim / swap faults. So I think zswap will need a
> similar approach to writeback and other in-kernel users.

Thanks for running the experiment.

In a previous thread [1], you mentioned your team was investigating
some premature OOM kills that might be attributed to this same stale
stats issue in the vmscan path. Did that turn out to be the case?
Asking because if so, that might be something we'd hit at Meta too.

>
> One idea is to keep per-CPU per-cgroup counters, but on the update
> side we update all the parents' counters, instead of just updating the
> current cgroup's counters. Flushing the stats then only needs to
> iterate the per-CPU counters and doesn't need to walk the cgroup tree
> at all. There is added work on the update side, but hopefully it's
> cheap enough to update per-CPU counters, and cgroup hierarchies aren't
> usually too deep.

I'm not sure about the zswap case, but for the writeback case there
are significantly more updates than reads. There are four stat updates
for every folio that gets dirtied / written back, so four per page
with 4k folios, while the read happens around every few hundred pages
dirtied. In the scenario I was testing with memory.max set to 8 GB and
using the default 20% dirty ratio, during freerun the stat gets read
once every 256 to 512 pages (with flushes happening less frequently
than reads).

I'm not too familiar with memcg or vmstat so apologies if this is a
naive question, but does it make sense for memcg to just do a similar
approach to what vmstat does? As I understand it, mod_lruvec_state()
updates the node counter and the memcg counter (if memcg applies),
where for updating the node counter, mod_node_state() does some
batching where it updates the global counter for that stat only once
it crosses some threshold (pcp->stat_threshold). Could memcg keep its
per-CPU counter as the accumulator but once it reaches some threshold,
it then propagates it up the parent/ancestors into a per-memcg atomic
global counter? The atomic would then only have to be touched once per
batch than on every update, which might eliminate the overhead of the
per-memcg atomic you saw previously? It seems like this would get rid
of needing to do any flushing altogether, as we could just read that
global counter directly.

>
> A more radical approach is to completely drop the per-CPU rstat trees.
> So instead of walking the parents to add them to the per-CPU tree, we
> just walk the parents and directly update the stat. The flush side
> will then always iterate the per-CPU counters to accumulate them. With
> this approach, the update cost roughly remains the same, but the flush
> cost changes. Instead of walking the trees and flushing all cgroups,
> but only doing it on CPUs/cgroups that actually have updates, we
> always iterate and sum the per-CPU counters. The average flush cost
> may become more expensive, but it should be more consistent and won't
> scale with the cgroup tree size. I am not sure if this would be a net
> win or not.

I wonder if this scales for machines that have a significant number of
cores? Onsomething like the 96-core / 192-thread machine Yunzhao
mentioned in the zswap case, it seems like the flush now would have to
touch multiple additional cachelines per CPU when it seems like for
the majority of the stats, only a small fraction of those hardware
threads would have any updates on them?

>
> We can also choose to do the above for all the stats or only the ones
> used by in-kernel flushers, the latter would probably perform better
> but at the cost of more complexity.

I agree. For the writeback case, afaict I think we really only need to
do this for NR_FILE_DIRTY and NR_WRITEBACK, neither of which are
updated from the page allocation path.

>
> I honestly don't have any time to pursue any of these approaches, so
> this is mostly just a brain dump. But I do think we should try to more
> systematically solve the stats flushing problem as it has given us a
> lot of pain over the years.
>

Thanks for writing up your thoughts on this - I found it helpful!

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxc=
B7xXNm_f3XfbA@mail.gmail.com/
