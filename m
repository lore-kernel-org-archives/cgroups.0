From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 12/17] cgroup: Remove cgroup v2 no internal
 process constraint
Date: Wed, 24 May 2017 13:01:40 -0400
Message-ID: <20170524170140.GG24798@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-13-git-send-email-longman@redhat.com>
 <20170519203824.GC15279@wtj.duckdns.org>
 <1495246207.7442.2.camel@gmx.de>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b6k1U1h0fvLCqfmmMPhyEmp0oMbD+/FJ50kKvCJvbcg=;
        b=ZgQ7KHLH2j4k9DtFIgqK92uxcCC10tsdUk2jmK6T+lp7PSPWL6cjxX6Gu6rY17ZB8g
         9axFxD+C69sbQCZY/202QR3UW7da/QEEV8eBHnZiD8mkDm4RsPTwfDy8H/Sg4O3b6rfY
         8uEElxkrXu8ppxqNawJCawvGnd0glczRZYAS8u3Q4ZtPTW1cShiT9F8bCD2IlHAxygas
         E1ov4Y/HYR2iHurk6wqanbCtkvPhoI6rzJrtj3+L1utQ01HAgWkcrC8NbToNgeSmL/h9
         fYxCL5cOgTSH3kmwPBXNbolgFzmEwRukRvZ/Mv6ePfSopH+TyQZ60v9HlZSRMBXEhBxH
         kcKw==
Content-Disposition: inline
In-Reply-To: <1495246207.7442.2.camel@gmx.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <efault@gmx.de>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net

Hello, Mike.

On Sat, May 20, 2017 at 04:10:07AM +0200, Mike Galbraith wrote:
> On Fri, 2017-05-19 at 16:38 -0400, Tejun Heo wrote:
> > Hello, Waiman.
> > 
> > On Mon, May 15, 2017 at 09:34:11AM -0400, Waiman Long wrote:
> > > The rationale behind the cgroup v2 no internal process constraint is
> > > to avoid resouorce competition between internal processes and child
> > > cgroups. However, not all controllers have problem with internal
> > > process competiton. Enforcing this rule may lead to unnatural process
> > > hierarchy and unneeded levels for those controllers.
> > 
> > This isn't necessarily something we can determine by looking at the
> > current state of controllers.  It's true that some controllers - pid
> > and perf - inherently only care about membership of each task but at
> > the same time neither really suffers from the constraint either.  CPU
> > which is the problematic one here...
> 
> (+ cpuacct + cpuset)

Yeah, cpuacct and cpuset are in the same boat as perf.  cpuset is
completely so and we can move the tree walk to the reader side or
aggregate propagation for cpuacct as necessary.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
