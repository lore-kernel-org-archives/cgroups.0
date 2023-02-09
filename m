From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next 2/5] bpf: use bpf_map_kvcalloc in bpf_local_storage
Date: Thu, 9 Feb 2023 19:27:19 +0800
Message-ID: <CALOAHbDSD6Nztr-Twa=nEEViBjCY5O3_1Ma6sRH4tJ-h_xvDzA@mail.gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com> <20230205065805.19598-3-laoar.shao@gmail.com>
 <Y+P3HSLNR94wILP1@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nV+ybsSlH6fK2G24aANd2g+1dPs+ZMjcUBV127jT5iM=;
        b=X4K+h7SDmsgXeHm6SaOqKeAx/ak9ol/Gl36DDVrtd9v5mfV9VkvblhU8nQ43XAXExl
         0Zt1F2nx9zBjVlXcB9TLAnC4pptj6RhMdfPfaW4zmacNVeI+g/po+g/eMkChVxAP/2Ax
         CNaLrdvnBvR1x//Vr2yOVxi6ZZEf/35FNvK9RLIsbuDGGL6TZD3ypxsOg3oYdWA11JSX
         yrmzxUfCSoBErji/R5CkNVV5s1KtCukigZsgcVZWCc6iRl2caL7yZR0Vz5WN4B25B3Fp
         jNQachOCoE6xeArss8RVs5hTwBaK6XEl43IezJq0vEZXHe1+l8IlpFNDe7I+gyGTcW9S
         rR+A==
In-Reply-To: <Y+P3HSLNR94wILP1-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Feb 9, 2023 at 3:25 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Sun, Feb 05, 2023 at 06:58:02AM +0000, Yafang Shao wrote:
> > Introduce new helper bpf_map_kvcalloc() for this memory allocation. Then
> > bpf_local_storage will be the same with other map's creation.
> >
> > Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> This looks good to me, but it could be helpful to explain the
> user-visible part of the bug somewhat, i.e. who is being charged right
> now for the allocation if it's not the map owner.

Sure. Will improve the commit log.

-- 
Regards
Yafang
