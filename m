From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 06/14] hugetlb: Simplify migrate_huge_page
Date: Thu, 24 May 2012 14:35:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205241432290.24113@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=rg/xYh+3rG+QCCuiga1DmjhTH5B4KgI/F8CvRcXvPjM=;
        b=WS3fChZXcXMjlDXW7dA3//CI5Mf2Lq+tHUMjKCtfgQGKf8I3gBUgPDIzKWa5F4oviu
         r0YPTCsXtCuLa7Yrum7WlUo24b6Wh50Tr5OMrkhHFQvmOStn03hfsDRfu/mg0BOwPdjE
         ZDxGHkjpMvy4ggPB7VxVvI+3Hvz+LeoTqfmsmD+W5M27s0QcweQtCVuYXqjMAD84d6k5
         rxBskovR93L5Sdyjc5IKZ7LzpdyN2A7VEMUO0nq+w8XrFNsSTiHXQyUUHLWKZvrz3R+S
         lfwec4at/tMiLjY2lRxVUwkGTKNqNZ1mD2hP5hZ1fDUKG1g17Yc190vNPCoSF0hDlu39
         2bVg==
In-Reply-To: <1334573091-18602-7-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 97cc273..1f092db 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1414,7 +1414,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	int ret;
>  	unsigned long pfn = page_to_pfn(page);
>  	struct page *hpage = compound_head(page);
> -	LIST_HEAD(pagelist);
>  
>  	ret = get_any_page(page, pfn, flags);
>  	if (ret < 0)
> @@ -1429,19 +1428,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	}
>  
>  	/* Keep page count to indicate a given hugepage is isolated. */
> -
> -	list_add(&hpage->lru, &pagelist);
> -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
> -				true);
> +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);

Was this tested?  Shouldn't this be migrate_huge_page(compound_head(page), 
...)?
