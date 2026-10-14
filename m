Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE2B757EA
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 00:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791936348; cv=pass; b=uh/TwIJcJ4gH+SUZu1CqvbQlyxhNsjvgnDywiC4LqOBbIsRFgENUfbbwyFT57Dyo8ERW10YRf8ZDV5ZXBJ5ThHICPLojR6Gu8hDX7QWgEZqJFiBBY2QuTVbpxB3KtMDUBkpYeIUN+VIJa8O5yfa1YIo3Vk5iRv6XBTIN9tKfHBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791936348; c=relaxed/simple;
	bh=JiIkoDrG8B/K/e0G126rXH/WHg3dZTUEry5fG6BL75M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GbIcZ2Lw5n+zTG0jYOpySMn38xQmu7vZampYCt73qaEWK9uLFgFIT8RrCG3gh+MGm56YZPHKlNxQouKtOZJBiLj4h/JPz6+9boVZaaMMsUq6OB1FPW1u/vHRTvqczeYJZoUD0KIpRlK+aWSRC3utlMxpyt7Q838i3FK8zXUVGnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCtnJbQB; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCtnJbQB"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2349693f8f.0
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 17:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791936344; cv=none;
        d=google.com; s=arc-20260327;
        b=EqBpMlGvjWfB0ojlzaM1QJcf/YAMaSrVsYVTmKEhMYgkQGB9MbObHFa0ErYVaiFiK6
         vHobu27Z9FBd/Z7hF3EmhDGsCUUT2EyHVE39q3T3kA2HQEVh+XWi+/+arukTjAizKF9y
         JWDMEWU2+XRH8vj8G1v4ZiNoks4i5cbqs7Ok+MK9uUr7oY3hyPqClp3hHyFfHqEMZN+h
         rpnVHmrazmZ3u1kjSzyz0MtrnO0OiONQyC+i1xUUAmMw8VU6MRBjKK9VDuuwBkqaAatB
         /dwy6saJQPRqZ6nU2ospbhy4jkSLq/fQyO594YfQ027ed16MZTxaydoH8/8BoDz7V83U
         4ztw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        fh=2kx2JmpDKyFlL4onbPZUYCqM08eEOXmDrbQNh/gocAU=;
        b=OCX5UAV1M/8x0Xfa2r8obJsa0eRg+Jzb6R0F8xPpmN4S0cB3qXyYqAkphGgAi2m0Ai
         Hs2ZSDJ7eSab6DaaLpxtWnXVzjB1+xj+qEgbUwAgqvutYJ6Y6ETe/GeyM0vVDw1L2vLM
         t6o2M9Od6YqHSbDdyRhh7PG8TNBAob+CLApOA3Z9jiobUxd2UcJpU0yB8An7oK53q35W
         KcH9MTPCSOft19Gddd5+Mi2ouaic0SldmngU/OZXcswo5D1xXX8zDB4eqticMuhP2n4B
         EHill/61sxQ3FgElfd5t7rBBdaD+y6t15REmaaKqG9j6rl7Tvl9cHK3Q5QEWGXC5zFnw
         eROA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791936344; x=1792541144; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        b=WCtnJbQBJDCUtVFEvJCn5UfOrSMWH3mCBLLkHdunYelA/uioc0YoxgeNxidOIER4js
         hpRSYKljuMk6QobzRmqv2cCN6YOCt+xfDj/My5IXPyQqDaSNY2rhHBzyHpEQ1eDhPO1z
         sMRJu8Lnh3FPX/8022gzbovsXOI6qAX5JRFmw4PF2da0Iwh7Oc8FkEzwJbWhd0ofR+fc
         PeI5KYxf9KCs1ff4ECV+XAAnattyAgjgQ/oaoV7LyEnsGRhWVd5XgKBjoOMxH5s23VJF
         w6BoCU13pWywfqrkXehGDlPcU+uSux4wxkHpxWcW+y4AaOqoz6j/emDANYRSOHTG4Kh0
         04Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791936344; x=1792541144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        b=DQVZH4ObaAehZPpV7+yyQsMCJxVzXo54BvBJNGZA1caAanS0+l7nbt5qDiaGseK2nK
         gQZX04m/WeAsVPogsFC8dJXCproSdQ9OhGINb+c2BZSlyonYrGFt9UfE+1655NWid6SI
         Fwi/9x8H5K/VMCbjOGI5zx4YaoSZwAZXjsDd7KjneKWNp/EWcqhvYN3mz+KwPuAqrtA0
         Jsds+Cy3WmcPH3TFef1Hn99cdOs5PQJsc/KN8EtxJ9pjJWkVDt1qR5PtekacRNGerwI/
         NdOyrsV6sYNCpLG9JFSVuCxi5NGggXqwsV2ARwxMC2Umv7G6oel6EZaFgx6MIRY7IoKw
         wteQ==
