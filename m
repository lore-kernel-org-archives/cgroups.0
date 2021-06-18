From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1] proc: Implement /proc/self/meminfo
Date: Fri, 18 Jun 2021 19:03:59 +0200
Message-ID: <YMzR/0QyP9BR7DtN@dhcp22.suse.cz>
References: <ac070cd90c0d45b7a554366f235262fa5c566435.1622716926.git.legion@kernel.org>
 <20210615113222.edzkaqfvrris4nth@wittgenstein>
 <20210615124715.nzd5we5tl7xc2n2p@example.org>
 <CALvZod7po_fK9JpcUNVrN6PyyP9k=hdcyRfZmHjSVE5r_8Laqw@mail.gmail.com>
 <87zgvpg4wt.fsf@disp2133>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624035840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LHiaEznjsNUF4rAZuGixsJoeW9b4ApvWTouIw4rKRH4=;
        b=tgHGhNEKrHZIfPRywKhTgPlChh7xLffPyPR5uJQIyb2HBLC33ASKcSFidv7iUXQuxGLrdO
        QdOiHPnVfrHBtcaU5QDujIs7RYUaN384TX7ibRbgCaNtSFWkCsF/3uDa9b3b5Fcwl+Y/mS
        XOpL0ncJouDsLGkucN3EQci1LHh56bs=
Content-Disposition: inline
In-Reply-To: <87zgvpg4wt.fsf@disp2133>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexey Gladkov <legion-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 16-06-21 11:17:38, Eric W. Biederman wrote:
[...]
> MemAvailable seems to have a good definition.  Roughly the amount of
> memory that can be allocated without triggering swapping.  Updated
> to include not trigger memory cgroup based swapping and I sounds good.

yes this definition is at least understandable but how do you want to
define it in the memcg scope? There are two different source of memory
pressure when dealing with memcgs. Internal one when a limit is hit and
and external when the source of the reclaim comes from higher the
hierarchy (including the global memory pressure). The former one would
be quite easy to mimic with the global semantic but the later will get
much more complex very quickly - a) you would need a snapshot of the
whole cgroup tree and evaluate it against the global memory state b) you
would have to consider memory reclaim protection c) the external memory
pressure is distributed proportionaly to the size most of the time which
is yet another complication. And more other challenges that have been
already discussed.

That being said, this might be possible to implement but I am not really
sure this is viable and I strongly suspect that it will get unreliable
in many situations in context of "how much you can allocate without
swapping".
-- 
Michal Hocko
SUSE Labs
