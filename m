From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
Date: Mon, 08 Jun 2015 15:49:56 -0400
Message-ID: <x491thmhtej.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433753973-23684-1-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:25 +0900")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> cfq has always charged all async IOs to the root cgroup.  It didn't
> have much choice as writeback didn't know about cgroups and there was
> no way to tell who to blame for a given writeback IO.  writeback
> finally grew support for cgroups and now tags each writeback IO with
> the appropriate cgroup to charge it against.
>
> This patchset updates cfq so that it follows the blkcg each bio is
> tagged with.  Async cfq_queues are now shared across cfq_group, which
> is per-cgroup, instead of per-request_queue cfq_data.  This makes all
> IOs follow the weight based IO resource distribution implemented by
> cfq.
>
> This patchset contains the following 8 patches.
>
>  0001-cfq-iosched-simplify-control-flow-in-cfq_get_queue.patch
>  0002-cfq-iosched-fix-async-oom-queue-handling.patch
>  0003-cfq-iosched-fix-oom-cfq_queue-ref-leak-in-cfq_set_re.patch
>  0004-cfq-iosched-minor-cleanups.patch
>  0005-cfq-iosched-remove-gfp_mask-from-cfq_find_alloc_queu.patch
>  0006-cfq-iosched-move-cfq_group-determination-from-cfq_fi.patch
>  0007-cfq-iosched-fold-cfq_find_alloc_queue-into-cfq_get_q.patch
>  0008-cfq-iosched-charge-async-IOs-to-the-appropriate-blkc.patch

Hi, Tejun,

Assuming you're ok with dropping patch 5, I'll review patches 6-8 once
they've been reworked to account for that.  I took a look at them, and
they look OK to me.  But, if they are going to change, I'd rather wait
to ack the final versions.

Cheers,
Jeff
