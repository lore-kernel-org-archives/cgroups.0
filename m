From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 4/5] genirq/affinity: allow driver's discontigous
 affinity set
Date: Mon, 24 Jun 2019 17:42:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906241740320.32342@nanos.tec.linutronix.de>
References: <cover.1561385989.git.zhangweiping@didiglobal.com> <1ead341c6d603cf138aed62e31091f257cb19981.1561385989.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ead341c6d603cf138aed62e31091f257cb19981.1561385989.git.zhangweiping@didiglobal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zhangweiping@didiglobal.com>
Cc: axboe@kernel.dk, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, bvanassche@acm.org, keith.busch@intel.com, minwoo.im.dev@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>

On Mon, 24 Jun 2019, Weiping Zhang wrote:

> The driver may implement multiple affinity set, and some of
> are empty, for this case we just skip them.

Why? What's the point of creating empty sets? Just because is not a real
good justification.

Leaving the patch for Ming.

Thanks,

	tglx

> Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
> ---
>  kernel/irq/affinity.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index f18cd5aa33e8..6d964fe0fbd8 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -295,6 +295,10 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
>  		unsigned int this_vecs = affd->set_size[i];
>  		int ret;
>  
> +		/* skip empty affinity set */
> +		if (this_vecs == 0)
> +			continue;
> +
>  		ret = irq_build_affinity_masks(affd, curvec, this_vecs,
>  					       curvec, masks);
>  		if (ret) {
> -- 
> 2.14.1
> 
> 
