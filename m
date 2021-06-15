From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/4] cgroup/cpuset: Allow cpuset to bound displayed cpu
 info
Date: Tue, 15 Jun 2021 11:59:25 -0400
Message-ID: <YMjGXlwQEHFwXZ4/@slm.duckdns.org>
References: <20210614152306.25668-1-longman@redhat.com>
 <YMe/cGV4JPbzFRk0@slm.duckdns.org>
 <0e21f16d-d91b-7cec-d832-4c401a713b10@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GL+RU9f1AKmMjTvDhvbMJyhE7RlsIlk2mxWhqIrVH80=;
        b=jkq8Km4vHTP7xZdrBvuBD4dByJ3zPoS+EImCYNZJ7O2IRlpr0D0e7kKl3ZXrex3iEj
         EKbrXTLwfwseiGI0RACOJgzGGcn7IRmzsobaa3/g8UYVQgWtCLTeMkK1y45t7JJg7E4G
         pGUhbQA0ppXUGAcG4qnauwNA3tYW6f1mm/77DyS53+guGLUR+UeaUKC+gvu9a1fxHza7
         FCR+80zeNEJUhhaYae5sZM+lTC0Lc6xzJrFDbWdadTr8AcOtAcc4ZCyvvVySiWXaTsHv
         ioDfO+9kBeUDmvBjr4hUmoEjD6wQxXww9KLyipFDbDLCELWSFIPAL0dwTvcAKYYHpOvF
         KuEA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <0e21f16d-d91b-7cec-d832-4c401a713b10@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, x86@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hello, Waiman.

On Mon, Jun 14, 2021 at 10:53:53PM -0400, Waiman Long wrote:
> Thanks for your comment. I understand your point making change via cgroup
> interface files. However, this is not what the customers are asking for.

It's not like we can always follow what specific customers request. If there
are actual use-cases that can't be achieved with the existing interfaces and
features, we can look into how to provide those but making interface
decisions based on specific customer requests tends to lead to long term
pains.

> They are using tools that look at /proc/cpuinfo and the sysfs files. It is a
> much bigger effort to make all those tools look at a new cgroup file
> interface instead. It can be more efficiently done at the kernel level.

Short term, sure, it sure is more painful to adapt, but I don't think longer
term solution lies in the kernel trying to masquerage existing sytsem-wide
information interfaces. e.g. cpuset is one thing but what are we gonna do
about weight control or work-conserving memory controls? Pro-rate cpu count
and available memory?

> Anyway, I am OK if the consensus is that it is not a kernel problem and have
> to be handled in userspace.

I'd be happy to provide more information from kernel side as necessary but
the approach taken here doesn't seem generic or scalable at all.

> BTW, do you have any comment on another cpuset patch that I sent a week
> earlier?
> 
> https://lore.kernel.org/lkml/20210603212416.25934-1-longman@redhat.com/
> 
> I am looking forward for your feedback.

Sorry about the delay. Will take a look later today.

Thanks.

-- 
tejun
