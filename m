From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2 blk-cgroup/for-5.8] blk-cgroup: show global disk
 stats in root cgroup io.stat
Date: Mon, 1 Jun 2020 16:42:14 -0400
Message-ID: <20200601204214.GF31548@mtj.thefacebook.com>
References: <20200601154351.GD31548@mtj.thefacebook.com>
 <20200601201205.1658417-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNZfm4KTFqe5hnlvYWDeBhcm8Ap+9mpyPFYJmsznAkM=;
        b=t8euN+bSgRmxO9c8Y/F883WBGe4+MHcPeJWqbsm/Ga9gEIjuGubgttCJNl+uoAu4f2
         WA3zDSPL6rLppywjj2lYh+yOrJLiGEntBUcihOjGwVwoOB+VIdBpDFHsUZKyLfQ2mqYV
         RDtckfLXaIynwN3PFlN6VbNxg0/5w0I5jj3n0pEQotS8YPJ9NtJpK3PpqYr1y6OmuR72
         DP+i/gUVvc8ImBV86uzJB2jknfWCq8ei32IFzdQbXhYFDor1nFtNyNC6g3NI2o2ixNLx
         YX5Ej8xkJ/zLmgnXpj7IkDsfKCsuw621xmaC5Ff+cxGIH9ky6fFxr9V1lwO1sDKFQMHm
         flMA==
Content-Disposition: inline
In-Reply-To: <20200601201205.1658417-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Jun 01, 2020 at 01:12:05PM -0700, Boris Burkov wrote:
> In order to improve consistency and usability in cgroup stat accounting,
> we would like to support the root cgroup's io.stat.
> 
> Since the root cgroup has processes doing io even if the system has no
> explicitly created cgroups, we need to be careful to avoid overhead in
> that case.  For that reason, the rstat algorithms don't handle the root
> cgroup, so just turning the file on wouldn't give correct statistics.
> 
> To get around this, we simulate flushing the iostat struct by filling it
> out directly from global disk stats. The result is a root cgroup io.stat
> file consistent with both /proc/diskstats and io.stat.
> 
> Note that in order to collect the disk stats, we needed to iterate over
> devices. To facilitate that, we had to change the linkage of a disk_type
> to external so that it can be used from blk-cgroup.c to iterate over
> disks.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
