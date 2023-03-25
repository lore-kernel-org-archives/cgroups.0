From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Fri, 24 Mar 2023 21:30:49 -0700
Message-ID: <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com> <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
 <ZB5UalkjGngcBDEJ@slm.duckdns.org> <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679718661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGXkNVqKc7W3NTjCcHQcK32QEBD4ibnmet17kfhhRaI=;
        b=PHAZU2Rd9Fp65snbdneP5IXYTtAFunJK2mfV2/pfOyuB8dkyTMfzLLe7Dl3igKadFa
         9se6SnVK1wDMGZrmKj4em9x05vBVwT9dWKvwg8pfB+2xddz8jQLLd8c3dXTvTi5HoOEM
         2GmUtVmBPiPdjr12BNA1afc7hYkVEBk1ABclJR45XULgq8DAuovm6lEt8UxThY/ahIWw
         /3+c8DXYKZwbijUtJPP5HW0j6XNHzjMvdaTMuYjuMYSA5o4nA0vJqIFNgoPtwVjvftrU
         rmoy1A9rEEka+aR2qVX1FnFd+1ObOumqDzWfDhM4lQCmdSGzsAXwwcTSY0Qcql8kFfYk
         X7yQ==
In-Reply-To: <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 24, 2023 at 7:18=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
[...]
> Any ideas here are welcome!
>

Let's move forward. It seems like we are not going to reach an
agreement on making cgroup_rstat_lock a non-irq lock. However there is
agreement on the memcg code of not flushing in irq context and the
cleanup Johannes has requested. Let's proceed with those for now. We
can come back to cgroup_rstat_lock later if we still see issues in
production.

Tejun, do you have any concerns on adding WARN_ON_ONCE(!in_task()) in
the rstat flushing code?
