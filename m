From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 4/5] genirq/affinity: allow driver's discontigous affinity set
Date: Sat, 01 Feb 2020 10:08:36 +0100
Message-ID: <871rrevfmz.fsf@nanos.tec.linutronix.de>
References: <cover.1580211965.git.zhangweiping@didiglobal.com> <c044e71afa25fdf65ca9abd21f8a5032e1b424eb.1580211965.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <c044e71afa25fdf65ca9abd21f8a5032e1b424eb.1580211965.git.zhangweiping@didiglobal.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zhangweiping@didiglobal.com>, axboe@kernel.dk, tj@kernel.org, hch@lst.de, bvanassche@acm.org, keith.busch@intel.com, minwoo.im.dev@gmail.com, edmund.nadolski@intel.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

Weiping Zhang <zhangweiping@didiglobal.com> writes:

> nvme driver will add 4 sets for supporting NVMe weighted round robin,
> and some of these sets may be empty(depends on user configuration),
> so each particular set is assigned one static index for avoiding the
> management trouble, then the empty set will be been by
> irq_create_affinity_masks().

What's the point of an empty interrupt set in the first place? This does
not make sense and smells like a really bad hack.

Can you please explain in detail why this is required and why it
actually makes sense?

Thanks,

        tglx
