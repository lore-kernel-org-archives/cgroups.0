From: Aaron Tomlin <atomlin@redhat.com>
Subject: Re: [PATCH v2] mm/memcg: Remove obsolete memcg_free_kmem()
Date: Wed, 6 Oct 2021 20:08:10 +0100
Message-ID: <20211006190810.ume55n4lugekcm63@ava.usersys.com>
References: <20211005202450.11775-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633547294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D1dm0Jsv2mUc+jhdc8qHClKIoNz3UWNx693+PgEldu0=;
        b=HRgjqzsSDo8mRKvkmzMwu8G4wQSFJXZ18uXKMGA7AlTyZdNWDcQSlA8zGoqkmbrMvadU3h
        w3mmcMZ19dWdDzfRvcT3qrLCPCTfd3xrLpux1f0WEThm8jA17jaR2mWsmGsV/fuHT97CIN
        pK1pgzjpO94Y09eXn4R7h8aDBln6XJA=
Content-Disposition: inline
In-Reply-To: <20211005202450.11775-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>

On Tue 2021-10-05 16:24 -0400, Waiman Long wrote:
> Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
> irreversible"), the only thing memcg_free_kmem() does is to call
> memcg_offline_kmem() when the memcg is still online which can happen when
> online_css() fails due to -ENOMEM. However, the name memcg_free_kmem()
> is confusing and it is more clear and straight forward to call
> memcg_offline_kmem() directly from mem_cgroup_css_free().
> 
> Suggested-by: Roman Gushchin <guro@fb.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Aaron Tomlin <atomlin@redhat.com>

-- 
Aaron Tomlin

