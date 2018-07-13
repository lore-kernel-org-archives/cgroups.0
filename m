From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 10/10] psi: aggregate ongoing stall events when
 somebody reads pressure
Date: Fri, 13 Jul 2018 18:17:58 -0400
Message-ID: <20180713221758.GB30013@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-11-hannes@cmpxchg.org>
 <20180712164537.324caee21fd68c47a02af009@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HgM7KHro5Gn8WNFQAxB6p2phFCYiHpaJFw0eoGoMk8o=;
        b=clRff0t/LKxP2MAaKBPTBh6Qov9zX5p9iR/gHqVHyfMmhtD2h1qWXdpw0+wLNLY8a1
         gyeRVdlbeRgCMBW0JNzjxSLveVg4ZFYmX/Xy3qK443tfiRtUSLhKCJMhJhK6Y88culc2
         82lWFICVR9lA99h2Jd++55g0BBv7bMAYw4+SLWlNkMlLUeFBOqf1ynNNEU+Ms9in6A3R
         YpHSJRlqXWceApOimo2I8040rZApFcY1Lyx9IyQhuiHMMqbZnS3NFBQ66WYCT5wrcCXn
         2XfqXnPzZ4ENHl7nw44puDV/wNM5iVlTfZ020t7G/gyrwdI2b21o1UebTVdll5sJUxgN
         eFag==
Content-Disposition: inline
In-Reply-To: <20180712164537.324caee21fd68c47a02af009@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 04:45:37PM -0700, Andrew Morton wrote:
> On Thu, 12 Jul 2018 13:29:42 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Right now, psi reports pressure and stall times of already concluded
> > stall events. For most use cases this is current enough, but certain
> > highly latency-sensitive applications, like the Android OOM killer,
> > might want to know about and react to stall states before they have
> > even concluded (e.g. a prolonged reclaim cycle).
> > 
> > This patches the procfs/cgroupfs interface such that when the pressure
> > metrics are read, the current per-cpu states, if any, are taken into
> > account as well.
> > 
> > Any ongoing states are concluded, their time snapshotted, and then
> > restarted. This requires holding the rq lock to avoid corruption. It
> > could use some form of rq lock ratelimiting or avoidance.
> > 
> > Requested-by: Suren Baghdasaryan <surenb@google.com>
> > Not-yet-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> What-does-that-mean:?

I didn't think this patch was ready for upstream yet, hence the RFC
and the lack of a proper sign-off.

But Suren has been testing this and found it useful in his specific
low-latency application, so I included it for completeness, for other
testers to find, and for possible suggestions on how to improve it.
