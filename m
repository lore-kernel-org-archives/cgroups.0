From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: linux-next: arm32: beagleboard x15: WARNING: CPU: 0 PID: 0 at
 /usr/src/kernel/kernel/cgroup/cgroup.c:1969 cgroup_setup_root+0x36c/0x4e8
Date: Fri, 15 Nov 2019 14:28:43 +0530
Message-ID: <CA+G9fYu-w+3qgkGet4B4NeBxQNaXoWij49j0WRwPAYELgakb6w@mail.gmail.com>
References: <CA+G9fYviReoG+gq=Jm8yQOMd01j2opae5p+VTGGMK7aLn0xWgw@mail.gmail.com>
 <20191114224213.GN4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+pg9wj7yRXgLDbaXk97MrdYcFuUJiaocpSFiWUQa1o=;
        b=UTHgI7il6nkwPJ5t8b7FMh0XJmESz0IGK7rLutWB2vw6I0WyJlHZc5HzSJe9OJO/Ja
         cy90XKj0jyihqQIuf3/Ck0cF/JNi8a+GasJC5mVdphNQ7QLH8qwoPiyf5YOLM25O8vUE
         e8HS4mV64/idioykbqun7VK9SHxe/G39ajtZOMaPkNT4mZiM3aHLURCdjKP3qGnV9YAF
         qZfzHyhsp1iwHI3ganjVtmXZ/Z8kRYHYojIyVFx6IdWBhExFxC+EmY3F7bcGcsbuVv1A
         3GVwJ9NAqejEzjvYAnJylfaw7p8QaRTdtXztlHIoB5j4SiHJJMjpmlprWqNwfzWFc3or
         IsUA==
In-Reply-To: <20191114224213.GN4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, namhyung@kernel.org, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, lizefan@huawei.com, hannes@cmpxchg.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>

Hi Tejun,

On Fri, 15 Nov 2019 at 04:12, Tejun Heo <tj@kernel.org> wrote:
> > [    0.015402] WARNING: CPU: 0 PID: 0 at /usr/src/kernel/kernel/cgroup/cgroup.c:1969
> > cgroup_setup_root+0x36c/0x4e8
> ...
> > [    0.015726] [<c053ac48>] (cgroup_setup_root) from [<c1c2a260>]
> > (cgroup_init+0x108/0x560)
>
> So, that's saying that the initial kernfs_node ino allocation returned
> something other than 1.  Hmmm... x86_32 works fine.  What does the
> following say?
>
> # mkdir -p /tmp/cgroup2
> # mount -t cgroup2 none /tmp/cgroup2
> # ls -lid /tmp/cgroup2


 mkdir -p /tmp/cgroup2
 mount -t cgroup2 none /tmp/cgroup2
 ls -lid /tmp/cgroup2
 1 dr-xr-xr-x 5 root root 0 Nov 15 08:00 /tmp/cgroup2


Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1011451#L1170

- Naresh
