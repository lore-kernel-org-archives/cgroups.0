From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO class
Date: Mon, 01 Oct 2012 16:51:02 -0400
Message-ID: <x49mx05j4qx.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-2-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-2-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:42 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Currently CFQ has three IO classes, RT, BE and IDLE. At many a places we
> are calling workloads belonging to these classes as "prio". This gets
> very confusing as one starts to associate it with ioprio.
>
> So this patch just does bunch of renaming so that reading code becomes
> easier. All reference to RT, BE and IDLE workload are done using keyword
> "class" and all references to subclass, SYNC, SYNC-IDLE, ASYNC are made
> using keyword "type".
>
> This makes me feel much better while I am reading the code. There is no
> functionality change due to this patch.
>
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thank you!

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
