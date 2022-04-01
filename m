From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 02:20:12 -0700
Message-ID: <CAJD7tkZHxRY0GEhcRoa8PqLM7pnsu44_U9XKV-9u==iGqwf3=g@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com> <2025405d-c32b-338a-b668-48b07a34e4ef@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OMo1PXKDvOs4amOpy943mVmES4FKrWtNYVwoIwrlEW0=;
        b=dE6o1rYodzjxtTII77PFayYHwAYvGEuz/3yKkeKM5iYvV8dPsZmhNg2JrlVHGvoqEg
         L7098s00vdpVkCAhCfZoBf5ieoMJ0WbvWSpObmsBX34vbVpYN8HhJk4/0O1F4IGKgJQ5
         EBmsy+JXP2q1i82SETOgFmXz8jdV+Rxw0f1W97He4sangP1hWP8kV6gWUoziezC+eBES
         m71DCS4rpwOd+WsQkuR7P20g6CnniuRqZpHaMi6Zm29GlSQ7oiWa/LCbJvO27w69w3Nx
         d1IZ2RugbuspyjLvjQM5cNntqE27YZVznZSZCABIoXbQ3ZlX4tlBz/1/tRFYHduOO81+
         7Khg==
In-Reply-To: <2025405d-c32b-338a-b668-48b07a34e4ef@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chen Wandun <chenwandun@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Thu, Mar 31, 2022 at 8:05 PM Chen Wandun <chenwandun@huawei.com> wrote:
>
>
>
> =E5=9C=A8 2022/3/31 16:41, Yosry Ahmed =E5=86=99=E9=81=93:
> > From: Shakeel Butt <shakeelb@google.com>
> >
> > Introduce an memcg interface to trigger memory reclaim on a memory cgro=
up.
> >
> > Use case: Proactive Reclaim
> > ---------------------------
> >
> > A userspace proactive reclaimer can continuously probe the memcg to
> > reclaim a small amount of memory. This gives more accurate and
> > up-to-date workingset estimation as the LRUs are continuously
> > sorted and can potentially provide more deterministic memory
> > overcommit behavior. The memory overcommit controller can provide
> > more proactive response to the changing behavior of the running
> > applications instead of being reactive.
> >
> > A userspace reclaimer's purpose in this case is not a complete replacem=
ent
> > for kswapd or direct reclaim, it is to proactively identify memory savi=
ngs
> > opportunities and reclaim some amount of cold pages set by the policy
> > to free up the memory for more demanding jobs or scheduling new jobs.
> >
> > A user space proactive reclaimer is used in Google data centers.
> > Additionally, Meta's TMO paper recently referenced a very similar
> > interface used for user space proactive reclaim:
> > https://dl.acm.org/doi/pdf/10.1145/3503222.3507731
> >
> > Benefits of a user space reclaimer:
> > -----------------------------------
> >
> > 1) More flexible on who should be charged for the cpu of the memory
> > reclaim. For proactive reclaim, it makes more sense to be centralized.
> >
> > 2) More flexible on dedicating the resources (like cpu). The memory
> > overcommit controller can balance the cost between the cpu usage and
> > the memory reclaimed.
> >
> > 3) Provides a way to the applications to keep their LRUs sorted, so,
> > under memory pressure better reclaim candidates are selected. This also
> > gives more accurate and uptodate notion of working set for an
> > application.
> >
> > Why memory.high is not enough?
> > ------------------------------
> >
> > - memory.high can be used to trigger reclaim in a memcg and can
> >    potentially be used for proactive reclaim.
> >    However there is a big downside in using memory.high. It can potenti=
ally
> >    introduce high reclaim stalls in the target application as the
> >    allocations from the processes or the threads of the application can=
 hit
