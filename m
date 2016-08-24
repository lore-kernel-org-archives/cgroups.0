From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv11 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 24 Aug 2016 17:17:47 -0400
Message-ID: <20160824211747.GV8185@htj.duckdns.org>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FlLrEdai+97r1gcNvkzKQ5E6UNNyf3Y+TSp2viMT6LI=;
        b=W+ZAE2eIWKgTbHDW5t6tmU8bkc7lqTo5g559AoqTj5d1SA9Pp7LWJB6sNZKBPLEUxP
         SqG8+XZjA1eBwMMzVG762rXEpSE5uYlftXm5KoRt+tNAk1Kx1M9Y0NIgox1HKfAnf3h0
         Ge6VoEB5Z+2exmUVzTI6m+TNp8pw/Y7VsZlkZ72WqLiUp1Nc3LdKevjXOJMYvsRiXqR8
         mY5hojRyIGbT7SYw1rT56LR1++qNxBWN/uNkMSlOpL1yA5oY1C/s2JeLGteTlZGjqEDL
         P+d3rNSg3qwZ0o1izHbdCaIcu5UHBsijT+uywfNvb40gMf+p9Locw/WZ2dcBKDrLRa5I
         pNwQ==
Content-Disposition: inline
In-Reply-To: <1471869231-15576-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org

(cc'ing Christoph)

On Mon, Aug 22, 2016 at 06:03:48PM +0530, Parav Pandit wrote:
> rdmacg: IB/core: rdma controller support
> 
> Patch is generated and tested against below Doug's linux-rdma
> git tree.
> 
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> Branch: master
> 
> Patchset is also compiled and tested against below Tejun's cgroup tree
> using cgroup v2 mode.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> Branch: master
> 
> Overview:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources. This results into service unavailibility.
> 
> RDMA cgroup addresses this issue by allowing resource accounting,
> limit enforcement on per cgroup, per rdma device basis.
> 
> RDMA uverbs layer will enforce limits on well defined RDMA verb
> resources without any HCA vendor device driver involvement.
> 
> RDMA uverbs layer will not do limit enforcement of HCA hw vendor
> specific resources. Instead rdma cgroup provides set of APIs
> through which vendor specific drivers can do resource accounting
> by making use of rdma cgroup.
> 
> Resource limit enforcement is hierarchical.
> 
> When process is migrated with active RDMA resources, rdma cgroup
> continues to uncharge original cgroup for allocated resource. New resource
> is charged to current process's cgroup, which means if the process is
> migrated with active resources, for new resources it will be charged to
> new cgroup and old resources will be correctly uncharged from old cgroup.
> 
> Changes from v10:
>   * (To address comments from Tejun, Christoph)
>    1. Removed unused rpool_list_lock from rdma_cgroup structure.
>    2. Moved rdma resource definition to rdma cgroup instead of IB stack
>    3. Added prefix rdmacg to static instances
>    4. Simplified locking with single mutex for all operations
>    5. Following approach of atomically allocating object and
>       charging resource in hirerchy
>    6. Code simplification due to single lock
>    7. Using for_each_set_bit API for bit operation
>    8. Renamed list heads as Objects instead of _head
>    9. Renamed list entries as _node instead of _list.
>   10. Made usage_num to 64 bit to avoid overflow and to avoid 
>       additional code to track non zero number of usage counts.
>   * (To address comments from Doug)
>    1. Added copyright and GPLv2 license

Looks good to me.  I just have a nit in the documentation.  Christoph,
what do you think?

Thanks.

-- 
tejun
