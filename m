From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 04 May 2015 16:09:42 +0200
Message-ID: <1430748582.3166.16.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
	 <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>
	 <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com>
	 <554737AE.5040402@huawei.com>
	 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=jdyg5txkDYDBJtCDWFVLyMtp9xZludAFTcGnNbKVASk=;
        b=toOptq4KFPjnj2rNUMtuI19DHCCYrmKH9UPBcHNFffw0Eglbq48bLV19vzqPkLYUWL
         FoxcwCOPDmHORFumBlJa4PhofAm2kG3gkKKxxMJ5M18P9NKGzZAvgLrIeM6MQjDb04qs
         hyR88jjld1h/7HF7V/kQXiJ4Qpa1ZOJq0YsJv0AATWOQBy4YATi4x7sYLktS/YVmfaXW
         pBTKCpVCTO5s+68f6cRwjcbaVCe1Fkr6AlVF53nR19R0aitKhAlti5LLrhzqLclmhvHy
         YsTRvQJqeBGIQMpe2K40y7leGby3rdXeVVVA0yUHIw+BqdpZxZKl63O07KcMdfR/khRg
         n+JQ==
In-Reply-To: <20150504123738.GZ21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zefan Li <lizefan@huawei.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Mon, 2015-05-04 at 14:37 +0200, Peter Zijlstra wrote:
> On Mon, May 04, 2015 at 05:11:10PM +0800, Zefan Li wrote:
> 
> > Some degree of flexibility is provided so that you may disable some controllers
> > in a subtree. For example:
> >
> > root                  ---> child1
> > (cpuset,memory,cpu)        (cpuset,memory)
> >                       \
> >                        \-> child2
> >                            (cpu)
> 
> Uhm, how does that work? Would a task their effective cgroup be the
> first parent that has a controller enabled?
> 
> In particular, in your example, if T were part of child1, would its cpu
> controller be root?

That's what I'd hope for.  I wanted to try that cgroup.subtree_control
gizmo to see for myself, but I don't have one, and probably won't get
one until I introduce systemd to my axe (again, it's a slow learner).

	-Mike
