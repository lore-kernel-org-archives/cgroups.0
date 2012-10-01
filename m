From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/15] cfq-iosched: Rename few functions related to selecting workload
Date: Mon, 01 Oct 2012 16:55:43 -0400
Message-ID: <x49ehlhj4j4.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-5-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-5-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:45 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> choose_st() selects/sets both wl_class and wl_type.  Rename it to
> choose_wl_class_and_type() to make it very clear.
>
> cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
> it with choose_st(). So rename it to cfq_choose_wl_type() to make
> it clear what does it do.
>
> Just renaming. No functionality change.
>
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

No objections.

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
