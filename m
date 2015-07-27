From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET block/for-4.3] blkcg: implement interface for the
 unified hierarchy
Date: Mon, 27 Jul 2015 12:12:09 -0400
Message-ID: <20150727161209.GB16064@redhat.com>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437763434-28699-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 24, 2015 at 02:43:44PM -0400, Tejun Heo wrote:
> Hello,
> 
> blkcg interface grew to be the biggest of all controllers and
> unfortunately most inconsistent too.  The interface files are
> inconsistent with a number of cloes duplicates.  Some files have
> recursive variants while others don't.  There's distinction between
> normal and leaf weights which isn't intuitive and there are a lot of
> stat knobs which don't make much sense outside of debugging and expose
> too much implementation details to userland.
> 
> In the unified hierarchy, everything is always hierarchical and
> internal nodes can't have tasks rendering the two structural issues
> twisting the current interface.  The interface has to be updated in a
> significant anyway and this is a good chance to revamp it as a whole.
> This patchset implements blkcg interface for the unified hierarchy.
> 
> * blkcg is identified by "io" instead of "blkio" on the unified
>   hierarchy.  Given that the whole interface is updated anyway, the
>   rename shouldn't carry noticeable conversion overhead.
> 
> * The original interface consisted of 27 files is replaced with the
>   following three files.
> 
>   blkio.stat	: per-blkcg stats
>   blkio.weight	: per-cgroup and per-cgroup-queue weight settings
>   blkio.max	: per-cgroup-queue bps and iops max limits
> 

Hi Tejun,

I browsed though the details of above knobs and it sounds great. It is
clean and much less number of knobs and files. You got rid of all the
debug CFQ knobs which is good. I was not happy with these either. Glad
to see that all the magic about leaf weight is gone. That was really
mind bending. Knob for reset stats is gone and instead of mutiple files
for configuration now we are using single file for R/W BPS/IOPS
configuration.

I will do some basic testing and see if something pops up.

Userspace will need to understand these new files but that's the
understanding anyway that unified hierarchy is different and needs
to be handled differently.

Thanks
Vivek
