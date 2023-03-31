From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Fri, 31 Mar 2023 12:03:47 -0700
Message-ID: <CAJD7tka-2vNn25=NdrKQoMf4ntdbWtojY0k4eAa-c9D+v7J=HQ@mail.gmail.com>
References: <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com> <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz> <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz> <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
 <ZCVKqN2nDkkQFvO0@dhcp22.suse.cz> <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
 <ZCa9sixp3GJcjf8Y@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680289464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBgtdWro37xy0xED7gYpWdnIpcRD6CvxaVJDB91GKvs=;
        b=fL6JQwfkCzg5k8MIp2yW1eevTYpumo4axpAUWjeQVnxZ023oShCKTwLmnAc/fye6xx
         neR98ZJVj6piv4J9ecd7xjjIQYyACuTq59qmaCS3yTQOGPhA91OF92s4v9CkBWSpvvKM
         rz65GCEGOOJ8yjBjMqwAS3b3tgCOZKNxFJajWQaJRjRdc4CSg/cA57O8D+Oq6Oe1LAJ4
         2mVn/cvkii1QVT3GcQW/mRwIrCzXmOwHpOMN8C/onm9XRgMZ288OdnZgwdQUr7MMj8+8
         RRbSZfC/Y3QYlXMJZsdEzOOnNaU20+AvLyLZyFhObvmRedEK5bFf9W0VpJPo3NjJ/PlU
         ADqQ==
In-Reply-To: <ZCa9sixp3GJcjf8Y@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Fri, Mar 31, 2023 at 4:02=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 30-03-23 01:53:38, Yosry Ahmed wrote:
> [...]
> > Maybe we can add a primitive like might_sleep() for this, just food for=
 thought.
>
> I do not think it is the correct to abuse might_sleep if the function
> itself doesn't sleep. If it does might_sleep is already involved.

Oh, sorry if I wasn't clear, I did not mean to reuse might_sleep() --
I meant introducing a new similar debug primitive that shouts if irqs
are disabled.

> --
> Michal Hocko
> SUSE Labs
