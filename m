From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHSET] kernfs, cgroup: make kernfs_path*() and
 cgroup_path*() behave in strlcpy() style
Date: Tue, 9 Aug 2016 10:18:19 +0200
Message-ID: <20160809081819.GB10279@kroah.com>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470720204-4605-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com

On Tue, Aug 09, 2016 at 01:23:20AM -0400, Tejun Heo wrote:
> kernfs path formatting functions always return the length of full path
> but the content of the output buffer is undefined when the length is
> longer than the provided buffer.  Most cgroup path formatting
> functions return the start of the output or NULL on errors including
> overflow.  These inconsistent and rather peculiar behaviors developed
> over time and make these functions unnecessarily difficult to use.
> This patchset updates the formatting functions so that they all behave
> in the style of strlcpy().
> 
> Greg, these changes are used by cgroup tracepoint additions and
> shouldn't affect other users much.  Would it be okay to route these
> through the cgroup tree?
> 
>  0001-kernfs-add-dummy-implementation-of-kernfs_path_from_.patch
>  0002-kernfs-make-kernfs_path-behave-in-the-style-of-strlc.patch
>  0003-kernfs-remove-kernfs_path_len.patch
>  0004-cgroup-make-cgroup_path-and-friends-behave-in-the-st.patch
> 
> The patches are also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kernfs_path-strlcpy
> 
> diffstat follows.  Thanks.

It's fine with me if you take these yourself:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

thanks,

greg k-h
