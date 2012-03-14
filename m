From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
Date: Wed, 14 Mar 2012 16:11:58 +0530
Message-ID: <87ty1r8nwp.fsf@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F5F4C48.8050001@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5F4C48.8050001-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 13 Mar 2012 17:31:52 +0400, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8cac77b..f4aa11c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2901,6 +2901,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
> >
> >   	if (PageSwapCache(page))
> >   		return NULL;
> > +	/*
> > +	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
> > +	 */
> > +	if (PageHuge(page))
> > +		return NULL;
> 
> Maybe it is better to call uncharge_common from the compound destructor,
> so we can have all the uncharge code in a single place.
> 

PageHuge is not represented by a page flags as SwapCache. Hence I was
not able to call uncharge_common from compound destructor. For
SwapCache, we clear the flag and call uncharge_common again. Also I will
have to update those functions to take the resource counter index as
argument so that we end up updated the right resource counter in the
counter array. That would result in more code changes and I was not sure
about that.

-aneesh