X-Forwarded-Encrypted: i=1; AKwUvBxbPDqJeiS0R9EAjFCH0ZysCZ/nX1Cn+twnzZZueCz6UkXFFhj/Mj2pt5mQWDXnzIvUyKRjHyny@vger.kernel.org
X-Gm-Message-State: AFq9FYLOl6mguvUiNQtzFTy2ootRX6rpZcOSCawD7yUd1Qal+1lQNMsb
	iFYfZs6oEw2UWDKP/s08PNMtnKJskRNhurtJuLUQrMVWduEv4r2GVtmUGxajTbmyfJFCUhURY0O
	hO0e1ZRq3F80h1j56RWeYVWJkEsE5frI=
X-Gm-Gg: AYBFou0LzLR02QV4BYS23z8bxpWQzvarhBXj4I5nG4lELbH/EY+AaygGCuey02jorat
	0wHdao6zu5ohX3WZRMcJ34pGi2Q+XSFa4mD1FKZVdk6+zRH8cTPPPVFG+DpslsMzYeoK8F+Azi0
	c6pn57EEtlyS3v978WCbUWapZCKyFfAfsxIqS2CeolcIfOtvKlwOzPeHtTVXCCPjE1nUPIqcd0l
	hdof11gonDWkPS+N/7dO7Gf0P/XDNTbKjiPAAHeJlAieqQJuV7J1eLMF1mL23yPggYQlT/zH/ee
	x1vo1piRkU0410h6C+ngWTMgsbJ7uFoDtD0fGJITfvqQog6S788VaysfKgsbVtWh28NckrfaXyn
	khfN1pBpx4uc+prFCXmTpPeGqxENpIdfFPznbU08sKyvEeR/I7lMD
X-Received: by 2002:a05:6000:491c:b0:485:1bcc:67f8 with SMTP id
 ffacd0b85a97d-48dbaadb2d5mr26190862f8f.13.1791936344413; Tue, 13 Oct 2026
 17:05:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com> <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
In-Reply-To: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 13 Oct 2026 17:05:32 -0700
X-Gm-Features: AclHuK8WhcrCOTeK0kKrzzEhohmXHWs0Un0onHQb7Xyw4WEMp2HD0VK19I_-6P8
Message-ID: <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, James Houghton <jthoughton@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yosry,

