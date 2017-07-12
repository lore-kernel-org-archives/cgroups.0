From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Wed, 12 Jul 2017 09:45:55 +0200
Message-ID: <20170712074555.slefkebvdpfjse34@hirez.programming.kicks-ass.net>
References: <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
 <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
 <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
 <8f9c83d7-cadf-3a41-8e56-5828d5abfa26@redhat.com>
 <20170711121527.imshmmoe4cj7dkig@hirez.programming.kicks-ass.net>
 <a554d16c-af40-756e-a611-a453451c40a9@redhat.com>
 <20170711165233.xx6wko4pdxk4rb72@hirez.programming.kicks-ass.net>
 <0659619a-067d-b542-918c-e468c51feb23@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tYFkqDsZECn/TEIsdEwMkLNVppLtHwTvQewrXzUwZfo=; b=goRwd3Abkma95zZ+7IQ5ljav4
        eRjaYJOgidILEl4Kc0eSR/Fa7Gkquj93W+IK1iuRQ0IIDaOHdkUdAAvJAZxJC9iQLi/odup4Af/q+
        MzLYZs4ZTwcm+1gSWlxN1jOkauqiRSFra2wiRAPaYgQw2K/4U9wYPkUOS5fy8jN/q+PHy+fyxGXUd
        MAF8GPZYMu15RcZo+Ly0h3/Ysn5lMPSGbyr09uBxc9TOBzstMxa3VSm0yhZM7j/GWJIyX2YYztQbl
        /mbf6jgQauBryt1eV5svzUQLiEWniGCjlsajarxUaxNXgacJixYeN50QzSH8RlnLwtLPt/+ZrJtzV
      
Content-Disposition: inline
In-Reply-To: <0659619a-067d-b542-918c-e468c51feb23-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Tue, Jul 11, 2017 at 05:12:39PM -0400, Waiman Long wrote:
> On 07/11/2017 12:52 PM, Peter Zijlstra wrote:
> > On Tue, Jul 11, 2017 at 10:14:42AM -0400, Waiman Long wrote:
> >
> >> The "join" was a special op for the children of cgroup root to join the
> >> root as part of a threaded subtree. The children can instead use the
> >> "enable" option to become a thread root which was the configuration
> >> shown above.  This behavior applied only to children of root. Down the
> >> hierarchy, you can't have configuration like:
> >>
> >>      R (t=0)
> >>     / \
> >>        D (t=1)
> >>       / \
> >>      T   D (t=1)
> > Why not?
> >
> > First you create:
> >
> >       R (t=0)
> >      / \
> >         D (t=1)
> >        / \
> >       T   T (t=1)
> >
> > Then you flip t=0 like:
> >
> >       R (t=0)
> >      / \
> >         D (t=1)
> >        / \
> >       T   D (t=0)
> >
> > And then you flip t=1 again:
> >
> >       R (t=0)
> >      / \
> >         D (t=1)
> >        / \
> >       T   D (t=1)
> 
> Tejun's thread mode patch has constraints on what operations are allowed
> and what aren't. For a threaded subtree, thread mode cannot be disabled
> in the middle of the tree.

Where in that scenario did I change anything in the middle? All
operations were on a leaf group.
