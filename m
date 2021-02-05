From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: remove rcu_read_lock from get_mem_cgroup_from_page
Date: Fri, 5 Feb 2021 20:56:07 +0800
Message-ID: <CAMZfGtW3fjnPt140OqaQqSyaPAiB9AKSVgop4pXdZb15qVmSPw@mail.gmail.com>
References: <20210205062719.74431-1-songmuchun@bytedance.com>
 <YB0DnAlCaQza4Uf9@dhcp22.suse.cz> <CAMZfGtVhBrwgkJVwiah6eDsppSf8fYp+uZ=tZmHBLDFeTmQX3w@mail.gmail.com>
 <YB0euLiMU+T/9bMK@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=at3tlE+CnMfJFYgoRalXte0nrDzDhLkLsR1wIcNPMOM=;
        b=rh+E2c1RBqi2Afh5NbYKEM3yLFpRTWi9kUBJWQ4+8iWFvtpIMOf9ASTnRxKKD+dKrA
         MJshQOYgCKe27lDY4QZkClKdDAUu9qWUjxOpvFSQTCDOBfkPF82Hynzf0IG1wPGdIzb3
         IU5bD6qlsNnrrjF+g3m382MXpUkDMR3Oar4JbCr0JG9Fjh6x+19tfj4EeRFbc/8rQOqk
         a2gbS5rTBo0mgUTFtn4PFjuvqG5Dg2lg8Qu8xk0/+bqRB77gJgMpLq7CVYlWkf4XImVG
         3ZBxBIpcfVcdKow7puYuDSj2Xw70IytFjMpGZ9aV5vKroCNt2CXgHJRdwIoPtBISS2fx
         ZFsg==
In-Reply-To: <YB0euLiMU+T/9bMK-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 5, 2021 at 6:32 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 05-02-21 17:14:30, Muchun Song wrote:
> > On Fri, Feb 5, 2021 at 4:36 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Fri 05-02-21 14:27:19, Muchun Song wrote:
> > > > The get_mem_cgroup_from_page() is called under page lock, so the page
> > > > memcg cannot be changed under us.
> > >
> > > Where is the page lock enforced?
> >
> > Because it is called from alloc_page_buffers(). This path is under
> > page lock.
>
> I do not see any page lock enforecement there. There is not even a
> comment requiring that. Can we grow more users where this is not the
> case? There is no actual relation between alloc_page_buffers and
> get_mem_cgroup_from_page except that the former is the only _current_
> existing user. I would be careful to dictate locking based solely on
> that.

Yeah, there is no comment requiring that. I have seen all the callers
of the alloc_page_buffers. I found that it is under page lock.
But it seems it is not the key point here. I should delete those
comments from the commit log.

>
> > > > Also, css_get is enough because page
> > > > has a reference to the memcg.
> > >
> > > tryget used to be there to guard against offlined memcg but we have
> > > concluded this is impossible in this path. tryget stayed there to catch
> > > some unexpected cases IIRC.
> >
> > Yeah, it can catch some unexpected cases. But why is this path
> > special so that we need a tryget?
>
> I do not remember details and the changelog of that change is not
> explicit but I suspect it was just because this one could trigger as
> there are external callers to memcg. Is this protection needed? I am not
> sure, this is for you to justify if you want to remove it.

I am sure it is not needed.

>
> > > > If we really want to make the get_mem_cgroup_from_page() suitable for
> > > > arbitrary page, we should use page_memcg_rcu() instead of page_memcg()
> > > > and call it after rcu_read_lock().
> > >
> > > What is the primary motivation to change this code? is the overhead of
> > > tryget/RCU something that needs optimizing?
> >
> > Actually, the rcu_read_lock() is not necessary here. So it is better to
> > remove it (indeed reduce some code).
>
> Please state your reasoning in the changelog including benefits we get
> from it.

OK.

> --
> Michal Hocko
> SUSE Labs
