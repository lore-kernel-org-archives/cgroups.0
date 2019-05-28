From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 4/7] mm: unify SLAB and SLUB page accounting
Date: Tue, 28 May 2019 20:12:54 +0300
Message-ID: <20190528171254.ymnytie2uc4hwd4v@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7II5+XRnVobtVPgQVRQrDR8x4e5To08TyrztMHGvqag=;
        b=eaq0BTRPkhNafZhWSSYSrscltuZlK8p6kHWOeCVXycDQv7t3RspcGhqc4CbVFRfJ0/
         o7HJXatIFeoKZxyCMT287FoSfvrUs0U0xqqF+ZyaTxsF6AXOvHhx+mEnvBMiZVkkC7ec
         QCS0S+APb1j6fW2ryNi4o7g80ajjVeRBHQNbzfaBo7pN07pH1YZkz60t0gSOOA3Sa77n
         IUDDmczlKJ9hmuAndnQn4+Y/SUZKWO+OMmA80g+gjOLOd+UpCkLuevIe+dS8TuJtPJey
         2PC562PZ6yYaNgc3BidpuZdLxw+bNgr4tYYphKwEZ3XqIzT7w38tkPatdRI9FkWb/PTS
         N+nw==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

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

Makes sense even without the rest of the series,

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
