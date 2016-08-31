From: Matan Barak <matanb@mellanox.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 31 Aug 2016 18:07:30 +0300
Message-ID: <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MqfvD/0SpVUi4EepAsLzFQzrPWE2iyNeYsBXd5/nXw8=;
 b=urHee4UknRqH45m1MJ15uvB9zZ5+eiThA6Ktb9TPP6akCUShaztRS7V6IbG+gbbPb/+EkPxXunQgzRR0yaA5dhoW9TaOqwL8X/LVKNmzPmHL0XhK/FCGgrOZXIp7Btzerp2tYCbbeLJE8IETng3la3lcXGU3LCJ2UpCjEQdenQU=
In-Reply-To: <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 31/08/2016 11:37, Parav Pandit wrote:
> Added rdma cgroup controller that does accounting, limit enforcement
> on rdma/IB verbs and hw resources.
>
> Added rdma cgroup header file which defines its APIs to perform
> charing/uncharing functionality. It also defined APIs for RDMA/IB
> stack for device registration. Devices which are registered will
> participate in controller functions of accounting and limit
> enforcements. It define rdmacg_device structure to bind IB stack
> and RDMA cgroup controller.
>
> RDMA resources are tracked using resource pool. Resource pool is per
> device, per cgroup entity which allows setting up accounting limits
> on per device basis.
>
> Currently resources are defined by the RDMA cgroup.
>
> Resource pool is created/destroyed dynamically whenever
> charging/uncharging occurs respectively and whenever user
> configuration is done. Its a tradeoff of memory vs little more code
> space that creates resource pool object whenever necessary, instead of
> creating them during cgroup creation and device registration time.
>
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
> ---
>  include/linux/cgroup_rdma.h   |  66 +++++
>  include/linux/cgroup_subsys.h |   4 +
>  init/Kconfig                  |  10 +
>  kernel/Makefile               |   1 +
>  kernel/cgroup_rdma.c          | 664 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 745 insertions(+)
>  create mode 100644 include/linux/cgroup_rdma.h
>  create mode 100644 kernel/cgroup_rdma.c
>
> diff --git a/include/linux/cgroup_rdma.h b/include/linux/cgroup_rdma.h
> new file mode 100644
> index 0000000..6710e28
> --- /dev/null
> +++ b/include/linux/cgroup_rdma.h
> @@ -0,0 +1,66 @@
> +/*
> + * Copyright (C) 2016 Parav Pandit <pandit.parav@gmail.com>
> + *
> + * This file is subject to the terms and conditions of version 2 of the GNU
> + * General Public License. See the file COPYING in the main directory of the
> + * Linux distribution for more details.
> + */
> +
> +#ifndef _CGROUP_RDMA_H
> +#define _CGROUP_RDMA_H
> +
> +#include <linux/cgroup.h>
> +
> +enum rdmacg_resource_type {
> +	RDMACG_VERB_RESOURCE_UCTX,
> +	RDMACG_VERB_RESOURCE_AH,
> +	RDMACG_VERB_RESOURCE_PD,
> +	RDMACG_VERB_RESOURCE_CQ,
> +	RDMACG_VERB_RESOURCE_MR,
> +	RDMACG_VERB_RESOURCE_MW,
> +	RDMACG_VERB_RESOURCE_SRQ,
> +	RDMACG_VERB_RESOURCE_QP,
> +	RDMACG_VERB_RESOURCE_FLOW,
> +	/*
> +	 * add any hw specific resource here as RDMA_HW_RESOURCE_NAME
> +	 */
> +	RDMACG_RESOURCE_MAX,
> +};
> +
> +#ifdef CONFIG_CGROUP_RDMA
> +

Currently, there are some discussions regarding the RDMA ABI. The 
current proposed approach (after a lot of discussions in the OFVWG) is 
to have driver dependent object types rather than the fixed set of IB 
object types we have today.
AFAIK, some vendors might want to use the RDMA subsystem for a different 
fabrics which has a different set of objects.
You could see RFCs for such concepts both from Mellanox and Intel on the 
linux-rdma mailing list.

Saying that, maybe we need to make the resource types a bit more 
flexible and dynamic.

Regards,
Matan
