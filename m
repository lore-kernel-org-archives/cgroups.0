From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/8] cfq-iosched: remove @gfp_mask from cfq_find_alloc_queue()
Date: Mon, 08 Jun 2015 16:27:10 -0400
Message-ID: <x49sia2gd41.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-6-git-send-email-tj@kernel.org>
	<x498ubuhulf.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x498ubuhulf.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 08 Jun 2015 15:24:12 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com

Jeff Moyer <jmoyer@redhat.com> writes:

> Tejun Heo <tj@kernel.org> writes:
>
>> Even when allocations fail, cfq_find_alloc_queue() always returns a
>> valid cfq_queue by falling back to the oom cfq_queue.  As such, there
>> isn't much point in taking @gfp_mask and trying "harder" if __GFP_WAIT
>> is set.  GFP_ATOMIC allocations don't fail often and even when they do
>> the degraded behavior is acceptable and temporary.
>>
>> After all, the only reason get_request(), which ultimately determines
>> the gfp_mask, cares about __GFP_WAIT is to guarantee request
>> allocation, assuming IO forward progress, for callers which are
>> willing to wait.  There's no reason for cfq_find_alloc_queue() to
>> behave differently on __GFP_WAIT when it already has a fallback
>> mechanism.
>>
>> Remove @gfp_mask from cfq_find_alloc_queue() and propagate the changes
>> to its callers.  This simplifies the function quite a bit and will
>> help making async queues per-cfq_group.
>
> Sorry, I disagree with this patch.  You've changed it so that all cfqq
> allocations are GFP_ATOMIC, and most, if not all of them simply don't
> need to be.

It occurs to me that replacing GFP_ATOMIC with GFP_NOWAIT in your patch
would address my concerns, and patches 6-8 would apply almost as-is.
What do you think about that?

-Jeff
