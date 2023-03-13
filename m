From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Mon, 13 Mar 2023 12:44:31 -0700
Message-ID: <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
References: <20230313083452.1319968-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678736672;
        bh=W94HEWIftode6/6zR57Ubi2uQZUtKVwUT0RuE4adZeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YFSLYeGI819Stzjl6ClJqdTFh/Ihg6fYTsWQvoQiC78GMGNGqG5a6KLj5e9mRpPfh
         dnPIAQIl+j99tqT3dq7ZMEWKrX4l/K2ECdNDdtXqK1+TbyzDgcljQWvIBlqMnetHE5
         OJlMJZ1aZJc+hhnYtMdNrG7sdM6aBZXF+dGGE81Q=
In-Reply-To: <20230313083452.1319968-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 13 Mar 2023 08:34:52 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> In a kernel with added WARN_ON_ONCE(PageTail) in page_memcg_check(), we
> observed a warning from page_cgroup_ino() when reading
> /proc/kpagecgroup.

If this is the only known situation in which page_memcg_check() is
passed a tail page, why does page_memcg_check() have

	if (PageTail(page))
		return NULL;

?  Can we remove this to simplify, streamline and clarify?


