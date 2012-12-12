From: Zhao Shuai <zhaoshuai-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>
Subject: Re: performance drop after using blkcg
Date: Wed, 12 Dec 2012 15:29:55 +0800
Message-ID: <CAFVn34TqCk71PDgdTAhBo9qTmhD3OwO9RxuyNRXwtkJoYqtOZg@mail.gmail.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
	<20121211142518.GA5580@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=HNTqAmzkP80ViZO8m1zRGLTg03CbMx7qhqI1SK29wSs=;
        b=hh5dsU3JKX6saji9YLk6l20bxixUKKzGSt+IlyExwlVcuXIhRWwhYfmtrUYP8DHxQL
         lfYBlke8P2o1W56b4mLKdA1YR/i7Oun/0x5AKc9owb/hg5vl4wjp+JSbocUedYE7XWHI
         Ut0vVu4/31mQZzbgF8ig+Y+rIsuOdFMzfr2AvGBMcXutZvaJ2G5ObrLc+bbAwE8eAIpI
         4nUVaqlNLkcAdUqQbELKtTRVbcFYP5+0NzfXcWBEU7TDowqPUkhy+cbnyCkq6ucqMWE+
         hjFewMs4ogvdvKQqChMw6ayucv/2PD/6cGrJFlunxx7s98y4Qy+4v0vCQcO45+HOfhuz
         InKg==
In-Reply-To: <20121211142518.GA5580-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

2012/12/11 Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> These results are with slice_idle=0?

Yes, slice_idle is disabled.

> What's the storage you are using. Looking at the speed of IO I would
> guess it is not one of those rotational disks.

I have done the same test on 3 different type of boxes,and all of them
show a performance drop(30%-40%) after using blkcg. Though they
have different type of disk, all the storage they use are traditional
rotational
devices(e.g."HP EG0146FAWHU", "IBM-ESXS").

> So if somebody wants to experiment, just tweak the code a bit to allow
> preemption when a queue which lost share gets backlogged and you
> practially have a prototype of iops based group scheduling.

Could you please explain more on this? How to adjust the code? I have test
the following code piece, the result is we lost group differentiation.

cfq_group_served() {
         if (iops_mode(cfqd))
                 charge = cfqq->slice_dispatch;
         cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
 }


-- 
Regards,
Zhao Shuai
