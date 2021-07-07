From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] blk-cgroup: prevent rcu_sched detected stalls
 warnings while iterating blkgs
Date: Wed, 7 Jul 2021 05:11:33 -1000
Message-ID: <YOXEJTI7qOY6QBjy@mtj.duckdns.org>
References: <20210707015649.1929797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GNDXNaZYGbMBdcYFq4ONE/0GjhVExMKqksA5/1NNflY=;
        b=LvrF+NLV2Gy3fvh0Cp5ddJeIkz+lg/q2D1FlVmFj5Jkxj1g5kvXlTZcePJo7FPdLbj
         lKFaGXeMxMwc73KD9WtJOg4I85I1QqKZCGrTyvBk5Y2evPdtYBrS2jOp4pf/t8d6f1K6
         ddi7qZM+7PlvZ9QU2nzr0XnVim+klirwv4P58eNHr4INOxvVfBWrAmSzoNqvZldGgPcX
         cJ2ox2pYtvFIXXAqsy7C3regM90zc2o1hZ2pLNxIJoRHcnP/6D4UM5U0uXE+OMk4CSR7
         TS00FHzfDMcY8/hOaBnDEbjpA7X2iEBODNaGG15YDGU2xPnzW4GfvNAGYhHnvJCYiyyc
         TuyA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210707015649.1929797-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Jul 07, 2021 at 09:56:49AM +0800, Yu Kuai wrote:
> We run a test that create millions of cgroups and blkgs, and then trigger
> blkg_destroy_all(). blkg_destroy_all() will hold spin lock for a long
> time in such situation. Thus release the lock when a batch of blkgs are
> destroyed.
> 
> blkcg_activate_policy() and blkcg_deactivate_policy() might have the
> same problem, however, as they are basically only called from module
> init/exit paths, let's leave them alone for now.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
