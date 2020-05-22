From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
 from protection checks
Date: Fri, 22 May 2020 23:59:09 +0800
Message-ID: <CALOAHbCdXrU1AeLd4pWubutuG6HP4xKvxRkXeOv=sd_MMW58rg@mail.gmail.com>
References: <20200505084127.12923-1-laoar.shao@gmail.com> <20200505084127.12923-3-laoar.shao@gmail.com>
 <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg@mail.gmail.com>
 <CALOAHbBTt1pMo0kwheWqPfU7RTXcDHWJ-x8=5mpw327uiy2qzA@mail.gmail.com> <CA+G9fYtmpjunUetTmf2yquB1rwZA+nnWOiueWbAMx483c0wUvQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtPsqd22g3xbib6xneI+Ag2OgkbCbIH9D8ABYL46yvQ=;
        b=iX98S1WGX0zPid+2GXhESW1748JtgtC//+o9Z1F8m/xa5JKbz+Xyp5/HEm3s+HscxF
         PgYK8FIamFK3CI58sGojA9grfQvJZFnP9ya0ZoF5K4tTa6/xzRJMIdxyTCENI3GdOoDh
         5zW/tbDQNIHSibqa3CRDg6aEZXrK2m+DmkHRGip9WLbfKWWeEuesPxQup+wQDdzGHCtX
         FX5w21SF6Ba8f/5juYPYHOwSoy7ijAt1xiGYhc1ZavjgL8/W2sP8mvOHKjwEMav5S+D+
         WHwQ5eKEygwvlcO26ca3Ir7ykZ1XlL1DRq2jZ/p6dmIyE2Cy7ofcSXkZvqFLg3hwYr77
         nDmA==
In-Reply-To: <CA+G9fYtmpjunUetTmf2yquB1rwZA+nnWOiueWbAMx483c0wUvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org

On Fri, May 22, 2020 at 11:52 PM Naresh Kamboju
<naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, 22 May 2020 at 17:49, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Fri, May 22, 2020 at 7:01 PM Naresh Kamboju
> > <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Tue, 5 May 2020 at 14:12, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > >
> > > > From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> > > >
> > > > mem_cgroup_protected currently is both used to set effective low and min
> > > > and return a mem_cgroup_protection based on the result.  As a user, this
> > > > can be a little unexpected: it appears to be a simple predicate function,
> > > > if not for the big warning in the comment above about the order in which
> > > > it must be executed.
> > > >
> > > > This change makes it so that we separate the state mutations from the
> > > > actual protection checks, which makes it more obvious where we need to be
> > > > careful mutating internal state, and where we are simply checking and
> > > > don't need to worry about that.
> > >
> > > This patch is causing oom-killer while running mkfs -t ext4 on i386 kernel
> > > running on x86_64 machine version linux-next 5.7.0-rc6-next-20200521.
> > >
> >
> > Hi Narash,
> >
> > Thanks for your report.
> > My suggestion to the issue found by you is reverting this bad commit.
>
> Thanks for giving details on this problem.
> I am not sure who will propose reverting this patch on the linux-next tree.
> Please add Reported-by if it is sane.
>

I will do it.
If no one has objection to my proposal, I will send it tomorrow.

> >
> > As I have explained earlier in another mail thread [1] that the usage
> > around memcg->{emin, elow} is very buggy.
> > We shouldn't use memcg->{emin, elow} in the reclaim context directly,
> > because  these two values can be modified by many reclaimers, so the
> > good usage of it is storing the protection value into the
> > scan_control. IOW, different reclaimers have different protection.
> > But unfortunately my suggestion is ignored.
> >
> > We can set them to 0 before using them to workaround the issue found
> > by you, but the fact is that we will introduce a new issue once we fix
> > an old issue.
> >
> > [1]. https://lore.kernel.org/linux-mm/20200425152418.28388-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
>
>
> - Naresh



-- 
Thanks
Yafang
