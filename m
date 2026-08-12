Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56F3DEFE2
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786568384; cv=pass; b=S3mXO6xbvfujA6WyQECrx64oS3fvK5GAFmlgTsii/JVjkaF8qk/9PZLswV9Fe1m8j+5rbGpY5R/STLEaYdKbygNH5r93RPRhO3N2o3toPoNBSkcconDMdKLwcz5sjkrCfHD01S20r6wJwFZKGXJvr1zMJ5fTGNdgdWxtus3aFqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786568384; c=relaxed/simple;
	bh=yWL2WL83hQ19XP/v0uAHa0MucXl7dvYxfvVpUpky/+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qSDCcuzdl7jmMtHNl7/tVG4ciEf7w/IELDMPheL4LjhOzrL3oUhLMcdD1lIERYdm6QQ7gUEBBk3UtWMR8YnaRxUFKM5pyhQk1nXR3OKPNIIdYdehuTJoNCYlUD+BnsqQMkRWSFbEd1W6LcM/00d+QlMIzJIKE3crM5TzyZ3VdRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdkXhuDX; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdkXhuDX"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f96c5b722so728726f8f.0
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 13:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786568380; cv=none;
        d=google.com; s=arc-20260327;
        b=XTJK78T7k+ZJmL02ACfFdGvy5SCDlDAm1xbvIIakiXwkbVP6Qs7lxen4hL+wuEMQPU
         Y2uabNB9Iv2ZTJygEKh2UFCJrPEfCNQy+naCHfkFuNGgRzmtBrqnavx9e+mKJtiEYkjn
         RDkC/B8mUkejZ96oKx5GLGQO5xozTQm7RNy7roRjH90qeOJTYV7lODxWLFIHS4wpRMBS
         DGb6ZSVQThx4NxqSfswzKzbn5niwxmVLuE/CWux1YshgMseRxr6N9huFKXGwSbKz7XEz
         CqZg0EEuLoip9Ypd4g/CIO69rd1wqU35orkwIa52BPFm3uKbqj2IejymmYjNf0Zkqz7G
         BfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        fh=ZES06c4OQMHD80/hZ1KtvuVs4U1YycoX//vS1Uj+TSM=;
        b=rE1cgmsEJ+zfWmUirxCDpp6wEbbpFGOcqJI+bzJ0gYsewzlMl1Z3cYE+15uOxxJYX2
         an/NfiArNNVeytX3G4ivVXzbDYP7caBj/0Uu0/fSl0zY5RciOhW11kQ8Gh/Eal1RAs4L
         +Pj7u7iPjkBR0B/fZtN9xjxKQlSj1Km/QmWls0qsmau7aFacKtT5sc1UjnZTGSE+eLmb
         d5+/0tLGSraRRm3vcA7azFcb094VOzwzs8Au8ICi3eWacGF2p+ZUyjkHYct16/iuBSpz
         jEwsrZyy1LCe5RMwBUbOjN6r6RyJTqnymDuCi60ghhPfcA7TiCW0l9bH7jS2kpH7VogZ
         BWkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786568380; x=1787173180; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        b=LdkXhuDX6ME5JIexDQ9JbaKsSLZsYZBM+TJKi97j6GewdEqUvvx0hL8RucUs3l3XT4
         eWVZMfTBKrIki87JSHwJTVNbOtSFhT5ifJ7/iZo/Yn1OLrg/xtR50SudHlrBgNRQQpCx
         ti+ny/ry5/4LH1wPFlsjMbVN2sbqKarkwkab1v/NN4TgnmA84m4dPFHijfgKiPMCntK7
         zs3mNZboFIp85k7uBBC9UjVgsZNFZseqmppCzPHbXxTxn+mvP2Z4CLQ8Fv1t89R/iSqt
         9STWdUBOgA7nSoNC82m/GADEzDGsRY8G2K/8QdEijUjHmKFEQD5HUSWNzzk20UdfqPu/
         NOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786568380; x=1787173180;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cG6kQ9uiiQnTnSbk7yBwezCJNC8B3xUK4sacoj5tne4=;
        b=VxgStvBBiRqHNBGZD2Jfqvk2igemoDZBjwmX4lWnjdgMhzAb09S/tEXt2OjZuRF+si
         YuuozXy55WEawowg5TynjhJDcI2stLNm+G9lwl2aoLeafe3q84h+TbCh/Y4Cg5hYRntD
         PbF29JXPDsN74V43sNn7lv4FG71jdCr3tIc2u040kH6n5eRa15OwwYLseJWAoROFsa94
         jeZk7GjbHkv0IU+2IISd4y3O+7KYFTSqLtL22zREcIwcXwu1SKuTILbyIKl8RzY+hHpk
         UjUG+GDu2Pei0dZvVZHqNUIIIFT9NKy4kV84QJXcf7Lg8TeiRY+6WrKM6hB93NKXq/N4
         eD4w==
