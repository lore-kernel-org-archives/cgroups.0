From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 1/1] memcg: enable accounting for pids in nested pid namespaces
Date: Mon, 26 Apr 2021 12:39:44 -0700
Message-ID: <CALvZod5uw+f5dY=dUmHvdRq-4OfJBQ8zqjT5rZzpKtqQoy+28A@mail.gmail.com>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com> <8b6de616-fd1a-02c6-cbdb-976ecdcfa604@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uKTFMl2K/jBtlUdprMSpQyuu4jIlYrjBFVJg7lJPhEk=;
        b=QLHlSH2LL9uXh4sy9QtauiXaoF8OnWxtk9QCSh8791OUvFB4sYoW8jVjCMkGTrtcQL
         FrGfNwUH0L3V08sKOzFRiJBbxgvswr4ji3xy0XAO/ufgHwMRGO6lR3COBApdiOIM/wk5
         POZkZIlQVZuug1Bn5mrxSe11DlrX+WEBcb3+u5Ut7b/ygHXvPDZutuvyEZ7HLinkTewW
         ISOX6S3OTcWbJyAX2Us30EFYhEOiff5QHkx6fv3pKd5//JiqcTwxKiS1xZfFqNrVY4K4
         it/m5g7kX04xUv8RCDAMnDfVccezvq8wz9ORMKhwhg9p6SAxNBLtvy4KiSRqAZSu+wuD
         JM3g==
In-Reply-To: <8b6de616-fd1a-02c6-cbdb-976ecdcfa604@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>, Christian Brauner <christian.brauner@ubuntu.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Serge Hallyn <serge@hallyn.com>

On Sat, Apr 24, 2021 at 4:54 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Commit 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> enabled memcg accounting for pids allocated from init_pid_ns.pid_cachep,
> but forgot to adjust the setting for nested pid namespaces.
> As a result, pid memory is not accounted exactly where it is really neede=
d,
> inside memcg-limited containers with their own pid namespaces.
>
> Pid was one the first kernel objects enabled for memcg accounting.
> init_pid_ns.pid_cachep marked by SLAB_ACCOUNT and we can expect that
> any new pids in the system are memcg-accounted.
>
> Though recently I've noticed that it is wrong. nested pid namespaces crea=
tes
> own slab caches for pid objects, nested pids have increased size because =
contain
> id both for all parent and for own pid namespaces. The problem is that th=
ese slab
> caches are _NOT_ marked by SLAB_ACCOUNT, as a result any pids allocated i=
n
> nested pid namespaces are not memcg-accounted.
>
> Pid struct in nested pid namespace consumes up to 500 bytes memory,
> 100000 such objects gives us up to ~50Mb unaccounted memory,
> this allow container to exceed assigned memcg limits.
>
> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Acked-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