> >    the temporary memory.high limit.
> >
> > - Userspace proactive reclaimers usually use feedback loops to decide
> >    how much memory to proactively reclaim from a workload. The metrics
> >    used for this are usually either refaults or PSI, and these metrics
> >    will become messy if the application gets throttled by hitting the
> >    high limit.
> >
> > - memory.high is a stateful interface, if the userspace proactive
> >    reclaimer crashes for any reason while triggering reclaim it can lea=
ve
> >    the application in a bad state.
> >
> > - If a workload is rapidly expanding, setting memory.high to proactivel=
y
> >    reclaim memory can result in actually reclaiming more memory than
> >    intended.
> >
> > The benefits of such interface and shortcomings of existing interface
> > were further discussed in this RFC thread:
> > https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd@g=
oogle.com/
> >
> > Interface:
> > ----------
> >
> > Introducing a very simple memcg interface 'echo 10M > memory.reclaim' t=
o
> > trigger reclaim in the target memory cgroup.
> >
> >
> > Possible Extensions:
> > --------------------
> >
> > - This interface can be extended with an additional parameter or flags
> >    to allow specifying one or more types of memory to reclaim from (e.g=
.
> >    file, anon, ..).
> >
> > - The interface can also be extended with a node mask to reclaim from
> >    specific nodes. This has use cases for reclaim-based demotion in mem=
ory
> >    tiering systens.
> >
> > - A similar per-node interface can also be added to support proactive
> >    reclaim and reclaim-based demotion in systems without memcg.
> >
> > For now, let's keep things simple by adding the basic functionality.
> >
> > [yosryahmed@google.com: refreshed to current master, updated commit
> > message based on recent discussions and use cases]
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   Documentation/admin-guide/cgroup-v2.rst |  9 ++++++
> >   mm/memcontrol.c                         | 37 ++++++++++++++++++++++++=
+
> >   2 files changed, 46 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 69d7a6983f78..925aaabb2247 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1208,6 +1208,15 @@ PAGE_SIZE multiple when read back.
> >       high limit is used and monitored properly, this limit's
> >       utility is limited to providing the final safety net.
> >
> > +  memory.reclaim
> > +     A write-only file which exists on non-root cgroups.
> > +
> > +     This is a simple interface to trigger memory reclaim in the
> > +     target cgroup. Write the number of bytes to reclaim to this
> > +     file and the kernel will try to reclaim that much memory.
> > +     Please note that the kernel can over or under reclaim from
> > +     the target cgroup.
> > +
> >     memory.oom.group
> >       A read-write single value file which exists on non-root
> >       cgroups.  The default value is "0".
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 725f76723220..994849fab7df 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6355,6 +6355,38 @@ static ssize_t memory_oom_group_write(struct ker=
nfs_open_file *of,
> >       return nbytes;
> >   }
> >
> > +static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
> > +                           size_t nbytes, loff_t off)
> > +{
> > +     struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
> > +     unsigned int nr_retries =3D MAX_RECLAIM_RETRIES;
> > +     unsigned long nr_to_reclaim, nr_reclaimed =3D 0;
> > +     int err;
> > +
> > +     buf =3D strstrip(buf);
> > +     err =3D page_counter_memparse(buf, "", &nr_to_reclaim);
> > +     if (err)
> > +             return err;
> > +
> > +     while (nr_reclaimed < nr_to_reclaim) {
> > +             unsigned long reclaimed;
> > +
> > +             if (signal_pending(current))
> > +                     break;
> > +
> > +             reclaimed =3D try_to_free_mem_cgroup_pages(memcg,
> > +                                             nr_to_reclaim - nr_reclai=
med,
> > +                                             GFP_KERNEL, true);
> In some scenario there are lots of page cache,  and we only want to
> reclaim page cache,
> how about add may_swap option?

Thanks for taking a look at this!

The first listed extension is an argument/flags to specify the type of
memory that we want to reclaim, I think this covers this use case, or
am I missing something?

> > +
> > +             if (!reclaimed && !nr_retries--)
> > +                     break;
> > +
> > +             nr_reclaimed +=3D reclaimed;
> > +     }
> > +
> > +     return nbytes;
> > +}
> > +
> >   static struct cftype memory_files[] =3D {
> >       {
> >               .name =3D "current",
> > @@ -6413,6 +6445,11 @@ static struct cftype memory_files[] =3D {
> >               .seq_show =3D memory_oom_group_show,
> >               .write =3D memory_oom_group_write,
> >       },
> > +     {
> > +             .name =3D "reclaim",
> > +             .flags =3D CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
> > +             .write =3D memory_reclaim,
> > +     },
> >       { }     /* terminate */
> >   };
> >
>
