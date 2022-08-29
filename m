From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Mon, 29 Aug 2022 11:07:35 -0700
Message-ID: <CA+khW7h5KAqmhJB+3bCmeqs5EW927XnK1D+GrXqa3RUaxb1wTQ@mail.gmail.com>
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-2-haoluo@google.com>
 <9edbddb7-4a3b-f8d1-777c-66e5f8efc977@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7rQocjicZEmcxwKtCOFzf24LVnPFDEo/4tWTRLGIYcE=;
        b=qL0rlGpyTRDVHdnZwy6wQJuIxEKjKUMQsjBj7a45cUf5S7tBgmg1bF5R/f9PiNR0Gn
         KWmzUDLsZEk79MqhJnyZIZRGIBj5vp4MUALH8RpbD+Ww3cAQo1OpenjDGzmr2p2oQC+i
         fV8bTXy5/C0GwxuhaUkXKHsUBy7mGZcNC/Aa2SjE+YGMUHyqf7fMt7TKYLMKz3CNYYXS
         pSxOmPMS5EROBSrSBSm4vbT+wUQAoBGMxub3djMvhplX2nbVFS45/nEhV4wct2EMl9/t
         Lk4TwfNdzKaBlQeNpeAj8WKQEyYuGVcbrNA+udLLIFWNW5Pc/dlmBmBBGvOEyl1iqYFr
         Z5kA==
In-Reply-To: <9edbddb7-4a3b-f8d1-777c-66e5f8efc977-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 25, 2022 at 4:00 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
> Hao, we missed the bpftool dump part for the above bpf_link_info so
> a followup is needed.
> Please take a look at tools/bpf/bpftool/link.c searching 'map_id'
> for an example.

Sure Yonghong. I was on vacation. Will do this today.
