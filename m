Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792501298;
	b=HmKSo1ZN4utpiGkBoAuUyfrETh2JFl85+Msr4cAIIPDGma7DV1DERT3KiHKr48FW+2VX
	 2QVQ/Nyu8AN5GnAACvJ7MXqiJS7hnQzvJkFGmVhnddcz/Sdrl9kYcelFYtPd5ubOe1wEt
	 rJ/tVD4CEUbYt6Kqumo+0IStT4i2wqZUbX6fJZzKG7r/aL8wG9jldTHxMAy4+sCyz5MM1
	 wQ6AJ8knUxDCtO87+Bmz/8AiEGioam69W8EhgVPP0jondLQaj9+hTyLxi+/ASsJ3T7KAW
	 WZLdw+OcDPlo9aFFRZjVIV3pnxqe6FaWxnKW/8134Qq2d/ZNGveWEasTm+OfqEfPNSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792501298;
	h=DMARC-Filter:DKIM-Signature:References:X-Original-From:In-Reply-To:
	 To:From:Message-Id:Mime-Version:Cc:Subject:User-Agent:Date:
	 Content-Transfer-Encoding:Content-Type:X-Lms-Return-Path;
	bh=YWKyDgPAMwPA3qrc0lPHDPftrnHIF8SWtFJgxMOACtU=;
	b=Mdg+wVsbkP9CR9RjCuRlrI8Z44gzN1gZaVn0cxBctdyFCOsrRzbew4KS91u54q/XKY2P
	 lz/jD7MnelQbyucoYcnvNy3ZOKNYCHTZRxEIsUa0tWha8XIrPi03/ODOZ/VRdYKJyClAK
	 9wVvGsSByCAclyvXgk+VIXZnMpQJ9SYc84UrWeDX+Lja6qiJWBzUBPW7LfvHnchlX2Amx
	 aqIbP4exj30r4M/4/5SF30goTLWjC8H2Yig2zVap5Kpdy3aTAw/4vVIVz6bERGy4D5TY7
	 vY6/z30OwfMT9U02pMhNV09XR79MMPrA+cAHQEO5jmB7jPvrknMiWpDPVGL7xfGGw4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bwugqmLO;
	arc=none smtp.remote-ip=209.127.230.113
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB56606A323
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 13:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDB56606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bwugqmLO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792501290; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YWKyDgPAMwPA3qrc0lPHDPftrnHIF8SWtFJgxMOACtU=;
 b=bwugqmLOLdiFHmYmSEl6RQMWsQ4Mr9t+ZBHggzzq4k9/88vKu9+6LX3K7gsS6KLSnJ4ZBl
 pv3m/P3pjdhySwAbenbLDzpgGw6tbp5VAIlL0YQGYuWsVpzkm/es4MExa08lhDlnUFUSZ7
 TnEKNU9UVPt2nB3zM8nHvVk2EuiQz2gyPGNeWXgmUdXFkmpurAyKkzlIQTMPucvmgErpww
 OHLNfP7JyhZHGzDu6qzOUUNtXWHTdO/DbvBb4MSM6ouE8Egh7xcpneypxWNsjGNiFztVvi
 avxVbeN7qsjXeew3+hlYAHUSuBrJ8ib3RLHS1C5Qwy1GalLfhyryjJNbbo9nMw==
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
To: "Gregory Price" <gourry@gourry.net>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
User-Agent: Mozilla Thunderbird
Date: Tue, 20 Oct 2026 21:01:03 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26ad76628+84a851+vger.kernel.org+lizhe.67@bytedance.com>

On 10/20/26 12:10 AM, Gregory Price wrote:
> On Mon, Oct 19, 2026 at 10:13:59PM +0800, Li Zhe wrote:
>> memory.reclaim is a useful proactive reclaim interface for memcgs, but
>> tiered memory makes "reclaim N bytes from this memcg" underspecified for
>> userspace controllers that manage memory placement across tiers. The
>> kernel's reclaim policy is aging-based, and on tiered systems aging may
>> demote folios before they are eventually evicted. Without a way to
>> declare where reclaim pressure should start, userspace can only reclaim
>> from the memcg as a whole and observe one aggregate progress value.
> This is not a good argument for pushing the complexity of managing tiers
> into userspace - it is an argument for fixing the reclaim interface to
> handle demotion and eviction sanely - which presently we do not do.
>
> My best examples:
>    1) the watermarks don't make sense for lower tiers that need to absorb
>       large amounts of demotions from upper tiers.  It's likely lower
>       tiers need larger WMARK_PROMO to let low-tier kswapd run longer.
>
>    2) proactive and async reclaim current reclaim top-down, which results
>       in swapping directly from top-tiers because lower tiers don't have
>       space to absorb demotions.  We should experiment with async /
>       proactive reclaim applying bottom-up (lowest tier first) so aging
>       the top-tiers demotes into lower tiers more successfully.
>
>       direct reclaim should stay top-down because we want the best page
>       with the least work to minimize stalls.
>
> I have a strong suspicion if we made these change, then memcg.reclaim
> would work more or less the way you'd want - and anything else can be
> managed more directly with madvise/process_madvise.
>
> I also have concerns with extending memory.reclaim this way permanently
> locking in reclaim implementation details that prevent us from making
> changes like this in the future.
>
> ~Gregory


Thanks for the feedback.

I agree that the kernel reclaim and demotion behavior still has room for
improvement, and the watermark changes and the bottom-up proactive/async
reclaim idea you mentioned may be useful to explore for some tiering
scenarios. But I think there is also an unavoidable userspace policy
component here. The kernel can improve whole-cgroup reclaim, but it
cannot know every controller's placement goal.

For example, one controller may want to keep a specific per-tier
resident ratio for a cgroup. Another use case, as Joshua pointed out in
another reply, is reclaiming from a lower tier first so that later
top-tier reclaim has room for demotion. A single default memory.reclaim
algorithm cannot express these per-cgroup policy choices.

I am not sure whether changing the default whole-cgroup reclaim behavior
in this direction could affect existing userspace dependencies. In the
old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
memory.reclaim triggering demotion [1].

I also do not intend source= to lock in current reclaim implementation
details. It should stay consistent with the current design: source= only
selects the resident source to which reclaim pressure is applied, while
the kernel remains free to change the reclaim policy.

The typed source= form also leaves room for future source selectors
without changing the meaning of source=nodes.

madvise and process_madvise are useful when userspace knows the target
virtual ranges or processes, but they are not a memcg-level interface
for applying reclaim pressure to a selected resident source.

So I tend to prefer the more conservative opt-in approach in this
patchset.

[1] https://lkml.org/lkml/2022/12/13/79

Thanks,
Zhe
