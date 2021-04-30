From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Fri, 30 Apr 2021 08:42:06 +0200
Message-ID: <20210430064206.um6fm5sr2vuyoak3@wittgenstein>
References: <20210429120113.2238065-1-brauner@kernel.org>
 <20210429120113.2238065-3-brauner@kernel.org>
 <YIt4NhikbQKc0Vku@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YIt4NhikbQKc0Vku-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 29, 2021 at 08:23:34PM -0700, Roman Gushchin wrote:
> On Thu, Apr 29, 2021 at 02:01:11PM +0200, Christian Brauner wrote:
> > From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > 
> > If cgroup.kill file is supported make use of it.
> > 
> > Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> > index 027014662fb2..3e27cd9bda75 100644
> > --- a/tools/testing/selftests/cgroup/cgroup_util.c
> > +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> > @@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
> >  	char buf[PAGE_SIZE];
> >  	char *ptr = buf;
> >  
> > +	/* If cgroup.kill exists use it. */
> > +        if (!cg_write(cgroup, "cgroup.kill", "1"))
>    ^^^^^^^^
>    spaces?

Huh, sorry about that weird how that got in there...
Will fix.
