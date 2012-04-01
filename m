From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file handling
Date: Sun, 1 Apr 2012 15:38:16 -0400
Message-ID: <20120401193816.GA6116@redhat.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1332975091-10950-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Wed, Mar 28, 2012 at 03:51:10PM -0700, Tejun Heo wrote:

[..]
> This patchset is an attempt at bringing some sanity to blkcg config
> and stat file handling.  It makes use of the pending dynamic cgroup
> file type addition / removal support [1], which will be merged into
> cgroup/for-3.5 once 3.4-rc1 is released.

Thanks Tejun. This looks like a nice cleanup. Especially the stat part.
It was very messy in blkcg core code. Now atleast it is clear who owns what
file and who needs per cpu stats etc. And new policies should be easily
able to define their own cgroup files.

Thanks
Vivek
