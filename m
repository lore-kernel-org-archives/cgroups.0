From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 10:15:24 -0800
Message-ID: <CALvZod6692L-mteZ9r+0Q1EZc_V7ZSQSwNtz+AbunFXZPKeUgg@mail.gmail.com>
References: <20230220230624.lkobqeagycx7bi7p@google.com> <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org> <Y/UDmc3+uIErpanS@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOgO/w06KVBEyUXIMY7wyQCGQx5gFUoRCVeioCjbV5M=;
        b=YGdztCTlaHrRbsKTCaOZcHg4zoVQf9sO6DhN0S+s8gLe9egkas2r1pR7vjCXOgIDck
         NJWuc3v0C6KuSOJmV2M0Eg8v2xOsHEgfWvu8vifqTwy0xOPsd33J5Lss/yNGsDerodKO
         Zh8QCfkTre3S5aJ58OkBgvlwhc9zeduIYtTYNB6un1RFp/q5lf/26EkHnKZ2HBzPVttS
         MMC13lP+IWG1Xi7/wGG7sA95MqHpkkZRUq3zHeGYfSGnijOLMz+IoUN1/nwRAayGCORs
         iJTF04oB/MCC31ZJoQseePfV43knWNWbVLcgUsyfFIAqowZPp/hixJziw4kKmA52WjFn
         LPwA==
In-Reply-To: <Y/UDmc3+uIErpanS@P9FQF9L96D.corp.robot.car>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Yue Zhao <findns94@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, muchun.song@linux.dev, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Feb 21, 2023 at 9:47 AM Roman Gushchin <roman.gushchin@linux.dev> w=
rote:
>
> On Tue, Feb 21, 2023 at 01:51:29PM +0000, Matthew Wilcox wrote:
> > On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> > > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin@linux.=
dev> wrote:
> > > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb@google.com> w=
rote:
> > > > >
> > > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin=
 wrote:
> > > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > > > >>> will be read and written simultaneously by user space
> > > > >>> programs, thus we'd better change memcg->oom_group access
> > > > >>> with atomic operations to avoid concurrency problems.
> > > > >>>
> > > > >>> Signed-off-by: Yue Zhao <findns94@gmail.com>
> > > > >>
> > > > >> Hi Yue!
> > > > >>
> > > > >> I'm curious, have any seen any real issues which your patch is s=
olving?
> > > > >> Can you, please, provide a bit more details.
> > > > >>
> > > > >
> > > > > IMHO such details are not needed. oom_group is being accessed
> > > > > concurrently and one of them can be a write access. At least
> > > > > READ_ONCE/WRITE_ONCE is needed here.
> > > >
> > > > Needed for what?
> > >
> > > For this particular case, documenting such an access. Though I don't
> > > think there are any architectures which may tear a one byte read/writ=
e
> > > and merging/refetching is not an issue for this.
> >
> > Wouldn't a compiler be within its rights to implement a one byte store =
as:
> >
> >       load-word
> >       modify-byte-in-word
> >       store-word
> >
> > and if this is a lockless store to a word which has an adjacent byte al=
so
> > being modified by another CPU, one of those CPUs can lose its store?
> > And WRITE_ONCE would prevent the compiler from implementing the store
> > in that way.
>
> Even then it's not an issue in this case, as we end up with either 0 or 1=
,
> I don't see how we can screw things up here.
>

What do you mean by this is not an issue in this case? Yes, the
oom_group usage will be ok but we can not say anything about the
adjacent byte/fields.
