From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Mon, 26 Jul 2021 11:46:39 -1000
Message-ID: <YP8tPwkJNMAcjDqk@mtj.duckdns.org>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
 <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WjCY/wbfUK0zm4QOWZ0DfXs/wUDR97ZPxIRjy8ov/A8=;
        b=cvGQNlqXc9F1r7YAKDQI6gKQ+w7Tm1Ej6DWyxSVtVV7QCgNAknurz1XyI+O85DdhQ+
         MJ0B1NDkbdjFhHEH7zWz5hF0cwbQvSLN0/ePaEE6MW16fBOA2MzLBYxet2f3qJiE7EnW
         m+OWDz1TI31PyE6H7nhrBrBAXCYMmjTzarqj7nhPP6xU4SdQvuOnNEfS03iSRiQFIKzR
         mCfOnn0G5hjF3ZplGswQcxPC11oEpekR6J8FdX3b1POrATCU3vkakA4DYNdEzEU3ULiA
         SRyYLqldmtNKEnXT4soiRYkC3NC/cHvwC326jLTI9WcKv/U+urb0F+6Z1OFVUF1Hiz2K
         jmVw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <957ab14d-c4bc-32f0-3f7d-af98832ab955-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 20, 2021 at 12:35:54AM +0800, brookxu wrote:
> In order to avoid code duplication and IOPS stability problems caused by estimating
> the equivalent number of IOs, and to avoid potential deadlock problems caused by
> synchronization through queue_lock. I tried to count the number of splited IOs in
> the current window through two atomic counters. Add the value of the atomic variable
> when calculating io_disp[rw], which can also avoid the problem of inaccurate IOPS in
> large IO scenarios. How do you think of this approach? Thanks for your time.

I guess it's okay but am still not a big fan of adding another hook. This is
primarily because blk-throtl is sitting too early in the stack - e.g. rq_qos
is doing the same thing but sits after the split path - and it's a bit nasty
to add an additional hook for it.

Do you think it can be an option to relocate the blk-throtl hooks to the
same spots as rq-qos or, even better, make it use rq-qos?

Thanks.

-- 
tejun
