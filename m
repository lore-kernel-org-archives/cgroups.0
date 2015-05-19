From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem
 with a global percpu_rwsem
Date: Tue, 19 May 2015 11:51:33 -0400
Message-ID: <20150519155133.GM24861@htj.duckdns.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <1431549318-16756-3-git-send-email-tj@kernel.org>
 <20150519151659.GF3644@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GPAplxLn6+gXctrg4aKq7ibT2jOcGli3anXUORMHtvU=;
        b=mWomeY3kCtCqjeNjabttYrFyMhO8UnlCJvO4j548/DY2j7EIlvF21RwKhfkaRHsn5f
         Dli7JJqfnTokXnIaIwu5P/MZmNyPvfpOkZjHZ3xjwVVf2XYQ0CJE0w+JnyrILSG/ys0A
         vDLgQAPRsmnU6peahafAUNHmWipngKvk1twMTVSrkkskvMX2JyOECLiQWLZx2JoCHYKY
         TRSg6+nmoRoweVh1XKqKt22TqWY0/c143bqUGOYop6ThHfRXftYg9XiD71diVhOIl+WR
         ARfRYNkZT1hThnPL9Bc2vRHKB/8GLqgrlonqnuWb7nSLX1HTR/AfgWUAy4k8UMFEPXK6
         BZmA==
Content-Disposition: inline
In-Reply-To: <20150519151659.GF3644-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Peter.

On Tue, May 19, 2015 at 05:16:59PM +0200, Peter Zijlstra wrote:
> .gitconfig:
> 
> [diff "default"]
>         xfuncname = "^[[:alpha:]$_].*[^:]$"
>
> Will avoid keying on labels like that and show us this is
> __cgroup_procs_write().

Ah, nice trick.

> So my only worry with this patch-set is that these operations will be
> hugely expensive.
> 
> Now it looks like the cgroup_update_dfl_csses() thing is very rare, its
> when you change which controllers are active in a given subtree under
> the uber-l337-super-comount design.
> 
> The other one, __cgorup_procs_write() is every /procs, /tasks write to a
> cgroup, and that does worry me, this could be a somewhat common thing.
>
> The Changelog states task migration is a cold path, but is tens of
> miliseconds per task really no problem?

The latency is bound by synchronize_sched_expedited().  Given the way
cgroups are used in majority of setups (process migration happening
only during service / session setups), I think this should be okay.

I agree that something which is closer to lglock in characteristics
would fit the workload better tho.  If this actually becomes a
problem, we can come up with a different percpu locking scheme which
puts a bit more overhead on the reader side to reduce the latency /
overhead on the writer side which shouldn't be that difficult but
let's see whether we need to get there at all.

Thanks.

-- 
tejun