X-Forwarded-Encrypted: i=1; AHgh+RpPOv/+2rMbyJTUTyIPos6UCpNN5CtNdVbfxpl59Z+ao301FXRzlByImtKRxNSh3Hk4AZjjRY93@vger.kernel.org
X-Gm-Message-State: AOJu0YwrqF0xr5dPXSsp2zyY3L0KP9pOcBzsFBCoiSqpMY010/qyTsbR
	pe+g5rRNbT8wwXYvwq0JbUafxj5IqKDeyvaAJIJPgn4C4hezB98wsLKdEDhj/KozWY14ErdenbV
	+u2ZmCruEoKDHQYLGf0sN+GobUN6MwZQ=
X-Gm-Gg: AR+sD11QDS/efzZykdSqqIANNGxIz3tC8xr7zzXXbqkawlr8g57HqO3MN0GQqWtd5dG
	0XHXQulZRC0RJDulaUWK6hCAt0YmrbIH/eTPpskRWLMj+1TIkup3ZxtbE59Yb6ZJ23+NRpIIWhO
	hmz1DjofWLoqmqI1xazVMJwx8XUZoJthjWjNlTLltpcZKhz7puXCUsuRcxbL2AqzYJWWU5u/+74
	qkNG4Q2kOf9WS3y1w1v0QUhA3FrWV1S2DwCZQT4zy5gXcVJ901FblllN6QzhP+8MYrK6Q7ODJNZ
	DtVLSwL6vL+xzlm2jeqqRLscgF/JgRV+TTrQM5dEmlcGd8QVCfwhJNxGD/QG5LXALv9Hk8aRvzU
	J1c5FyTyLFG+2NMlbGLtMasOd5UxDUjarxWM=
X-Received: by 2002:a05:6000:60b:b0:47f:eb22:4d9a with SMTP id
 ffacd0b85a97d-48159fee3d5mr1167517f8f.22.1786568380185; Wed, 12 Aug 2026
 13:59:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com> <anpsLy_pCanocgS1@google.com>
In-Reply-To: <anpsLy_pCanocgS1@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 12 Aug 2026 13:59:25 -0700
X-Gm-Features: AUfX_mwFa8e6pDMfp1WdXiJ_HKLGDCz9OWII2-x-7qK48Cw8cAhcq_BvLRoXfk8
Message-ID: <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
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