On Mon, Oct 5, 2026 at 1:45=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > I added some instrumentation to prepare_scan_control() and have been
> > seeing that the OOM gets triggered in this pathway:
> > a) the memcg is created with memory.max set to unlimited. 512 M gets
> > faulted in. The new anon folios get put on the inactive list. Nothing
> > reclaims them yet
> > b) userspace then sets memory.max to half of memory.current (~271M
> > from ~542 M currently used). This causes memory_max_write() to trigger
> > reclaim logic
> > c) the folios have already moved to the active list (my
> > instrumentation shows 122684 active vs. 179 inactive) when reclaim
> > does the scanning, which means the only way for pages to be reclaimed
> > is for pages to get deactivated from the active list back to the
> > inactive list.
> > d) prepare_scan_control() (which decides if the pages get deactivated)
> > reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> > (the 2s flusher hasn't yet triggered since when the memcg was
> > created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> > still zero. The real values are all still sitting in per-cpu buffers
> > that haven't yet been flushed. My instrumentation shows:
> >         inactive_anon       rstat: 0    actual: 179
> >         active_anon          rstat: 0    actual: 122684  (~479 MB)
> > e) the deactivation logic in prepare_scan_control() is:
> >
> >                 refaults =3D lruvec_page_state(target_lruvec,
> >                                 WORKINGSET_ACTIVATE_ANON);
> >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_AN=
ON] ||
> >                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANO=
N))
> >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> >                 else
> >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> >
> > The if check fails:
> >      refaults !=3D prev refaults: 0 !=3D 0      (false)
> >      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> > inactive_ratio < 0     ( false)
> >
> > DEACTIVATE_ANON gets cleared
> >
> > f) pages don't get moved from the active list to the inactive list, so
> > reclaim ends up freeing nothing. memory_max_write() goes through all
> > MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> > (but it's all on the active list).
> >
> > I saw that the skipped_deactivate retry did fire (on 858 of 4264
> > scans), but not enough to get the memory.current back under the halved
> > memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> > and OOMed.
> >
> >
> > imo I think the best fix would be
> > a) for non-root memcgs, revert back to the non-ratelimited version
> > (mem_cgroup_flush_stats())
> > b) for root-memcgs (which if flushed will flush every cgroup on the
> > machine), don't use rstat at all and use the existing node counters
> > instead (which is what the non-memcg case already uses).
> > mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> > stat in the same call. For the root lruvec, the node counter reflects
> > the same value and doesn't need any flushing. It has an error bound of
> > 125 pages/cpu at most, but this is tighter than what we currently have
> > with the ratelimited version.
>
> This seems like the right thing to do. If we have global stats, we
> should avoid a rstat flush. I actually wonder if we should start
> systematically eliminating root flushes, and if that ends up being
> good enough to keep everything else as-is for in-kernel flushers. The
> flush in zswap_shrinker_count() is also a good candidate, we already
> use global stats when memcg is disabled there as well.

I agree, I think we should replace all root flushes with reading the
node counter values. I'll submit some patches for that.

