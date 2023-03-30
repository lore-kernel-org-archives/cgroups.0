From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 09:06:46 +0200
Message-ID: <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com>
 <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680160007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QLfYeLt+TXwV+pwToLzrHHrJTaYboOCW9UaiwVxS7lA=;
        b=mAI7MPiHSl8rJ93izo+zY41ldY7Q5UIHq3cnqnGtElFi7az9dtYt0NrZYGnhHulCp4xuiB
        tCKde3AIvlhN6fTukiLKYF3ViOCSzqBHTGWpE8aQCHMCXW6+8GcWX7Keeil3ozJ3OOGTHK
        IGmmNg/5vANvb4KhA3aiQh5XlXtsXR4=
Content-Disposition: inline
In-Reply-To: <20230329192059.2nlme5ubshzdbpg6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 29-03-23 19:20:59, Shakeel Butt wrote:
> On Wed, Mar 29, 2023 at 11:41:39AM -0700, Yosry Ahmed wrote:
> > On Wed, Mar 29, 2023 at 4:22=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67=
k@public.gmane.org> wrote:
> > >
> > > On Tue 28-03-23 22:16:39, Yosry Ahmed wrote:
> > > > rstat flushing is too expensive to perform in irq context.
> > > > The previous patch removed the only context that may invoke an rstat
> > > > flush from irq context, add a WARN_ON_ONCE() to detect future
> > > > violations, or those that we are not aware of.
> > > >
> > > > Ideally, we wouldn't flush with irqs disabled either, but we have o=
ne
> > > > context today that does so in mem_cgroup_usage(). Forbid callers fr=
om
> > > > irq context for now, and hopefully we can also forbid callers with =
irqs
> > > > disabled in the future when we can get rid of this callsite.
> > >
> > > I am sorry to be late to the discussion. I wanted to follow up on
> > > Johannes reply in the previous version but you are too fast ;)
> > >
> > > I do agree that this looks rather arbitrary. You do not explain how t=
he
> > > warning actually helps. Is the intention to be really verbose to the
> > > kernel log when somebody uses this interface from the IRQ context and
> > > get bug reports? What about configurations with panic on warn? Do we
> > > really want to crash their systems for something like that?
> >=20
> > Thanks for taking a look, Michal!
> >=20
> > The ultimate goal is not to flush in irq context or with irqs
> > disabled, as in some cases it causes irqs to be disabled for a long
> > time, as flushing is an expensive operation. The previous patch in the
> > series should have removed the only context that flushes in irq
> > context, and the purpose of the WARN_ON_ONCE() is to catch future uses
> > or uses that we might have missed.
> >=20
> > There is still one code path that flushes with irqs disabled (also
> > mem_cgroup_usage()), and we cannot remove this just yet; we need to
> > deprecate usage threshold events for root to do that. So we cannot
> > enforce not flushing with irqs disabled yet.
> >=20
> > So basically the patch is trying to enforce what we have now, not
> > flushing in irq context, and hopefully at some point we will also be
> > able to enforce not flushing with irqs disabled.
> >=20
> > If WARN_ON_ONCE() is the wrong tool for this, please let me know.
> >=20
>=20
> If I understand Michal's concern, the question is should be start with
> pr_warn_once() instead of WARN_ON_ONCE() and I think yes we should start
> with pr_warn_once().

Yes, I do not really like the WARN_ON here. It is an overkill. pr_warn
would much less intrusive but potentially incomplete because you won't
know who that offender is. So if you really care about those then you
would need to call dump_stack as well.

So the real question is. Do we really care so deeply? After all somebody
might be calling this from within a spin lock or irq disabled section
resulting in a similar situation without noticing.
--=20
Michal Hocko
SUSE Labs
