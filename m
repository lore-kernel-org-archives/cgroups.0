From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Tue, 17 Apr 2012 08:41:17 -0700
Message-ID: <20120417154117.GE32402@google.com>
References: <4F862851.3040208@jp.fujitsu.com>
 <20120412113217.GB11455@somewhere.redhat.com>
 <4F86BFC6.2050400@parallels.com>
 <20120412123256.GI1787@cmpxchg.org>
 <4F86D4BD.1040305@parallels.com>
 <20120412153055.GL1787@cmpxchg.org>
 <20120412163825.GB13069@google.com>
 <20120412172309.GM1787@cmpxchg.org>
 <20120412174155.GC13069@google.com>
 <4F878480.60505@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=B+Jv9zQ94yzlbCyZTR3yEcrOSIVr907FdAesq4LQk0E=;
        b=VXRLsHSKLLSWTv3rKpGkx+Tzq5aE0pS2CLWyMZxk4uHAS15SuvfMSte4HhQZilCV+E
         Ot9K6tzHM8QU1fzbwGnXTCo7dzHKYwlA+KefXFNpY8W8YhvJbAmyXVbdkYpUwM8sEPPm
         306qziZJQka3hG1oejEB16hFloTb2T0AuTUR5K0c9RK1MPp2MWL0qhr6+VlHOW5M+cnK
         QMjIzoq/izIPys0I1Voiw4IMZ0H4c2NJUAg1MvV4xwIaaqBRW4YzzfgZpbodz5eJ7+Ev
         M5rgmeCoBkWGVmT3EyA+fNBsXf7J5ABk/s5T53ynZB4cRtQW46n4PYGbNvcX19mvdAK2
         iMEg==
Content-Disposition: inline
In-Reply-To: <4F878480.60505-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hello, KAMEZAWA.

On Fri, Apr 13, 2012 at 10:42:24AM +0900, KAMEZAWA Hiroyuki wrote:
> > So, there's spectrum of solutions between merging task counter and
> > just directing everyone to kmem without distinguishing task resource
> > at all, and at the moment voices in my head are succeeding at making
> > cases for both directions.  What do you guys think about the above two
> > issues?
> 
> 
> To be honest, I doubt that task counter is unnecessary...memcg can catch
> oom situation well. I often test 'make -j' under memcg.

Heh, the double negation is confusing me.  Were you trying to say that
task_counter is necessary or was it the other way around?

> To the questions
> *   It sounds like a 'ulimit' cgroup. How about overwriting
>     ulimit values via cgroup ? (sounds joke?) Then, overhead will be small but
>     I'm not sure it can be hierarchical and doesn't break userland.
> 
>     If people wants to limit the number of tasks, I think interface should provide it
>     in the unit of objects. Then, I'm ok to have other subsystem for counting something.
>     fork-bomb's memory overhead can be prevent by memcg. What memcg cannot handle
>     is ulimit. If forkbomb exhausts all ulimit/tasks, the user cannot login.
>     So, having task-limit cgroup subsys for a sandbox will make sense in some situation.
> 
> In short, I don't think it's better to have task-counting and fd-counting in memcg.
> It's kmem, but it's more than that, I think.
> Please provide subsys like ulimit.

So, you think that while kmem would be enough to prevent fork-bombs,
it would still make sense to limit in more traditional ways
(ie. ulimit style object limits).  Hmmm....

Thanks.

-- 
tejun
