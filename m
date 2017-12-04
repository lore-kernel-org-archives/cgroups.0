From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 4 Dec 2017 12:22:19 -0800
Message-ID: <20171204202219.GF2421075@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3nfdnYbi85La7AY2JzILsSFeFotSzChkBkrOAPTN4EE=;
        b=qjYI1+BMJp7utje/orF9aAUCZvUFITiC35asVK0nugoSQtdBYe+nTA2dL+BEwi9FAk
         9ImHPRsIBf+bJP9nvIkmbSROQSoQS7ajvzn0MVP618X5aE/o/BkoCsdB8XNiXwP6u7qY
         HQMdNEgPPkVX2L1b8wC5pb68giTJoP++bdcCIjwYsuxfwokFSGvJ7thQgNjCN092lVU7
         J9dFoHSus7djnUQeh2oyDV16rddhebEMO9MIOCkjn/6pCSOOY1BoqHPWhlWwB4snKCCL
         1zL2SOXEVfXvJb1f6+7sKHpZYta/pRxqoEQGEdR/oxKCkCTYa4SgrBmmnJmD0gQS/zBg
         5zmw==
Content-Disposition: inline
In-Reply-To: <623f214b-8b9a-f967-7a3d-ca9c06151267-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Hello,

On Mon, Dec 04, 2017 at 10:44:49AM +0530, Prateek Sood wrote:
> Any feedback/suggestion for this patch?

Sorry about the delay.  I'm a bit worried because it feels like we're
chasing a squirrel.  I'll think through the recent changes and this
one and get back to you.

Thanks.

-- 
tejun
