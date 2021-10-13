From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: unify memcg stat flushing
Date: Wed, 13 Oct 2021 20:01:22 +0200
Message-ID: <20211013180122.GA1007@blackbody.suse.cz>
References: <20211001190040.48086-1-shakeelb@google.com>
 <20211001190040.48086-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634148083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5NE66Dj/QGO/V+dUIB7Cr5kb37zCYA6r5tio5RjzNII=;
        b=B5V05/9o7Qyc+X/mDJCKHrJHU6FQg67zI22a1OGNF5iATFfW4V+ZU+C3WOUGmUajfs4qXT
        b99ySrjT5mzdxKSCuG0VXQ051wZ81Y+pAXYTdRsnw0QOlXMlLv1cVG9822BZobjv//KMc6
        y/fzTXdhw/CXtYD2grraAEdVjDxI85s=
Content-Disposition: inline
In-Reply-To: <20211001190040.48086-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Shakeel.

(Sorry for taking so long getting down to this.)

On Fri, Oct 01, 2021 at 12:00:40PM -0700, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> There is no need for that.  We just need one flusher and everyone else
> can benefit.

I imagine a cgroup with an intricate deep hiearchy with many updates and
a separate (simpler) sibling/independent cgroup that would need to pay
the costs of the first hierarchy updates [1] when it asks just for its
own stats (bound by the amount that's leftover from the periodic
updates).

The stats files (or wb stats) are likely not that time sensitive and the
reclaim (that can be local only but is slow path anyway) already uses
the global flushing.

I wonder whether the bigger benefit would be to retain the global
stats_flush_threshold counter but flush only local subtree.

Thanks,
Michal

[1] At first I thought non-memcg updates would interfere too via rstat
tree but I see it's actually filtered with the stats_flush_threshold so
only foreign memcg updates are relevant.
