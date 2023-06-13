From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Tue, 13 Jun 2023 01:36:51 -0700
Message-ID: <CAJD7tkawYZAWKYgttgtPjscnZTARj+QaGZLGiMiSadwC3oCELQ@mail.gmail.com>
References: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz> <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
 <ZFkEqhAs7FELUO3a@dhcp22.suse.cz> <CAJD7tkaw_7vYACsyzAtY9L0ZVC0B=XJEWgG=Ad_dOtL_pBDDvQ@mail.gmail.com>
 <ZIgodGWoC/R07eak@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686645448; x=1689237448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZ+CvAJZZG5mOPdj3tAJQaLRWxTq3hPFAsybxhkvum8=;
        b=ueFdsDRGBH0IFFxFK5dPixyGXGsAYzcWqUEOQdg71MXN4n/hDpu0fNd0RBX7IsmfP3
         2LqBGZ7Zq7fzGNk1KNj2QhoaYIBhAcrjtYWnhh8lBr/CZRgapwKBEo9Yv0ShQqCEhWWv
         dvl8YHEyWCBJXZQ46e5a4rsHQDnQGFHAFsRsAJbsg66c/0Jok8KeWHl2y6iOw9PN0ldg
         ZWOUAS0SHMlY9th/JhoJ+LiL0QsVq0PSzBI5bllG3ESnXuSADW/2eGQu6CKX6lbLKy72
         JhXWx5Sk4E4G/oAYn95haLXo0bn5JcE6n0OgTMYsXscI9SoyZZAvG0HnlKS/9h0EVtR6
         /cqA==
In-Reply-To: <ZIgodGWoC/R07eak@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: =?UTF-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= <chengkaitao@didiglobal.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brauner@kernel.org" <brauner@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, pilgrimtao@gmai

+David Rientjes

On Tue, Jun 13, 2023 at 1:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Sun 04-06-23 01:25:42, Yosry Ahmed wrote:
> [...]
> > There has been a parallel discussion in the cover letter thread of v4
> > [1]. To summarize, at Google, we have been using OOM scores to
> > describe different job priorities in a more explicit way -- regardless
> > of memory usage. It is strictly priority-based OOM killing. Ties are
> > broken based on memory usage.
> >
> > We understand that something like memory.oom.protect has an advantage
> > in the sense that you can skip killing a process if you know that it
> > won't free enough memory anyway, but for an environment where multiple
> > jobs of different priorities are running, we find it crucial to be
> > able to define strict ordering. Some jobs are simply more important
> > than others, regardless of their memory usage.
>
> I do remember that discussion. I am not a great fan of simple priority
> based interfaces TBH. It sounds as an easy interface but it hits
> complications as soon as you try to define a proper/sensible
> hierarchical semantic. I can see how they might work on leaf memcgs with
> statically assigned priorities but that sounds like a very narrow
> usecase IMHO.

Do you mind elaborating the problem with the hierarchical semantics?

The way it works with our internal implementation is (imo) sensible
and straightforward from a hierarchy POV. Starting at the OOM memcg
(which can be root), we recursively compare the OOM scores of the
children memcgs and pick the one with the lowest score, until we
arrive at a leaf memcg. Within that leaf, we also define per-process
scores, but these are less important to us.

I am not sure I understand why this is not sensible from a hierarchy
POV or a very narrow use case. Not that all this is optional, by
default all memcgs are given the same score, and ties are broken based
on per-memcg (or per-process) usage.

>
> I do not think we can effort a plethora of different OOM selection
> algorithms implemented in the kernel. Therefore we should really
> consider a control interface to be as much extensible and in line
> with the existing interfaces as much as possible. That is why I am
> really open to the oom protection concept which fits reasonably well
> to the reclaim protection scheme. After all oom killer is just a very
> aggressive method of the memory reclaim.
>
> On the other hand I can see a need to customizable OOM victim selection
> functionality. We've been through that discussion on several other
> occasions and the best thing we could come up with was to allow to plug
> BPF into the victim selection process and allow to bypass the system
> default method. No code has ever materialized from those discussions
> though. Maybe this is the time to revive that idea again?

That definitely sounds interesting, and it was brought up before. It
does sound like BPF (or a different customization framework) can be
the answer here. Interested to hear what others think as well.

>
> > It would be great if we can arrive at an interface that serves this
> > use case as well.
> >
> > Thanks!
> >
> > [1]https://lore.kernel.org/linux-mm/CAJD7tkaQdSTDX0Q7zvvYrA3Y4TcvLdWKnN=
3yc8VpfWRpUjcYBw@mail.gmail.com/
> --
> Michal Hocko
> SUSE Labs
