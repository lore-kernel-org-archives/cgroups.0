From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 2/5] memcg: flush stats non-atomically in mem_cgroup_wb_stats()
Date: Thu, 20 Apr 2023 11:55:40 -0700
Message-ID: <CALvZod5mxE8RAtCEZkaq2fce-Od5MZtyPppn-ns0XzXHMcFm9g@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com> <20230403220337.443510-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682016952; x=1684608952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbCxu47aXqOZFjOgElAuAaCkhQzE3b3RJfWYjmehSCc=;
        b=oa5zJsQrq+PRcAacYKvPmJFEiT892k3KGbGwJQk5suWva6mPaVh1qqAA8IzY+Jj/hD
         VFBYO4okZJxeVSzysh4ToRnXR/6o5DYUVATkBJfNde9WKEOtWJJ8yy7sY1xXBfZGEY3q
         xOZ0jkjwyMWdnarfIh0L8R4nUzdGSyWIKSazjknGk1r11LI/2RO684ecfw7UrQTVXs/M
         GzaTUPkrFcjqNquKq6y2UAqISLWfsxVd028RdcSxBegIpsM6e0JAtRgxUzO7FY9aKxf+
         Lt1hLlXFBFqgRdkJ2/8j3ivRECJ5MYEvxha3Z2O262UcpC3xjQwUKeyV2yCazEbahUJf
         4cIw==
In-Reply-To: <20230403220337.443510-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> The previous patch moved the wb_over_bg_thresh()->mem_cgroup_wb_stats()
> code path in wb_writeback() outside the lock section. We no longer need
> to flush the stats atomically. Flush the stats non-atomically.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
