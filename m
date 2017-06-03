From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 4/6] mm: memcontrol: use generic mod_memcg_page_state for
 kmem pages
Date: Sat, 3 Jun 2017 20:40:55 +0300
Message-ID: <20170603174055.GD15130@esperanza>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1+fHT4r/eaL8h5OAHR4B3m5yWDKu9D4HS/ZWEDrHzro=;
        b=FjYkgNSc37PBDeQJZkHq9mNpiLrKxvN/RNICspK31zx6qxiFqYm/DbXhE8LdoxM+jR
         5+kfKL+BfBRZWkssGcpbBDcIDb9TblegFEZhYVqL1Xbe7dDpWT7KDLtA9nyAHyhTTYpc
         OCBBirU7loisy6F+bZB8wyRZtIcui1M9W6GeYKDrUUZ8k59vnot9hs5bLl9QE1bs9g9T
         M+vI71x8F8MCwWSEHtdGcWnaHS6vH5rMWB5xkOLPXIZdJhLGZgXkX3e6GJ8OEk5fC44j
         NqZ8+mb/CvpZbpJGP7CvXbjjUcdF6gKjDQ+qxrId8wLPdd2WmDyL8ZfSAwIcIc6USqFy
         XgZg==
Content-Disposition: inline
In-Reply-To: <20170530181724.27197-5-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, May 30, 2017 at 02:17:22PM -0400, Johannes Weiner wrote:
> The kmem-specific functions do the same thing. Switch and drop.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h | 17 -----------------
>  kernel/fork.c              |  8 ++++----
>  mm/slab.h                  | 16 ++++++++--------
>  3 files changed, 12 insertions(+), 29 deletions(-)

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
