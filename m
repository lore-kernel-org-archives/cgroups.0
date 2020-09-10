From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] taskstats: fix CGROUPSTATS_CMD_GET for cgroup v2
Date: Thu, 10 Sep 2020 10:32:44 -0400
Message-ID: <20200910143244.GF4295@mtj.thefacebook.com>
References: <20200910055207.87702-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mY+K4wwI3uVC3MNpAenDFKOHI/Yx4eP9ajKsUNDpIAY=;
        b=iEmg7HsfmLxZys3AFomnebmzkqL4Q6IslUgZ24TBHj2QY7DH16fGDE7K2Uob+iyLFz
         NQLRdKxSgflbs3gpI9Kg5W9pRn5mrmHf2sy6LqIVFN5lnQfaI1U0lJ4qd248lSzlR6w6
         YM49BPXRRXN67RsKd5djmGZLjmcCwsPxk+lvOII/xkRZTpnpg5P7M7bWSs5TvOxqlFmV
         9fr0wNWrU2hBI0w0ghHfYDzuyiJxhBVUaIXkCj9F7xZ93d6nZNUHYmxzVUdqGB/JYQql
         R1GaE5G0qk09dwHzjROwTQbAaxhOK8RRO+ityTp39eDqfOdBdwaGZEt1QJDkq1CRTIuI
         on8w==
Content-Disposition: inline
In-Reply-To: <20200910055207.87702-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Thu, Sep 10, 2020 at 01:52:07PM +0800, Chengming Zhou wrote:
> We found cgroupstats_build would return -EINVAL when using netlink
> CGROUPSTATS_CMD_GET interface to get stats on cgroup v2. Fix it by
> supporting cgroup v2 kernfs directory in cgroupstats_build, and export
> cgroup2_fs_type like we did for cgroup_fs_type.
> 
> Reported-by: Daowen Luo <luodaowen.backend-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Tested-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The exclusion of cgroupstats from v2 interface was intentional due to the
duplication and inconsistencies with other statistics. If you need these
numbers, please justify and add them to the appropriate cgroupfs stat file.

Thanks.

-- 
tejun
