From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: fix race between blkcg_bio_issue_check
 and cgroup_rmdir
Date: Thu, 8 Feb 2018 07:23:07 -0800
Message-ID: <20180208152307.GL695913@devbig577.frc2.facebook.com>
References: <6f136c90-faa9-4bc0-b02f-3a112b4d8360@linux.alibaba.com>
 <20180207213811.GF695913@devbig577.frc2.facebook.com>
 <b590caed-1423-4776-966d-cd9e346a8ea1@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xuluscIXlBuN04464kbco/zAKEP0PN1IpZnSSYS5OCQ=;
        b=Cjoqw0oJIO6anPjSrKXJxans8/Fm4C4db/u2dkhPoSTNPxPI43pjudx7suayIQtRWI
         zOAiyyNUU3iXHMdjbB7onko5AZxMWt3TNlHxizbIN5b37r/NINGIIe7iv0bMOgKJ2wOL
         r9cnJ46t1EE86ZcL8nHaLfEzcfHMNnKbHjGcjaKpYRwftFMYBXRqa2rKcsdCXU1SzoCY
         6a6sW3MlyNLA5vQWFM1ASuORh2om+iQJoaCbHTytCD2ENiXz7DpJ2ofPvparL2poP977
         Fsy6VawfMcEiAX6RFQTv584bMZz9tIpCH4GIhLwEkyjCtlaiofShfImmG5VF5LfT/1b7
         jQ7A==
Content-Disposition: inline
In-Reply-To: <b590caed-1423-4776-966d-cd9e346a8ea1-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Caspar Zhang <caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Joseph.

On Thu, Feb 08, 2018 at 10:29:43AM +0800, Joseph Qi wrote:
> So you mean checking css->refcnt to prevent the further use of
> blkg_get? I think it makes sense.

Yes.

> IMO, we should use css_tryget_online instead, and rightly after taking

Not really.  An offline css still can have a vast amount of IO to
drain and write out.

> queue_lock. Because there may be more use of blkg_get in blk_throtl_bio
> in the futher. Actually it already has two now. One is in
> blk_throtl_assoc_bio, and the other is in throtl_qnode_add_bio.
> What do you think of this?

As long as we avoid making the bypass paths expensive, whatever makes
the code easier to read and maintain would be better.  css ref ops are
extremely cheap anyway.

Thanks.

-- 
tejun
