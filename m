From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Tue, 21 Feb 2023 09:47:05 -0800
Message-ID: <Y/UDmc3+uIErpanS@P9FQF9L96D.corp.robot.car>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
 <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
 <CALvZod55K5zbbVYptq8ud=nKVyU1xceGVf6UcambBZ3BA2TZqA@mail.gmail.com>
 <Y/TMYa8DrocppXRu@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677001642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9Vle9DIVimy94+UNgGowfW4NEcOWHtMED9QUramsCw=;
        b=tGJQqG2SnvFiAeIRPoeutMXJ8iZZtSxdJyku+xpxaxa3+Dvk2zq/YT7AMOnbj3PvaMVaXy
        ifTNdgxKhi/ObJVbavXqJsmPBJKDW6C1p0zbbIQPbpBYy9Z9dPsMuBJP2UunxLKJh8myrw
        MH2cdrdcc1F8cKP3K+ah8r2/B03ZsRc=
Content-Disposition: inline
In-Reply-To: <Y/TMYa8DrocppXRu-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 21, 2023 at 01:51:29PM +0000, Matthew Wilcox wrote:
> On Mon, Feb 20, 2023 at 10:52:10PM -0800, Shakeel Butt wrote:
> > On Mon, Feb 20, 2023 at 9:17 PM Roman Gushchin <roman.gushchin-fxUVXftI=
FDnyG1zEObXtfA@public.gmane.org> wrote:
> > > > On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0d=
ZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin w=
rote:
> > > >>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> > > >>> The knob for cgroup v2 memory controller: memory.oom.group
> > > >>> will be read and written simultaneously by user space
> > > >>> programs, thus we'd better change memcg->oom_group access
> > > >>> with atomic operations to avoid concurrency problems.
> > > >>>
> > > >>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.g=
mane.org>
> > > >>
> > > >> Hi Yue!
> > > >>
> > > >> I'm curious, have any seen any real issues which your patch is sol=
ving?
> > > >> Can you, please, provide a bit more details.
> > > >>
> > > >
> > > > IMHO such details are not needed. oom_group is being accessed
> > > > concurrently and one of them can be a write access. At least
> > > > READ_ONCE/WRITE_ONCE is needed here.
> > >
> > > Needed for what?
> >=20
> > For this particular case, documenting such an access. Though I don't
> > think there are any architectures which may tear a one byte read/write
> > and merging/refetching is not an issue for this.
>=20
> Wouldn't a compiler be within its rights to implement a one byte store as:
>=20
> 	load-word
> 	modify-byte-in-word
> 	store-word
>=20
> and if this is a lockless store to a word which has an adjacent byte also
> being modified by another CPU, one of those CPUs can lose its store?
> And WRITE_ONCE would prevent the compiler from implementing the store
> in that way.

Even then it's not an issue in this case, as we end up with either 0 or 1,
I don't see how we can screw things up here.

Thanks!
