From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v3] sched: cpuset: Don't rebuild root domains on
 suspend-resume
Date: Wed, 1 Mar 2023 15:26:32 +0100
Message-ID: <Y/9gmDRlGOChIwpf@localhost.localdomain>
References: <20230206221428.2125324-1-qyousef@layalina.io>
 <20230223153859.37tqoqk33oc6tv7o@airbuntu>
 <5f087dd8-3e39-ce83-fe24-afa5179c05d9@arm.com>
 <20230227205725.dipvh3i7dvyrv4tv@airbuntu>
 <5a1e58bf-7eb2-bd7a-7e19-7864428a2b83@arm.com>
 <20230228174627.vja5aejq27dsta2u@airbuntu>
 <Y/7/SLzvK8LfB29z@localhost.localdomain>
 <20230301122852.zgzreby42lh2zf6w@airbuntu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677680803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dFfI+7W5JfA3qjbiFdEfsYsg+z7lgNEBSS9MtpBoNwc=;
        b=A6PALloTigbcbLVa0wQgB6LyX3L+qsq4746TI1xz6mccMvtAbw9bqTgkjg1Uj4GGfD3gbn
        GuNnsCWLqRHwHlgjIEYqZbU84Efi2quGCBEDpG21LDykcvYttcU/j2pCcE/Pe5lMKDct7G
        2wpq1fIa/PWShBrJgoG4s9qeoEsleSU=
Content-Disposition: inline
In-Reply-To: <20230301122852.zgzreby42lh2zf6w@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef@layalina.io>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Waiman Long <longman@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <sudeep.holla@arm.com>, Zefan Li <lizefan.x@bytedance.com>, linux-s390@vger.kernel.org, x86@kerne

On 01/03/23 12:28, Qais Yousef wrote:
> On 03/01/23 08:31, Juri Lelli wrote:

...

> > Not ignoring you guys here, but it turns out I'm quite bogged down with
> > other stuff at the moment. :/ So, apologies and I'll try to get to this
> > asap. Thanks a lot for all your efforts and time reviewing so far!
> 
> Np, I can feel you :-)

Eh. :/

BTW, do you have a repro script of some sort handy I might play with?

