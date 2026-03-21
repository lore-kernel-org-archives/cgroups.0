Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B4C275B03;
	Sat, 21 Mar 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774117350; cv=none; b=saIYsxmuLnDY6t8N+X6j2bCGMkv7mZijSiT93lLu7Qg7DrdXnsYSs6BNdKp/j92gtZCf3GMkj03PVEhnbhC0rLtcKZ+zOQTwrGwOlS6EZ1z7bbv8faszakWhlaQ+5r+h+AubnJXNa9k3W0FZ4SDFaTWiSlKSa4OpYOedpXc93IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774117350; c=relaxed/simple;
	bh=Z5ShjZezr9g7HSBWIB7EdDeQzkiOkItYLDWdO/0hqwg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=eQkUZHXA7Ij+NF04rSQnIv3NWKZM1UyyGbM6KArXdHgcdaz5xiRjK4j3iJzstWWdjLxuCt78Ub5XgbiWKJ/S+qNDV5f5+c5dAFsX6XRRcyLUfxwUCuc05a3lP4WfBpaT/+tZCk968wD0vzWa4d3ACaps66ahLRfOFP6L/W1oie0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHnQ6lEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHnQ6lEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F66DC19421;
	Sat, 21 Mar 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774117349;
	bh=Z5ShjZezr9g7HSBWIB7EdDeQzkiOkItYLDWdO/0hqwg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZHnQ6lEE88xOYc1iWlfVdzE5iZN8nimxIF52Ss4eTF1z+Nyp+L28Ma1fB9cqmr3uJ
	 yzQG5uqOcJBToMwnI6OwsOuyqtwCjFvOO0UEqyuFC7carzJi376cVWa4tdboRarVLo
	 ITCBnvYm+w+9Qx3q3fVDKpfDkqYqP/1uCASrkDmY=
Date: Sat, 21 Mar 2026 11:22:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org,
 chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
 lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mhocko@suse.com,
 muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org,
 peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de,
 rafael@kernel.org, rakie.kim@sk.com, roman.gushchin@linux.dev,
 rppt@kernel.org, ryan.roberts@arm.com, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
 vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
 yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com,
 ziy@nvidia.com, kernel-team@meta.com, riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-Id: <20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Mar 2026 12:27:14 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> This patch series implements the virtual swap space idea, based on Yosry's
> proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> inputs from Johannes Weiner. The same idea (with different
> implementation details) has been floated by Rik van Riel since at least
> 2011 (see [8]).

AI review got partway through then decided it couldn't apply patches.  So
a partial result: https://sashiko.dev/#/patchset/20260320192735.748051-1-nphamcs@gmail.com
