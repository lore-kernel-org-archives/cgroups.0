From: Arnaldo Carvalho de Melo <arnaldo.melo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Fri, 30 Sep 2022 19:00:42 -0300
Message-ID: <88915C51-33CD-49A4-A9E0-F5F5ECDEA0C7@gmail.com>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com> <20220922041435.709119-1-namhyung@kernel.org> <YzdjHenrJpooKMjv@krava> <CAM9d7cjKaZvWQUwGwoTLNzAgHS7ndL_V_5+O+WqMUvuHJ7cWNg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date;
        bh=msbEtVn2XnPhkP1nh+HeVtH130znwtC+tV5GCPNIfiI=;
        b=JuT8PZMwI+cog5yqJIKmEDK9vgvcMw+jb0WaZ0auwmYV/Db1Q1AMNAynltuC4tEicO
         u36dDJel+DVg0RurCLUchPWR//yz8gbuwz+r+L8jEOITkv8Fb1z6jfv5M4kkJt/uZUPk
         ZYpqe4htpjO2DrZmiMsx/UBuGbwGsyFYI1amBup610De9zatozGqH//KKfY9oQuBn3Rc
         gDvIL/5o9wzsJI0WAAXFNYJvhzh3cYkHYyM2iPgbus6is+qB4ZJxFSANYNeJzHm+b8AH
         2WQWCCZiA1MqQ8UX+8zisnskeMFlB9QzlJaH7FpteCTh7WsnhikVECX8Z4AGvqR0NmLX
         5THg==
In-Reply-To: <CAM9d7cjKaZvWQUwGwoTLNzAgHS7ndL_V_5+O+WqMUvuHJ7cWNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users <linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On September 30, 2022 6:56:40 PM GMT-03:00, Namhyung Kim <namhyung@kernel=
=2Eorg> wrote:
>Hi Jiri,
>
>On Fri, Sep 30, 2022 at 2:44 PM Jiri Olsa <olsajiri@gmail=2Ecom> wrote:
>>
>> On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
>> > The recent change in the cgroup will break the backward compatiblity =
in
>> > the BPF program=2E  It should support both old and new kernels using =
BPF
>> > CO-RE technique=2E
>> >
>> > Like the task_struct->__state handling in the offcpu analysis, we can
>> > check the field name in the cgroup struct=2E
>> >
>> > Signed-off-by: Namhyung Kim <namhyung@kernel=2Eorg>
>> > ---
>> > Arnaldo, I think this should go through the cgroup tree since it depe=
nds
>> > on the earlier change there=2E  I don't think it'd conflict with othe=
r
>> > perf changes but please let me know if you see any trouble, thanks!
>>
>> could you please paste the cgroup tree link?
>
>Do you mean this?
>
>  https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/tj/cgroup=2Egit
>


Which branch and cset in that tree does you perf skel depends on?

- Arnaldo=20
>Thanks,=2E
>Namhyung
