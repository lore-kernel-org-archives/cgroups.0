From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: accounting for objects allocated for new netdevice
Date: Wed, 27 Apr 2022 09:52:25 -0700
Message-ID: <CALvZod6Dz7iw=gyiQ2pDVe2RJxF-7PbVoptwFZCw=sWtxpBBGQ@mail.gmail.com>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org> <20220427140153.GC9823@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vykJS+GCN4oOt/wUy0V+c72rmxebQEGqa0biVVI0j7Y=;
        b=j3R3a5/JnI6fvngAk0q+6VHP/6OI5UNIT6V+w+qj8VLfcmJqtjseEGtXfaFyizk/IX
         PU/q6OweVYApqtV+lBDouzWxtm9XMMTYRudgUBSWgiCEQeTgIfT9DYFKVpCH58w1ERBM
         7W5wA9x7X+j9QfaBRhyL2NKcYQLcxBJnX91rFinU+EE0JN6Yw0stS+Z5kOjleeuUHa2K
         JNrPLV5o8eERREFVn8dvNtQ1ddpTpcbK8yoa2y4mPAEolJ6zRBFHuOgsBd3YU6axaQCy
         LPZoUV3EUZ91yfLwtV5EQqd8BqSXjuWij1ldNudI+1JBYK35W2Fqwb/G6hIzlIzOXgYG
         kQlw==
In-Reply-To: <20220427140153.GC9823-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 27, 2022 at 7:01 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hello Vasily.
>
> On Wed, Apr 27, 2022 at 01:37:50PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> =
wrote:
> > diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> > index cfa79715fc1a..2881aeeaa880 100644
> > --- a/fs/kernfs/mount.c
> > +++ b/fs/kernfs/mount.c
> > @@ -391,7 +391,7 @@ void __init kernfs_init(void)
> >  {
> >       kernfs_node_cache =3D kmem_cache_create("kernfs_node_cache",
> >                                             sizeof(struct kernfs_node),
> > -                                           0, SLAB_PANIC, NULL);
> > +                                           0, SLAB_PANIC | SLAB_ACCOUN=
T, NULL);
>
> kernfs accounting you say?
> kernfs backs up also cgroups, so the parent-child accounting comes to my
> mind.
> See the temporary switch to parent memcg in mem_cgroup_css_alloc().
>
> (I mean this makes some sense but I'd suggest unlumping the kernfs into
> a separate path for possible discussion and its not-only-netdevice
> effects.)
>

I agree with Michal that kernfs accounting should be its own patch.
Internally at Google, we actually have enabled the memcg accounting of
kernfs nodes. We have workloads which create 100s of subcontainers and
without memcg accounting of kernfs we see high system overhead.
