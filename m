From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH 08/10] blkcg: implement blk-ioweight
Date: Fri, 14 Jun 2019 14:17:45 +0200
Message-ID: <87pnngbbti.fsf@toke.dk>
References: <20190614015620.1587672-1-tj@kernel.org> <20190614015620.1587672-9-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614015620.1587672-9-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org, Tejun Heo <tj@kernel.org>, Josef Bacik <jbacik@fb.com>

Tejun Heo <tj@kernel.org> writes:

> This patchset implements IO cost model based work-conserving
> proportional controller.
>
> While io.latency provides the capability to comprehensively prioritize
> and protect IOs depending on the cgroups, its protection is binary -
> the lowest latency target cgroup which is suffering is protected at
> the cost of all others.  In many use cases including stacking multiple
> workload containers in a single system, it's necessary to distribute
> IO capacity with better granularity.
>
> One challenge of controlling IO resources is the lack of trivially
> observable cost metric.  The most common metrics - bandwidth and iops
> - can be off by orders of magnitude depending on the device type and
> IO pattern.  However, the cost isn't a complete mystery.  Given
> several key attributes, we can make fairly reliable predictions on how
> expensive a given stream of IOs would be, at least compared to other
> IO patterns.
>
> The function which determines the cost of a given IO is the IO cost
> model for the device.  This controller distributes IO capacity based
> on the costs estimated by such model.  The more accurate the cost
> model the better but the controller adapts based on IO completion
> latency and as long as the relative costs across differents IO
> patterns are consistent and sensible, it'll adapt to the actual
> performance of the device.
>
> Currently, the only implemented cost model is a simple linear one with
> a few sets of default parameters for different classes of device.
> This covers most common devices reasonably well.  All the
> infrastructure to tune and add different cost models is already in
> place and a later patch will also allow using bpf progs for cost
> models.
>
> Please see the top comment in blk-ioweight.c and documentation for
> more details.

Reading through the description here and in the comment, and with the
caveat that I am familiar with network packet scheduling but not with
the IO layer, I think your approach sounds quite reasonable; and I'm
happy to see improvements in this area!

One question: How are equal-weight cgroups scheduled relative to each
other? Or requests from different processes within a single cgroup for
that matter? FIFO? Round-robin? Something else?

Thanks,

-Toke
