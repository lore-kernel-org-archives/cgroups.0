From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Tue, 13 Jun 2023 14:06:44 +0200
Message-ID: <ZIhb1EwvrdKXpEMb@dhcp22.suse.cz>
References: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz>
 <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
 <ZFkEqhAs7FELUO3a@dhcp22.suse.cz>
 <CAJD7tkaw_7vYACsyzAtY9L0ZVC0B=XJEWgG=Ad_dOtL_pBDDvQ@mail.gmail.com>
 <ZIgodGWoC/R07eak@dhcp22.suse.cz>
 <CAJD7tkawYZAWKYgttgtPjscnZTARj+QaGZLGiMiSadwC3oCELQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686658004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HYVUFO1wPWNonY/X8OsDNVi5gRCOnIF00hLJCgVVXL8=;
        b=E2hmup+R2QkYLjr7YF45V8o6ojzs8mRStZDGZ4gtvemfRUU6ZMdUti8UWYB14K4N087zID
        PCmHqx+U0pWm1b+NAhJZWgxdcsmQ+DfDoUQ1SrXhDczXVUyCIOGHqIdZ4Mqv9LGNpjulD7
        sr0aoAT7cMde28oU3y65lkUec6malk0=
Content-Disposition: inline
In-Reply-To: <CAJD7tkawYZAWKYgttgtPjscnZTARj+QaGZLGiMiSadwC3oCELQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brauner@kernel.org" <brauner@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, pilgrimtao@gmail.com

On Tue 13-06-23 01:36:51, Yosry Ahmed wrote:
> +David Rientjes
>=20
> On Tue, Jun 13, 2023 at 1:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wr=
ote:
> >
> > On Sun 04-06-23 01:25:42, Yosry Ahmed wrote:
> > [...]
> > > There has been a parallel discussion in the cover letter thread of v4
> > > [1]. To summarize, at Google, we have been using OOM scores to
> > > describe different job priorities in a more explicit way -- regardless
> > > of memory usage. It is strictly priority-based OOM killing. Ties are
> > > broken based on memory usage.
> > >
> > > We understand that something like memory.oom.protect has an advantage
> > > in the sense that you can skip killing a process if you know that it
> > > won't free enough memory anyway, but for an environment where multiple
> > > jobs of different priorities are running, we find it crucial to be
> > > able to define strict ordering. Some jobs are simply more important
> > > than others, regardless of their memory usage.
> >
> > I do remember that discussion. I am not a great fan of simple priority
> > based interfaces TBH. It sounds as an easy interface but it hits
> > complications as soon as you try to define a proper/sensible
> > hierarchical semantic. I can see how they might work on leaf memcgs with
> > statically assigned priorities but that sounds like a very narrow
> > usecase IMHO.
>=20
> Do you mind elaborating the problem with the hierarchical semantics?

Well, let me be more specific. If you have a simple hierarchical numeric
enforcement (assume higher priority more likely to be chosen and the
effective priority to be max(self, max(parents)) then the semantic
itslef is straightforward.

I am not really sure about the practical manageability though. I have
hard time to imagine priority assignment on something like a shared
workload with a more complex hierarchy. For example:
	    root
	/    |    \
cont_A    cont_B  cont_C

each container running its workload with own hierarchy structures that
might be rather dynamic during the lifetime. In order to have a
predictable OOM behavior you need to watch and reassign priorities all
the time, no?

> The way it works with our internal implementation is (imo) sensible
> and straightforward from a hierarchy POV. Starting at the OOM memcg
> (which can be root), we recursively compare the OOM scores of the
> children memcgs and pick the one with the lowest score, until we
> arrive at a leaf memcg.

This approach has a strong requirement on the memcg hierarchy
organization. Siblings have to be directly comparable because you cut
off many potential sub-trees this way (e.g. is it easy to tell
whether you want to rule out all system or user slices?).

I can imagine usecases where this could work reasonably well e.g. a set
of workers of a different priority all of them running under a shared
memcg parent. But more more involved hierarchies seem more complex
because you always keep in mind how the hierarchy is organize to get to
your desired victim.

--=20
Michal Hocko
SUSE Labs
