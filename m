From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Test of [PATCH] blk-throttle: simplify logic by token bucket
 algorithm
Date: Tue, 15 Apr 2014 16:14:48 -0400
Message-ID: <20140415201448.GC13033@redhat.com>
References: <1397546303-6709-1-git-send-email-zhiguohong@tencent.com>
 <1397546586-6776-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1397546586-6776-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Tue, Apr 15, 2014 at 03:23:06PM +0800, Hong Zhiguo wrote:
> Hi, Vivek,
> 
> I tested the PATCH again for some basic hierarchical setup as I did
> before.
> 
> Preparation
> ============
> 1) mount subsys blkio with "__DEVEL__sane_behavior"

What init system are you using? How did you specify sane flag. I am
using systemd with F20 and I don't know how to specify this flag
and test your patches.

Thanks
Vivek
