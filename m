From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V9 04/15] hugetlb: use mmu_gather instead of a temporary
 linked list for accumulating pages
Date: Wed, 13 Jun 2012 17:03:38 +0200
Message-ID: <20120613150338.GB14777@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339583254-895-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120613145923.GA14777@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120613145923.GA14777-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-06-12 16:59:23, Michal Hocko wrote:
> On Wed 13-06-12 15:57:23, Aneesh Kumar K.V wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > 
> > Use a mmu_gather instead of a temporary linked list for accumulating
> > pages when we unmap a hugepage range
> 
> Sorry for coming up with the comment that late but you owe us an
> explanation _why_ you are doing this.
> 
> I assume that this fixes a real problem when we take i_mmap_mutex
> already up in 
> unmap_mapping_range
>   mutex_lock(&mapping->i_mmap_mutex);
>   unmap_mapping_range_tree | unmap_mapping_range_list 
>     unmap_mapping_range_vma
>       zap_page_range_single
>         unmap_single_vma
> 	  unmap_hugepage_range
> 	    mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
> 
> And that this should have been marked for stable as well (I haven't
> checked when this has been introduced).
> 
> But then I do not see how this help when you still do this:
> [...]
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 1b7dc66..545e18a 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1326,8 +1326,11 @@ static void unmap_single_vma(struct mmu_gather *tlb,
> >  			 * Since no pte has actually been setup, it is
> >  			 * safe to do nothing in this case.
> >  			 */
> > -			if (vma->vm_file)
> > -				unmap_hugepage_range(vma, start, end, NULL);
> > +			if (vma->vm_file) {
> > +				mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
> > +				__unmap_hugepage_range(tlb, vma, start, end, NULL);
> > +				mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
> > +			}
> >  		} else
> >  			unmap_page_range(tlb, vma, start, end, details);
> >  	}

Ahhh, you are removing the lock in the next patch. Really confusing and
not nice for the stable backport.
Could you merge those two patches and add Cc: stable? 
Then you can add my
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
