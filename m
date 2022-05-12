From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Fix bugs in memcontroller cgroup tests
Date: Thu, 12 May 2022 10:30:18 -0700
Message-ID: <20220512173018.3pqlfwfigbbkoh4u@dev0025.ash9.facebook.com>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220512170410.GA16096@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220512170410.GA16096-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Michal,

On Thu, May 12, 2022 at 07:04:10PM +0200, Michal Koutn=FD wrote:
> Are the Roman's patches merged anywhere? (I ran into some issues when I
> was rebasing your (David's) series on top of master.) I'd like to put
> all sensible patches in one series or stack on existing branch (if
> there's any).

Roman's patches are present on master on the linux-mm tree. See
b7dbfd6553d..a131b1ed12c6.

> For possible v3 of this series, I did:
>   - dropped the patch that allows non-zero memory.events:low for a siblin=
g with
>     memory.low=3D0 when mounted with memory_recursiveprot (the case needs=
 more
>     discussion),

Ack, and thanks for keeping us steered in the right direction here. I don't
see this in the patch set you linked, but I agree this commit should be
reverted and the reclaim logic instead fixed.

>   - added few more cleanups, convenience for debugging,

Are you referring to the FAIL() macro you added? I would love to Ack that,
but unfortunately checkpatch.pl will probably yell at you for having a goto
in that macro, per the point about avoiding macros that affect control flow
[0].

I tried to do the same thing when sending out my patch set and had to
revert it before sending it to upstream.

Thanks,
David

[0] https://github.com/Werkov/linux/commit/a076339cc4825af2f22f58c1347a572b=
104b8221
