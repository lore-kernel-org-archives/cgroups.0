From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V9 04/15] hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages
Date: Wed, 13 Jun 2012 22:07:06 +0530
Message-ID: <871uljnp71.fsf@skywalker.in.ibm.com>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339583254-895-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120613145923.GA14777@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120613145923.GA14777-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Wed 13-06-12 15:57:23, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Use a mmu_gather instead of a temporary linked list for accumulating
>> pages when we unmap a hugepage range
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

Switch to mmu_gather is to get rid of the use of page->lru so that i can use it for
active list.


-aneesh
