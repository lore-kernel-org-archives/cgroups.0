From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Mon, 3 Apr 2023 10:38:22 +0200
Message-ID: <ZCqQfuprGreGYwFA@dhcp22.suse.cz>
References: <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz>
 <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz>
 <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
 <ZCVKqN2nDkkQFvO0@dhcp22.suse.cz>
 <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
 <ZCa9sixp3GJcjf8Y@dhcp22.suse.cz>
 <CAJD7tka-2vNn25=NdrKQoMf4ntdbWtojY0k4eAa-c9D+v7J=HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680511103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnIw06JprC7dy+OnhMRvOYKEzAkA2puzGDnOPlmZGCQ=;
        b=LDAThqfAUeP8YfeXSMx0SCHxnohK7Gj/nCpVhVUNjqwdqETlqzrvBDKy6zQjJyHIXkNUrb
        W6q2FQW0lYcUVVPC3UdRINlfnj6L5qLDp56/Q/IMjloPT68YokJAyiWkMM1I2SWlg8W3Ab
        mdMS9LC6dZdFbLNpceTPxyFhjNTS7Bo=
Content-Disposition: inline
In-Reply-To: <CAJD7tka-2vNn25=NdrKQoMf4ntdbWtojY0k4eAa-c9D+v7J=HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 31-03-23 12:03:47, Yosry Ahmed wrote:
> On Fri, Mar 31, 2023 at 4:02=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@=
public.gmane.org> wrote:
> >
> > On Thu 30-03-23 01:53:38, Yosry Ahmed wrote:
> > [...]
> > > Maybe we can add a primitive like might_sleep() for this, just food f=
or thought.
> >
> > I do not think it is the correct to abuse might_sleep if the function
> > itself doesn't sleep. If it does might_sleep is already involved.
>=20
> Oh, sorry if I wasn't clear, I did not mean to reuse might_sleep() --
> I meant introducing a new similar debug primitive that shouts if irqs
> are disabled.

This is circling back to original concerns about arbitrary decision to
care about IRQs. Is this really any different from spin locks or preempt
disabled critical sections preventing any scheduling and potentially
triggereing soft lockups?
--=20
Michal Hocko
SUSE Labs
