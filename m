From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Date: Fri, 27 Apr 2012 16:21:19 -0400
Message-ID: <20120427202119.GO10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <20120427194654.GN10579@redhat.com>
 <20120427201516.GJ26595@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120427201516.GJ26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Fri, Apr 27, 2012 at 01:15:16PM -0700, Tejun Heo wrote:

[..]
> > IOW, looks like we need a mechanism to mark a blkcg dead (set in
> > pre_destroy() call) and any submissions to blkcg after that should result
> > in bio being divered to root group?
> 
> Don't we already have that with css_tryget()?

Ok, forgot about css_tryget(). Yes that should work. Thanks. Introduction
of cgroup has made locking and lifetime rules little complicated. :-)

Thanks
Vivek
