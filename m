Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929495;
	b=kSUuTCrDjAQSQ94GI+Cp/09lol+jJEIYywOvfsuIOjGWAZJNt7je6VjCOGI2zjrRRpFD
	 9WtCnSdoZwvAoTx2xSV341fVeL+DVsdgSWPtOVPYzmJinPzmaGZm2wSaqmOJQcRGbSC/r
	 4YOm8vWQxMqoP6ERUTwpBqHVbkV469hHlYihEQ3pSiYSWbKweE68hXtJUa79fLzIETlvj
	 v0I4YtqvalcMl5qxoAVUxyZC0IUBCoahAnGOZX5skLXYUnyzdj/4gBcuQnza9+9o0BmJd
	 WVVZMJGmDiO5qsyO2ywcVsm5N09NeUUenzE6CcSHrpw4AbmDWtQiwGfQnki6KBKPhAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929495;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=D1BQyEii6F0Q1y4egErAzidghcHKqUk0a8SnAS5enws=;
	b=BMH8LE+FteTnGKCuvkBTN9bi1u4oAEAOHdQX8YOmFvBJVSL+1JWnCi4Zzdf3T6x77fQo
	 kcJbXQ36+IqhebccC/quwape5e3JH+627LuP3LeybSBr+3SnP5YsK9mR8njcPsXIVhPJb
	 URzh4rOPYJK0Fi/GrPd680SFJza1V4mNkNHYjC2vPohMkfSpzju8TkZF7wTqH7E16eCUI
	 gjip7OKycUj/cSBleO6UWsEz17kv5xmvesAhxO+oT3VfUqOOuIbqJgDXsuYiFu7OEohM9
	 JXUp/qaBERPcpRJuVR/ogusP46cAowYyXNQGwtI4OZsXc4hRyEbH5oaOfhskoB2jvFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jYFWQMOg;
	arc=none smtp.remote-ip=91.218.175.86
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC0D606A31B
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 01:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDC0D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jYFWQMOg
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=h0d+yOrZ64mGc0iSYwHwgGdKZilHQ9XexIhOgkjacwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793929491; v=1; x=1794534291;
 b=jYFWQMOgfpkZ3mBb54JklcG6tzN9HnFBLmJXkcokoa2V6NhjxwFO0SANbAxuStk3vhzs13PK
 rcj/5dhCYzxFEvL1fa7/lj5SxJN4AE+F3z0hlp97Q6gr3qqzMQaGTUTTvVQLLb7g5UY7gMzKifJ
 lXdgdK5Tp3u0ic4lgbiJCIWA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ac22e0871729a49a;
	Fri, 06 Nov 2026 01:44:51 +0000
X-Mizu-Trace-ID: ac22e0871729a49a
X-Migadu-Flow: FLOW_OUT
Message-ID: <76fc7cbb-11e8-4591-bb2f-d6fb8ac1fbf3@linux.dev>
Date: Fri, 6 Nov 2026 09:44:44 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb_cgroup: prevent use-after-free during
 cgroup offlining
To: Daehyeon Ko <4ncienth@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, tj@kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, hongfu.li@linux.dev
References: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
 <20261022022146.506005-1-4ncienth@gmail.com>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20261022022146.506005-1-4ncienth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 10/22/26 10:21, Daehyeon Ko 写道:
