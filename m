From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v3 4/7] mm: unify SLAB and SLUB page accounting
Date: Mon, 13 May 2019 18:01:05 +0000
Message-ID: <0100016ab25aef20-4552213a-13e1-4aff-ba52-e970f3ac7fd4-000000@email.amazonses.com>
References: <20190508202458.550808-1-guro@fb.com> <20190508202458.550808-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1557770465;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=PlYvmqxRpVISnjsRFpBbrKcWou6q8G660sOR1uIfQB8=;
        b=b8UGgDxXFtgOe6/nHEgwLitQKKdP6MaTm72eml72TE9fnqIiPmXw8fT7pLun0Kck
        rTcHdXuzgkeKJJQmYht5nMnPLcckFMsU/bqzVWYwIlrnDkBQuekNUTWLhxi0ugBfjUe
        6vhOsZoNl7l4/KTlnny/6ogqiyJ4zFkjdnQwfoKQ=
In-Reply-To: <20190508202458.550808-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Wed, 8 May 2019, Roman Gushchin wrote:

> Currently the page accounting code is duplicated in SLAB and SLUB
> internals. Let's move it into new (un)charge_slab_page helpers
> in the slab_common.c file. These helpers will be responsible
> for statistics (global and memcg-aware) and memcg charging.
> So they are replacing direct memcg_(un)charge_slab() calls.

Looks good.

Acked-by: Christoph Lameter <cl@linux.com>
