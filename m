Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E0B286A4
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788745495; cv=none; b=QOttdqqnW4vhKaYtz093Tz/q0n+2XBicCuptkG0PT0szPvWdaYfNzzUrtxJlgpchxWuuLidHd+uw6JvctzHoudjvAqAgYjLWKugf8XBekgPeyxPIU/2tK/roUNYVgX9srK9XpcBdczvHgCxSA+Zp04Gs2e3+FnyC3mKlOzse8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788745495; c=relaxed/simple;
	bh=XMR5YJjRPObLoKxi0OzfqaRkyg3NKVdX/m6x9mGp2oc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ExdgvYe6r++Pb7VazzyBYqO9baNvxaaaICADAY3VNkHbGPyF762GC4DXeHoSdxst0ZstyamM25vkcDHYa8vOdgXy7yAEGzAAYemhhXXh7bfWo4W5YpfN2YPsreeE0L5MYigNt9EfnDX/XemDhNv3WdNYHoncT8afCrTGkSsPnrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCwUwJdn; arc=none smtp.client-ip=91.218.175.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCwUwJdn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XMR5YJjRPObLoKxi0OzfqaRkyg3NKVdX/m6x9mGp2oc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788745490; v=1; x=1789350290;
 b=ZCwUwJdnQWZStcaR1trmencBxswFTSJP9SSHtDQ85LnJZyNu/A4+4jTNLdmgUIHqbaDDb+JB
 LQudeadFJtMDgfTF6V0UwmXbodmzrtZ94bHIiO7J/kDN+fKED7jno1P5IJE9rmIMHXiHQdMxRy3
 k3qmsR2+SEnDwKHBqxMKh+Q8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8afd76475cebebba;
	Mon, 07 Sep 2026 01:44:40 +0000
X-Mizu-Trace-ID: 8afd76475cebebba
X-Migadu-Flow: FLOW_OUT
Message-ID: <33a37382-28d0-420c-9254-431e1b7e6d6b@linux.dev>
Date: Mon, 7 Sep 2026 09:44:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v3 2/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
References: <cover.1788514750.git.zhuhui@kylinos.cn>
 <2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
 <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



> On Fri,  4 Sep 2026 17:45:55 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
>> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
>> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
>> which only the classic LRU paths maintain.  MGLRU accounts its pages
>> through __update_lru_size(), which skips that array, so with MGLRU on the
>> four evictable LRU lists are always seen as empty.  The shadow node budget
>> (pages >> 3) then collapses to slab plus unevictable pages, and the
>> workingset shadow shrinker reclaims eviction tokens almost as fast as they
>> are created, losing thrashing protection.
>>
>> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
>> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
>> race this re-exposes on cgroup v2 is closed by the follow-up patch that
>> redirects dying-memcg stat updates for all hierarchies.
> The follow-up patch is "mm: memcg: skip the RCU lock when the memcg is
> not dying"?  But that's an optimization so I'm confused.

Sorry for the confusion - the commit message still says "follow-up
patch" because that was the position in v2.  In v3 the series was
reordered as requested, so the patch that closes the race, "mm: memcg:
redirect stats updates of dying memcgs for all hierarchies", is now
patch 1 and comes before this one.  Patch 3 is indeed only an
optimization.  v4 will reword this sentence to:

The reparenting race this re-exposes on cgroup v2 is closed by the
preceding patch that redirects dying-memcg stat updates for all
hierarchies.

> If we're re-exposing a race, the fix for that race should have the same
> Fixes: and cc:stable as the commit which did the reexposure?

Yes, and it does.  Patch 1 carries exactly the same tags as this
patch:
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the 
number of lru pages")
Cc: stable@vger.kernel.org
Patch 3 has no tags because it only recovers the fast-path overhead
that patch 1 adds; it fixes no bug by itself.

> It isn't clear why any of these patches is cc:stable.  The overall
> effect is a tiny performance improvement?  Very clear descriptions of
> end-user effects are always helpful.
The performance table in the cover letter measures the overhead that
the patches themselves add to the stat update fast path, not the
impact of the bug - sorry if that was misleading.

The end-user effect of the bug is the loss of thrashing protection.
Since 7404bd37cfbe, with MGLRU enabled count_shadow_nodes() sees the
four evictable LRU lists as always empty, so the workingset shadow
node budget collapses to slab plus unevictable pages: for a memcg
holding 1 GiB of page cache and 64 MiB of slab the budget drops from
~35k nodes to ~2k.  The shadow shrinker then reclaims eviction tokens
almost as fast as they are created, so a refault finds a live page
instead of a shadow entry and lru_gen_refault() cannot restore the
workingset state of the refaulting page.  Hot file pages that should
be protected are evicted again and re-read from disk.  In other words,
workloads that refault page cache under memory pressure thrash, with
visibly increased IO and latency.  This hits every memcg reclaim and,
since the root memcg is iterated as well, global reclaim too.
> So at this time I'll schedule the whole series for 7.4-rc1.  If there's
> some reason why some/all of these should be backported then please lmk.
>
I would suggest backporting all three patches together to the trees
that contain 7404bd37cfbe: it went into v7.1, so 7.1.y and 7.2.y
carry the regression.  Taking patch 3 along with patches 1 and 2
avoids leaving the ~0.6% fast-path overhead of patch 1 in the stable
trees.

So v4 will reword the reference in this patch's commit message ("the
preceding patch" instead of "the follow-up patch").  No code changes.

One question: should patch 3 ("mm: memcg: skip the RCU lock when the
memcg is not dying") also carry the same

   Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get 
the number of lru pages")
   Cc: stable@vger.kernel.org

tags?  That would make the stable trees pick up the whole series
together, but since patch 3 only recovers the overhead of patch 1 and
fixes no bug by itself, a Fixes: tag on it may look odd.  Please let
me know your preference.

Best,
Hui


