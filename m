From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Date: Mon, 01 Oct 2012 16:52:13 -0400
Message-ID: <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-4-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:44 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> At quite a few places we use the keyword "service_tree" and I feel that
> names in CFQ are already very long and they need to be shortened a bit
> where appropriate.
>
> So this patch just renames "service_tree" to "st" at most of the places.
> No functionality change.

NACK.

> -	struct cfq_rb_root service_trees[2][3];
> -	struct cfq_rb_root service_tree_idle;
> +	struct cfq_rb_root sts[2][3];
> +	struct cfq_rb_root st_idle;

Honestly, who looks at sts and thinks "service trees?"
