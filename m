Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7D122CBE6;
	Sat,  5 Sep 2026 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788652189; cv=none; b=Uqg2j54xNPaVYUEQX2UCbSHuwM1DH9lhzxkQIFIPbFGePqG2phfAOxIh1xYWHbzU18bcCoJrXJo4oTNsdnRGAWRdl6Gos1zD45CGU3eBeMlK3xKrMjRLKVxUIangW/WNWzMKEK5VdwscYXQczuWnkqg40oFqepH+lpqnu9cRy6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788652189; c=relaxed/simple;
	bh=d/2VaAqpPElytI46bHNxq0Hr75t6ZFPXI+1aOnFseGU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XQLfRdmKM+nK+iA2ehnzR+OCPYz3ikeBzQW/A97sRcSpENAyTdMneXy2RyBMmToucxSKuo0b7kF5xZwQLHFFoNmTEpJa0CgI6G3IddlS6QNUBdOdOqp9T5f2+nu5l/Z+QvywwOdVtUwz270U6Jbt5hXPXQ5wvBS1Zfbp1i16Zr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W4Q8SsX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W4Q8SsX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0744E1F00A3A;
	Sat,  5 Sep 2026 23:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788652187;
	bh=p14q8RLb24PxaMUYcK7wccluqPq4Jq34o6+JYyS8wt0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W4Q8SsX0rX3ZIF72rGvSAwiSKnpfIGVQQvms336X/+gNpc4Mp7DVvMswijn/SoNTW
	 g8TmYkJzVCGpYbORmVgzL9oCzgB+fKi0WXJigxzSF+8rIcPXYcvcixX2TvW3yfI1IT
	 mixVVFWqFWGf7wp8It8g5Q2fKu1lijAYbSbgESgI=
Date: Sat, 5 Sep 2026 16:49:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-Id: <20260905164946.ff22c7cf24445057dadc89a6@linux-foundation.org>
In-Reply-To: <20260904173145.2028377-1-stevensd@google.com>
References: <20260904173145.2028377-1-stevensd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Sep 2026 10:31:45 -0700 David Stevens <stevensd@google.com> wrote:

> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")

Thanks.

To fill in the desirable statement of user impact, I pasted this from
the v1 thread:

: Found this via code inspection.  I spent a little bit trying to trigger it
: for real, but the only way I managed was by writing a hacky driver absuing
: alloc_pages_nolock().


