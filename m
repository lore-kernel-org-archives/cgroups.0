Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4381D5CC9;
	Tue,  1 Sep 2026 00:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220956; cv=none; b=scHXACeu7/9cQFWxpXP3pWJSvdQWCXE9hDdOdU1gVjjOJ5892tcm2COtElHOeTvYT6CRWGO8NM+xFAylot7HrmqljP8id+XMW6jIzPMye6sqCPyqhqyTc1x2YlSK980kCrtAQZHf0FneHMJu8VSD3NO+ccyMhvBZidBO32T6CiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220956; c=relaxed/simple;
	bh=TAl7fifn7t1bB9NM0Vk9R+qbwb4+eK9QhlzL2dXyQY8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=GPvbLN4bCFrCKH8TBoCQCOTn7stS+t/qe4Mz9dYsj+XSsqa/CXbAi/Yzl0Rt/QzCkjgZKU9Oo9eF8N0bUd7T4nDr9GzN30wI8b3Zlbl5ppQFhoccZWRYNQfjbSsdj/7fHUjdN0rhh63kgibkHENTLFdv7x1x0g7CorHoE8av/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZKaH01if; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZKaH01if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF9C1F000E9;
	Tue,  1 Sep 2026 00:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788220954;
	bh=eTlrpQWzxbwCPPSf4vM9BxkALA4WAiGAhLpXzsRVP00=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZKaH01ifMY4i78+8eAJ7lZTV+LQIL/XWqKn44DS2+UVEgj25WFu316wKVzIXqwzp+
	 ERdY7Kwmp8rOrSujjnTZMfaihqx/JI14pn3lMBoRB2mUgcJiPAz5BbHJZh57N1phlh
	 hKjaODtluC+q6YbbehddLGUqISmTYpG4v33r1L4E=
Date: Mon, 31 Aug 2026 17:02:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-Id: <20260831170233.e3deb2a546722a3c664bcd98@linux-foundation.org>
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>
References: <20260831234339.280376-1-stevensd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 31 Aug 2026 16:43:39 -0700 David Stevens <stevensd@google.com> wrote:

> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI.

Who does that.  bpf, IIRC?

> If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")

Can anything actually hit this?  IOW, should we backport it?

> Signed-off-by: David Stevens <stevensd@google.com>

