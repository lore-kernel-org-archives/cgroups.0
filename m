From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Tue, 13 Jun 2023 13:24:24 -0700
Message-ID: <CAJD7tka-w8-0G5hjr8MRAue0wct0UPh4-BrPEGkOa1eUycz5mQ@mail.gmail.com>
References: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz> <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
 <ZFkEqhAs7FELUO3a@dhcp22.suse.cz> <CAJD7tkaw_7vYACsyzAtY9L0ZVC0B=XJEWgG=Ad_dOtL_pBDDvQ@mail.gmail.com>
 <ZIgodGWoC/R07eak@dhcp22.suse.cz> <CAJD7tkawYZAWKYgttgtPjscnZTARj+QaGZLGiMiSadwC3oCELQ@mail.gmail.com>
 <ZIhb1EwvrdKXpEMb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686687901; x=1689279901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tu74121bGTOyi/gScvgyRcJ4UHCFo8s9EjAjR7M4bno=;
        b=ulZ0jrJSHTa44Qg7LztFaCU5OztMo1pzVdcwaQdm3K0MJ+V8u2aBjSkTyr9cquXrQA
         GHi/c9unlglS2gH6aSu87kJPrEnsYJkUqT7K98t95dvhTb2hl8FnJlyKH59hFs/QomsE
         B0IG2WTvaJQe+TMeAvtQzzZCYw9ZbLHP7XM+ayfnU//j7Plf0t2fyDdDz/YHSjg1fE1y
         vfJ7xZTNRGH04qcTdDaxtvDjnf7xuB9RSqUHby5veNVYLqpQ7nGJy4ytb5MQtdmPP4O8
         yNPNCgR/Ew0tge3k25Z+klUrBuGsQ4LGa/QDhPzFgee+jNvpGtHmhB70UEtFK1O60XHE
         s3iA==
In-Reply-To: <ZIhb1EwvrdKXpEMb@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: =?UTF-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= <chengkaitao@didiglobal.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brauner@kernel.org" <brauner@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, pilgrimtao@gmai

On Tue, Jun 13, 2023 at 5:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 13-06-23 01:36:51, Yosry Ahmed wrote:
> > +David Rientjes
> >
> > On Tue, Jun 13, 2023 at 1:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Sun 04-06-23 01:25:42, Yosry Ahmed wrote:
> > > [...]
> > > > There has been a parallel discussion in the cover letter thread of =
v4
> > > > [1]. To summarize, at Google, we have been using OOM scores to
> > > > describe different job priorities in a more explicit way -- regardl=
ess
> > > > of memory usage. It is strictly priority-based OOM killing. Ties ar=
e
> > > > broken based on memory usage.
> > > >
> > > > We understand that something like memory.oom.protect has an advanta=
ge
> > > > in the sense that you can skip killing a process if you know that i=
t
> > > > won't free enough memory anyway, but for an environment where multi=
ple
> > > > jobs of different priorities are running, we find it crucial to be
> > > > able to define strict ordering. Some jobs are simply more important
> > > > than others, regardless of their memory usage.
> > >
> > > I do remember that discussion. I am not a great fan of simple priorit=
y
> > > based interfaces TBH. It sounds as an easy interface but it hits
> > > complications as soon as you try to define a proper/sensible
> > > hierarchical semantic. I can see how they might work on leaf memcgs w=
ith
> > > statically assigned priorities but that sounds like a very narrow
> > > usecase IMHO.
> >
> > Do you mind elaborating the problem with the hierarchical semantics?
>
> Well, let me be more specific. If you have a simple hierarchical numeric
> enforcement (assume higher priority more likely to be chosen and the
> effective priority to be max(self, max(parents)) then the semantic
> itslef is straightforward.
>
> I am not really sure about the practical manageability though. I have
> hard time to imagine priority assignment on something like a shared
> workload with a more complex hierarchy. For example:
>             root
>         /    |    \
> cont_A    cont_B  cont_C
>
> each container running its workload with own hierarchy structures that
> might be rather dynamic during the lifetime. In order to have a
> predictable OOM behavior you need to watch and reassign priorities all
> the time, no?

In our case we don't really manage the entire hierarchy in a
centralized fashion. Each container gets a score based on their
relative priority, and each container is free to set scores within its
subcontainers if needed. Isn't this what the hierarchy is all about?
Each parent only cares about its direct children. On the system level,
we care about the priority ordering of containers. Ordering within
containers can be deferred to containers.

>
> > The way it works with our internal implementation is (imo) sensible
> > and straightforward from a hierarchy POV. Starting at the OOM memcg
> > (which can be root), we recursively compare the OOM scores of the
> > children memcgs and pick the one with the lowest score, until we
> > arrive at a leaf memcg.
>
> This approach has a strong requirement on the memcg hierarchy
> organization. Siblings have to be directly comparable because you cut
> off many potential sub-trees this way (e.g. is it easy to tell
> whether you want to rule out all system or user slices?).
>
> I can imagine usecases where this could work reasonably well e.g. a set
> of workers of a different priority all of them running under a shared
> memcg parent. But more more involved hierarchies seem more complex
> because you always keep in mind how the hierarchy is organize to get to
> your desired victim.

I guess the main point is what I mentioned above, you don't need to
manage the entire tree, containers can manage their subtrees. The most
important thing is to provide the kernel with priority ordering among
containers, and optionally priority ordering within a container
(disregarding other containers).

>
> --
> Michal Hocko
> SUSE Labs
