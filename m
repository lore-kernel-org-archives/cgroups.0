From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/15] cfq-iosched: Print sync-noidle information in blktrace messages
Date: Mon, 01 Oct 2012 17:01:07 -0400
Message-ID: <x49626tj4a4.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-7-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-7-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:47 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Currently we attach a character "S" or "A" to the cfqq<pid>, to represent
> whether queues is sync or async. Add one more character "N" to represent
> whether it is sync-noidle queue or sync queue. So now three different
> type of queues will look as follows.
>
> cfq1234S   --> sync queus
> cfq1234SN  --> sync noidle queue
> cfq1234A   --> Async queue
>
> Previously S/A classification was being printed only if group scheduling
> was enabled. This patch also makes sure that this classification is
> displayed even if group idling is disabled.
>
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I'm assuming nobody relies on the contents of trace_message output not
changing in blktrace output.

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