On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > I'm not too familiar with memcg or vmstat so apologies if this is a
> > > > naive question, but does it make sense for memcg to just do a simil=
ar
> > > > approach to what vmstat does? As I understand it, mod_lruvec_state(=
)
> > > > updates the node counter and the memcg counter (if memcg applies),
> > > > where for updating the node counter, mod_node_state() does some
> > > > batching where it updates the global counter for that stat only onc=
e
> > > > it crosses some threshold (pcp->stat_threshold). Could memcg keep i=
ts
> > > > per-CPU counter as the accumulator but once it reaches some thresho=
ld,
> > > > it then propagates it up the parent/ancestors into a per-memcg atom=
ic
> > > > global counter? The atomic would then only have to be touched once =
per
> > > > batch than on every update, which might eliminate the overhead of t=
he
> > > > per-memcg atomic you saw previously? It seems like this would get r=
id
> > > > of needing to do any flushing altogether, as we could just read tha=
t
> > > > global counter directly.
> > >
> > > The memcg stats perform similar per-CPU counting and thresholding. Th=
e
> > > main difference from vmstat AFAICT is the cgroup hierarchy. In vmstat
> > > we have per-CPU counters and a global atomic counter for each stat.
> > > For memcg, we have the same for each cgroup, then we also have a
> > > cgroup tree. When we read the stats of a cgroup, we usually want the
> > > hierarchical stats including all of its children, so we can't just
> > > read the global counter.
> > >
> > > We use rstat, a cgroup framework that keeps track of which cgroups
> > > have updates on which CPUs, and then memcg has thresholding logic on
> > > top to only flush if the number of pending updates exceeds a
> > > threshold. Essentially, if the magnitude updates on a CPU exceeds
> > > MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We only
> > > flush if that global per-memcg counter has > NR_CPUS *
> > > MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to 2 =
*
> > > NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
> > > stats).
> > >
> > > See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this lo=
gic.
> > >
> > > Looking at this code again, it made me realize that we already iterat=
e
> > > the per-CPU stats_updates on every update to increment the number of
> > > pending stats on this CPU. I wonder if we can replace this with
> > > actually updating the stat on each parent, then the flush path only
> > > needs to accumulate CPU counters. Or maybe as you mention, we update
> > > the global per-memcg counter when updates on a CPU exceed a threshold=
,
> > > and forgo the rstat flushing logic completely.
> > >
> >
> > I can run some experiments and see if updating the global per-memcg
> > counter per batch and forgoing flushing could be a viable solution.
> > I can use my setup to test it for writeback, but for the zswap use
> > case, what's the best way to test if the changes are too expensive? Is
> > there a benchmark program you're running?
>
> I was running stress-ng and measuring the latency of zswap_load() and
> zswap_store() with bpftrace. But I suspect whatever works for writeback
> should work for zswap :)
>
> >
> > For updating the stat on each parent and having the flush path only
> > accumulate CPU counters, I think this means we would have to
> > unconditionally walk the ancestors + update its counters on every
> > update, as we wouldn't be able to early break if the flushable
> > threshold was already exceeded. I don't think we could replace the
> > stats_update update, as it seems like readers still need some way of
> > knowing when to flush. It seems like this could be a nontrivial
> > performance hit, but maybe it's a non-factor in reality. If you think
> > this would be useful to get benchmark numbers on, I can run some
> > experiments on this too.
>
> I think we need to experiment with how much work we can shift around
> between the update and reader sides.
>
> Right now, on the update side, we call __css_rstat_updated(), which
> iterates the parents and puts them on the per-CPU rstat tree, then we
> iterate the parents again in memcg_rstat_updated() and:
> - Check if flushing threshold is already met.
> - Update per-CPU counter for stats_updates.
> - If per-CPU update exceeds (another) threshold, we update an atomic for
>   stats_updates.
>
> The flush side checks the flushing threshold and does an rstat flush,
> which will walk the update trees on all CPUs and iterates all child
> cgroups on it. Pretty expensive when the threshold is met.
>
> I think we discussed two different options:
>
> (a) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly.
>
> In this case, we can't keep using rstat, as we would still need to add
> the cgroup and all its ancestors to the update tree anyway and the flush
> cost will remain similar. So on the flush path we'll need to iterate all
> CPUs and add the counters. We can explore if use a cpumask can help
> here, but perhaps not since we'll need to update it atomically on all
> stat updates.
>
> I imagine that if we do this we'll drop the stats_updates optimization
> to avoid adding more cost to the update side. We'll be replacing parent
> stats_updates modification with parent stat counter modification. But
> maybe it's feasible to keep both to limit the cost of flusing.
>
> This only works if the cost of iterate the CPUs on the flush side ends
> up being cheaper than the current flush. I imagine the average cost will
> be higher but the cost should be much more consistent vs the current
> flush, so the tail should be better.
>
> (b) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly AND update a global atomic if the per-CPU
> counter exceeds a threshold. I think updates may get too expensive as we
> may need to update multiple atomics, especially when updating the root
> counter as it will be contended by all cgroups.
>
> The flush side becomes an atomic read, so should be very cheap, and we
> can drop other heuristics and optimizations.
>
> ---
>
> I think ultimately we need to experiment with these approachs (and
> perhaps others) to check what actually works in practice. You'll
> probably want some benchmarks or synthetic tests with many cgroups to
> exercise the worst case scenarios.
>
> For the zswap stats, I used to run stress-ng with a bunch of workers
> (20, 50, 100, ..) in cgroups of different levels. Since all workers are
> in the same cgroups, all the parents are common and all threads end up
> competing on the same atomics, so worst case scenario. I was also
> testing in a VM that has more CPUs than stress-ng workers, to exercise
> the full extent of the concurrency and contention.
>
> This could be a lot of work, so I am not really asking you to do it, but
> just brainstorming and sharing ideas :)

