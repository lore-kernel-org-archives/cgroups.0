From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm: memcg: let non-unified root stats flushes help
 unified flushes
Date: Tue, 5 Sep 2023 08:54:46 -0700
Message-ID: <CAJD7tkaHVtMiMYFocNiABuyhPcqt77gei0UeaDq4J7V-=tMFYA@mail.gmail.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-4-yosryahmed@google.com> <ZPXupwjewuLgksAI@dhcp22.suse.cz>
 <6tne52ip62ucev7nmnim3m7fhcydnwcytyxynrlxxgaf4cbqea@r4hec425izap>
 <ZPX6luPGqypp68+L@dhcp22.suse.cz> <hrpw2bjsrs3pzxympb7cz4nohyeztnxkmdtzbzlfdba6ugkken@dhcdbbbrv4fn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693929323; x=1694534123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfVVipA0o6H6ewNJe4xhsC2K0XPQ+3N1YnkSldVjkDY=;
        b=Hz853w87jY9/nR9lnAL2MD006JQ677WdRtB8Vhnlob6er4Cxab+/VZLaD+LcrG9h0C
         bg6gdMYpppIsHgrr4yUB4DdHLE7hcPJUlobsChkPMscryE7yMWJygest7mAP65y8iHYq
         XIW0763Z+nzmcnty+UhYS1ealuX2q6lMFh1I3XyaI5c5kB4kNkq/rae6DKklNmjbJqJw
         HDjfQLaplFlqHNBxvvCJF1epQWMpOgpJiM4Wn0JppYv8Kqixmvr8pz7Em0+1faYN/cWf
         UUoydLmr2t9n+a0eK0Z6fGWMWlp9HvQkQbZ326U8FYj4LhG4plynRSQi+dFSUJYi2129
         wmCg==
In-Reply-To: <hrpw2bjsrs3pzxympb7cz4nohyeztnxkmdtzbzlfdba6ugkken@dhcdbbbrv4fn>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 5, 2023 at 7:10=E2=80=AFAM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org=
> wrote:
>
> On Mon, Sep 04, 2023 at 05:41:10PM +0200, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =
wrote:
> > So it also creates an undocumented but userspace visible behavior.
> > Something that userspace might start depending on, right?
>
> Yes but -
> - depending on undocumented behavior is a mistake,
> - breaking the dependency would manifest (in the case I imagine) as a
>   performance regression (and if there are some users, the future can
>   allow them configuring periodic kernel flush to compensate for that).

I think I am missing something. This change basically makes userspace
readers (for the root memcg) help out unified flushers, which are
in-kernel readers (e.g. reclaim) -- not the other way around.

How would that create a userspace visible behavior that a dependency
can be formed on? Users expecting reclaim to be faster right after
reading root stats? I would guess that would be too flaky to cause a
behavior that people can depend on tbh.
