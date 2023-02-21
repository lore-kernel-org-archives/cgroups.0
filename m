From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Mon, 20 Feb 2023 21:17:25 -0800
Message-ID: <6563189C-7765-4FFA-A8F2-A5CC4860A1EF@linux.dev>
References: <20230220230624.lkobqeagycx7bi7p@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676956658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHA4ShwNMc6Yko4CbZnfjUYJ3+IEBFc/U9IHl1ydyHU=;
        b=SXSZebXV3YlaL4vWyE/804yKeFVfemiAG1+03DjJ6qxJkRSrXnmU0+PShEqj3GjAY5zPiX
        wMvdyP9wVBiSDcdKGvCTvpXtS5z5qfbZaGs+tWTsPwwuZJoE7vUsH7Pufzko8fAojReXSK
        MUzlB4qxYLsDXsDQEHUlhfdQs6bkSsQ=
In-Reply-To: <20230220230624.lkobqeagycx7bi7p-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> On Feb 20, 2023, at 3:06 PM, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> =EF=BB=BFOn Mon, Feb 20, 2023 at 01:09:44PM -0800, Roman Gushchin wrote:
>>> On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
>>> The knob for cgroup v2 memory controller: memory.oom.group
>>> will be read and written simultaneously by user space
>>> programs, thus we'd better change memcg->oom_group access
>>> with atomic operations to avoid concurrency problems.
>>>=20
>>> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>=20
>> Hi Yue!
>>=20
>> I'm curious, have any seen any real issues which your patch is solving?
>> Can you, please, provide a bit more details.
>>=20
>=20
> IMHO such details are not needed. oom_group is being accessed
> concurrently and one of them can be a write access. At least
> READ_ONCE/WRITE_ONCE is needed here.

Needed for what?

I mean it=E2=80=99s obviously not a big deal to put READ_ONCE()/WRITE_ONCE()=
 here, but I struggle to imagine a scenario when it will make any difference=
. IMHO it=E2=80=99s easier to justify a proper atomic operation here, even i=
f it=E2=80=99s most likely an overkill.

My question is very simple: the commit log mentions =E2=80=9C=E2=80=A6 to av=
oid concurrency problems=E2=80=9D, so I wonder what problems are these.

Also there are other similar cgroup interfaces without READ_ONCE()/WRITE_ONC=
E().

Thanks!=
