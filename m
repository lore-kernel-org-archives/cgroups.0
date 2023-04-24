From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/5] writeback: move wb_over_bg_thresh() call outside
 lock section
Date: Mon, 24 Apr 2023 10:16:34 -0700
Message-ID: <CALvZod5g9MYjYB5eY4Z9rX5goyh7xSU_b3nfCpJCoUrzmHpyAg@mail.gmail.com>
References: <20230421174020.2994750-1-yosryahmed@google.com> <20230421174020.2994750-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682356605; x=1684948605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFrKoxBHGprwgkyWOKkqPAUbe8SAzISHnkMGiiR8Aro=;
        b=UfBxvwVKYODQclpyyYmaFw+7g6vxWtp7h7eOLJzSO+Z4ZTIFraL2+ZKsSs2aXXuwsh
         HbDf5lyhZa88b5+PXxEI3xiuHA63r0DZqaOTUAqjEiIyw3u7d736t+fN1KOyOsXqKSIA
         8X2Inx/COF34us2GlZKK5Cq3jAC6buT8baXyjzFdKs6GK//FxdZnoqKt3AevOqfjcddu
         LL0kCTlD6IvZg2NLITGh0pBzvgbkj8R0+iJtApNuZe+MvXkMU3T07tEhupSemhWHOECT
         MHOXbbv5i4QMRJGaUVdL+h3BdxuFWUXKUd9nXpgbJQoa3sgZX7tViIMGFDFh0eeD47kC
         nrlQ==
In-Reply-To: <20230421174020.2994750-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>
> wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
> flush, which can be expensive on large systems. Currently,
> wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
> have to do the rstat flush atomically. On systems with a lot of
> cpus and/or cgroups, this can cause us to disable irqs for a long time,
> potentially causing problems.
>
> Move the call to wb_over_bg_thresh() outside the lock section in
> preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic.
> The list_empty(&wb->work_list) check should be okay outside the lock
> section of wb->list_lock as it is protected by a separate lock
> (wb->work_lock), and wb_over_bg_thresh() doesn't seem like it is
> modifying any of wb->b_* lists the wb->list_lock is protecting.
> Also, the loop seems to be already releasing and reacquring the
> lock, so this refactoring looks safe.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
