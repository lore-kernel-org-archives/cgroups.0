From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Mon, 17 Jul 2017 16:14:09 +0200
Message-ID: <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aJ/TDYz+uRkTfQRjhH1KaL4q+b0Ez6XvzQFC47mS0Ww=; b=o9vFFkuqmQu2eh184aHG/qohL
        h4K7e5Ge3B6VuKgxXMfdzffRPvpzWAdJ2U4vhhqblZz3Qv/KYuX0GVgjP2lryQNLwOMao2qPBzqXD
        XqCYv4foWL84sdhI7bpFFmQZ7+XMoNcICWQNF3EGzQCb3ByPcpeA+Tn38gU0pntFbcVohPXWcYRmb
        F0wudialYCYtYFNEPm8WfL1DdgE6Q8CQv+tFJbBbISBHWHMzKowGDK8Y30X+FI/z1PfDnF542rbnu
        rbXiYe79fb2wb3G+OsaieJpVmOaIgE7ZuIDi/gnfSt8M3d08S+z7OTre68Vam8l6mkB5BgYSplOD5
    
Content-Disposition: inline
In-Reply-To: <20170717020721.3612468-6-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Jul 16, 2017 at 10:07:20PM -0400, Tejun Heo wrote:
> 
> v4: - Updated to marking each cgroup threaded as suggested by PeterZ.
> 

> +On creation, a cgroup is always a domain cgroup and can be made
> +threaded by writing "threaded" to the "cgroup.type" file.  The
> +operation is single direction::
> +
> +  # echo threaded > cgroup.type
> +
> +Once threaded, the cgroup can't be made a domain again.  To enable the
> +thread mode, the following conditions must be met.
> +
> +- As the cgroup will join the parent's resource domain.  The parent
> +  must either be a valid (threaded) domain or a threaded cgroup.
> +
> +- The cgroup must be empty.  No enabled controllers, child cgroups or
> +  processes.
> +
> +Topology-wise, a cgroup can be in an invalid state.  Please consider
> +the following toplogy::
> +
> +  A (threaded domain) - B (threaded) - C (domain, just created)
> +
> +C is created as a domain but isn't connected to a parent which can
> +host child domains.  C can't be used until it is turned into a
> +threaded cgroup.  "cgroup.type" file will report "domain (invalid)" in
> +these cases.  Operations which fail due to invalid topology use
> +EOPNOTSUPP as the errno.
> +
> +A domain cgroup is turned into a threaded domain when one of its child
> +cgroup becomes threaded or threaded controllers are enabled in the
> +"cgroup.subtree_control" file while there are processes in the cgroup.
> +A threaded domain reverts to a normal domain when the conditions
> +clear.

AFAICT this is not in fact what I suggested... :/

My proposal did not have that invalid state. It would simply refuse to
change the type from thread to domain in the case where the parent is
not a domain.

Also, my proposal maintained the normal property inheritance rules. A
child cgroup's creation 'type' would be that of its parent and not
always be 'domain'.

Let me read more (and more careful) to see if there's other things.
