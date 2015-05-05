From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 15:06:03 -0400
Message-ID: <20150505190603.GZ1971@htj.duckdns.org>
References: <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
 <20150505141838.GR1971@htj.duckdns.org>
 <20150505151949.GQ21418@twins.programming.kicks-ass.net>
 <20150505163112.GU1971@htj.duckdns.org>
 <20150505190057.GR23123@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SiJSOEe3UnBTIo8NZwDiW0hVzzkP1afuURIEysF/bU0=;
        b=FFzYxI48857moh5KVZcMWEYOTC/zfpy5rB1R9/2adpmnzmFvFoFHvlSHOhYtbTPue/
         Rpk8X2vp4Aogd+74zpbzGFcEbMaoAyG5/BSHysLYUA/Btsx8LNOLLtIAWUcYKp8OagVv
         s1kQxEPXgiELj3C5sLdV2naQjCaeiO9h/Q8bYQhqDtCfT9CUVRtTT4q1uO/qjykgovGd
         66hg2bGFhcpg3o0iDokNEvP0UvVK3wqw1qL0CpdR8Zrzd5JChL0qo/ae9UELBSBVJoQg
         8iIbYsDJeqnK5f5rnK3GRDWWso3b57FEqPScXIMmPaDYLzQFXkVtF70vtZZEJJE41KDZ
         QAbw==
Content-Disposition: inline
In-Reply-To: <20150505190057.GR23123-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Peter.

On Tue, May 05, 2015 at 09:00:57PM +0200, Peter Zijlstra wrote:
> On Tue, May 05, 2015 at 12:31:12PM -0400, Tejun Heo wrote:
> > What I don't want to happen is controllers failing migrations
> > willy-nilly for random reasons leaving users baffled, which we've
> > actually been doing unfortunately.  Maybe we need to deal with this
> > fixed resource arbitration as a separate class and allow them to fail
> > migration w/ -EBUSY.
> 
> Ah, _that_ was the problem.
> 
> Which is something created by this co-mounting of controllers.

Yeah, partly, but also that it's an extra failure mode which isn't
necessary for most controllers.

> You could of course store the ss-id of the failing operation in
> task_struct and have a file reporting the name of the ss-id.
> 
> That way, there is a simple way to find out which controller failed the
> migrate.

Given that the resources which can fail are very limited, I don't
think we need that right now as long as we limit and document the
possible failure cases clearly.  Hopefully, this won't devolve into
collection of arbitrary failures.

Thanks.

-- 
tejun
