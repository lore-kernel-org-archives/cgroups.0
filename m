From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm/memcg: update page struct member in comments
Date: Fri, 6 Nov 2020 12:51:40 -0800
Message-ID: <20201106205140.GA2285866@carbon.dhcp.thefacebook.com>
References: <1604662413-5734-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=g/IF6JDeuYmH1ljRDYU6MG+7bcLFRY47bRijoqWLlug=;
 b=G4m5UURfK2cLS7lmNUqhuY0NnUrFFAX0/GYVEinPITWo5KYgnwY6TIjgWKaexUklh8SP
 eIvhtcXmsIuvT2ZDJn0FjLV3RsSzzw+WeLB6iiIC2RIPj7g1U817IS8h/Xb2N9/VosKK
 XiavQmdPQ99BtdryV0lPbvA01ITzEM3xPPI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/IF6JDeuYmH1ljRDYU6MG+7bcLFRY47bRijoqWLlug=;
 b=Mr+OC9T3Mw00pmrXTf77P7zajnLuaQV+JYhX3/k8Ip7DXM9KKHTzT9bqzvzEsjVy3BwsgDHbid+RVASBLJoLZR9nyarmO28x5wIFyWnuJkw8sUM8o0APTPMNEZd+20l8WWkvnuX0RKTFqnbwJ5io8r3G+F87/6luzTvihE5hhjs=
Content-Disposition: inline
In-Reply-To: <1604662413-5734-1-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: hannes@cmpxchg.org, akpm@linux-foundation.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Nov 06, 2020 at 07:33:33PM +0800, Alex Shi wrote:
> The page->mem_cgroup member is replaced by memcg_data, and add a helper
> page_memcg() for it. Need to update comments to avoid confusing.

Hi Alex,

thank you for bringing it in!
I definitely missed those.

> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org> 
> Cc: Michal Hocko <mhocko@kernel.org> 
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com> 
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Cc: cgroups@vger.kernel.org 
> Cc: linux-mm@kvack.org 
> Cc: linux-kernel@vger.kernel.org 
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b2aa3b73ab82..8a8debea34fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1310,7 +1310,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>   * @page: the page
>   * @pgdat: pgdat of the page
>   *
> - * This function relies on page->mem_cgroup being stable - see the
> + * This function relies on page_memcg(page) being stable - see the
>   * access rules in commit_charge().

There are "page and memcg binding" and "page's memcg" used in similar cases,
I think it's more obvious than "page_memcg(page) being stable".

Maybe it helps to address Ira's comment.

Anyway, please feel free to add:
Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
