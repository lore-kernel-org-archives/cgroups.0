From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -V3 2/8] memcg: Add HugeTLB extension
Date: Wed, 14 Mar 2012 16:43:34 -0700
Message-ID: <20120314164334.5e35f3b6.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120313143316.0ef74d0e.akpm@linux-foundation.org>
	<87zkbj8ou9.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zkbj8ou9.fsf-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 14 Mar 2012 15:51:50 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> On Tue, 13 Mar 2012 14:33:16 -0700, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > On Tue, 13 Mar 2012 12:37:06 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > 
> > > +static int mem_cgroup_hugetlb_usage(struct mem_cgroup *memcg)
> > > +{
> > > +	int idx;
> > > +	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
> > > +		if (memcg->hugepage[idx].usage > 0)
> > > +			return memcg->hugepage[idx].usage;
> > > +	}
> > > +	return 0;
> > > +}
> > 
> > Please document the function?  Had you done this, I might have been
> > able to work out why the function bales out on the first used hugepage
> > size, but I can't :(
> 
> I guess the function is named wrongly. I will rename it to
> mem_cgroup_have_hugetlb_usage() in the next iteration ? The function
> will return (bool) 1 if it has any hugetlb resource usage.
> 
> > 
> > This could have used for_each_hstate(), had that macro been better
> > designed (or updated).
> > 
> 
> Can you explain this ?. for_each_hstate allows to iterate over
> different hstates. But here we need to look at different hugepage
> rescounter in memcg. I can still use for_each_hstate() and find the
> hstate index (h - hstates) and use that to index memcg rescounter
> array. But that would make it more complex ?

If the for_each_hstate() macro took an additional arg which holds the
base address of the array, that macro could have been used here.

Or perhaps not - I didn't look too closely ;)  It isn't important.
