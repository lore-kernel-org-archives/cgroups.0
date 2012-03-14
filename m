From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 7/8] memcg: move HugeTLB resource count to parent cgroup on memcg removal
Date: Wed, 14 Mar 2012 17:52:28 +0530
Message-ID: <87ipi78j97.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313144705.020b6dde.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120313144705.020b6dde.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, 13 Mar 2012 14:47:05 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 12:37:11 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This add support for memcg removal with HugeTLB resource usage.
> > 
> > ...
> >
> > +int hugetlb_force_memcg_empty(struct cgroup *cgroup)
> 
> It's useful to document things, you know.  For a major function like
> this, a nice little description of why it exists, what its role is,
> etc.  Programming is not just an act of telling a computer what to do:
> it is also an act of telling other programmers what you wished the
> computer to do.  Both are important, and the latter deserves care.
> 


Will do.

> > +{
> > +	struct hstate *h;
> > +	struct page *page;
> > +	int ret = 0, idx = 0;
> > +
> > +	do {
> > +		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> > +			goto out;
> > +		if (signal_pending(current)) {
> > +			ret = -EINTR;
> > +			goto out;
> > +		}
> 
> Why is its behaviour altered by signal_pending()?  This seems broken.

If the task that is doing a cgroup_rmdir got a signal we don't really
need to loop till the hugetlb resource usage become zero. 


> 
> > +		for_each_hstate(h) {
> > +			spin_lock(&hugetlb_lock);
> > +			list_for_each_entry(page, &h->hugepage_activelist, lru) {
> > +				ret = mem_cgroup_move_hugetlb_parent(idx, cgroup, page);
> > +				if (ret) {
> > +					spin_unlock(&hugetlb_lock);
> > +					goto out;
> > +				}
> > +			}
> > +			spin_unlock(&hugetlb_lock);
> > +			idx++;
> > +		}
> > +		cond_resched();
> > +	} while (mem_cgroup_hugetlb_usage(cgroup) > 0);
> > +out:
> > +	return ret;
> > +}

-aneesh
