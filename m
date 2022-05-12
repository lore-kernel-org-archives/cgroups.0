From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Fix bugs in memcontroller cgroup tests
Date: Thu, 12 May 2022 19:04:10 +0200
Message-ID: <20220512170410.GA16096@blackbody.suse.cz>
References: <20220423155619.3669555-1-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652375052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8x6aPJt6yqRe+xxwaduylXqRn+TAS3mKV8QmNRMu74M=;
        b=oqAeYgjoS/Yzrg0FlOaRvqUONZMeshLiVKHa5kE0tg7n3W/Qd8TjfD2+9mXN1PtCJP58R8
        wnlHvNSmzK+5ejL8Fn0anZd7UdrYBDHqSDVzVTUq6+y9ZXzNhqW3be11YgM8I/tx3NwAfM
        R0sJIrUtOa7NJDVEeM6pKGJS33DF4rc=
Content-Disposition: inline
In-Reply-To: <20220423155619.3669555-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello.

On Sat, Apr 23, 2022 at 08:56:15AM -0700, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org> wrote:
> tools/testing/selftests/cgroup/test_memcontrol.c contains a set of
> testcases which validate expected behavior of the cgroup memory controller.
> Roman Gushchin recently sent out a patchset that fixed a few issues in the
> test.

Link here
https://lore.kernel.org/r/20220415000133.3955987-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.

> This patchset continues that effort by fixing a few more issues that
> were causing non-deterministic failures in the suite.

Are the Roman's patches merged anywhere? (I ran into some issues when I
was rebasing your (David's) series on top of master.) I'd like to put
all sensible patches in one series or stack on existing branch (if
there's any).

For possible v3 of this series, I did:
  - dropped the patch that allows non-zero memory.events:low for a sibling with
    memory.low=0 when mounted with memory_recursiveprot (the case needs more
    discussion),
  - added few more cleanups, convenience for debugging,
  - fixed comments in the first patch.

Pushed here [1] before properly sending the v3 for discussion.

Thanks,
Michal

[1] https://github.com/Werkov/linux/commits/cgroup-ml/memory.low-overreclaim-var2

