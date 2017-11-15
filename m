From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Wed, 15 Nov 2017 07:15:08 -0500
Message-ID: <20171115121508.GA2501@cmpxchg.org>
References: <20171114172429.8916-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lK8l8ZpLYLx41ye05YuPOxg7HQJuq6p/1ODCN4zbpEA=; b=Oc7+Xc54mrqKsfZNEGlcxbUlzY
	aNqERTby5FSL/Q1KhoKlRQU827QOWByhY+w0s5QoAiF4JpRoo641QTdV18Ujnw3wpQQSO3KqaVdqd
	uFQD4o+bF58tEg+1XEHI5+bv2tedgoAFwy7g6kfYL6e1Rcn06qGmDh4Cj+bFdCAVJtnI=;
Content-Disposition: inline
In-Reply-To: <20171114172429.8916-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 14, 2017 at 05:24:29PM +0000, Roman Gushchin wrote:
> This patch implements basic accounting of memory consumption
> by hugetlbfs pages for cgroup v2 memory controller.
> 
> Cgroup v2 memory controller lacks any visibility into the
> hugetlbfs memory consumption. Cgroup v1 implemented a separate
> hugetlbfs controller, which provided such stats, and also
> provided some control abilities. Although porting of the
> hugetlbfs controller to cgroup v2 is arguable a good idea and
> is outside of scope of this patch, it's very useful to have
> basic stats provided by memory.stat.
> 
> As hugetlbfs memory can easily represent a big portion of total
> memory, it's important to understand who (which memcg/container)
> is using it.

I'm not really buying this argument.

Hugetlb setups tend to be static configurations that require intimate
coordination between booting the kernel with a hugetlb reservation and
precisely setting up the application(s).

In the few cases where you need introspection, you can check the the
HugetlbPages entry in /proc/<pid>/status. The minor convenience
provided by adding an aggregate cgroup counter IMO doesn't outweigh
the weirdness of listing a type of resource in memory.stat that isn't
otherwise acknowledged or controllable as memory.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
