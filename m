From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files to tmpfs
Date: Tue, 21 Jul 2020 07:45:14 -0700
Message-ID: <CALvZod7xGNxJxTcJmo8mCVAgDkPdC5Pp12rhuBNsFsw-Yv=e+A@mail.gmail.com>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0pAwByUR93Lcw7763OHJXsSvUvLTrNih6qhx4gjT+aM=;
        b=RJPk4UVm3QG1OSNEE3CsSct0ln7CZy0uNFBtNkbOJqVixfV+ABWf25M4H+TnYcPfce
         Ta+awLrH5yk/hEx+EREuJMfro+hKQpGe5CFLuXIivkB9MRt63Mgki6+ZSqsYmq60+KGR
         saMyvxi2Hmz1v1xQI2GSgfDNxXTFo1iMzKVWjBJjRBqfCJ1CmI8KNgJBdaDfPJ2tuRhc
         1B2BJWsw4BWQe4cDBiWCe26f3Sag/jnK6MVlPixWUeRZaxdJW6M9dd3rU+dU/oYLU+7I
         NhW4hltGvXPB7wF1uCgYh08R3vYJ9kwAMy5b5J9dOBkBQSe9QqK7WkCSf+m3yniK49H9
         NTuA==
In-Reply-To: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7-vMFu1QFWtjo1LvNSbZiozgK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, caihaomin <caihaomin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Weiwei (N)" <wick.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Tue, Jul 21, 2020 at 4:20 AM jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> ; Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Thanks.
>
> ---
> PROBLEM: cgroup cost too much memory when transfer small files to tmpfs.
>
> keywords: cgroup PERCPU/memory cost too much.
>
> description:
>
> We send small files from node-A to node-B tmpfs /tmp directory using sftp. On
> node-B the systemd configured with pam on like below.
>
> cat /etc/pam.d/password-auth | grep systemd
> -session     optional      pam_systemd.so
>
> So when transfer a file, a systemd session is created, that means a cgroup is
> created, then file saved at /tmp will associated with a cgroup object. After
> file transferred, session and cgroup-dir will be removed, but the file in /tmp
> still associated with the cgroup object.

Is there a way for you to re-use the cgroup instead of creating and
deleting cgroup for each individual file transfer session?

> The PERCPU memory in cgroup/css object
> cost a lot(about 0.5MB/per-cgroup-object) on 200/cpus machine.
>
> When lot of small files transferred to tmpfs, the cgroup/css object memory
> cost become huge in this scenes to be used.
>
> systemd related issue: https://github.com/systemd/systemd/issues/16499
>
> kernel version: 4.19+
>
> Problem:
>
> 1. Do we have any idea to descrease cgroup memory cost in this case?
> 2. When user remove cgroup directory, does it possible associated file memory to root cgroup?

No, the memory remains associated with the cgroup and the cgroup
becomes zombie on deletion.

> 3. Can we provide an option that do not associate memory with cgroup in tmpfs?

Only way, if you don't want to disable memcg, is to move the file
receiver process to root cgroup.
