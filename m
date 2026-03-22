Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4BB37DE86;
	Sun, 22 Mar 2026 02:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774145950; cv=none; b=HMS1VxOdwKvWn6jh72x8lXGuIf+3IKoZugGF12HCQVqMYyZHwwqiNrTdr/1DCjrQPGQHgE3kP/r/Y6ma+exugcQ0ZLwjFS8tWAluvxzwY/lfYMd5W7dr61aNj8AtTDnDIMjKvAt2Qk5xuMfXya1NYooqeaKluaa6OORMOnPXmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774145950; c=relaxed/simple;
	bh=IEx9S7ZLcKuDlX914CBxQlU9Wp/ndEt6rAUfAIl2N6E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jVBTYdzOdm5OucN/bvxJpguq3B7vXJw07diUJT1OrWuPmtQjnuK+Yxe6BulBeGnrHRnLXC/KLUEVL3uD+DLiYXwT2VMOg2scytOjmRHjZ03k+Gh2nFBvK7x5yAV/+nRx192/hfRMUqSUeY+aB3aH1cI6wLpt0dut1EogSMqPT4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CT9c+ixX; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CT9c+ixX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774145945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8dSaIRMuVhMrUs54qbaoxf4Mz2+8KV+v/+TX/3wx/Lc=;
	b=CT9c+ixXjHb5VtwyDbprVHIreuwtN97fIwVMaaXEMzNpKtPYSnSY4StGDWxh6n3TH0+6xa
	VQCzOBsDue6qm2M7m6w/nHNLxpY4blLtTRnKpOhT3HVUHUHkyqKuX+Z6bo0FF4jIYysmc0
	Fovcn7H+NgcySMe8Pb1DLf8jnug9AN4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,  kasong@tencent.com,
  Liam.Howlett@oracle.com,  apopple@nvidia.com,  axelrasmussen@google.com,
  baohua@kernel.org,  baolin.wang@linux.alibaba.com,  bhe@redhat.com,
  byungchul@sk.com,  cgroups@vger.kernel.org,  chengming.zhou@linux.dev,
  chrisl@kernel.org,  corbet@lwn.net,  david@kernel.org,  dev.jain@arm.com,
  gourry@gourry.net,  hannes@cmpxchg.org,  hughd@google.com,
  jannh@google.com,  joshua.hahnjy@gmail.com,  lance.yang@linux.dev,
  lenb@kernel.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-pm@vger.kernel.org,  lorenzo.stoakes@oracle.com,
  matthew.brost@intel.com,  mhocko@suse.com,  muchun.song@linux.dev,
  npache@redhat.com,  pavel@kernel.org,  peterx@redhat.com,
  peterz@infradead.org,  pfalcato@suse.de,  rafael@kernel.org,
  rakie.kim@sk.com,  rppt@kernel.org,  ryan.roberts@arm.com,
  shakeel.butt@linux.dev,  shikemeng@huaweicloud.com,  surenb@google.com,
  tglx@kernel.org,  vbabka@suse.cz,  weixugc@google.com,
  ying.huang@linux.alibaba.com,  yosry.ahmed@linux.dev,
  yuanchu@google.com,  zhengqi.arch@bytedance.com,  ziy@nvidia.com,
  kernel-team@meta.com,  riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
In-Reply-To: <20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
	(Andrew Morton's message of "Sat, 21 Mar 2026 11:22:27 -0700")
References: <20260320192735.748051-1-nphamcs@gmail.com>
	<20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
Date: Sat, 21 Mar 2026 19:18:50 -0700
Message-ID: <87cy0wip2t.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 20 Mar 2026 12:27:14 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
>> This patch series implements the virtual swap space idea, based on Yosry's
>> proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
>> inputs from Johannes Weiner. The same idea (with different
>> implementation details) has been floated by Rik van Riel since at least
>> 2011 (see [8]).
>
> AI review got partway through then decided it couldn't apply patches.  So
> a partial result: https://sashiko.dev/#/patchset/20260320192735.748051-1-nphamcs@gmail.com

It's a bug in the error handling. I've already fixed it, but haven't
deployed the new version yet. In the reality, the review failed for some
other reason (the most popular one now is backend/llm api transient errors).

Sashiko applies the entire patchset first and if it fails, it's not
reviewing anything.
