From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: About cgroup memory limits
Date: Wed, 23 May 2012 10:07:28 +0200
Message-ID: <20120523080727.GJ1800@cmpxchg.org>
References: <1336685923.15687.1.camel@andre>
 <20120515092040.GF1406@cmpxchg.org>
 <1337174128.2759.33.camel@Thor>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337174128.2759.33.camel@Thor>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michel Machado <michel-K36Kqf6HJK439yzSjRtAkw@public.gmane.org>
Cc: Andre Nathan <andre-K36Kqf6HJK439yzSjRtAkw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 16, 2012 at 09:15:28AM -0400, Michel Machado wrote:
> Hi Johannes,
> 
>    Thank you very much for your reply, it does help us to understand the
> numbers we have at hand.
> 
>    Could you clarify your following statement further:
> 
> > > Below is the sum of each field in /proc/$PID/statm for every process
> > > running inside a test container, converted to bytes:
> > > 
> > >        size  resident     share     text  lib       data  dt
> > >   897208320  28741632  20500480  1171456    0  170676224   0
> > 
> > statms accounts based on virtual memory, not physical memory like
> > memcg does.  If you have the same page mapped into two tasks, both
> > their "share" counters will show a page, while the memcg will only
> > account the single physical page in mapped_file.
> 
>    You mean when those two tasks are in the same cgroup, don't you? Is
> there a case in which a page is shared by two tasks that are in
> different cgroups but that page is accounted only for one of the two
> cgroups? If so, how's this case triggered?

It doesn't matter whether it's the same cgroup or separate cgroups.

When two tasks are in separate memory cgroups, the shared page will be
accounted to the group of the task that is responsible for bringing it
into memory, the one touching it for the first time.
