From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Thu, 12 Apr 2012 14:53:19 -0300
Message-ID: <4F87168F.3060405@parallels.com>
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120412174155.GC13069-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On 04/12/2012 02:41 PM, Tejun Heo wrote:
> I'm still split on the issue.
>
> * #tasks as unit of accounting / limiting is well understood (or at
>    least known).  I think this holds the same to #open files, to a
>    lesser extent.  It means there are and will continue to be people
>    wanting them.  So, they have some value in familiarity - "but... I
>    want to limit the resources consumed by tasks cuz that's what I
>    know!" factor.
>
> * People could want counting and limiting #tasks or #open files
>    without the overhead of tracking all memory resources.  This stems
>    from the same reason #tasks was used for this sort of things in the
>    first place.  Counting tasks or open files tends to be easier and
>    cheaper than tracking all memory allocations.
>
> So, there's spectrum of solutions between merging task counter and
> just directing everyone to kmem without distinguishing task resource
> at all, and at the moment voices in my head are succeeding at making
> cases for both directions.  What do you guys think about the above two
> issues?
>

About each of your points:

1) Quite honestly, if we were implementing what people say they want...
We'd have a lisp interpreter in the kernel by now.
At the very best, it is an issue of getting the communication right.
I really don't think this is of any concern.

2) It is dependent on the previous question/answer. Do people really 
want to account and limit that? Or do they just think they want?

Also note that we need to make memcg cheaper anyway... And right not it 
is not *that* expensive if you are not doing deep hierarchy.

user pages get cached through the stock mechanism, slab pages are not 
very frequently allocated (because first you need to exhaust the objects 
on the slab, etc)
