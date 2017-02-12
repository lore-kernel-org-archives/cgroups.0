From: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Sun, 12 Feb 2017 07:59:59 +0100
Message-ID: <1486882799.24462.25.camel@gmx.de>
References: <20170202200632.13992-1-tj@kernel.org>
         <20170203202048.GD6515@twins.programming.kicks-ass.net>
         <20170203205955.GA9886@mtj.duckdns.org>
         <20170206124943.GJ6515@twins.programming.kicks-ass.net>
         <20170208230819.GD25826@htj.duckdns.org>
         <20170209102909.GC6515@twins.programming.kicks-ass.net>
         <20170210154508.GA16097@mtj.duckdns.org>
         <20170210175145.GJ6515@twins.programming.kicks-ass.net>
         <20170212050544.GJ29323@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170212050544.GJ29323-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sun, 2017-02-12 at 14:05 +0900, Tejun Heo wrote:

> > I think cgroup tree depth is a more significant issue; because of
> > hierarchy we often do tree walks (uo-to-root or down-to-task).
> > 
> > So creating elaborate trees is something I try not to do.
> 
> So, as long as the depth stays reasonable (single digit or lower),
> what we try to do is keeping tree traversal operations aggregated or
> located on slow paths.  There still are places that this overhead
> shows up (e.g. the block controllers aren't too optimized) but it
> isn't particularly difficult to make a handful of layers not matter at
> all.

A handful of cpu bean counting layers stings considerably.

homer:/abuild # pipe-test 1                          
2.010057 usecs/loop -- avg 2.010057 995.0 KHz
2.006630 usecs/loop -- avg 2.009714 995.2 KHz
2.127118 usecs/loop -- avg 2.021455 989.4 KHz
2.256244 usecs/loop -- avg 2.044934 978.0 KHz
1.993693 usecs/loop -- avg 2.039810 980.5 KHz
^C
homer:/abuild # cgexec -g cpu:hurt pipe-test 1
2.771641 usecs/loop -- avg 2.771641 721.6 KHz
2.432333 usecs/loop -- avg 2.737710 730.5 KHz
2.750493 usecs/loop -- avg 2.738988 730.2 KHz
2.663203 usecs/loop -- avg 2.731410 732.2 KHz
2.762564 usecs/loop -- avg 2.734525 731.4 KHz
^C
homer:/abuild # cgexec -g cpu:hurt/pain pipe-test 1
2.967201 usecs/loop -- avg 2.967201 674.0 KHz
3.049012 usecs/loop -- avg 2.975382 672.2 KHz
3.031226 usecs/loop -- avg 2.980966 670.9 KHz
2.954259 usecs/loop -- avg 2.978296 671.5 KHz
2.933432 usecs/loop -- avg 2.973809 672.5 KHz
^C
...
homer:/abuild # cgexec -g cpu:hurt/pain/ouch/moan/groan pipe-test 1
4.417044 usecs/loop -- avg 4.417044 452.8 KHz
4.494913 usecs/loop -- avg 4.424831 452.0 KHz
4.253861 usecs/loop -- avg 4.407734 453.7 KHz
4.378059 usecs/loop -- avg 4.404766 454.1 KHz
4.179895 usecs/loop -- avg 4.382279 456.4 KHz
