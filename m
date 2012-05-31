From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V7 05/14] hugetlb: avoid taking i_mmap_mutex in
 unmap_single_vma() for hugetlb
Date: Wed, 30 May 2012 18:57:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205301857170.25774@chino.kir.corp.google.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1338388739-22919-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=W3xwPet3fxrmOgxqpbYPT+yIaTYMNWe6zRzpJtsxCWE=;
        b=kjSAr7uk5FP8yEr+MXupCYkf1ClG1RcEktrg1k8TzGYmd0gDFlNGGJRb8fbBAM1bJh
         Xlbw4CUrCNffP651ztUfnUAP5gl2U3s5o0QvBeRvxSE/RrnBf7LZ0BHkGoortDDZ64ah
         VX0aslslFjyTh2BjkTfmauGB8tJz0fsYfKZYFYaWyYV8lCZoGAW3eEwYA5jmHsFkHfII
         PVMWpQbhSrEc+HBh375my+fLAgf/M23zyU5lLe5gNGDU0RX8L7BBnrV87eOVrp7T0tDf
         zJqADZW75MYq/KNhca009EXNwWuzPPDoLC80E2br0snaOX5zT5RHDTcA7/wDqQdXNNxS
         sJQg==
In-Reply-To: <1338388739-22919-6-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, 30 May 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> i_mmap_mutex lock was added in unmap_single_vma by 502717f4e ("hugetlb:
> fix linked list corruption in unmap_hugepage_range()") but we don't use
> page->lru in unmap_hugepage_range any more.  Also the lock was taken
> higher up in the stack in some code path.  That would result in deadlock.
> 
> unmap_mapping_range (i_mmap_mutex)
>  -> unmap_mapping_range_tree
>     -> unmap_mapping_range_vma
>        -> zap_page_range_single
>          -> unmap_single_vma
> 	      -> unmap_hugepage_range (i_mmap_mutex)
> 

You should be able to show this with lockdep?

> For shared pagetable support for huge pages, since pagetable pages are ref
> counted we don't need any lock during huge_pmd_unshare.  We do take
> i_mmap_mutex in huge_pmd_share while walking the vma_prio_tree in mapping.
> (39dde65c9940c97f ("shared page table for hugetlb page")).
> 

I think this should be folded into patch 4, the code you're removing here 
is just added in that function unnecessarily.
