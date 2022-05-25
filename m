From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 25 May 2022 18:14:55 +0200
Message-ID: <20220525161455.GA16134@blackbody.suse.cz>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653495296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nveNkbQd0lCAXKeId3LcmC7N6UTtx563GjLwBF9X3SM=;
        b=IqhqwHV+le8KctKpt3p8cJ+ogCgAU4pKENhjX5Pv9JiWbXpf195OZuQCuuaL/71y7/p9qq
        Kf09Y01qolu5EvvwJFMPsy/pMLgibwaAAOagge4fmclEhR8S3HlHpHh4ddog+TuFDht1mY
        n4qnfke5MirTxUxXRHLUwQFkJ39v7Ds=
Content-Disposition: inline
In-Reply-To: <20220525151517.8430-3-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Wed, May 25, 2022 at 05:15:17PM +0200, Michal Koutn=FD <mkoutny-IBi9RG/b=
67k@public.gmane.org> wrote:
> // ref=3D1: only base reference
> kill_css()
>   css_get() // fuse, ref+=3D1 =3D=3D 2
>   percpu_ref_kill_and_confirm
>     // ref -=3D 1 =3D=3D 1: kill base references
>   [via rcu]
>   css_killed_ref_fn =3D=3D refcnt.confirm_switch
>     queue_work(css->destroy_work)               (1)
>     [via css->destroy_work]
>     css_killed_work_fn =3D=3D wq.func
>       offline_css() // needs fuse
>       css_put // ref -=3D 1 =3D=3D 0: de-fuse, was last
>         ...
>         percpu_ref_put_many
>            css_release
>              queue_work(css->destroy_work)      (2)
>              [via css->destroy_work]
>              css_release_work_fn =3D=3D wq.func

Apologies, this is wrong explanation. (I thought this explains why
Tadeusz's patch with double get/put didn't fix it (i.e. any number
wouldn't help with the explanation above).)

But the above is not correct. I've looked at the stack trace [1] and the
offending percpu_ref_put_many is called from an RCU callback
percpu_ref_switch_to_atomic_rcu(), so I can't actually see why it drops
to zero there...

Regards,
Michal
