Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A0246AEFE;
	Mon, 17 Aug 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988394; cv=none; b=RTVLxWx+DYiVMjNb6IEIR7EKn+heh0GhqIexNHYWF5sf4LTnR7a2W9aOgxXoOo2XPRhMS+Lv87bWKx8F8Zu2SMtZcFqa08luv025y3KA6pd23wI4lusxN6uFkw41oFUyLoWp54YtcC3j4izFvcx6NMjiv6V4QbUvpqgYdS2z3c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988394; c=relaxed/simple;
	bh=sZWhXmRFzc6KnyYUwUU7QSqkVs5Py0h6yaeJqxZzeYc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fIfXWLgcFkcgy82COmBdcoGBrSq6oqRem7DYx3+Q/+LcVWCtVPlN6tNOncXjmEQYGpbl2o5h3ZoNlWCq0R8RCigrXzn85TxffmqjYESF5Xczy/SINl2pv42+gJhe6atfQdmOZyXZJC+LDP17GLTLEBSUM6qaeTLsC2d0K1KY0Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uiu93YaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiu93YaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA511F000E9;
	Mon, 17 Aug 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988391;
	bh=EldLsYcfZqfCW5hxzb5tOUJDz+gGEDI1z/tkTtJs2mE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uiu93YaOjew7mOLo84HKnQddyWvyyyNomIDx6TMOcHvXfDf5Hr0qsINLC8oVt1LO9
	 +6mCdT3sP9qcuc1LI/TSrR9sIkWpI26014R49EWcYkv5XwVMOofMRo44q7f5aSQAqo
	 ZCXsJ3fyIA35kNh4on92A1QlnxIDCiB427Panfnk=
Date: Mon, 17 Aug 2026 10:39:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Narek Jilavyan <njilav@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside
 VM_BUG_ON()
Message-Id: <20260817103950.5ff58d6ebe536e6ed6e7098c@linux-foundation.org>
In-Reply-To: <20260817103433.191266-1-njilav@gmail.com>
References: <20260817103433.191266-1-njilav@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Aug 2026 10:34:33 +0000 Narek Jilavyan <njilav@gmail.com> wrote:

> hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
> the huge page size and then applies it inside an assertion:
> 
> 	VM_BUG_ON(page_counter_set_max(fault, limit));
> 	VM_BUG_ON(page_counter_set_max(rsvd, limit));
> 
> With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
> i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
> evaluated.  page_counter_set_max() is not a predicate - it performs
> xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
> never applied and the counters keep page_counter_init()'s
> PAGE_COUNTER_MAX.
> 
> That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
> the same rounded value and uses equality as its "unlimited" sentinel.
> PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
> odd, so round_down() really does change it and the two sides disagree.
> With CONFIG_DEBUG_VM=n:
> 
> 	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 	9223372036854771712
> 
> and with this patch:
> 
> 	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 	max
> 
> A debug option should not change cgroup output.
> 
> Call the function, then assert the result, as v6.12 did.  Use
> VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
> identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
> use BUG() variants.

Nice, thanks, I'll add cc:stable to this, to help ensure that users of
earlier kernels get to enjoy it.

