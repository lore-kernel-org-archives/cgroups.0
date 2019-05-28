From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v5 4/7] mm: unify SLAB and SLUB page accounting
Date: Tue, 28 May 2019 18:00:28 -0400
Message-ID: <20190528220028.GB26614@cmpxchg.org>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zz3efGRJMkCi9u1FMXnDOgSGtU0NK8c6CTTxYaLRlUk=;
        b=UZzU4SeJuNsj1RuhrcyrwW4MS5X4kGC8Ge0T2obb1h/h/CTewhMxNkcfTqUtxV7Ybt
         l9JJno+dbcn1nkV0bH46Xhs3idLMJ4T/k55B/bpWBy9ryQnadZtrxLIcchZWxAkYBAbu
         fbhRFIDfo0/NnrAyNaE2ecYXcWho1QdaI0s/85/A+X7r9AK+tHFK+6aNWEpQy9HQs8Bb
         Li6LBCRaI75me6R17Qp1LTHnXDTPmx2UWK0vuWad9yeDuO3j4ni9wGrrdVO0l8uqGxHW
         8Dsgz6ec6+oz4dmuhnZIKpxAgp6jx6+atPwCgm0WJQwwyg81bncpkILNj4fcw8WBEp02
         G2HA==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:32PM -0700, Roman Gushchin wrote:
> Currently the page accounting code is duplicated in SLAB and SLUB
> internals. Let's move it into new (un)charge_slab_page helpers
> in the slab_common.c file. These helpers will be responsible
> for statistics (global and memcg-aware) and memcg charging.
> So they are replacing direct memcg_(un)charge_slab() calls.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Christoph Lameter <cl@linux.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
