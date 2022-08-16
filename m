From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 07:52:51 -1000
Message-ID: <YvvZc7KgZT/bRoKl@slm.duckdns.org>
References: <20220816151119.29534-1-longman@redhat.com>
 <20220816151119.29534-4-longman@redhat.com>
 <YvvR2Sa6LxZLwXsJ@slm.duckdns.org>
 <349849aa-937d-8b08-a836-7c5c70168139@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=eQ2NahsvhVwzDF3w07e6eihKRt+nAgyrGOVPsy4ALjQ=;
        b=btGDKJUPdlCBMrCw0W7r+qRR0ygNQM+t19v7X/E8232ZCf5d1iJ5myUaogZDT0bQ+r
         P5HD4RaRb+zs7sWXrIcFBQgiYQhl6Bs2UEdFxTX+cFRiu0qaH2dYUfWBHTXgbym5bfRB
         SslXBcZNrxU0Ff9BRXgujiqqE48oYo2NT3XmBYEnPWfBl8Fcgl+WJkFxK0Iv8L+CSD4P
         18THZJfa0IDp2ZfwOX1m7OoctLlK1IG2qEjwVhqxtefmHCkjDAW71MdQO70B2pHpqI5A
         9989hu8AEup2dHvUaz2KIjm2pi5wAFxPdjK66SV6P6+d6KAcGKs9VUrYlOL+tzoZo8RC
         bOyQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <349849aa-937d-8b08-a836-7c5c70168139-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Tue, Aug 16, 2022 at 01:38:17PM -0400, Waiman Long wrote:
> Yes, a race like this is possible. To completely eliminate the race may
> require taking task_rq_lock() and then calling
> __set_cpus_allowed_ptr_locked() which is internal to kernel/sched/core.c.
> 
> Alternatively, we can check user_cpus_ptr again after the scond
> set_cpus_allowed_ptr() and retry it with the other path if set. That will
> probably address your concern. Please let me know if you are OK with that.

I think this would look better if structured the other way around - make the
scheduler side call out to cpuset to query the current restrictions and
apply it atomically.

Thanks.

-- 
tejun
