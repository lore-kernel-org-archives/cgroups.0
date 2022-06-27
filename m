From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Mon, 27 Jun 2022 11:33:58 +0800
Message-ID: <CAMZfGtWrqFiXUtGkhQwuR3wk1a8xH4Z1+B8zCwRTzny7EJGG-Q@mail.gmail.com>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org> <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udYx9yVhBp19zfd4dxd6NWb/kHxWi5c9y7nXzGrjJEY=;
        b=Ntxnvqwm+4atSA7oH8HbS0qWbiyLl9hwKQPjhaoe5CikG0EkSFeR0jzF9Fwgs89O4j
         ozapg21g9OejXt5DBNn8WHlCY7d3wYaGk6oVysdhLX5uDoB0lr4Yj2j5BFkI8663a8CI
         vEn9f5StKVKnsH4GCtCWGuUIEclxpY7VETIg4LAbikp2xJIoxYRU/G60aZC+L5uz0YMX
         gAFxNaaPYcAbhKgIJuuMQXi6TMfdYpZvDjd1AL92PLhymq6SZ1HHzQqn1/sc6ctNL/67
         0YEX5l2JvW2MC4YiaTeERP3HtTy2l0iDOGc3MhIAtFpGeaEHSo0XcpN+idqgqzAYWKXG
         v33w==
In-Reply-To: <d8a9e9c6-856e-1502-95ac-abf9700ff568-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 27, 2022 at 10:12 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> When cgroup_mkdir reaches the limits of the cgroup hierarchy, it should
> not return -EAGAIN, but instead react similarly to reaching the global
> limit.
>
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