Thanks for your guidance and insights on this, Yosry! Your responses
have been very helpful.

I'll do some experimentation with this and try to get a sense of what
the update costs are.

One thing I was unclear about and have been looking at is how
pervasive/important this issue is outside of the writeback case. It
looks like there are roughly 4 other categories of users that rely on
stats that can be 2s stale: zswap, cachestat(), working set, and
vmscan.

Of these, vmscan is the only one that looks troublesome. Some armchair
analysis below:

a) zswap (zswap_shrinker_count()): 2s of staleness looks fine. the
stats are only used to calculate the compression ratio and the ratio
scales a count that comes from a list_lru and *isn't* stale. The ratio
is an average over the whole pool, so it seems like that should be
fairly steady across 2s. A stale result doesn't seem too bad - afaict,
it is a heuristic of how zswap should get weighed against the other
shrinkers.

b) cachestat() syscall (filemap_cachestat()): seems preferable to just
rely on the 2s flusher worker. The results are returned back to
userspace and not used for any internal kernel decision-making, seems
ok to have one field in it (nr_recently_evicted) potentially be stale.
Seems better to err on the side of less frequent flushing anyways, as
the call path is invoked from unprivileged userspace and flushes the
root memcg.

c) workingset: looking at the original commits, the calculations are
estimates that don't require exact stats -

refaulting (workingset_test_recent()): commit 9b3016154c91 ("memcg:
sync flush only if periodic flush is delayed")
    Now the question: what are the side-effects of this change? The worst
    that can happen is the refault codepath will see 4sec old lruvec stats
    and may cause false (or missed) activations of the refaulted page which
    may under-or-overestimate the workingset size.  Though that is not very
    concerning as the kernel can already miss or do false activations.

shadow-node shrinker (count_shadow_nodes()): commit d4a5b369ad6d ("mm:
ratelimit stat flush from workingset shrinker")
    On further inspection it seems like we don't really need
    accurate stats in this function as it was already approximating the amo=
unt
    of appropriate shadow entries to keep for maintaining the refault
    information.

d) vmscan (prepare_scan_control()): for determining whether reclaim
can deactivate, there's this logic

                /*
                 * When refaults are being observed, it means a new
                 * workingset is being established. Deactivate to get
                 * rid of any stale active pages quickly.
                 */
                refaults =3D lruvec_page_state(target_lruvec,
                                WORKINGSET_ACTIVATE_ANON);
                if (refaults !=3D target_lruvec->refaults[WORKINGSET_ANON] =
||
                        inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
                        sc->may_deactivate |=3D DEACTIVATE_ANON;
                else
                        sc->may_deactivate &=3D ~DEACTIVATE_ANON;

(and same for DEACTIVATE_FILE for file-backed folios)

target_lruvec->refaults[] gets set at the end of the reclaim pass. It
stores the same lruvec_page_state() value that prepare_scan_control()
will read at the start of the next reclaim pass, which means if
reclaim passes happen more frequently than the 2s flushes (eg under
sustained/heavy memory pressure), this logic will incorrectly assume
no refaults occurred and deactivation is disabled, which afaict means
folios won't be moved from the active -> inactive list, and reclaim
will start evicting pages from the inactive list that are hot (eg more
refaults).

This is from reading the code rather than a reproducer though, so I
don't know how much this matters in practice. Unlike for the writeback
case, I don't think flushign more frequently solves the problem. It
would shrink the staleness window but not eliminate it. Maybe one
solution is to keep the deactivation state for a period of time if
refaults were observed.

If it turns out iterating the parents and updating the per-CPU
counters of the stat on updates is too expensive, perhaps it makes
sense to keep the existing rstat logic as is and have caller-side
workarounds, as only writeback and vmscan would require them.

Thanks,
Joanne
