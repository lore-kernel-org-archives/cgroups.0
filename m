From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/4] Charge loop device i/o to issuing cgroup
Date: Fri, 21 Aug 2020 13:23:20 -0700
Message-ID: <CALvZod7mfgOab_NSBegCcJ4jL6pb98CfckUhk7QgNCLsmiB4aQ@mail.gmail.com>
References: <20200528135444.11508-1-schatzberg.dan@gmail.com>
 <CALvZod655MqFxmzwCf4ZLSh9QU+oLb0HL-Q_yKomh3fb-_W0Vg@mail.gmail.com>
 <20200821150405.GA4137@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <20200821160128.GA2233370@carbon.dhcp.thefacebook.com> <CALvZod69w5UoCjfWcqVAejpKWzRAUxX7dEPzqDUknHhUFV_XEA@mail.gmail.com>
 <20200821200530.GA2250889@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3D+TqH2GckoXVS0G3AVPPpXHl/Ts1q0PzrQAkDG5DxU=;
        b=Iaf2NJFcLLPjJhCFY4NPJilmEIWG1EFZPPdHf4a8cj0cg5EIjHpega0AiSsQdtW2bk
         gfJ+fc6kt7IQS7SnbVWnC7nVl1NCVvIvAYMA+W7ZX4lygUpP1+w1ZAYWXppaTBAf8FnJ
         HLiubgJccGNPYTJixoFrXXnbWGuO3t08zDeHSeMZCXjnotaLbkFq91VPkpSg8AOzFma2
         6iZ7V4Oefj3vBgGenVmlNikMMYEnqUWK1a+A4pNOYTR11AA0IqAS6HeY4XIaHwSMRWmH
         w3QNtXRLNxeUZuRdcDTgKqZ6ih6/11rJX2eAqK4u7o5a+KWL4L4g4AZjl5yls4ZEKP7/
         G2Ow==
In-Reply-To: <20200821200530.GA2250889-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TasMV2rI37PzA@public.gmane.org>

On Fri, Aug 21, 2020 at 1:05 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Fri, Aug 21, 2020 at 09:27:56AM -0700, Shakeel Butt wrote:
> > On Fri, Aug 21, 2020 at 9:02 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> > >
> > > On Fri, Aug 21, 2020 at 11:04:05AM -0400, Dan Schatzberg wrote:
> > > > On Thu, Aug 20, 2020 at 10:06:44AM -0700, Shakeel Butt wrote:
> > > > > On Thu, May 28, 2020 at 6:55 AM Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > > >
> > > > > > Much of the discussion about this has died down. There's been a
> > > > > > concern raised that we could generalize infrastructure across loop,
> > > > > > md, etc. This may be possible, in the future, but it isn't clear to me
> > > > > > how this would look like. I'm inclined to fix the existing issue with
> > > > > > loop devices now (this is a problem we hit at FB) and address
> > > > > > consolidation with other cases if and when those need to be addressed.
> > > > > >
> > > > >
> > > > > What's the status of this series?
> > > >
> > > > Thanks for reminding me about this. I haven't got any further
> > > > feedback. I'll bug Jens to take a look and see if he has any concerns
> > > > and if not send a rebased version.
> > >
> > > Just as a note, I stole a patch from this series called
> > > "mm: support nesting memalloc_use_memcg()" to use for the bpf memory accounting.
> > > I rewrote the commit log and rebased to the tot with some trivial changes.
> > >
> > > I just sent it upstream:
> > > https://lore.kernel.org/bpf/20200821150134.2581465-1-guro-b10kYP2dOMg@public.gmane.org/T/#md7edb6b5b940cee1c4d15e3cef17aa8b07328c2e
> > >
> > > It looks like we need it for two independent sub-systems, so I wonder
> > > if we want to route it first through the mm tree as a standalone patch?
> > >
> >
> > Another way is to push that patch to 5.9-rc2 linus tree, so both block
> > and mm branches for 5.10 will have it. (Not sure if that's ok.)
>
> Ok, it looks like the patch provides a generally useful API enhancement.
> And we do have at least two potential use cases for it.
> Let me send it as a standalone patch to linux-mm@.
>
> Btw, Shakeel, what do you think of s/memalloc_use_memcg()/set_active_memcg() ?
>

I am fine with it.