> A normal hugetlb charge obtains the current task's hugetlb cgroup with
> css_tryget(), charges its page counter, and drops the CSS reference before
> the folio is committed under hugetlb_lock.
>
> The task can be migrated while the allocation is in progress.  If the old
> CSS is then offlined, its final active-folio scan can finish before the
> charge becomes visible.  The allocation can subsequently charge that dying
> CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
> the folio accesses the freed hugetlb_cgroup, including its page counter and
> per-node usage.
>
> Keep the reference acquired by the charge until commit or cancellation.  At
> commit time, while holding hugetlb_lock, move an uncommitted charge out of
> each dying CSS to the first live ancestor.  The hierarchical charge already
> includes every ancestor, so moving it only requires canceling each dying
> CSS's local count.
>
> This orders commit against the offline active-folio scan: either the scan
> runs after commit and reparents the folio, or commit observes the dying CSS
> after the scan and selects a live ancestor.  The retained reference also
> keeps the originally selected hugetlb_cgroup alive through this decision.
> Reservation charges retain their existing CSS lifetime and are not
> reparented.
>
> On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
> capability-free uid 1000 allocator racing administrator rmdir reproduced
> KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
> disable reproduced the same fault.  With this change, 5,000 rmdir rounds
> with over 1 million successful faults and 2,000 controller-disable rounds
> with over 1.6 million successful faults completed without KASAN, LOCKDEP,
> page-counter, or refcount reports.
>
> AI-assisted source review was used to identify the race and to help draft
> the reproducer and fix.  The interleaving and the resulting allocation,
> free, and use-after-free stacks were verified with tracefs and KASAN.
>
> Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

Hi, Daehyeon,

Would it be better to send v2 as a standalone thread rather
than as a reply to the v1 review thread? It would be easier
to track.

> ---
> V1 -> V2:
> - Remove the redundant disabled-controller check from uncharge, as requested
>    by Andrew Morton.
>
> v1: https://lore.kernel.org/r/20261020100345.1677643-1-4ncienth@gmail.com
>
>   mm/hugetlb_cgroup.c | 34 ++++++++++++++++++++++++++--------
>   1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 3fb41311e4c7dc..6921b185726662 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -310,11 +310,10 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
>   		css_put(&h_cg->css);
>   		goto done;
>   	}
> -	/* Reservations take a reference to the css because they do not get
> -	 * reparented.
> +	/*
> +	 * Hold the CSS reference until commit. Reservations keep it longer
> +	 * because they are not reparented.
>   	 */
> -	if (!rsvd)
> -		css_put(&h_cg->css);
>   done:
>   	*ptr = h_cg;
>   	return ret;
> @@ -337,9 +336,26 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>   					   struct hugetlb_cgroup *h_cg,
>   					   struct folio *folio, bool rsvd)
>   {
> +	struct hugetlb_cgroup *charged_h_cg = h_cg;
> +
>   	if (hugetlb_cgroup_disabled() || !h_cg)
> -		return;
> +		goto out;
>   	lockdep_assert_held(&hugetlb_lock);
> +
> +	/*
> +	 * A task can be migrated after selecting h_cg. Once offlining starts,
> +	 * redirect the uncommitted charge to a live ancestor. hugetlb_lock
> +	 * serializes this decision with the offline scan, which reparents
> +	 * earlier commits.
> +	 */
> +	if (!rsvd) {
> +		while (css_is_dying(&h_cg->css)) {
> +			page_counter_cancel(&h_cg->hugepage[idx], nr_pages);
> +			/* The root CSS never dies. */
> +			h_cg = parent_hugetlb_cgroup(h_cg);
> +		}
> +	}
> +
>   	__set_hugetlb_cgroup(folio, h_cg, rsvd);
>   	if (!rsvd) {
>   		unsigned long usage =
> @@ -352,6 +368,9 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
>   		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
>   			   usage + nr_pages);
>   	}
> +out:
> +	if (!rsvd && charged_h_cg)
> +		css_put(&charged_h_cg->css);
>   }
>   
>   void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> @@ -419,15 +438,14 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>   					     struct hugetlb_cgroup *h_cg,
>   					     bool rsvd)
>   {
> -	if (hugetlb_cgroup_disabled() || !h_cg)
> +	if (!h_cg)
>   		return;
>   
>   	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
>   								   rsvd),
>   			      nr_pages);
>   
> -	if (rsvd)
> -		css_put(&h_cg->css);
> +	css_put(&h_cg->css);
>   }
>   
>   void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,

-- 
Best regards,
Hongfu

