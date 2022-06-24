From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Fri, 24 Jun 2022 15:41:26 -0700
Message-ID: <CAJuCfpHYNZcT2DTB-=z1FGcsyqb5YjVz2HGavhkUbc7cbrkuuA@mail.gmail.com>
References: <20220623000530.1194226-1-yosryahmed@google.com>
 <YrQe5A+FXnbgOR1f@dhcp22.suse.cz> <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz> <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz> <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz> <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
 <CAJuCfpG6D1fhc4c_-0cL=rmXUbhdROSWsObYrZ7Mp4=+sBkT7Q@mail.gmail.com> <CAJD7tkY6Jg3+Pb95B0YAvHdgYKvKv_D8Tbc62hX5wzCmWUF6xQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PB2ou5T9HchfcMcQw7R0zS+RgHm7z0GH0PzcwmCwOgA=;
        b=XQE4jOFcM4OBioX8gNb6neMZZtMx9ApUxsfIs+HvbW74PPckXr9kwQl3EPOlYYez6B
         hJlk4uLOgUGW8gdUDBG9YVqB17VvMyYEkPvFl8nRwuScUFY362IVVVdErTsLlScS3cfY
         ykm30jXlcihAE8MKVVS2Kq3xjw4J7+r8yi+0+KvlXisgFGvjb3ntL+P8eTwYho4AMSgC
         mdBMrFgW0cc8jdW0r4MWZRBhiDZHNsQ2PizaT4z9wDWW1HHhjl16Jm0swyyHkDDQrq7f
         j5e6kCtnNYFwpaFURhhxhidnhV9TKrtFD2f9Emuxk0b7CnGAlvswguw3CxV2lYtXDK+7
         qo3g==
In-Reply-To: <CAJD7tkY6Jg3+Pb95B0YAvHdgYKvKv_D8Tbc62hX5wzCmWUF6xQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>, NeilBrown <neilb@suse.de>, Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>

On Fri, Jun 24, 2022 at 3:14 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Fri, Jun 24, 2022 at 3:10 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Thu, Jun 23, 2022 at 10:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > On Thu, Jun 23, 2022 at 10:04 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Thu 23-06-22 09:42:43, Shakeel Butt wrote:
> > > > > On Thu, Jun 23, 2022 at 9:37 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > > >
> > > > > > On Thu 23-06-22 09:22:35, Yosry Ahmed wrote:
> > > > > > > On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > > > > >
> > > > > > > > On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
> > > > > > [...]
> > > > > > > > > In our internal version of memory.reclaim that we recently upstreamed,
> > > > > > > > > we do not account vmpressure during proactive reclaim (similar to how
> > > > > > > > > psi is handled upstream). We want to make sure this behavior also
> > > > > > > > > exists in the upstream version so that consolidating them does not
> > > > > > > > > break our users who rely on vmpressure and will start seeing increased
> > > > > > > > > pressure due to proactive reclaim.
> > > > > > > >
> > > > > > > > These are good reasons to have this patch in your tree. But why is this
> > > > > > > > patch benefitial for the upstream kernel? It clearly adds some code and
> > > > > > > > some special casing which will add a maintenance overhead.
> > > > > > >
> > > > > > > It is not just Google, any existing vmpressure users will start seeing
> > > > > > > false pressure notifications with memory.reclaim. The main goal of the
> > > > > > > patch is to make sure memory.reclaim does not break pre-existing users
> > > > > > > of vmpressure, and doing it in a way that is consistent with psi makes
> > > > > > > sense.
> > > > > >
> > > > > > memory.reclaim is v2 only feature which doesn't have vmpressure
> > > > > > interface. So I do not see how pre-existing users of the upstream kernel
> > > > > > can see any breakage.
> > > > > >
> > > > >
> > > > > Please note that vmpressure is still being used in v2 by the
> > > > > networking layer (see mem_cgroup_under_socket_pressure()) for
> > > > > detecting memory pressure.
> > > >
> > > > I have missed this. It is hidden quite good. I thought that v2 is
> > > > completely vmpressure free. I have to admit that the effect of
> > > > mem_cgroup_under_socket_pressure is not really clear to me. Not to
> > > > mention whether it should or shouldn't be triggered for the user
> > > > triggered memory reclaim. So this would really need some explanation.
> > >
> > > vmpressure was tied into socket pressure by 8e8ae645249b ("mm:
> > > memcontrol: hook up vmpressure to socket pressure"). A quick look at
> > > the commit log and the code suggests that this is used all over the
> > > socket and tcp code to throttles the memory consumption of the
> > > networking layer if we are under pressure.
> > >
> > > However, for proactive reclaim like memory.reclaim, the target is to
> > > probe the memcg for cold memory. Reclaiming such memory should not
> > > have a visible effect on the workload performance. I don't think that
> > > any network throttling side effects are correct here.
> >
> > IIUC, this change is fixing two mechanisms during userspace-induced
> > memory pressure:
> > 1. psi accounting, which I think is not controversial and makes sense to me;
> > 2. vmpressure signal, which is a "kinda" obsolete interface and might
> > be viewed as controversial.
> > I would suggest splitting the patch into two, first to fix psi
> > accounting and second to fix vmpressure signal. This way the first one
> > (probably the bigger of the two) can be reviewed and accepted easily
> > while debates continue on the second one.
>
> This change should be NOP for psi. psi was already fixed by
> e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure") by Johannes a while ago. This patch does the same
> for vmpressure, but in a different way, as the same approach of
> e22c6ed90aa9 cannot be used.
>
> The changes you are seeing in this patch for psi are basically
> reverting e22c6ed90aa9 and using the newly introduced flag that
> handles vmpressure to handle psi as well, to avoid having two separate
> ways to address accounting memory pressure during userspace-induced
> reclaim.

Ah, I see. Thanks for clarifying that.

>
> >
> > >
> > > >
> > > > > Though IMO we should deprecate vmpressure altogether.
> > > >
> > > > Yes it should be really limited to v1. But as I've said the effect on
> > > > mem_cgroup_under_socket_pressure is not really clear to me. It really
> > > > seems the v2 support has been introduced deliberately.
> > > >
> > > > --
> > > > Michal Hocko
> > > > SUSE Labs
