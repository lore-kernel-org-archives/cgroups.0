From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] add pinned flags for kernfs node
Date: Wed, 8 Sep 2021 14:35:17 +0200
Message-ID: <YTiuBaiVZhe3db9O@kroah.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <e753e449240bfc43fcb7aa26dca196e2f51e0836.1631102579.git.escape@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631104519;
        bh=COdmmMC2NhlKWVFj31C7uZM1YgxY0x3WYgYnuLq4PgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/A4aDcK8Fv+z1kk7N/+S/Z3baBZOHsGdy10qq5md1XsQ8bUS8wIj5okQG8vTNMFm
         nrcXld76SdV+JI9/tX8X+Si84zT+7egkmC/KeX4GEkZMK8VO8av1RBW8ccmj/CCS9n
         NEZkkAMiJJXg1gdlLDAxIH1S14J5bZCRHo4duD3c=
Content-Disposition: inline
In-Reply-To: <e753e449240bfc43fcb7aa26dca196e2f51e0836.1631102579.git.escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yi Tao <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

On Wed, Sep 08, 2021 at 08:15:12PM +0800, Yi Tao wrote:
> This patch is preparing for the implementation of cgroup pool. If a
> kernfs node is set to pinned. the data of this node will no longer be
> protected by kernfs internally. When it performs the following actions,
> the area protected by kernfs_rwsem will be protected by the specific
> spinlock:
> 	1.rename this node
> 	2.remove this node
> 	3.create child node
> 
> Suggested-by: Shanpei Chen <shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yi Tao <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  fs/kernfs/dir.c        | 74 ++++++++++++++++++++++++++++++++++++--------------
>  include/linux/kernfs.h | 14 ++++++++++
>  2 files changed, 68 insertions(+), 20 deletions(-)

Ugh, this is going to get messy fast.

Why are kernfs changes needed for this?  kernfs creation is not
necessarily supposed to be "fast", what benchmark needs this type of
change to require the addition of this complexity?

And how are we going to audit things to ensure the "pinning" is working
properly?

thanks,

greg k-h
