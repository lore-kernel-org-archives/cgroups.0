From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/5] cgroup: remove cgroup_rstat_flush_atomic()
Date: Mon, 24 Apr 2023 10:17:01 -0700
Message-ID: <CALvZod4Ci1RamjLEk7e9zVnqSuEVKPEWjDUAwy6TWaU+X1WeVQ@mail.gmail.com>
References: <20230421174020.2994750-1-yosryahmed@google.com> <20230421174020.2994750-6-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682356631; x=1684948631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0eRdTeN7jkM57vYYN0vPrAxj3a6rnjVZ2S7PSMzkMk=;
        b=7NKiu1IiwRRKF1fJQNyjBd8av5/cqtJU9MwybHOmeJ+dADdvaJ+DHco65RXZQcn7X0
         6JM1kMAWRWTmsRwLfIIpTIne4JD5RbLum/t9IInggIEJOXFzqJ5Btg3SH2BQ/iEayg49
         khUC9L54LBJse/JTK1luGsjzv3ex8pX8qi8Z9b/yuXuX7MbPT6jx7vYp1Q5wyLKe8V/3
         9wmskz5xZmaPS3BGEJsZbf5OTzsPTkI3qyOfEJcLpS6d3lzg8PXdje6yMaIi/eb8BipH
         oZWUdcwrxh54KXDhvz4VCshlClgQWMJHDSkB0sM3NQJzWIV52NuydPQUr9SBJnA4lWmz
         MLIQ==
In-Reply-To: <20230421174020.2994750-6-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>
> Previous patches removed the only caller of cgroup_rstat_flush_atomic().
> Remove the function and simplify the code.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
