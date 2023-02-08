From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH bpf-next 0/5] bpf, mm: introduce cgroup.memory=nobpf
Date: Wed, 8 Feb 2023 14:29:43 -0500
Message-ID: <Y+P4J5+fykUp67b5@cmpxchg.org>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ckq//vME+Nz5mmbgePkAmCR230i6+DQZLOGVcNp8OPI=;
        b=mY9IBBFHZrMt3A7IAF4mj5amR2XXHtGbkhKVwWX3uZwbz8T5AaiDODgRKqOBw8LfK2
         5dl7uRpC26Fv81ZHwfOHZsYObi8lbqOW7Q/VFNQroo9KB2njDmFW+73tT9lRFbtTq14D
         RNGfsDHsmXQ3q5g71UxwNdqeC2twiEB88FJg27NRVBL9OfPo4/SnRJ1x8335humNkyKB
         Z+uUnGrUZvdq5MbT51Uq35FqJwaR42M7g0FznkYlVTRsPISYBQqXCcJ2P4zg/sjddj0T
         WTr7Yws0uYkc/sb/ahUuZfkDxJxO+KFPudzY8szdtLIuKqyYXr9PPcXBkUcR909g7awT
         gYcA==
Content-Disposition: inline
In-Reply-To: <20230205065805.19598-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Feb 05, 2023 at 06:58:00AM +0000, Yafang Shao wrote:
> The bpf memory accouting has some known problems in contianer
> environment,
> 
> - The container memory usage is not consistent if there's pinned bpf
>   program
>   After the container restart, the leftover bpf programs won't account
>   to the new generation, so the memory usage of the container is not
>   consistent. This issue can be resolved by introducing selectable
>   memcg, but we don't have an agreement on the solution yet. See also
>   the discussions at https://lwn.net/Articles/905150/ .
> 
> - The leftover non-preallocated bpf map can't be limited
>   The leftover bpf map will be reparented, and thus it will be limited by 
>   the parent, rather than the container itself. Furthermore, if the
>   parent is destroyed, it be will limited by its parent's parent, and so
>   on. It can also be resolved by introducing selectable memcg.
> 
> - The memory dynamically allocated in bpf prog is charged into root memcg
>   only
>   Nowdays the bpf prog can dynamically allocate memory, for example via
>   bpf_obj_new(), but it only allocate from the global bpf_mem_alloc
>   pool, so it will charge into root memcg only. That needs to be
>   addressed by a new proposal.
> 
> So let's give the user an option to disable bpf memory accouting.
> 
> The idea of "cgroup.memory=nobpf" is originally by Tejun[1].

I'm not the most familiar with bpf internals, but the memcg bits and
adding the boot time flag look good to me:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
