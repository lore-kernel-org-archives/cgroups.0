From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 4/5] genirq/affinity: allow driver's discontigous
 affinity set
Date: Tue, 25 Jun 2019 10:14:12 +0800
Message-ID: <20190625021411.GD23777@ming.t460p>
References: <cover.1561385989.git.zhangweiping@didiglobal.com>
 <1ead341c6d603cf138aed62e31091f257cb19981.1561385989.git.zhangweiping@didiglobal.com>
 <alpine.DEB.2.21.1906241740320.32342@nanos.tec.linutronix.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1906241740320.32342@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Weiping Zhang <zhangweiping@didiglobal.com>, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, bvanassche@acm.org, keith.busch@intel.com, minwoo.im.dev@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

Hi Thomas,

On Mon, Jun 24, 2019 at 05:42:39PM +0200, Thomas Gleixner wrote:
> On Mon, 24 Jun 2019, Weiping Zhang wrote:
> 
> > The driver may implement multiple affinity set, and some of
> > are empty, for this case we just skip them.
> 
> Why? What's the point of creating empty sets? Just because is not a real
> good justification.

Patch 5 will add 4 new sets for supporting NVMe's weighted round robin
arbitration. It can be a headache to manage so many irq sets(now the total
sets can become 6) dynamically since size of anyone in the new 4 sets can
be zero, so each particular set is assigned one static index for avoiding
the management trouble, then empty set will be seen by
irq_create_affinity_masks().

So looks skipping the empty set makes sense because the API will become
easier to use than before.

Thanks,
Ming
