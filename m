From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V4 10/10] memcg: Add memory controller documentation for
 hugetlb management
Date: Wed, 28 Mar 2012 16:36:58 +0200
Message-ID: <20120328143658.GJ20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331919570-2264-11-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 16-03-12 23:09:30, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  Documentation/cgroups/memory.txt |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 4c95c00..d99c41b 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -43,6 +43,7 @@ Features:
>   - usage threshold notifier
>   - oom-killer disable knob and oom-notifier
>   - Root cgroup has no limit controls.
> + - resource accounting for HugeTLB pages
>  
>   Kernel memory support is work in progress, and the current version provides
>   basically functionality. (See Section 2.7)
> @@ -75,6 +76,12 @@ Brief summary of control files.
>   memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
>   memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
>  
> +
> + memory.hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
> + memory.hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
> + memory.hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
> +						  # see 5.7 for details
> +
>  1. History
>  
>  The memory controller has a long history. A request for comments for the memory
> @@ -279,6 +286,15 @@ per cgroup, instead of globally.
>  
>  * tcp memory pressure: sockets memory pressure for the tcp protocol.
>  
> +2.8 HugeTLB extension
> +
> +This extension allows to limit the HugeTLB usage per control group and
> +enforces the controller limit during page fault. Since HugeTLB doesn't
> +support page reclaim, enforcing the limit at page fault time implies that,
> +the application will get SIGBUS signal if it tries to access HugeTLB pages
> +beyond its limit. 

This is consistent with the quota so we should mention that. We should
also add a note how we interact with quotas.

Another important thing to note is that the limit/usage are
unrelated to memcg hard/soft limit/usage.

> This requires the application to know beforehand how much
> +HugeTLB pages it would require for its use.
> +
>  3. User Interface
>  
>  0. Configuration
> @@ -287,6 +303,7 @@ a. Enable CONFIG_CGROUPS
>  b. Enable CONFIG_RESOURCE_COUNTERS
>  c. Enable CONFIG_CGROUP_MEM_RES_CTLR
>  d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
> +f. Enable CONFIG_MEM_RES_CTLR_HUGETLB (to use HugeTLB extension)
>  
>  1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
>  # mount -t tmpfs none /sys/fs/cgroup
> @@ -510,6 +527,18 @@ unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
>  
>  And we have total = file + anon + unevictable.
>  
> +5.7 HugeTLB resource control files
> +For a system supporting two hugepage size (16M and 16G) the control
> +files include:
> +
> + memory.hugetlb.16GB.limit_in_bytes
> + memory.hugetlb.16GB.max_usage_in_bytes
> + memory.hugetlb.16GB.usage_in_bytes
> + memory.hugetlb.16MB.limit_in_bytes
> + memory.hugetlb.16MB.max_usage_in_bytes
> + memory.hugetlb.16MB.usage_in_bytes
> +
> +
>  6. Hierarchy support
>  
>  The memory controller supports a deep hierarchy and hierarchical accounting.
> -- 
> 1.7.9
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
