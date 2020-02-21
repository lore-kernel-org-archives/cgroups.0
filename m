From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/11] drm, cgroup: Introduce lgpu as DRM cgroup resource
Date: Fri, 21 Feb 2020 00:59:55 -0500
Message-ID: <CAOWid-dLs079jHAVoDeJ2Ung1Tti0Jszhd-0D2RYPOjuWnTprQ@mail.gmail.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com> <20200214155650.21203-10-Kenny.Ho@amd.com>
 <CAOFGe96N5gG+08rQCRC+diHKDAfxPFYEnVxDS8_udvjcBYgsPg@mail.gmail.com>
 <CAOWid-f62Uv=GZXX2V2BsQGM5A1JJG_qmyrOwd=KwZBx_sr-bg@mail.gmail.com>
 <20200214183401.GY2363188@phenom.ffwll.local> <CAOWid-caJHeXUnQv3MOi=9U+vdBLfewN+CrA-7jRrz0VXqatbQ@mail.gmail.com>
 <20200214191754.GA218629@mtj.thefacebook.com> <20200219161850.GB13406@cmpxchg.org>
 <CAOWid-e=7V4TUqK_h5Gs9dUXqH-Vgr-Go8c1dCkMux98Vdd1sQ@mail.gmail.com> <20200219183841.GA54486@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H7aXQTqmLNxvdPr5mBNnJfbo38LB1xJHVHK2rWbKEqw=;
        b=MOqfv/kaObHJEU4A0mnaFSEPVoAQ+XzGpPBw1qUzIDChC2bV5Xis329ghi0OSMUe2T
         YhVicpLrQndbQZs6riGjFqTmtdy+EMbG4jyCnKVus42lLRijK/C+rJhfwsU1A1+dZ2oq
         x9Iy53HEEPilEHf0enrdVhBui0Cuk44XNN8OwtHBWBHJG4b2EaSDPRDTxw6C8lUt5zYA
         mHMjTP2udC0KW3zyt6aJmu5BQahyQw6PpXAAISnMF6MG4/nYxe6+8f552zlV89Bl8i8e
         Rq9Iqy2Y+S2iwCZPuVrxEqWRujTeaoMDyqLddd6W1ztvZrcj+S68m6+yNug0QMoHvJop
         m+Pg==
In-Reply-To: <20200219183841.GA54486-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jason Ekstrand <jason-fQELhIk9awXprZlt/sZkLg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx mailing list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org

Thanks, I will take a look.

Regards,
Kenny

On Wed, Feb 19, 2020 at 1:38 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Feb 19, 2020 at 11:28:48AM -0500, Kenny Ho wrote:
> > On Wed, Feb 19, 2020 at 11:18 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > Yes, I'd go with absolute units when it comes to memory, because it's
> > > not a renewable resource like CPU and IO, and so we do have cliff
> > > behavior around the edge where you transition from ok to not-enough.
> > >
> > > memory.low is a bit in flux right now, so if anything is unclear
> > > around its semantics, please feel free to reach out.
> >
> > I am not familiar with the discussion, would you point me to a
> > relevant thread please?
>
> Here is a cleanup patch, not yet merged, that documents the exact
> semantics and behavioral considerations:
>
> https://lore.kernel.org/linux-mm/20191213192158.188939-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
>
> But the high-level idea is this: you assign each cgroup or cgroup
> subtree a chunk of the resource that it's guaranteed to be able to
> consume. It *can* consume beyond that threshold if available, but that
> overage may get reclaimed again if somebody else needs it instead.
>
> This allows you to do a ballpark distribution of the resource between
> different workloads, while the kernel retains the ability to optimize
> allocation of spare resources - because in practice, workload demand
> varies over time, workloads disappear and new ones start up etc.
>
> > In addition, is there some kind of order of preference for
> > implementing low vs high vs max?
>
> If you implement only one allocation model, the preference would be on
> memory.low. Limits are rigid and per definition waste resources, so in
> practice we're moving away from them.
