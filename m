From: Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH v2 12/17] cgroup: Remove cgroup v2 no internal
 process constraint
Date: Sat, 20 May 2017 04:10:07 +0200
Message-ID: <1495246207.7442.2.camel@gmx.de>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
	 <1494855256-12558-13-git-send-email-longman@redhat.com>
	 <20170519203824.GC15279@wtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170519203824.GC15279@wtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net

On Fri, 2017-05-19 at 16:38 -0400, Tejun Heo wrote:
> Hello, Waiman.
> 
> On Mon, May 15, 2017 at 09:34:11AM -0400, Waiman Long wrote:
> > The rationale behind the cgroup v2 no internal process constraint is
> > to avoid resouorce competition between internal processes and child
> > cgroups. However, not all controllers have problem with internal
> > process competiton. Enforcing this rule may lead to unnatural process
> > hierarchy and unneeded levels for those controllers.
> 
> This isn't necessarily something we can determine by looking at the
> current state of controllers.  It's true that some controllers - pid
> and perf - inherently only care about membership of each task but at
> the same time neither really suffers from the constraint either.  CPU
> which is the problematic one here...

(+ cpuacct + cpuset)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
