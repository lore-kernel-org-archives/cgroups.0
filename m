Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFABA38B14B
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 19:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006082; cv=none; b=IeMG+nRuiwwmc/CZDvDBb1AIBNQzJS0tRTtJa4Bdf/s3A2u5tWTyFBA2Og57oo7jWSsqSi+g1+Yx75/LLAtuKyowP+TSIZeHOhmzMOfLF9AF6XpZXQQ2Ju/Oe44jg3jzKpSYFXd84CUmiEM9ED54OLuFJJj/27eQ+UZ+ZafMDrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006082; c=relaxed/simple;
	bh=U+T8zcNui896RuKy/9PmUhVVMHFkbK+hoFwjEBuIhlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b86qZhUrfq56aeTc+pfNlZxbrPE3FtlFK0STpKIa145M5AluHNOBWZbbbu67qNNFOcRpdy408mZ6kWxIphS8C2hmuCxkIUIoG39aqreC6jrWFOD99XsZlHw8vO4IAAO1CI6XtZnw9LbeX+HcCSTyKIRsOTJkAVqfFGNRYne7uYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e5mc20eq; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e5mc20eq"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so41078595e9.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 12:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792006079; x=1792610879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=79ZQLVF6/awVfagux6X340wRycgEHKIlZJR5+alEZXw=;
        b=e5mc20eqsiJhW1Nig3xUs4wAUeT20jkdeEW8NQn/lP5yHP8v+zBP9WX9cHjaztYOjZ
         xN8xODAVg8a5MAs/anBJ/zbrwMc1jkJilScp5nsCPD/mKpvL9+qJGZrxTfz7bfd3g7NK
         GbqyVH0bomc+ZgmKOMkH8RSxpP6BC88e9XdghXDGU8sJZbq7hjaqnoN6IWwCtSw3QkD6
         cOQ8EqzjN+zZJPwngyGfUBhoX5PV9qLQ7fkLRA9/k9AAXlYQ8sXx6ddkyZBrV9yZASnl
         BRFc+pxMDjftdi5AJX7rhjb67fDplfbGhBI/ux9FOg4ZVzIeehEVIorQwk3DFao0qAuE
         +/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792006079; x=1792610879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=79ZQLVF6/awVfagux6X340wRycgEHKIlZJR5+alEZXw=;
        b=UrG/igwz0eyLsqTrs8rDNDj9Aw1bjsnIh7GJQaVf2rJmyqXggtz5/kGEDqnNG34EUG
         CImAip/1A1GwMe/tUe86nQdYnvBtTEBSK00X1yI230zwepACxeayvsRfToh+zK838NI9
         xB02GB3yQZAqjn9v1AgzuGAxBIZiPrqVFU87jflgPbJ3iSJ8+xU8ii+bS/gw66EP9GsC
         dlLHvgPOx1C8jrInV4yqJepZE1iVQcm8TD83yAoauPMDR1SS/ZFrNWy1nO5+NSeW//b9
         KYKr1zpch2kDl2tjL+/C8a2L2VvrgFIFQlOLtJokP4Qw8upatUn0ci6H2o7FwbzVqQLM
         6ZHg==
X-Forwarded-Encrypted: i=1; AKwUvBzTXlDqHQUe/s/w0TjicpyFk0KwIWTfkresEbynrfMT2QdR52IUR8QOD9ctq6NdkCuiLNoe3w8/@vger.kernel.org
X-Gm-Message-State: AFq9FYICa5fQHZ0FJgjuCvzvEQC3GdtB/npn8wThF9S+P44xvZHNdJmh
	4q1wDYyoAfD8FniYMUm3qcEBqc7jjCOcHAl/JGaXa4zW6L/iJakL7hSY4zPYwYbmsKM=
X-Gm-Gg: AYBFou1zOwMD2kAO1w0kDqE+ERBV66uNjtp3Urfr5JLJJxj86n8i0EFr6u8FutfO8IF
	Rqsi4gRwh1Ov6paGFwE7pEL4HTskOzoc2z7M3GzwuAaSLCVYy9owOX0MEHvmlrtQ//Cik9+eO7B
	hl1SEICblOMKJ3dy2VwbNeZc7PSPnqzQpCdq6dyT5RccbhFW/+iyZAFOq8ZatvCLBbhtq99TwPB
	51M9kDM5WFAewWaRPW/FN9O/zjCuvEFk1usVe6yFy5KC82OUxrBlWlLVLIof1D6UJg1tJZI/9Lo
	76XpCuc7vBTISyKfLix0J3AQFS+gjuFwV+pB9u4ypNnhLkt6VLtiEPJGDuSsd8xXxOm/12tks8B
	D5PMcEr2x+m0HZ6pujNAYRjgeg/YwxEb4qhRyrHyb8gv2VsOcvNnuX1qxAc0UtW39O+YAFPlFeQ
	uhVCpq4uINUxxrgYMzafjFcj1QiiTa0oP9OTz5XkWO+2hbRzfHWmks9nX7ZBmxdJ62gRPiAzBGB
	oiAS5yqe7eg
X-Received: by 2002:a05:600c:8b78:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4a18e47acf5mr381505505e9.11.1792006079203;
        Wed, 14 Oct 2026 12:27:59 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd972affsm12468825e9.2.2026.10.14.12.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:27:58 -0700 (PDT)
Date: Wed, 14 Oct 2026 21:27:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_XvRZzV6vR9dCo@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
 <as_AxtUlV8K2fkNu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as_AxtUlV8K2fkNu@linux.dev>

On Wed 14-10-26 10:55:21, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> > On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > > for example when zswap stores a page.
> > > > > 
> > > > > Without a check, the high_work worker can queue itself from its own
> > > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > > can queue another run.
> > > > 
> > > > What does that mean really? Does this delays the actual run?
> > > 
> > > It will not delay the actual charge request. This mainly means that we keep
> > > enqueing the high reclaim work even from high reclaim context and can
> > > potentially keep wasting CPU if high reclaim is not very successful.
> > 
> > Hmm, so is there any practical problem if we do that? What exactly do you
> > mean by "keep wasting CPU"?
> 
> More specifically if high_work kworker keeps enqueing high_work, most probably
> the memcg does not have reclaimable memory and keep retrying it wastes CPU.

Yes but this is not specific to PF_MEMALLOC context, or do I miss
something?
 
> > > > > Skip memory.high enforcement for charges from task context with
> > > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > > threads and remote charges. The memory is still charged. Interrupt
> > > > > charges keep their current path.
> > > > > 
> > > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > > without this check.
> > > > > 
> > > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > 
> > > > The patch itself looks OK. I am wondering whether we can unify the check
> > > > with the existing one which forces the allocation through in main
> > > > charging path.
> > > 
> > > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > > altogether.
> > 
> > Exactly. Isn't that exactl what we want to achieve here as well?
> > 
> > > Only successful charges (done_restock label) goes through
> > > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > > will still be a separate check before calling high enforcement function. I think
> > > this check is very high_work specific and better to be in the high enforcement
> > > function.
> > 
> > I meant something like the following
> 
> Oh ok this makes sense. Do you want to send a patch or should I add this in this
> series replacing the 4th patch?

Feel free to take it. I haven't even tried to compile this. Just wanted
to show what I have in mind.

-- 
Michal Hocko
SUSE Labs
