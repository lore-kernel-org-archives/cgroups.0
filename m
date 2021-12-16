From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Thu, 16 Dec 2021 08:51:52 +0100
Message-ID: <YbrwGCoklB+IOqH0@linutronix.de>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
 <Ya+SCkLOLBVN/kiY@cmpxchg.org>
 <YbNwmUMPFM/MO0cX@linutronix.de>
 <YbcbmvQk+Sgdsi9G@dhcp22.suse.cz>
 <YbocOh+h3o/Yc5Ag@linutronix.de>
 <YboeI1aTFdQpN0TI@dhcp22.suse.cz>
 <YboiRA1znig/cbCt@linutronix.de>
 <Ybo3cAkyg0SrUyJJ@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639641113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7M0mhRgQajj4JooEekItEmeezbDQdgPBX9TAoVx0FJ4=;
        b=fFIBCwWplbZ0Rdcm9iQ+R/u7UmGMd+qS7fmMP6RWtHq2X8wxzfHokIcFxQk9Fn/xFZhpbC
        y8equxQrn8WrWM1R7Gi3s3ux6ycuV3Qkj5ssXxfeeymw20UjYrIQgkb+cYxDzaOERm1bxj
        4X7xN0c1x9kj99x6vQz5HPLAbf6ou+LeBW17X6oyt4bg8GWjTBR6jWBAggamBoAC5nq8f1
        6o7IDHjfrLH2NAIlK/N5Bv94kXywaz+BJR62yeM+5cEjB9ELtIvEgqxJRkY6e6v3nrifC2
        wDKOhtt1p9VpK4ujtNK79ZdyRcvms2BvgRcRzVBFvpIAFAW3fIXnJ9Gtv2ekmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639641113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7M0mhRgQajj4JooEekItEmeezbDQdgPBX9TAoVx0FJ4=;
        b=4DYVkaQQzSIvUTNyOabyRGRff4LFhI6EsnuFBJ/cD/VnzcEAIm2QGCrJVDH5iYiwhF6UQt
        Q3hC1ZsoHK26A5Bg==
Content-Disposition: inline
In-Reply-To: <Ybo3cAkyg0SrUyJJ-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2021-12-15 19:44:00 [+0100], Michal Hocko wrote:
> On Wed 15-12-21 18:13:40, Sebastian Andrzej Siewior wrote:
> > Okay. What do I gain by doing this / how do I test this? Is running
> > tools/testing/selftests/cgroup/test_*mem* sufficient to test all corner
> > cases here?
> 
> I am not fully aware of all the tests but my point is that if the soft
> limit is not configured then there are no soft limit tree manipulations
> ever happening and therefore the code is effectivelly dead. Is this
> sufficient for the RT patchset to ignore the RT incompatible parts?

So if that softlimit is not essential and makes things easier by simply
disabling it, yes I could try that. I will keep that in mind.

Sebastian
