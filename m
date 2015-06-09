From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
Date: Tue, 09 Jun 2015 11:05:46 -0400
Message-ID: <x49lhfssz05.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<x491thmhtej.fsf@segfault.boston.devel.redhat.com>
	<20150609030327.GL21465@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609030327.GL21465-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Tue, 9 Jun 2015 12:03:27 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hey, Jeff.
>
> On Mon, Jun 08, 2015 at 03:49:56PM -0400, Jeff Moyer wrote:
>> Assuming you're ok with dropping patch 5, I'll review patches 6-8 once
>
> I'll update it to use GPF_NOWAIT.  Can't drop it easily as that would
> complicate group lookup more complicated w/ pinning and all.
>
>> they've been reworked to account for that.  I took a look at them, and
>> they look OK to me.  But, if they are going to change, I'd rather wait
>> to ack the final versions.
>
> Hmm... the changes will be simple s/GFP_ATOMIC/GFP_NOWAIT.  Shouldn't
> affect reviewing, I think.

Yeah, I sent this email before realizing that GFP_NOWAIT would work out.
I've reviewed the rest of the series.  Looks good to me!  You did a nice
job splitting things up into easily reviewable pieces, so thanks for
that.

Cheers,
Jeff
