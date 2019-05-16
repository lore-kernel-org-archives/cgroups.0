From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] signal: unconditionally leave the frozen state in
 ptrace_stop()
Date: Thu, 16 May 2019 10:45:23 -0700
Message-ID: <20190516174523.GD374014@devbig004.ftw2.facebook.com>
References: <20190516173821.1498807-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TZW9oPjKjF7UuQfNRNZlJhWogoRZGc1JB7uoqoIfv+8=;
        b=U+/Dsbpe3Ev8qOz5ABegg4QwYrxhkHAqm6TrtgUJZMxYDxJyKNRkrRR2BomF+w8bGA
         JeXPRak510vhmmzJ8bRXqpXFQtGibDSo/kyK2zYtiw+D7B7H/6Gb/lGYxPaHanLuyx5i
         gUYWYVTnZ5fNLpvZmPoI1/hpBdL/MlRiTGoXmomSU60h70cP2MeSUERNp3AMtK+BAXOR
         753TXbfYLlPuastYz2vzgY435v4UWD/63ouWJF2lzPjL0KwD1TPbqNzSVAQQTSmrFxD3
         BiH4q8vfb1Vc8YX3FlMIFhHYqPuYMeE0fF9Zpl545yER8ygpzwARFTZi9cGlYGk6xKUt
         f7dA==
Content-Disposition: inline
In-Reply-To: <20190516173821.1498807-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alex Xu <alex_y_xu@yahoo.ca>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 16, 2019 at 10:38:21AM -0700, Roman Gushchin wrote:
> Alex Xu reported a regression in strace, caused by the introduction of
> the cgroup v2 freezer. The regression can be reproduced by stracing
> the following simple program:
> 
>   #include <unistd.h>
> 
>   int main() {
>       write(1, "a", 1);
>       return 0;
>   }
> 
> An attempt to run strace ./a.out leads to the infinite loop:
>   [ pre-main omitted ]
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   write(1, "a", 1)                        = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
>   [ repeats forever ]
> 
> The problem occurs because the traced task leaves ptrace_stop()
> (and the signal handling loop) with the frozen bit set. So let's
> call cgroup_leave_frozen(true) unconditionally after sleeping
> in ptrace_stop().
> 
> With this patch applied, strace works as expected:
>   [ pre-main omitted ]
>   write(1, "a", 1)                        = 1
>   exit_group(0)                           = ?
>   +++ exited with 0 +++
> 
> Reported-by: Alex Xu <alex_y_xu@yahoo.ca>
> Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-5.2-fixes.

Thanks.

-- 
tejun
