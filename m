From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 10:18:38 -0400
Message-ID: <20150505141838.GR1971@htj.duckdns.org>
References: <5546C34C.7050202@huawei.com>
 <1430709236.3129.42.camel@gmail.com>
 <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jde5xhsQmf9jJuuZF1NefwTktXrFTFu5vatj0uNfwac=;
        b=SW0xn6kZHEEhatLvbrSC5i+9CkW/2+wTVIpdAJO+FlmLBrF/u+KPJPRuxGUmT1mNd1
         Gbz8b3qpFMhqQcDltNp5AWwPs/snp/38xALdYzwcTys61kcy/89z3VyCYA+J26qFIlnO
         NdVRdj89Qn8EqHB7s3ciNyuQcdw2hzwsefDp7Awm5RbzD8eHiE1YdXd2tlP6SiwrVUQy
         FPPfK3fkXTQJpsXKvbCWuHnKWgYvx30fkS3+3J05ZlDK55YDgu6xZNQDEIjtYKu0EGfb
         hn/Fk8y8PGJzzkSLh8RjDfwxcMfOlVoEL6CHNXcezM9CEj5NuigvdETt9x1sByO6eqcE
         qD3A==
Content-Disposition: inline
In-Reply-To: <20150505141049.GN21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Peter.

On Tue, May 05, 2015 at 04:10:49PM +0200, Peter Zijlstra wrote:
> Imagine:
> 
> 	  root
> 	 /    \
> 	A      B
>        / \    / \
>       a1 a2  b1 b2
> 
> Now if they all have -1, I cannot set a bw on any except the leaf nodes
> ([ab][12]). Because the sum of child bw must strictly be smaller or
> equal to the parent bandwidth, and -1 if effective inf.
> 
> Similarly, if A has bw enabled I cannot create a new child with -1.
> Because above.
> 
> Now you can kludge around some of this, for example you can make the
> default depend on the parent setting etc.. But that's horribly
> inconsistent.

I don't think we can kludge this.  For all other resources, we're
defining the limits that can't be crossed so nesting them w/ -1 by
default is fine.  RR slices are different it that we're really slicing
up and guaranteeing a portion of something finite, so unlimited by
default thing doesn't really work here.

> So I really prefer not to go that way; if people use RR/FIFO they had
> better bloody know what they're doing; which includes setting up the
> system.

The problem is that this is tied to the normal cpu controller.  Users
who don't have any intention of mucking with RT scheduling end up
being dragged into it.  Given the strict nature of RR slicing, I'm
don't even think it's actually useful to make the slicing
hierarchical.  From cgroup's POV, it'd be best if RR slicing can be
detached.

> The whole RR/FIFO thing is so enormously broken (by definition; this
> truly is unfixable) that you simply _cannot_ automate it.

Yeah, exactly.

Thanks.

-- 
tejun
