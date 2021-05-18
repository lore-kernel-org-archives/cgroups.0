From: Yang Shi <shy828301@gmail.com>
Subject: Re: [PATCH] cgroup: disable controllers at parse time
Date: Tue, 18 May 2021 12:54:09 -0700
Message-ID: <CAHbLzkqziUEUz-4nxBs4H5z4pZS3y+ceKciKYt8KVN34Gw8egw@mail.gmail.com>
References: <20210512201946.2949351-1-shakeelb@google.com> <CALvZod5a_W8P0v7xg0jdh-TLvy4OUYaQkyjBx-1RSTUBo+YQmg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NIbWp7tup4eVOlx3Pu4l4njVP4uN2qbWLCiCWarrYCE=;
        b=HNSW85axgCU+zrmo9twXR0r0XwE9BPovx+g1TTiC4PJGaOmGv73DrM2Ldht2i7h1up
         HLuPg+LbH89LIVsSLGrVrVJSJTN5tws64xNj3s25GyRupAAGwWocdYv5/lx38Lq/2DVx
         wi9TuSa+kGG4bUVbxkJcGvc1BnnYLthm2t5Lhg+PqOIKdITFj6UvvIcOf8RPLEr3TgVb
         qx+jTnNmXrnO9QSIdZfLSOd9tApK+NCvSTK+fGl0XY7y23mggWyuWJx3NvERPvLVn9pt
         NBjj4fo+DupkQy/1AvuuX/n/F9t7BpMG/yxtN9NJWrK6lU0w4cWVQGOhEeQyzowQgZpb
         PRgg==
In-Reply-To: <CALvZod5a_W8P0v7xg0jdh-TLvy4OUYaQkyjBx-1RSTUBo+YQmg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?B?Tk9NVVJBIEpVTklDSEko6YeO5p2RIOa3s+S4gCk=?= <junichi.nomura@nec.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, May 18, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, May 12, 2021 at 1:19 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > This patch effectively reverts the commit a3e72739b7a7 ("cgroup: fix
> > too early usage of static_branch_disable()"). The commit 6041186a3258
> > ("init: initialize jump labels before command line option parsing") has
> > moved the jump_label_init() before parse_args() which has made the
> > commit a3e72739b7a7 unnecessary. On the other hand there are
> > consequences of disabling the controllers later as there are subsystems
> > doing the controller checks for different decisions. One such incident
> > is reported [1] regarding the memory controller and its impact on memor=
y
> > reclaim code.
> >
> > [1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371=
e4@nec.com
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: NOMURA JUNICHI(=E9=87=8E=E6=9D=91=E3=80=80=E6=B7=B3=E4=B8=
=80) <junichi.nomura@nec.com>
>
> Nomura, I think you have already tested this patch, so, can you please
> add your tested-by tag?
>
> Tejun, any comments or concerns?
>
> Yang, do you think we should add Fixes tag to make sure this patch
> lands in 5.13 where your shrinker patches landed?

Yes, I think we should, please do that.

>
> > ---
> >  kernel/cgroup/cgroup.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> >
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index e049edd66776..e7a9a2998245 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -5634,8 +5634,6 @@ int __init cgroup_init_early(void)
> >         return 0;
> >  }
> >
> > -static u16 cgroup_disable_mask __initdata;
> > -
> >  /**
> >   * cgroup_init - cgroup initialization
> >   *
> > @@ -5694,12 +5692,8 @@ int __init cgroup_init(void)
> >                  * disabled flag and cftype registration needs kmalloc,
> >                  * both of which aren't available during early_init.
> >                  */
> > -               if (cgroup_disable_mask & (1 << ssid)) {
> > -                       static_branch_disable(cgroup_subsys_enabled_key=
[ssid]);
> > -                       printk(KERN_INFO "Disabling %s control group su=
bsystem\n",
> > -                              ss->name);
> > +               if (!cgroup_ssid_enabled(ssid))
> >                         continue;
> > -               }
> >
> >                 if (cgroup1_ssid_disabled(ssid))
> >                         printk(KERN_INFO "Disabling %s control group su=
bsystem in v1 mounts\n",
> > @@ -6214,7 +6208,10 @@ static int __init cgroup_disable(char *str)
> >                         if (strcmp(token, ss->name) &&
> >                             strcmp(token, ss->legacy_name))
> >                                 continue;
> > -                       cgroup_disable_mask |=3D 1 << i;
> > +
> > +                       static_branch_disable(cgroup_subsys_enabled_key=
[i]);
> > +                       pr_info("Disabling %s control group subsystem\n=
",
> > +                               ss->name);
> >                 }
> >         }
> >         return 1;
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
