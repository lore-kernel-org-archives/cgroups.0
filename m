From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 3/5] cgroup/cpuset: make callback_lock raw
Date: Wed, 7 Nov 2018 07:53:30 -0800
Message-ID: <20181107155330.GA2509588@devbig004.ftw2.facebook.com>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-4-juri.lelli@redhat.com>
 <20180925143416.GD25664@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HBsAi1/zcZAhn1DpkP41LMbYfHFLfREhipwh3kGR2xo=;
        b=iL0UAfC2UGyt6OXwjIQ/5Oaz2YM3Z6r+yDWkZFh9CR4NqgujrVr1N2KU3ImG/Z2Su+
         JvLXGtsP3GWr3Bj2peJ6/akjTIwlZLkGamlZYu2ONIvkBSHawVd9MefI6idhhkDjZMQ1
         hkHNtSgG0iqhE8SG55a5B+GvJhYIdLaJhUoviHQTsG9sVX7NRvrUmhtPfqYmVupLGQtc
         08jj9Oyh+iT1bdJIP+XpTDiO8CJ9wJLlH/mzecWhS78jqB1PVJ1zdzQu/j1GoQPZaS8R
         uRiJpYgvnzNbNl+5YGvEXdnYeZfxVEHBZ63GEKSTWgpjqDfeDLI9zj2zTqv4DXlfNuh5
         vdXQ==
Content-Disposition: inline
In-Reply-To: <20180925143416.GD25664@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: lizefan@huawei.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org

Hello,

On Tue, Sep 25, 2018 at 04:34:16PM +0200, Juri Lelli wrote:
> It would be great if you could please have a look at the proposed change
> below (and the rest of the set of course :-).

Yeah, looks good to me.  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

> Another bit that I'd be more comfortable after hearing your word on it
> is this one (discussed over 5/5):
> 
> https://lore.kernel.org/lkml/20180925130750.GA25664@localhost.localdomain/

Can you please loop Waiman Long <longman@redhat.com> into discussion?
He's working on cgroup2 cpuset support which might collide.

Thanks.

-- 
tejun
