From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 09/11] mm: memcontrol: use obj_cgroup APIs to charge
 the LRU pages
Date: Wed, 1 Jun 2022 19:34:38 +0200
Message-ID: <20220601173438.GC2434@blackbody.suse.cz>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-10-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654104880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjM3NNyZi+mdyAAgbPoVYQ4gLBCkOnK/73Cw9/lkEMA=;
        b=fMgAUfgOUjfloaDS4p8wAJAzvluuJQWZvnxiAi6ShSWltsPq3megQImODM+d9HSmLxJwFW
        MPWNEw2VE8jdwfgtsn50e1wTFaVQCwr62zTR8vifW9Q6K6zdvBem445A38lxWHjrF3MLUd
        99BaPGC4eSxt1lgF0sZWfxXLV2fja2o=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-10-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello Muchun.

On Mon, May 30, 2022 at 03:49:17PM +0800, Muchun Song <songmuchun-EC8Uxl6Np=
ydl57MIdRCFDg@public.gmane.org> wrote:
> +static inline bool obj_cgroup_is_root(struct obj_cgroup *objcg)
> +{
> +	return objcg =3D=3D root_obj_cgroup;
> +}

Admittedly, this predicate alone caught my eye, why it did not also
check root_mem_cgroup->objcg_list.
However, deeper look reveals it's purpose is to avoid missing uncharges
of pages that were charged in non-root memcg and later re-associated
upwards after reparenting.
So it's like obj_cgroup_root_origin() (I'm not suggesting a rename, just
illustrating the understanding).

get_obj_cgroup_from_current() gains some complexity but it still holds
that in root memcg neither kernel objects nor LRU pages are charged.
At the same time, reparented kernel objects or LRU pages are properly
uncharged.

These parts are=20
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

(I did not look into the locking guarantees with the new API though.)

