From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Tue, 27 Jul 2021 21:48:06 -1000
Message-ID: <YQELtmeLjlDHCk2i@mtj.duckdns.org>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
 <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
 <YP8tPwkJNMAcjDqk@mtj.duckdns.org>
 <34a6f4b5-9055-e519-5693-068f8dcb169c@gmail.com>
 <YQAydzEhZfPUpzWI@mtj.duckdns.org>
 <fab343e8-5929-fb30-90e3-b5b6bd34702a@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nSOViMYPYa18THue5NB1xRZRfJm692a7CdBC4/LyTC4=;
        b=KNM2TQ0qBbPb4XvWNcysK8INoORw2FRUtbc8UbVGuaP8PeRKXOA40SbsDF9oCehOVL
         AnCZvTFY+1SPWB6JTBKcQKVHe3UPQGU3v1GUFjON3h/+SJzOISApHH7sj4rhrF7i2OA/
         MoxIDhyejas59nJVOYyl3xM1pLZ6ytfPEfoAhwvPgna4fkebhtY+gUYU+jJCtA+Ctm3k
         Ji/a68Vrx6gto6KOy8+ipXUFVimMCo4eWMWAltb/IoZ4C2U32jFknB1VnzXzmkX2ohHe
         CJffsTry3FwO+oIN4xrkKxl/JfuJtPbRpXoMTAJLEmaV29xTQ0CpI2LIj2vNyc5xy9+V
         XZgQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fab343e8-5929-fb30-90e3-b5b6bd34702a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jul 28, 2021 at 10:33:20AM +0800, brookxu wrote:
> If we do this, I think we will encounter some problems, as follows:
> 1. blk-throttle is now at the top of the IO stack. Changing the position of the throttle hook
>    will make this mechanism invalid for some devices.
> 2. We may also need to add a new hook to handle back-merge, otherwise I think the isolation
>    effect will be worse in the sequential IO scene.
> 3. Since bio has entered the IO stack, if it is suspended and resubmitted by blk-throttle,
>    then there is an IO stack reentry problem, which I think may cause many small problems.

Yeah, you're right. I don't think it's worth rocking the boat with
blk-throtl at this point. An extra callback it is then.

Thanks.

-- 
tejun
