From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem
 with a global percpu_rwsem
Date: Thu, 21 May 2015 16:39:43 -0400
Message-ID: <20150521203943.GS24861@htj.duckdns.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <1431549318-16756-3-git-send-email-tj@kernel.org>
 <20150519151659.GF3644@twins.programming.kicks-ass.net>
 <20150519155133.GM24861@htj.duckdns.org>
 <555C5C71.80200@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KpwtBjn6I7t3RlfOYABdsf6UofwfjUN97vyg4mbruVA=;
        b=lTv4d1uc6aX1eXozBEcMl7CjmKno0qNoi3u4LOVFXv+Tmdh1Tq6XVG4C8h0G635VV5
         +o0t2O7n/Wf+wjduTrZ2gyuVFt4HrnScV1m+ZC1U3Wl2IZJjUI/i4XJ1po9hRrNxYgew
         n6T4NrfPviYraXK3E/HlvyQ374+b2XlYMRQEn++9yu703ebiAkCuFoRTgudA28Xt8CBO
         qmGrgMcBVwfRk9jzSY/Gn6SMS2WHTzjEW2K1TyDzpQr4g86z12zVtGez9zs5TtRvWi/5
         p/Yi5ThqBAkd6OtfDIw+Hf+TxXpt7t0kpATprGSVFNcFPIFUlcQS+okFAEUcSL+w/Pj6
         lcGw==
Content-Disposition: inline
In-Reply-To: <555C5C71.80200-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li.

On Wed, May 20, 2015 at 06:05:37PM +0800, Zefan Li wrote:
> > The latency is bound by synchronize_sched_expedited().  Given the way
> > cgroups are used in majority of setups (process migration happening
> > only during service / session setups), I think this should be okay.
> 
> Actually process migration can happen quite frequently, for example in
> Android phones, and that's why Google had an out-of-tree patch to remove
> the synchronize_rcu() in that path, which turned out to be buggy.

It's still not a very frequent operation tho.  We're talking about
users switching fore/background jobs here and the expedited
synchronization w/ preemption enabled doesn't take much time.  In
addition, as it currently stands, android is doing memory charge
immigration on each fore/background switches.  I'm pretty doubtful
this would make any difference.

Thanks.

-- 
tejun
