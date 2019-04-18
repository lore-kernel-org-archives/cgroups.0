From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle
 management
Date: Thu, 18 Apr 2019 13:34:52 +0000
Message-ID: <0100016a30a83bcf-7f99039c-77ec-4c48-a1c4-92e398f8f185-000000@email.amazonses.com>
References: <20190417215434.25897-1-guro@fb.com> <20190417215434.25897-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1555594493;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=tGKbg7T4m2hja67VSnD+5sN45YQjy0gEHiOhoXRYwnE=;
        b=ab1gt2ubDBnvlERvCSi1ce9rbtCoG/YS77M3OGWWcVMUjDZG7kdCTAIh3pFVU73u
        JBYkidNGYMpwtlzEcOGCrYV7+GGxIkApxsJL4FIYB0Sro4vm00cQ7klrHZkK5gkWFTd
        +5z2ftsGtTwkIdbIkR74gay/PBi7mTjrZi0orids=
In-Reply-To: <20190417215434.25897-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, david@fromorbit.com, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Wed, 17 Apr 2019, Roman Gushchin wrote:

> Let's make every page to hold a reference to the kmem_cache (we
> already have a stable pointer), and make kmem_caches to hold a single
> reference to the memory cgroup.

Ok you are freeing one word in the page struct that can be used for other
purposes now?

