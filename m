From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Date: Tue, 2 Oct 2012 09:26:03 -0400
Message-ID: <20121002132603.GB758@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-4-git-send-email-vgoyal@redhat.com>
 <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <x49ipatj4oy.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 01, 2012 at 04:52:13PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > At quite a few places we use the keyword "service_tree" and I feel that
> > names in CFQ are already very long and they need to be shortened a bit
> > where appropriate.
> >
> > So this patch just renames "service_tree" to "st" at most of the places.
> > No functionality change.
> 
> NACK.
> 
> > -	struct cfq_rb_root service_trees[2][3];
> > -	struct cfq_rb_root service_tree_idle;
> > +	struct cfq_rb_root sts[2][3];
> > +	struct cfq_rb_root st_idle;
> 
> Honestly, who looks at sts and thinks "service trees?"

Yes this one is little odd. Ok, I will change it back to "service_tree"
and only use "st" for local variables and in some function names.

Vivek
