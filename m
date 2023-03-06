From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store
 tearing fixes
Date: Mon, 6 Mar 2023 08:25:57 -0800
Message-ID: <CALvZod5z4F=mS=kgd4DOy8HHCDpL--hxw2uf_bjE+7Svs5ps_g@mail.gmail.com>
References: <20230306154138.3775-1-findns94@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678119968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oquj9zczWta39dkibg5GfP7EL+Ye+DwkctVIeTmEPfU=;
        b=bosj6vnLUEt0XF9hTitW9opaoGtgVkZRNCeGSYikHGh3TN+eYxRp69ZbhlogPQt3FC
         8+rYgTRXE1ny3erHUDalB0QrgQcH8attkXk+h1d2LtKytFU8zc8Pfma1exRiysE8xxTq
         oMF80ZLxkA2wZf2Lm3emXf73HHEVNb7Dxy2mPqbtX4uvytvi41oLdUwW5V6fpqzYeGbX
         X+vayVe/4cTpkB5QiIc48PF7K8R2Hb/423TKKHaptnPZ5AOBhPwL7PTzyQkDVPxXiV0J
         ImE7y9Qsd+bXutgMq2XH3h21VjyFBpDzN2BVXtPNSZ1nX2TSuzooHCJh0aW5l141RdfQ
         g6aw==
In-Reply-To: <20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Mar 6, 2023 at 7:42=E2=80=AFAM Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> This patch series helps to prevent load/store tearing in
> several cgroup knobs.
>
> As kindly pointed out by Michal Hocko and Roman Gushchin
> , the changelog has been rephrased.
>
> Besides, more knobs were checked, according to kind suggestions
> from Shakeel Butt and Muchun Song.
>
> v1:
> - Add [WRITE|READ]_ONCE for memcg->oom_group
> v2:
> - Rephrase changelog
> - Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
>  memcg->swappiness, vm_swappiness and memcg->soft_limit
>

Thanks Yue and for the whole series:

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
