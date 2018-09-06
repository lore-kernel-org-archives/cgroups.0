From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 13/15] blkcg: change blkg reference counting to use
 percpu_ref
Date: Thu, 6 Sep 2018 16:46:30 -0400
Message-ID: <20180906204629.GD26048@dennisz-mbp.dhcp.thefacebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-14-dennisszhou@gmail.com>
 <20180901003159.GK1488037@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=615dcgvYagoVUaB+AgYoQbpcTQ8B8tOaJJYCjiBxilk=;
        b=cpYKw5b57qvqc0mnWpsXkj7AztK+R0aUxg8yy/Hbvb/Sw/MUepAmkYWeYdi1e9qS96
         9YcgWBUAGWZB8r+RTbfqnmuDhy3BqRlkrCDzPJwPrXlyVt/uDBj3njpcf0LK//f66aTZ
         Pbl3Ai1nHDhbKt0xpMglJmJKcxtB37Gu0EdD0E9Z95O8uZ7RmyD4RUMGwD65gTyWz2Yj
         uYJpJRyJEFfj4kUyzcEaVHiIETYNRRl3uANvbF+Pt8o0QWVovq9fB010pZyFW6WwXeqq
         E6d8E4U4WRL+gMRAP/oTflD0K5wHrvnzb8IlLJQOEwYFPsDTuPYRff4Ojigj9iSysgxw
         qtbw==
Content-Disposition: inline
In-Reply-To: <20180901003159.GK1488037@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 31, 2018 at 05:31:59PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 30, 2018 at 09:53:54PM -0400, Dennis Zhou wrote:
> > @@ -217,6 +240,10 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
> >  		blkg_get(blkg->parent);
> >  	}
> >  
> > +	ret = percpu_ref_init(&blkg->refcnt, __blkg_release, 0, GFP_KERNEL);
> 
> So, while this would work in some configs, you can't depend on RCU
> grace period inside percpu_ref.  blkg is now percpu-reference counted
> and rcu protected object - it has to explicitly go through a rcu grace
> period before release.
> 

Ah ok. I've made it into a call_rcu which should work.

Thanks,
Dennis
