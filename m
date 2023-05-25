From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Thu, 25 May 2023 11:25:05 -0400
Message-ID: <8f56f60f-8dd3-d798-3d81-6ccbb185465d@redhat.com>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
 <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
 <3ej42djuuzwx36yf2yeo5ggyrvogeaguos5jtve2bvuaejnwff@fak3yjwe2fbi>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685028311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMrxhWgLyOUzKMB1Tal5g/FIIXS1y2NZ/71A12nEoZg=;
        b=RZqLRQIbG+ECn3iQXrIExaPkNFiYs7HaNZMdFpWgOftekITSrcTbCn3bFnF2x4FhhGF9lW
        M6Q4VKMQ0CrnMll9NtzVUpL8IBZ6hw3b8XbbhfSH7t8NSl+54MQPj/43JvGhTAvvsAIhmf
        jZrZOwyVRu9sVH5wez0oTkqkou5Rkeo=
Content-Language: en-US
In-Reply-To: <3ej42djuuzwx36yf2yeo5ggyrvogeaguos5jtve2bvuaejnwff@fak3yjwe2fbi>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 5/25/23 10:11, Michal Koutn=C3=BD wrote:
> On Wed, May 24, 2023 at 10:37:10AM +0800, Ming Lei <ming.lei-H+wXaHxf7aLQ=
T0dZR+AlfA@public.gmane.org> wrote:
>>> I am not at all familiar with blkcg, but does calling
>>> cgroup_rstat_flush() in offline_css() fix the problem?
>> Except for offline, this list needs to be flushed after the associated d=
isk
>> is deleted.
> Why the second flush trigger?
> a) To break another ref-dependency cycle (like on the blkcg side)?
> b) To avoid stale data upon device removal?
>
> (Because b) should be unnecessary, a future reader would flush when
> needed.)

Since the percpu blkg_iostat_set's that are linked in the lockless list=20
will be freed if the corresponding blkcg_gq is freed, we need to flush=20
the lockless list to avoid potential use-after-free in a future=20
cgroup_rstat_flush*() call.

Cheers,
Longman

