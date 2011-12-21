From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: reset to root_mem_cgroup at bypassing
Date: Tue, 20 Dec 2011 19:25:04 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112201847500.1310@eggly.anvils>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1112191218350.3639@eggly.anvils> <CABEgKgrk4X13V2Ra_g+V5J0echpj2YZfK20zaFRKP-PhWRWiYQ@mail.gmail.com> <20111221091347.4f1a10d8.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-472047041-1324437918=:1310"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=lH8jbjsopzIch62GM3vOw5SeEjvv7nb0cnBBXt6idNI=;
        b=oGpR1wPLqCnyLg/jH2DiUJPc0Utgmr7LW+R3kZ5PMVm17NuFa5o+l/7rJzF/bDQtvG
         48g2o0JTyAWUPbvtuZxQ==
In-Reply-To: <20111221091347.4f1a10d8.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-472047041-1324437918=:1310
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 21 Dec 2011, KAMEZAWA Hiroyuki wrote:
> On Tue, 20 Dec 2011 09:24:47 +0900
> Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 2011/12/20 Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
> >=20
> > > I speak from experience: I did *exactly* the same at "bypass" when
> > > I introduced our mem_cgroup_reset_page(), which corresponds to your
> > > mem_cgroup_reset_owner(); it seemed right to me that a successful
> > > (return 0) call to try_charge() should provide a good *ptr.
> > >
> > ok.
> >=20
> > > But others (Ying and Greg) pointed out that it changes the semantics
> > > of __mem_cgroup_try_charge() in this case, so you need to justify the
> > > change to all those places which do something like "if (ret || !memcg=
)"
> > > after calling it. =C2=A0Perhaps it is a good change everywhere, but t=
hat's
> > > not obvious, so we chose caution.
> > >
> > > Doesn't it lead to bypass pages being marked as charged to root, so
> > > they don't get charged to the right owner next time they're touched?
> > >
> > Yes. You're right.
> > Hm. So, it seems I should add reset_owner() to the !memcg path
> > rather than here.
> >=20
> Considering this again..
>=20
> Now, we catch 'charge' event only once in lifetime of anon/file page.
> So, it doesn't depend on that it's marked as PCG_USED or not.

That's an interesting argument, I hadn't been looking at it that way.
It's not true of swapcache, but I guess we don't need to preserve its
peculiarities in this case.

I've not checked the (ret || !memcg) cases yet to see if any change
needed there.

I certainly like that the success return guarantees that memcg is set.

Hugh
--8323584-472047041-1324437918=:1310--
