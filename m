From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] cgroup: define controller file conventions
Date: Tue, 4 Aug 2015 10:53:53 -0400
Message-ID: <20150804145353.GC17598@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804084855.GK25159@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FaOJJeDxtt7gkk1rWsDGT4L5tzYzQbEV9+KMN5+F2qo=;
        b=Ieotrq8mGNfXlQrUzRjoO4aAmS47W2hHztXukd8/pHYZLcDgb63n6/HSmHYVY6V6qQ
         4GJ+vpbISsYgKUpDhUmew25+sbwO9QQ9VYvhISGBpAqzoUL56YVgrPzJHC4DN4JFcHkZ
         Chi850ujEgWGaLjQJhcJAwNcJek1JkJ/ST7bMzqUAeyOoLmCKMh/nsuByHZCKqemyoiH
         8VkTqFnMq1/YFDU7xlrHITAj2HrreXzecMRS3KNC0LjlRMcPs9Oi6N3Zg0g9utYjvXop
         pX20gg0PCDQ1UZfd8iDz+YEB7Tzj2Pb5NXlG/C21fV7rbnpLugieV12QxseCbNf4URq/
         Gv5w==
Content-Disposition: inline
In-Reply-To: <20150804084855.GK25159@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello, Peter.

On Tue, Aug 04, 2015 at 10:48:55AM +0200, Peter Zijlstra wrote:
> > +- If a controller implements ratio based resource distribution, the
> > +  control knob should be named "weight" and have the range [1, 10000]
> > +  and 100 should be the default value.  The values are chosen to allow
> > +  enough and symmetric bias in both directions while keeping it
> > +  intuitive (the default is 100%).
> 
> Aside from 100% being a sane 'default', what it actually is is a unit.
> 100% == 1.
> 
> So I would suggest naming the thing CGROUP_WEIGHT_UNIT := 100,

It's a minor point either way but I think people would generally find
default more familiar.

> > +/*
> > + * All weight knobs on the default hierarhcy should use the following min,
> > + * default and max values.  The default value is the logarithmic center of
> > + * MIN and MAX and allows 100x to be expressed in both directions.
> > + */
> > +#define CGROUP_WEIGHT_MIN		1
> > +#define CGROUP_WEIGHT_DFL		100
> > +#define CGROUP_WEIGHT_MAX		10000
> 
> That said, I'm not entirely keen on having to change this.

Yeah, changing the scale is an icky thing to do but I think the
benefits of unifying the scales across different controllers outweigh
here.

Thanks.

-- 
tejun
