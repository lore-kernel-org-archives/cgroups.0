From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Date: Wed, 24 Aug 2022 19:57:44 +0800
Message-ID: <CALOAHbArQ=TdgiYnpBh-2OEKpFhnYAeAUbBaGV7FSfsaVb46tg@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org> <CALOAHbBTR-07La=-KPehFab0WDY4V6LovXbrhLXOqKDurHD-9g@mail.gmail.com>
 <YwUKZWXbqzfy0w4o@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Eox6EyQ1Oerj12qBsic5JiOxegll7gmv6Zzm6c/Jyw4=;
        b=M4voFZgYS9F3LD2hkQaN5T2ZO6XvIYvX8aD7IWHMYrWvgy9X+IZ1+b24FiiHTGp0iO
         09OLureDLYgwqvF0pBUd44qKGt0QIg/KEJVV1bzsf9krXXM+rfAcBFCS8OS/9VaMIIpY
         wiGEHTyCeUffTzGCBZU+RSPKSRbnu6ShJN0zow1uVMZ9u4C8Mb/1ML0CaZoi8LKarT3w
         KTGAfN4qMnMAiPw0GDoE3+SqBk7YhsdTBE/yeE9wLH1maHH3/bMpv7hRTiZ+yYDP7jyr
         h4SjxbRmAGHf5LzrXg6UN13lmVdqCk+NOUManYQe2YiWc+xBh7YD7J/HB0qk42/4Ii4P
         QZCw==
In-Reply-To: <YwUKZWXbqzfy0w4o-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Aug 24, 2022 at 1:12 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, Aug 23, 2022 at 07:08:17PM +0800, Yafang Shao wrote:
> > On Mon, Aug 22, 2022 at 7:29 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > [1] Can this be solved by layering the instance cgroups under persistent
> > >     entity cgroup?
> >
> > Below is some background of kubernetes.
> > In kubernetes, a pod is organized as follows,
> >
> >                pod
> >                |- Container
> >                |- Container
> >
> > IOW, it is a two-layer unit, or a two-layer instance.
> > The cgroup dir of the pod is named with a UUID assigned by kubernetes-apiserver.
> > Once the old pod is destroyed (that can happen when the user wants to
> > update their service), the new pod will have a different UUID.
> > That said, different instances will have different cgroup dir.
> >
> > If we want to introduce a  persistent entity cgroup, we have to make
> > it a three-layer unit.
> >
> >            persistent-entity
> >            |- pod
> >                  |- Container
> >                  |- Container
> >
> > There will be some issues,
> > 1.  The kuber-apiserver must maintain the persistent-entity on each host.
> >      It needs a great refactor and the compatibility is also a problem
> > per my discussion with kubernetes experts.
>
> This is gonna be true for anybody. The basic strategy here should be
> defining a clear boundary between system agent and applications so that
> individual applications, even when they build their own subhierarchy
> internally, aren't affected by system level hierarchy configuration changes.
> systemd is already like that with clear delegation boundary. Our (fb)
> container management is like that too. So, while this requires some
> reorganization from the agent side, things like this don't create huge
> backward compatbility issues involving applications. I have no idea about
> k8s, so the situation may differ but in the long term at least, it'd be a
> good idea to build in similar conceptual separation even if it stays with
> cgroup1.
>
> > 2.  How to do the monitor?
> >      If there's only one pod under this persistent-entity, we can
> > easily get the memory size of  shared resources by:
> >          Sizeof(shared-resources) = Sizeof(persistent-entity) - Sizeof(pod)
> >     But what if it has N pods and N is dynamically changed ?
>
> There should only be one live pod instance inside the pod's persistent
> cgroup, so the calculation doesn't really change.
>
> > 3.  What if it has more than one shared resource?
> >      For example, pod-foo has two shared resources A and B, pod-bar
> > has two shared resources A and C, and another pod has two shared
> > resources B and C.
> >      How to deploy them?
> >      Pls, note that we can introduce multiple-layer persistent-entity,
> > but which one should be the parent ?
> >
> > So from my perspective, it is almost impossible.
>
> Yeah, this is a different problem and cgroup has never been good at tracking
> resources shared across multiple groups. There is always tension between
> overhead, complexity and accuracy and the tradeoff re. resource sharing has
> almost always been towards the former two.
>
> Naming specific resources and designating them as being shared and
> accounting them commonly somehow does make sense as an approach as we get to
> avoid the biggest headaches (e.g. how to split a page cache page?) and maybe
> it can even be claimed that a lot of use cases which may want cross-group
> sharing can be sufficiently served by such approach.
>
> That said, it still has to be balanced against other factors. For example,
> memory pressure caused by the shared resources should affect all
> participants in the sharing group in terms of both memory and IO, which
> means that they'll have to stay within a nested subtree structure. This does
> restrict overlapping partial sharing that you described above but the goal
> is finding a reasonable tradeoff, so something has to give.
>
> > > b. Memory is disassociated rather than just reparented on cgroup destruction
> > >    and get re-charged to the next first user. This is attractive in that it
> > >    doesn't require any userspace changes; however, I'm not sure how this
> > >    would work for non-pageable memory usages such as bpf maps. How would we
> > >    detect the next first usage?
> > >
> >
> > JFYI, There is a reuse path for the bpf map, see my previous RFC[1].
> > [1] https://lore.kernel.org/bpf/20220619155032.32515-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
>
> I'm not a big fan of explicit recharging. It's too hairy to use requiring
> mixing system level hierarchy configuration knoweldge with in-application
> resource handling. There should be clear isolation between the two. This is
> also what leads to namespace and visibility issues. Ideally, these should be
> handled by structuring the resource hierarchay correctly from the get-go.
>
> ...
> > > b. Let userspace specify which cgroup to charge for some of constructs like
> > >    tmpfs and bpf maps. The key problems with this approach are
> > >
> > >    1. How to grant/deny what can be charged where. We must ensure that a
> > >       descendant can't move charges up or across the tree without the
> > >       ancestors allowing it.
> > >
> >
> > We can add restrictions to check which memcg can be selected
> > (regarding the selectable memcg).
> > But I think it may be too early to do the restrictions, as only the
> > privileged user can set it.
> > It is the sys admin's responsbility to select a proper memcg.
> > That said, the selectable memcg is not going south.
>
> I generally tend towards shaping interfaces more carefully. We can of course
> add a do-whatever-you-want interface and declare that it's for root only but
> even that becomes complicated with things like userns as we're finding out
> in different areas, but again, nothing is free and approaches like that
> often bring more longterm headaches than the problems they solve.
>
> > >    2. How to specify the cgroup to charge. While specifying the target
> > >       cgroup directly might seem like an obvious solution, it has a couple
> > >       rather serious problems. First, if the descendant is inside a cgroup
> > >       namespace, it might be able to see the target cgroup at all.
> >
> > It is not a problem. Just sharing our practice below.
> > $ docker run -tid --privileged    \
> >                       --mount
> > type=bind,source=/sys/fs/bpf,target=/sys/fs/bpf    \
> >                       --mount
> > type=bind,source=/sys/fs/cgroup/memory/bpf,target=/bpf-memcg    \
> >                       docker-image
> >
> > The bind-mount can make it work.
>
> Not mount namespace. cgroup namespace which is used to isolate the cgroup
> subtree that's visible to each container. Please take a look at
> cgroup_namespaces(7).
>

