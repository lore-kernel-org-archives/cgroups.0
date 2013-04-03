From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: remove unused parameter in
 cgroup_task_migrate().
Date: Wed, 3 Apr 2013 14:05:08 -0700
Message-ID: <20130403210508.GB3411@htj.dyndns.org>
References: <1364802697-7875-1-git-send-email-wkevils@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=lVLIp9rucCSsH3yuKaZC1BkMH5AKXd6nEqjGi+Y76Vc=;
        b=Fcd5CbUEFsC/lNT6GdxnhKYUwpoLyx+q0gIf6DWgbjd5lbSy908taYCuI/ualkmVaB
         xoaffK0s01gvdNxPadl8jJ6u/73qvBU6k+f2cOgi0jSsc5ZBCZfVt6+drXYiYB23z3rr
         hQMnNV/J+j+rVwa/zGCaUQVTXmSwiLIOFbSF5V5yEmoLpRUftrEfpmGYRpQj0X/gkG0P
         /lsIl2/2wIgkRJy5B8PPHust+S+95r0UhsGLKYpUjxIievD52nI+FkY3FWL6bO/lsOUq
         aVGaGEodtadmq12aehvE2856MasAizJ5k5tpyApGNNOxDjxvNnwLLSSkkNsRhWo38kiy
         6CRA==
Content-Disposition: inline
In-Reply-To: <1364802697-7875-1-git-send-email-wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Apr 01, 2013 at 10:51:37AM +0300, Kevin Wilson wrote:
> This patch removes unused parameter from cgroup_task_migrate().
> 
> Signed-off-by: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
