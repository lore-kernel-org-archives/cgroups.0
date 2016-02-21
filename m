From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 21 Feb 2016 09:43:01 +0200
Message-ID: <20160221074301.GK30450@leon.nu>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leon-nu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        bh=SXwZohWLGWMPXEiSYZl5AntkcTKPACujtSYJ5bidfAc=;
        b=MnbeCHWNVmXXfJP3tYmXURPPOcGi+abxeGKdGVzVdkW4TMGKNEpEzxNp2SsxOuMFrv
         4LE04TxjtSRxeiBIpXCEeyhbhZI4BDQ+Xcz4tUeA9oZD7EQthWHfSKGPmtH21nzfCkdS
         j0A7iGjQNCfL+Ed0NtWLa0AOJo0sVeUmBGaE4GCy/Gy8U7zq0hkBh9bSfOoLCQMAjv0G
         Cvj5//fDUqd078h7OuoyPYuGSwa57hfSfkrKXBCzt6VWcJdr3AIfjiWRaoG/rOebLYsV
         +/FCsdVDZiURYyokzwtF1FnFVo9qN8jQLqpnV3fFJPbORVgt+PsZKsaR6DLhiPvFiZbS
         e7wQ==
Content-Disposition: inline
In-Reply-To: <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Sat, Feb 20, 2016 at 04:30:04PM +0530, Parav Pandit wrote:
> Added rdma cgroup controller that does accounting, limit enforcement
> on rdma/IB verbs and hw resources.
> 
> Added rdma cgroup header file which defines its APIs to perform
> charing/uncharing functionality and device registration which will
> participate in controller functions of accounting and limit
> enforcements. It also define rdmacg_device structure to bind IB stack
> and RDMA cgroup controller.
> 
> RDMA resources are tracked using resource pool. Resource pool is per
> device, per cgroup entity which allows setting up accounting limits
> on per device basis.
> 
> Resources are not defined by the RDMA cgroup, instead they are defined
> by the external module IB stack. This allows extending IB stack
> without changing kernel, as IB stack is going through changes
> and enhancements.
> 
> Resource pool is created/destroyed dynamically whenever
> charging/uncharging occurs respectively and whenever user
> configuration is done. Its a tradeoff of memory vs little more code
> space that creates resource pool whenever necessary,
> instead of creating them during cgroup creation and device registration
> time.
> 
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
> ---
>  include/linux/cgroup_rdma.h   |  53 +++
>  include/linux/cgroup_subsys.h |   4 +
>  init/Kconfig                  |  10 +
>  kernel/Makefile               |   1 +
>  kernel/cgroup_rdma.c          | 753 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 821 insertions(+)
>  create mode 100644 include/linux/cgroup_rdma.h
>  create mode 100644 kernel/cgroup_rdma.c
> 
> diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
> new file mode 100644
> index 0000000..b370733
> --- /dev/null
> +++ b/include/linux/cgroup_rdma.h
> @@ -0,0 +1,53 @@
> +#ifndef _CGROUP_RDMA_H
> +#define _CGROUP_RDMA_H
> +
> +#include <linux/cgroup.h>
> +
> +struct rdma_cgroup {
> +#ifdef CONFIG_CGROUP_RDMA
> +	struct cgroup_subsys_state	css;
> +
> +	spinlock_t rpool_list_lock;	/* protects resource pool list */
> +	struct list_head rpool_head;	/* head to keep track of all resource
> +					 * pools that belongs to this cgroup.
> +					 */
> +#endif
> +};
> +
> +#ifdef CONFIG_CGROUP_RDMA

I'm sure that you already asked about that, but why do you need ifdef
embedded in struct rdma_cgroup and right after that the same one?
Can you place this ifdef before declaring struct rdma_cgroup?

> +
> +struct rdmacg_device;
> +

Thanks