IIUC, we can get the target cgroup with a relative path if cgroup
namespace is enabled, for example ../bpf, right ?
(If not, then I think we can extend it.)

> > >  Second,
> > >       it's an interface which is likely to cause misunderstandings on how it
> > >       can be used. It's too broad an interface.
> > >
> >
> > As I said above, we just need some restrictions or guidance if that is
> > desired now.
>
> I'm really unlikely to go down that path because as I said before I believe
> that that's a road to long term headaches and already creates immediate
> problems in terms of how it'd interact with other resources. No matter what
> approach we may choose, it has to work with the existing resource hierarchy.

Unfortunately,  the bpf map has already broken and is still breaking
the existing resource hierarchy.
What I'm doing is to improve or even fix this breakage.

The reason I say it is breaking the existing resource hierarchy is
that the bpf map is improperly treated as a process while it is really
a shared resource.

A bpf-map can be written by processes running in other memcgs, but the
memory allocated caused by the writing won't be charged to the
writer's memcg, but will be charged to bpf-map's memcg.

That's why I try to convey to you that what I'm trying to fix is a bpf
specific issue.

> Otherwise, we end up in a situation where we have to split accounting and
> control of other controllers too which makes little sense for non-memory
> controllers (not that it's great for memory in the first place).
>

If the resource hierarchy is what you concern, then I think it can be
addressed with below addition change,

if (cgroup_is_not_ancestor(cgrp))
    return -EINVAL;

-- 
Regards
Yafang
