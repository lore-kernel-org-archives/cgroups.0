From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/17] cgroup: create directory before linking while
 creating a new cgroup
Date: Wed, 14 Nov 2012 11:04:07 -0800
Message-ID: <20121114190407.GI21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-5-git-send-email-tj@kernel.org>
 <50A30E0F.7000408@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gQONhsIrWy/5oo9EqVrmYBinXpRNSpdWIjHQV+18HQs=;
        b=e1oOmrVcFX3LDkjBTBI3nT8UZ4RY4gRflvkqHxcRnOAHkbMnB1lj7TSe7phykWsqTv
         oGyIgCaY5GHtf+YghiystSAo9UybALjP2ADLkse13uo/Siw6rJciDjJQ1xaXF7CYPl2l
         nEKSjZoUqnYiTe5bmQZGq8AwTmncS0GJJTybKrXv7u5RLlwT/zKlJvpDPydRE+c809A0
         1OD/vnlQjhm76OkYAIprsCzu+Wn5VEUGirKrWfwOaZ9LEn84Wk1lYdog+yhQ3/RLKja5
         PgW314izYqoovpzXepSw+2a65ugxv2zQuP0d6+ENqGW+8lpu1nRsoJdIRSl4bDCHFh+d
         LtCg==
Content-Disposition: inline
In-Reply-To: <50A30E0F.7000408-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

Hello, Li.

On Wed, Nov 14, 2012 at 11:20:47AM +0800, Li Zefan wrote:
> > It also removes the need to check whether cgroup->dentry is %NULL in
> > cgroup_path.  If a cgroup is visible, its dentry is guaranteed to be
> > visible too.
> 
> I'm afraid this isn't safe.
> 
> The cgroup is visible to a controller soon after ss->create(), and then
> the controller might call cgroup_path() while cgrp->dentry is still NULL.

Hmmm... I can't find any case where ss->create() is calling
cgroup_path().  Do you remember which one that was?

> This can happen for cpu cgroup I think, and in fact the NULL check was
> added for this reason IIRC.

Then, I think we better move the dentry assignment further up.  It's
really silly to be unable to answer "what's this new cgroup's name?"
for any callback really.  Will update accordingly.

Thanks.

-- 
tejun
