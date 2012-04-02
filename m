From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Date: Mon, 2 Apr 2012 14:49:38 -0700
Message-ID: <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <4F7A1C8B.3010402@tao.ma>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IMqy//H4GS57qx72SnUK1ChyRCTI6CjDjIm/sEEiwaU=;
        b=Y+387RQtEMn+hyS021JUWJNTTBvSmuMsatHYruGUouNrNUqGFWVNvYrXHgX37wYjn2
         Ye3Lj1Ll0wIdKH52vrmHf266np709/djvBDvQUh7Fw0CwiYtHPi641louK0BKWP3AcLY
         bAeVoDtfp8FlqqZUKrWLbpWSslKPN/FPU7rycqO9IEMBZPEmSnsCEL3f8WPMaJfeh+kk
         18NzEam5S/37dMmm6ufrYxgeLAFh+vRPh/amfWtpBkZORlcuyZ6D5IdszIUZJaA34ROj
         gV5vj7saoXyOWdthULcaXiHMOXQxHTY5mu+7UFRum54ZLMjG77dg6jP8DIHEZyX9rD7B
         wKQg==
Content-Disposition: inline
In-Reply-To: <4F7A1C8B.3010402-d1IQDZat3X0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Tue, Apr 03, 2012 at 05:39:23AM +0800, Tao Ma wrote:
> I guess blkio->weight is a generic way of abstracting the weight between
> different block cgroups.

It isn't and can't be.  There's nothing generic about it across
different policies and it's not even clear what that means.  If the
user chooses combine, iops limit with cfq weights, what the hell is
"generic" about that weight?

> Yes, currently, only cfq uses it, but I am
> trying to improve Shaohua's original fiops scheduler and add cgroup
> support to it. So please leave it there so that future scheduler(if
> other than the fiops scheduler) can use the framework.

So, if you want to implement a new blkcg policy, add the config
parameters and export the stats the policy wants *yourself*.  Not
having clear separation between policies and generic stuff was what
led us to this yucky mess and there's no way we're going back there.
So, NO.

Thanks.

-- 
tejun
