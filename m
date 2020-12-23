From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v5 1/7] mm: memcontrol: fix NR_ANON_THPS accounting in
 charge moving
Date: Wed, 23 Dec 2020 13:01:07 -0800
Message-ID: <CALvZod7WqYEVOD0o7y+JVcTjdF8N=cbZHEeXa3VvkMsJDQjeKg@mail.gmail.com>
References: <20201217034356.4708-1-songmuchun@bytedance.com> <20201217034356.4708-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g36tAmTEjSaA0vpBKIUlCpStJerd4pisa8lbF6yxKNQ=;
        b=kn3BVILCed5+28QuNVyEq3hRiqw3fts33Is0SKnBnm17qBAVZ6oxU+DgC7uMmunsTH
         2a8wsM30fyoKI6v9GWohnvTMO5TYWEKkVvE4s/DF3tT8r5sdLksMQxtNkyWi0AcTFDW4
         hzsZELBW0HTOt7N1u6bEzGc/JOnkLsHiAVA5rj/vh/uyWPVcX86QX6MXrj/vEh+tO/wr
         0sSNB2ZbmhP1LDMvMU6ZvEQDpTyGMYClmNF1sruJq5YfeMV7C8cqn0Px8HjHsQIdLbk8
         5GRLH2bKy5K4w+EZF35tH6U5vIO0TqDfdYVDaxNJu/ntR7m/JgE56e2Kf41SGSmLlpc3
         h6Aw==
In-Reply-To: <20201217034356.4708-2-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Sami Tolvanen <samitolvanen@google.com>, Feng Tang <feng.tang@intel.com>, Neil Brown <neilb@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

On Wed, Dec 16, 2020 at 7:45 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> by one rather than nr_pages.
>
> Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> Reviewed-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
