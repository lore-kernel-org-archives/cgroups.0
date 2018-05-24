From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Thu, 24 May 2018 10:27:29 +0200
Message-ID: <20180524082729.GX20441@dhcp22.suse.cz>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
 <20180522135148.GA20441@dhcp22.suse.cz>
 <af1a3050-7365-428a-dfb1-2f3da37dc9ff@ascade.co.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <af1a3050-7365-428a-dfb1-2f3da37dc9ff@ascade.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: TSUKADA Koutaro <tsukada@ascade.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Punit Agrawal <punit.agrawal@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu 24-05-18 13:26:12, TSUKADA Koutaro wrote:
[...]
> I do not know if it is really a strong use case, but I will explain my
> motive in detail. English is not my native language, so please pardon
> my poor English.
> 
> I am one of the developers for software that managing the resource used
> from user job at HPC-Cluster with Linux. The resource is memory mainly.
> The HPC-Cluster may be shared by multiple people and used. Therefore, the
> memory used by each user must be strictly controlled, otherwise the
> user's job will runaway, not only will it hamper the other users, it will
> crash the entire system in OOM.
> 
> Some users of HPC are very nervous about performance. Jobs are executed
> while synchronizing with MPI communication using multiple compute nodes.
> Since CPU wait time will occur when synchronizing, they want to minimize
> the variation in execution time at each node to reduce waiting times as
> much as possible. We call this variation a noise.
> 
> THP does not guarantee to use the Huge Page, but may use the normal page.
> This mechanism is one cause of variation(noise).
> 
> The users who know this mechanism will be hesitant to use THP. However,
> the users also know the benefits of the Huge Page's TLB hit rate
> performance, and the Huge Page seems to be attractive. It seems natural
> that these users are interested in HugeTLBfs, I do not know at all
> whether it is the right approach or not.

Sure, asking for guarantee makes hugetlb pages attractive. But nothing
is really for free, especially any resource _guarantee_, and you have to
pay an additional configuration price usually.
 
> At the very least, our HPC system is pursuing high versatility and we
> have to consider whether we can provide it if users want to use HugeTLBfs.
> 
> In order to use HugeTLBfs we need to create a persistent pool, but in
> our use case sharing nodes, it would be impossible to create, delete or
> resize the pool.

Why? I can see this would be quite a PITA but not really impossible.

> One of the answers I have reached is to use HugeTLBfs by overcommitting
> without creating a pool(this is the surplus hugepage).
> 
> Surplus hugepages is hugetlb page, but I think at least that consuming
> buddy pool is a decisive difference from hugetlb page of persistent pool.
> If nr_overcommit_hugepages is assumed to be infinite, allocating pages for
> surplus hugepages from buddy pool is all unlimited even if being limited
> by memcg.

Not really, you can specify how much you can overcommit hugetlb pages.

> In extreme cases, overcommitment will allow users to exhaust
> the entire memory of the system. Of course, this can be prevented by the
> hugetlb cgroup, but even if we set the limit for memcg and hugetlb cgroup
> respectively, as I asked in the first mail(set limit to 10GB), the
> control will not work.
-- 
Michal Hocko
SUSE Labs
