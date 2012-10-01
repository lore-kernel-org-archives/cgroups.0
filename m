From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/15] cfq-iosched: Get rid of unnecessary local variable
Date: Mon, 01 Oct 2012 16:57:54 -0400
Message-ID: <x49a9w5j4fh.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-6-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-6-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:46 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Use of local varibale "n" seems to be unnecessary. Remove it. This brings
> it inline with function __cfq_group_st_add(), which is also doing the
> similar operation of adding a group to a rb tree.
>
> No functionality change here.

Agreed.

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
