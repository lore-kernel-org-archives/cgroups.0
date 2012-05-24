From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 03/14] hugetlbfs: Add an inline helper for finding
 hstate index
Date: Thu, 24 May 2012 14:22:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205241420410.24113@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=XFifqI4aD2rVmxoRNoAD+fiFjLAlJ9g1jLCTfUYHcVU=;
        b=Jq/esdn9pU1SmnIbP7eDK5Dc5jYUhdLLXsDW+QD25v26ZYS9EnAP8G8JdU3AZzXxfi
         WNT0uPiVMljYfscnsGief0MGAcW3S8yL4DOifmuMWgcNxWeOsY4rsvEOxD2bto54II87
         uvZUYD6XprJzY5jrtHcN4U6ZnxFXG8kpOcwDXTMB3aqTna3xOUZT2cwKFsir1+XPdAat
         Xy5M88e52yO2n6k7ztr3fw0Y7rQVz/QB/OYwUmYqXHGH7tv4NzTuG/mJlb46wzlz1tc1
         UcauZPacO73W0otbkgsTQjzCcS4Y2BynRS4wwDcXxe4ybDjFUke2+2vG+tGArBVrivoS
         SXcw==
In-Reply-To: <1334573091-18602-4-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Add an inline helper and use it in the code.
> 
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

I like the helper function, but you missed using it in 
hugetlb_init().
