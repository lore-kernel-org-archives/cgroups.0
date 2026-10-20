Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792517465;
	b=Q4mM2irgbiNRIBbPIDyqVvKBVnU1DT9MIEwSj3NhqDh7wQ9B5tj1et2rXzs+Cw16tyzB
	 ITKHv+d+xz3fq82Dt2P2VuxkfQpol2p9/U05tU7Ql7KjTBi4qzUTf8tsAMfGgoG0ZM6qR
	 xf4nF+JOheom3EMk5biQ6hCFNgKowgAc5MgKZSaRrbaKtQg/Yu9bqkkG+t+l7YZkio22W
	 DcGcibTFNwPb+xBWBN9WwWA+WAERgmLHQltDveSne1TqvfUxSFFYevDnyyxr8zORGgGQ5
	 9mrUlAZ66q2E2UvrA5ElHMX/YZJ8yQnfO2jbVFQ81tTFprtClIjegYuYMRJ6VxCS+Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792517465;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=j+gbm0Z15tp8VKniuyUyyrqMzdRSHHdEh41Xgir5bIc=;
	b=Q7YUgUrzKmOUyT65fUkz0/Xb/YWwkWk6coBbnM8bt+hVVBFsK3p/wqvx/AWNZ05FNg6g
	 bmRIMyKfQwYS2LXtiR2aNz+Hxuro5+Mjgn8j3wCfqG2oi66rq9BV4BbXrpZ6nLyW/aAVi
	 8EhZcxI5isVTBgYfjN9ECQjvgwsHwL1sze83tGEGTHD82CXtr6y6mMdAJuwvuQIG3UWFz
	 FBHyF+XqozXKHn9VO1QEFIAqs8iRf7pW99+421piROvAo3lh2O/1yoN6EI0qX5kXYsRY8
	 21kHy4vQbrv9nswN2BRhY/srDXpZLGfP3VTwvxGS+0Ee5XpQhhWXQ44QVelprMiZq9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="M2ANc/UE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B56606A32E;
	Tue, 20 Oct 2026 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M2ANc/UE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC97E1F000C9;
	Tue, 20 Oct 2026 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792517464;
	bh=j+gbm0Z15tp8VKniuyUyyrqMzdRSHHdEh41Xgir5bIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M2ANc/UEwP+2XoIwwV7civxb/e+s55KN4SazeS3hJt7uXujlnErwVMFFF7GG0xfkU
	 pNOkQVehGnI9FjPiObPRMlruDigQp2Mlh7g3ZLbaDjE3SMSDzzvMGSRCInsf3nDc7v
	 3RIFNVjJVJwqb3nKKb6Xb7IH2DPm9Uz7GJ2vtYmg=
Date: Tue, 20 Oct 2026 10:30:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_cgroup: prevent use-after-free during cgroup
 offlining
Message-Id: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
In-Reply-To: <20261020100345.1677643-1-4ncienth@gmail.com>
References: <20261020100345.1677643-1-4ncienth@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Oct 2026 19:03:45 +0900 Daehyeon Ko <4ncienth@gmail.com> wrote:

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
> with 1,075,055 successful faults and 2,000 controller-disable rounds with
> 1,707,348 successful faults completed without KASAN, LOCKDEP, page-counter,
> or refcount reports.
> 
> AI-assisted source review was used to identify the race and to help draft
> the reproducer and fix.  The interleaving and the resulting allocation,
> free, and use-after-free stacks were verified with tracefs and KASAN.

Thanks.  I ran this through my evolving reviewbot.  It liked the change
and agreed with it.

One claim:

>
> ...
>
> @@ -419,15 +438,17 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  					     struct hugetlb_cgroup *h_cg,
>  					     bool rsvd)
>  {
> -	if (hugetlb_cgroup_disabled() || !h_cg)
> +	if (!h_cg)
>  		return;
>  
> -	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
> -								   rsvd),
> -			      nr_pages);
> +	if (!hugetlb_cgroup_disabled()) {

This test is unnecessary.  Once h_cg is non-NULL, a successful charge
necessarily came from an enabled controller, and cgroup_disable= is a
boot-time static-key setting.  Please just unconditionally call
page_counter_uncharge() after the existing !h_cg check, followed by
css_put().

> +		struct page_counter *counter;
>  
> -	if (rsvd)
> -		css_put(&h_cg->css);
> +		counter = __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd);
> +		page_counter_uncharge(counter, nr_pages);
> +	}
> +
> +	css_put(&h_cg->css);
>  }
>  
>  void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
