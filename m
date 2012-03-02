From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
Date: Fri, 2 Mar 2012 14:48:28 +0900
Message-ID: <20120302144828.e985c63a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330593380-1361-1-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu,  1 Mar 2012 14:46:11 +0530
"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> Hi,
> 
> This patchset implements a memory controller extension to control
> HugeTLB allocations. It is similar to the existing hugetlb quota
> support in that, the limit is enforced at mmap(2) time and not at
> fault time. HugeTLB's quota mechanism limits the number of huge pages
> that can allocated per superblock.
> 

Thank you, I think memcg-extension is better than hugetlbfs cgroup.


> For shared mappings we track the regions mapped by a task along with the
> memcg. We keep the memory controller charged even after the task
> that did mmap(2) exits. Uncharge happens during truncate. For Private
> mappings we charge and uncharge from the current task cgroup.
> 

What "current" means here ? current task's cgroup ?


> A sample strace output for an application doing malloc with hugectl is given
> below. libhugetlbfs will fall back to normal pagesize if the HugeTLB mmap fails.
> 
> open("/mnt/libhugetlbfs.tmp.uhLMgy", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
> unlink("/mnt/libhugetlbfs.tmp.uhLMgy")  = 0
> 
> .........
> 
> mmap(0x20000000000, 50331648, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = -1 ENOMEM (Cannot allocate memory)
> write(2, "libhugetlbfs", 12libhugetlbfs)            = 12
> write(2, ": WARNING: New heap segment map" ....
> mmap(NULL, 42008576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfff946c0000
> ....
> 
> 
> Goals:
> 
> 1) We want to keep the semantic closer to hugelb quota support. ie, we want
>    to extend quota semantics to a group of tasks. Currently hugetlb quota
>    mechanism allows one to control number of hugetlb pages allocated per
>    hugetlbfs superblock.
> 
> 2) Applications using hugetlbfs always fallback to normal page size allocation when they
>    fail to allocate huge pages. libhugetlbfs internally handles this for malloc(3). We
>    want to retain this behaviour when we enforce the controller limit. ie, when huge page
>    allocation fails due to controller limit, applications should fallback to
>    allocation using normal page size. The above implies that we need to enforce
>    limit at mmap(2).
> 

Hm, ok. 

> 3) HugeTLBfs doesn't support page reclaim. It also doesn't support write(2). Applications
>    use hugetlbfs via mmap(2) interface. Important point to note here is hugetlbfs
>    extends file size in mmap.
> 
>    With shared mappings, the file size gets extended in mmap and file will remain in hugetlbfs
>    consuming huge pages until it is truncated. We want to make sure we keep the controller
>    charged until the file is truncated. This implies, that the controller will be charged
>    even after the task that did mmap exit.
> 

O.K. hugetlbfs is charged until the file is removed.
Then, next question will be 'can we destory cgroup....'

> Implementation details:
> 
> In order to achieve the above goals we need to track the cgroup information
> along with mmap range in a charge list in inode for shared mapping and in
> vm_area_struct for private mapping. We won't be using page to track cgroup
> information because with the above goals we are not really tracking the pages used.
> 
> Since we track cgroup in charge list, if we want to remove the cgroup, we need to update
> the charge list to point to the parent cgroup. Currently we take the easy route
> and prevent a cgroup removal if it's non reclaim resource usage is non zero.
> 

As Andrew pointed out, there are some ongoing works about page-range tracking.
Please check.

Thanks,
-Kame

> Changes from V1:
> * Changed the implementation as a memcg extension. We still use
>   the same logic to track the cgroup and range.
> 
> Changes from RFC post:
> * Added support for HugeTLB cgroup hierarchy
> * Added support for task migration
> * Added documentation patch
> * Other bug fixes
> 
> -aneesh
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
