From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Thu, 18 Nov 2021 09:48:41 +0100
Message-ID: <YZYTaSVUWUhW0d9t@dhcp22.suse.cz>
References: <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz>
 <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
 <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
 <CAHS8izPcnwOqf8bjfrEd9VFxdA6yX3+a-TeHsxGgpAR+_bRdNA@mail.gmail.com>
 <YZN5tkhHomj6HSb2@dhcp22.suse.cz>
 <CAHS8izNTbvhjEEb=ZrH2_4ECkVhxnCLzyd=78uWmHA_02iiA9Q@mail.gmail.com>
 <YZOWD8hP2WpqyXvI@dhcp22.suse.cz>
 <CAHS8izPyCDucFBa9ZKz09g3QVqSWLmAyOmwN+vr=X2y7yZjRQA@mail.gmail.com>
 <CALvZod7FHO6edK1cR+rbt6cG=+zUzEx3+rKWT5mi73Q29_Y5qA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637225322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K1ZCPVq3M/kq9T4nlqgpL35Tc3peJZijmvs4kEuxGJA=;
        b=Pa9rSh+Aq6osGp7TDt1OWOX3Fqw0zfTH2foxwF0j5jwP7LkZcobFCOdu53aiZwY6a42sIu
        Y9UYvASMomOZkRJafHSII6R7VLGWcMXMF59q+3+hIXZyYmSXfcTVhoe4FenubXtRHz2/N1
        43hTQf4y3/iib7lf7xP35eyjfIt2AdQ=
Content-Disposition: inline
In-Reply-To: <CALvZod7FHO6edK1cR+rbt6cG=+zUzEx3+rKWT5mi73Q29_Y5qA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 16-11-21 13:55:54, Shakeel Butt wrote:
> On Tue, Nov 16, 2021 at 1:27 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Tue, Nov 16, 2021 at 3:29 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> [...]
> > > Yes, exactly. I meant that all this special casing would be done at the
> > > shmem layer as it knows how to communicate this usecase.
> > >
> >
> > Awesome. The more I think of it I think the ENOSPC handling is perfect
> > for this use case, because it gives all users of the shared memory and
> > remote chargers a chance to gracefully handle the ENOSPC or the SIGBUS
> > when we hit the nothing to kill case. The only issue is finding a
> > clean implementation, and if the implementation I just proposed sounds
> > good to you then I see no issues and I'm happy to submit this in the
> > next version. Shakeel and others I would love to know what you think
> > either now or when I post the next version.
> >
> 
> The direction seems reasonable to me. I would have more comments on
> the actual code. At the high level I would prefer not to expose these
> cases in the filesystem code (shmem or others) and instead be done in
> a new memcg interface for filesystem users.

A library like function in the memcg proper sounds good to me I just
want to avoid any special casing in the core of the memcg charging and
special casing there.

-- 
Michal Hocko
SUSE Labs
