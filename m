From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Mon, 18 Jul 2022 17:19:30 -0700
Message-ID: <CA+khW7i_SCDoMgtVWw=E5RkJBmSvqo+KFjVp3_X+LZ9wyfqO7g@mail.gmail.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com> <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
 <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/tfmTl8rXDFpYRGXN4+L+UsANM+7IsYT4VqGSMDHfM=;
        b=YsSa6GugGINKY6fPTPL9pliswrcB1UYTnSQSyvHufKXAKsnNqjgbZf/MrzBAVFkpkV
         3efUWwnPZNgyam4zbFiZvkF6DwmWKFdS4gCpQebSh57I/6VOBjSSfsjowVXVPiw71gNH
         de+i+jDRoJXPnuWcTFjPOCu7w5EYVFWAUjK8xRxu3vg0KbHaPYzSIuS0CLG8vyC+lneJ
         h4Ng6A/IL8PySfzmZtqDJZ+vkSLiZB+gEobBhwgUXPRZxEZxNCQ3mkTA+krKy7w5UpLY
         vLso/ZSSkedxwIUPkoCsvkpFvozIoqB8yMpsstKN1pibqE18Si1uau6Mu0kK3kRsror3
         2GFg==
In-Reply-To: <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux

On Mon, Jul 18, 2022 at 12:34 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
>
> I think I figured this one out (the CI failure). I set max_entries for
> the maps in the test to 10, because I have 1 entry per-cgroup, and I
> have less than 10 cgroups. When I run the test with other tests I
> *think* there are other cgroups that are being created, so the number
> exceeds 10, and some of the entries for the test cgroups cannot be
> created.

Using hashmap to store per-cgroup data is only a short-term solution.
We should work on extending cgroup-local storage to tracing programs.
Maybe as a follow-up change once cgroup_iter is merged.

> in the bpf trace produced by my test, and the error turned out to be
> -E2BIG. I increased max_entries to 100 and it seems to be consistently
> passing when run with all the other tests, using both test_progs and
> test_progs-no_alu32.
>
> Please find a diff attached fixing this problem and a few other nits:
> - Return meaningful exit codes from the reclaimer() child process and
> check them in induce_vmscan().
> - Make buf and path variables static in get_cgroup_vmscan_delay()
> - Print error code in bpf trace when we fail to create a bpf map entry.
> - Print 0 instead of -1 when we can't find a map entry, to avoid
> underflowing the unsigned counters in the test.
>
> Let me know if this diff works or not, and if I need to send a new
> version with the diff or not. Also let me know if this fixes the
> failures that you have been seeing locally (which looked different
> from the CI failures).
>

Yosry, I also need to address Yonghong's comments in the cgroup_iter
patch, so we need to send v4 anyway.

Hao

> Thanks!
>
[...]
