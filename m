From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Relocate mod_objcg_mlstate(), get_obj_stock()
 and put_obj_stock()
Date: Tue, 30 Nov 2021 10:36:07 +0800
Message-ID: <CAMZfGtXvHB-PRe11VmmFqsLg9EQ3LUPqYA2zNi-1A81p-pzH5Q@mail.gmail.com>
References: <20211129161140.306488-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rgI/AaQZFO092ur38zyTNNcK9cTmIjNH5zoKttaDw+s=;
        b=kYkEpq6LFfs3NoxTELSmxCDx47pYFaIovpRQGk2quPgVmdWUClF+vOD/rZsiomySAK
         X/zimWA0oKUSpvxdallx8oTsNjVTID4LekkUuE/tLkqT+GQ1HYUie6ZhKNFbOtfVyLrg
         Ol6Ov926pxHkMA3keHjhtZeyKd40GR/QHKJXOriNYWJvDwZi+y5GANYYSFLL7EwFqLls
         SWOM6of0sDfztlYzipJoSoyG0n7huKNlRqpRkgc+Flg82cBAIaqmbxv4poSaIfXHcBVP
         68vLxzZrlSTYmwhvu7R6HepJZm6xQ31Nn9db81qJeAbnEl09V7n0zPl1oE840Yz/jQlU
         SWIQ==
In-Reply-To: <20211129161140.306488-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Nov 30, 2021 at 12:14 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> All the calls to mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()
> are done by functions defined within the same "#ifdef CONFIG_MEMCG_KMEM"
> compilation block. When CONFIG_MEMCG_KMEM isn't defined, the following
> compilation warnings will be issued [1] and [2].
>
>   mm/memcontrol.c:785:20: warning: unused function 'mod_objcg_mlstate'
>   mm/memcontrol.c:2113:33: warning: unused function 'get_obj_stock'
>
> Fix these warning by moving those functions to under the same
> CONFIG_MEMCG_KMEM compilation block. There is no functional change.
>
> [1] https://lore.kernel.org/lkml/202111272014.WOYNLUV6-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> [2] https://lore.kernel.org/lkml/202111280551.LXsWYt1T-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
>
> Fixes: 559271146efc ("mm/memcg: optimize user context object stock access")
> Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
