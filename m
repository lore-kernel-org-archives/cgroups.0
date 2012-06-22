From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Date: Fri, 22 Jun 2012 15:11:21 -0700
Message-ID: <20120622151121.917178eb.akpm@linux-foundation.org>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4FD9A79D.9030303@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FD9A79D.9030303@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Thu, 14 Jun 2012 16:58:05 +0800
Li Zefan <lizefan@huawei.com> wrote:

> > +int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
> 
> > +				 struct hugetlb_cgroup **ptr)
> > +{
> > +	int ret = 0;
> > +	struct res_counter *fail_res;
> > +	struct hugetlb_cgroup *h_cg = NULL;
> > +	unsigned long csize = nr_pages * PAGE_SIZE;
> > +
> > +	if (hugetlb_cgroup_disabled())
> > +		goto done;
> > +	/*
> > +	 * We don't charge any cgroup if the compound page have less
> > +	 * than 3 pages.
> > +	 */
> > +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> > +		goto done;
> > +again:
> > +	rcu_read_lock();
> > +	h_cg = hugetlb_cgroup_from_task(current);
> > +	if (!h_cg)
> 
> 
> In no circumstances should h_cg be NULL.
> 

Aneesh?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
