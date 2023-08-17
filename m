From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] selftests: cgroup: fix test_kmem_memcg_deletion kernel
 mem check
Date: Thu, 17 Aug 2023 13:02:08 -0700
Message-ID: <CALvZod4C7+q+wF6UYRq5Ud75o8PevUExHVs_kFZ9sDbzQbqM3A@mail.gmail.com>
References: <bvrhe2tpsts2azaroq4ubp2slawmop6orndsswrewuscw3ugvk@kmemmrttsnc7>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692302541; x=1692907341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFt42+2gL2zS27EyJiumcQJzSPb9Kj8mX4pG71zx5cw=;
        b=JeEPJFThFtK7b6jYwe7zK72koT1k9KkeHpiFPJ1aRPzOL9oY6vKDr3BSOZoLEbtizJ
         Faulh/e/+MOgduHk0RrucQCigvVUys2uGZPsgkaKG7ggxeQ2Q6SIbiE3UFC0X5LSz6DR
         /3uvEDap0anA8Ibix8KixmMZl4KuKYTvn6avYKILdWvbhZPBnESwBXLjiqrS73/4uy6t
         4hqy8HdMOqKjbYhf+EbLjT1wqvs+yOGIJ6tXWJNOOG47x9iNH49Z1H7EhySv84DVy5hw
         JwShuWqZmI4uoPbF/i06RvThRAfJKnhDyoIORcVFFVDmMtjOruBuLioebzarH/PG9U4I
         ZWdA==
In-Reply-To: <bvrhe2tpsts2azaroq4ubp2slawmop6orndsswrewuscw3ugvk@kmemmrttsnc7>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 17, 2023 at 12:58=E2=80=AFPM Lucas Karpinski <lkarpins@redhat.c=
om> wrote:
>
> Currently, not all kernel memory usage is being accounted for. This
> commit switches to using the kernel entry within memory.stat which
> already includes kernel_stack, pagetables, and slab. The kernel entry
> also includes vmalloc and other additional kernel memory use cases which
> were missing.
>
> Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
