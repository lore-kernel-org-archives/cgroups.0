From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] mm/memcg: remove definition of MEM_CGROUP_ID_MAX when
 !CONFIG_MEMCG
Date: Fri, 7 Jul 2023 09:47:46 +0800
Message-ID: <892B507C-CFE8-4792-BA5F-3C698290A8EE@linux.dev>
References: <20230706112820.2393447-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688694503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pp8ftPIqIMWudMuh7pf3FOr9N5RY8pAcKRI4zNvC1xk=;
        b=NAnGKJVhSLp4yv2kkSMp6ADs5X+O14sYJ3GsIbaqOhhGuEqWS8qfljYCRlUZlp9ICcdIYz
        5FxxKOSECYnAUDSrDCflNCisXuLUqXM51woWVHg9ky1pusXt5nfstpC1xnpzNla/MRsAEM
        pVfOzYEieXPnM9NljXB2CjqfStTa/c0=
In-Reply-To: <20230706112820.2393447-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>



> On Jul 6, 2023, at 19:28, Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
> MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured. Remove
> unneeded !CONFIG_MEMCG variant.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

MEM_CGROUP_ID_MAX is also only used in mem_cgroup_alloc(), maybe you also
could move it from memcontrol.h to memcontrol.c. And define it as:

#define MEM_CGROUP_ID_MAX ((1U << MEM_CGROUP_ID_SHIFT) - 1)

I am not suggesting defining it as USHRT_MAX, because if someone changes
MEM_CGROUP_ID_SHIFT in the future, then MEM_CGROUP_ID_MAX will not updated
accordingly.

For this patch, LGTM.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

