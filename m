From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Thu, 19 Oct 2017 15:45:34 -0400
Message-ID: <20171019194534.GA5502@cmpxchg.org>
References: <20171019185218.12663-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g0apvw11DmikvksfY7r+4kstGsih1pCucBHsAkC2jp0=; b=T6cpujLsi/5loNbAjgVG7YFmnE
        G8tN612WZ6lr9+mJh4zQGjJe/sYszn1BizqCSwtzfndZ4E3DEWd3YgGf7x0DhWsXsl7UMjUOWrz8V
        W65zCzEsUj+I1oYgMib4F0q+wPaqSsoOIOS2dTA/8Sl1s6XYDobdNABwD9lswN+oibM0=;
Content-Disposition: inline
In-Reply-To: <20171019185218.12663-1-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Oct 19, 2017 at 07:52:12PM +0100, Roman Gushchin wrote:
> This patchset makes the OOM killer cgroup-aware.

Hi Andrew,

I believe this code is ready for merging upstream, and it seems Michal
is in agreement. There are two main things to consider, however.

David would have really liked for this patchset to include knobs to
influence how the algorithm picks cgroup victims. The rest of us
agreed that this is beyond the scope of these patches, that the
patches don't need it to be useful, and that there is nothing
preventing anyone from adding configurability later on. David
subsequently nacked the series as he considers it incomplete. Neither
Michal nor I see technical merit in David's nack.

Michal acked the implementation, but on the condition that the new
behavior be opt-in, to not surprise existing users. I *think* we agree
that respecting the cgroup topography during global OOM is what we
should have been doing when cgroups were initially introduced; where
we disagree is that I think users shouldn't have to opt in to
improvements. We have done much more invasive changes to the victim
selection without actual regressions in the past. Further, this change
only applies to mounts of the new cgroup2. Tejun also wasn't convinced
of the risk for regression, and too would prefer cgroup-awareness to
be the default in cgroup2. I would ask for patch 5/6 to be dropped.

Thanks
