From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] Make rstat flushing IRQ and sleep friendly
Date: Wed, 22 Mar 2023 21:10:21 -0700
Message-ID: <CALvZod5uyZRsvA5ntw0jSBXUNa1_HzB9zOabsGKsndyA5KCYnQ@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lcSWN3GyBfovXV1vZTMtcIYaPrkreWXQ9n4Cq5J+k0=;
        b=rsH6Q3RSuOVN3v4OApWCK2fKM+hkdBWgfdvhHyQzW5Pw+plPTNi9t2m+UBHsGzWBhv
         Pk3rTZw8S6erq7968367WPneS5lOiBB263QMPQIVZosoB7XgLrX5yK+4fD9eP3bHitsO
         uvxzf7qEvXAmJrFSpdvQ60LIHlUll8cmFnmqKpFZ1USUIBElYfXVEPUVMOIKgSNihg2n
         nslvhDFRmKyaFgWa0Y1XYP6jxLvfUtJtMY/+Q2dg//gD1t2dlL7SklCJpgAJluQNrVEh
         IC06YYalM2n8mMSw7nA8J/qZlHYoX/dOLHyJZPURTxp1XDJGlwr9WTpY2AlVLpaX4gxi
         gAsg==
In-Reply-To: <20230323040037.2389095-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> Currently, if rstat flushing is invoked using the irqsafe variant
> cgroup_rstat_flush_irqsafe(), we keep interrupts disabled and do not
> sleep for the entire flush operation, which is O(# cpus * # cgroups).
> This can be rather dangerous.
>
> Not all contexts that use cgroup_rstat_flush_irqsafe() actually cannot
> sleep, and among those that cannot sleep, not all contexts require
> interrupts to be disabled.

Too many negations in the above sentence is making it very confusing.