>
> >
> > commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> > reclaim") was what switched vmscan to using ratelimited flushing. The
> > reason for this was to fix the stalls from concurrent reclaimers
> > contending on the rstat lock. For the Cloudflare case, kswapd threads
> > were contending on the rstat lock on 8 numa-node machines. That's the
> > global path (eg sc->target_mem_cgroup is NULL,
> > mem_cgroup_flush_stats() turns it into root, so this flush essentially
> > ends up flushing every cgroup on the machine), which gets addressed by
> > adding the fix in b), which takes kswapd and global direct reclaim off
> > rstat entirely. For the non-root memcg case, the flushing is bounded
> > by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> > memcg's stats_updates only accumulates its own subtree's updates, so
> > it takes a lot longer for it to be exceeded than the root's does).
> >
> > I ran some benchmarks to get a rough idea of what a) costs. I set up a
> > workload that allocates 512M of anon memory in a memcg with memory.max
> > set to half of that to trigger reclaim continuously. I varied the
> > number of threads touching the memory, so that N of them hit
> > memory.max and enter direct reclaim on the same memcg at once. I used
> > bpftrace to measure the time spent inside css_rstat_flush() and
> > shrink_node() and used those two numbers to get a percentage for how
> > much of reclaim is spent in flushing. These are the numbers I saw:
> >
> > # threads      flush as % of shrink_node()
> > 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> > 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> > 64              ratelimited: 0.16%       non-ratelimited: 2.52%
> >
> > Between the ratelimited and the non-ratelimited runs, walltime and
> > pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> > threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> > pgsteal within 0.2%).
> >
> > I also measured the lock contention. At 16 and 64 threads, 15-20% of
> > __css_rstat_lock() acquisitions hit a contended trylock with the
> > non-ratelimited version. At 16 threads, the mean flush time rises
> > about 8% and at 64 it roughly triples from the single-thread case
> > (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> > effect of this on wall time or pgsteal between the non-ratelimited and
> > the ratelimited version, and the percentage of reclaim time spent
> > flushing stayed at 2-3%. I think that's because css_rstat_flush()
> > takes and drops the lock once per cpu rather than holding it across
> > the walk.
> >
> > I also ran it with 32 actively churning sub-cgroups under the reclaim
> > target, since css_rstat_flush() walks the descendants that have
> > pending updates. I saw that per-flush cost rises slightly (~24 us to
> > 27 us) but the share of reclaim time spent flushing went down rather
> > than up (4.1% to 3.2%), because reclaim gets more expensive faster
> > than flushing does. I don't have a ratelimited baseline at 32 children
> > though, because with the ratelimited version, all the runs I tried
> > OOMed. I think this is an alternative repro to the OOM issue but
> > doesn't need/have KVM dependencies, so if this would be useful to
> > clean up and send as a standalone C repro, please let me know.
>
> It might be useful if it can be added as a selftest or similar, so
> that such regressions can be caught more easily in the future?
>
> >
> > (Also btw (this is a bit tangential to this OOM issue, but somewhat
> > semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> > checking really does anything in practice. On my benchmark runs, the
> > "refaults !=3D prev_refaults" check evaluates to false in pretty much
> > every scan. Even with flushing working properly, it didn't trigger on
> > 1673718 of 1674912 samples, even though the cgroup was thrashing the
> > whole time (a separate run of the same workload counted 6371860 anon
> > refaults vs 6523 activations). I think it's because reclaim is
> > scanning faster than the refaults counter advances, so it'll almost
> > always see no change. I'm not sure how much this matters in practice,
> > but I think effectively in that check above in prepare_scan_control(),
> > deactivation relies entirely on the inactive_is_low() check.)
>
> I am also not sure about this one. I am not sure if reclaim moving
> faster than refaults is something universal, it seems like it would be
> workload-specific. Johannes is the person that comes to mind when I
> think about these heuristics, so maybe he has an opinion about this?
> :)
>
> >
> > What do you all think about adding a) and b) as the fix for this issue?
>
> I generally agree. Doesn't really matter much, but I think we should
> do (b) then (a) to avoid reintroducing the regression temporarily?

I'll send out the patch for (b) and then (a).

Thinking some more about how stats are used... I think there's two
categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
workingset counters, dirty/writeback, zswap) which are read very
frequently from the reclaim, refault, writeback and zswap paths and b)
userspace-only ones (everything else) that are read through
memory.stat / bpf / etc and much less often. The hot in-kernel ones
are a small subset (~20 of ~80). Most of the stats fall into category
b). However right now, a flush always aggregates *all* of these stats,
even when the caller only needs / cares about the hot in-kernel ones.
Flushing does all the work for the stats in category b), which the
in-kernel flushers don't need. With the per-node lruvec copies, a
flush goes through 100+ counters per cgroup per CPU vs ~30 for just
the hot in-kernel ones (on a single-node machine).

What do you think about splitting the stats into two rstat trees, one
for each category? In-kernel flushers would then only flush the hot
tree (~30 counters). memory.stat would still flush both (eg userspace
would see the same thing as it sees today). Each tree would have its
own lock and its own stats_updates threshold. I can run some
benchmarks but I think this would make flushes a lot cheaper, and
since flushes would hold the lock for less time, it should also reduce
the contention we see between concurrent flushers right now. Together
with using node counters for root readers, hopefully this will make
the non-ratelimited flush cheap enough for all non-root in-kernel
readers and ideally let us get rid of the ratelimiting variant
altogether.

Do you think something like this makes sense?

Separate from this but also kind of semi-related, I noticed
css_rstat_flush() takes the rstat lock for every possible cpu, even
cpus that have nothing to flush for the subtree. Maybe another
improvement is to just first check locklessly whether there's any
updates and then just skip the cpu if there aren't any. I can send a
patch out for this.

Thanks,
Joanne
