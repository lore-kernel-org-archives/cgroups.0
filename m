From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Tue, 11 Jul 2017 14:15:27 +0200
Message-ID: <20170711121527.imshmmoe4cj7dkig@hirez.programming.kicks-ass.net>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
 <20170627070143.GB4114@worktop>
 <20170630132324.GA18669@htj.duckdns.org>
 <20170710083200.poevcjo7x47hy5ni@hirez.programming.kicks-ass.net>
 <8f9c83d7-cadf-3a41-8e56-5828d5abfa26@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wpxrPcQTdNdBl8NaWNryomzJtguXWkn43xrdwWTdMKc=; b=JmcVnksnBHGzwDm4sSN+l1nz7
        Fgf3AwrlPUeAKLbHS1mcBORQXdd5UOnWEbaOebqQEMchAwVZxjwBCxqjuVCUYM6Iw1iyiTH5fgvWV
        g1WWb4UGBkp83CTrWjIKUwYy2w54Yy+INrQuKTQLRyyRhYahrY3Pmf9WsiZWbOEeUHicFbt9V2wkM
        ptFf8TftQTYkiffH7WyLYke3kBFc9GBnssWKjBKkAnXVPF74HwGj1/rC5wfJr3090nvVRGp/gzXYf
        CWqA1GzMvzwVc0n7x5yiwH3JnVG2Vq1L74wo5DINkZx/jr3l9pcBXzBoGVMWF1J/DUd8GRBlyuH9v
      
Content-Disposition: inline
In-Reply-To: <8f9c83d7-cadf-3a41-8e56-5828d5abfa26-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, Jul 10, 2017 at 05:01:19PM -0400, Waiman Long wrote:
> On 07/10/2017 04:32 AM, Peter Zijlstra wrote:
> > On Fri, Jun 30, 2017 at 09:23:24AM -0400, Tejun Heo wrote:
> >> On Tue, Jun 27, 2017 at 09:01:43AM +0200, Peter Zijlstra wrote:
> >>> On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:
> >>> IIRC the problem with the 'threaded' marker is that it doesn't clearly
> >>> capture what a resource domain is.
> >>>
> >>> That is, assuming that a thread root is always a resource domain, we get
> >>> the following problem:
> >>>
> >>> If we set 'threaded' on the root group in order to create a thread
> >>> (sub)group. If we then want to create another domain group, we'd have to
> >>> clear 'threaded' on that.
> >>>
> >>> 	R (t=1)
> >>>        / \
> >>> (t=1) T   D (t=0)
> >>>
> >>> So far so good. However, now we want to create another thread group
> >>> under our domain group D, so we have to set its 'threaded' marker again:
> >>>
> >>> 	R (t=1)
> >>>        / \
> >>> (t=1) T   D (t=1)
> >>>          /
> >>> 	T (t=1)
> 
> This configuration is actually not possible with Tejun's latest v3 patch
> which took out the "join" operation. Maybe we should keep the "join"
> operation if this configuration is likely to happen.

Wait what? Why not? That's a fairly fundamental setup that needs to be
possible. I understood the 'join' thing was for something else entirely.
TJ said the 'join' was to allow thread-roots that were not domain
controllers -- which I didn't get the point of.

> >>> And we can no longer identify D as a resource domain. If OTOH we mark
> >>> 'domain' we get:
> >>>
> >>> 	R (d=1)
> >>>        / \
> >>> (d=0) T   D (d=1)
> >>>          /
> >>> 	T (d=0)
> >>>
> >>> Which clearly identifies the domains and the thread only groups.
> >> So, the difference between the two interfaces is that the one I
> >> proposed is marking the thread root which makes all its descendants
> >> threaded while the above is marking each individual cgroup as being
> >> whether a resource domain or threaded.
> > You start by marking the thread root, but then continue to mark all
> > 'threaded' (including root). This then leads to the problem described
> > above where you cannot (easily) (re)discover what the actual root is.
> 
> I don't think that is true. Internally, we can always find out if a
> cgroup is a thread root. Externally, the presence of resource domain
> control knobs in a threaded cgroup will indicate that it is a thread root.

You're confusing thread root with resource domain. While a resource
domain must be a thread root the reverse is not necessarily so (this is
what I understood the 'join' thing to be for).

And this is detection by inference, which breaks the moment you disable
all resource domain controllers, because at that point those files will
not be present.

> > My proposal differs in that we retain a clear difference between
> > resource domain / root and threaded (sub)trees.
> 
> For me, I have no preference of using either the threaded or the domain
> marker as long as some kind of join operation that allows the
> configuration above is present in the thread mode. They both looks good
> to me. It is just a matter of which aspect of the cgroup we want to
> emphasize. I would suggest we reach a consensus ASAP and move forward to
> other more substantial issues in cgroup v2.

I think you're confused on join. Join should not be needed.
