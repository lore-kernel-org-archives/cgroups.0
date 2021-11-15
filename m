From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 1/5] mm/shmem: support deterministic charging of tmpfs
Date: Mon, 15 Nov 2021 09:53:00 -0800
Message-ID: <CALvZod72uULZ1TfJbk5q-0cVTmGfBG=a5zNb69nb4A2bv+pPWA@mail.gmail.com>
References: <20211108211959.1750915-1-almasrymina@google.com>
 <20211108211959.1750915-2-almasrymina@google.com> <20211108221047.GE418105@dread.disaster.area>
 <YYm1v25dLZL99qKK@casper.infradead.org> <20211109011837.GF418105@dread.disaster.area>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NsJwQViYjBx6x1vnKWwbVuDzGBfSCVWT/rbaDdS07o=;
        b=KO3K519hv/U7eBTcKvTNDP2eKFUA2AUXYqJpuH3H7HpyMWbd/okypmhcyl68qsgEMB
         Tk6M3OgdZeFJesvlAB5Bhgl6XW/O9P8mk3dMd4fFh80iqqMofW9VhwiDp62KQ0N/YUUx
         kuKS6PM57Mxitv2Gso7uX6bsb3i2CsyEFARebzexwMlXFoA74eOMXb002OmB9tn9+Y85
         wR9hyRPYMFGUdQX09cuC8rvxOvFIKVUi7nFklVRic3dV6iooqaWcyuL5oVncWpD+oPvG
         mL1mSaV4SWgyrxi/iuT2d03XoYCARQJVASW7AGQBqLHs2tgGfUQfKdhwJr20mXiPSoOr
         4lYw==
In-Reply-To: <20211109011837.GF418105@dread.disaster.area>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, Mina Almasry <almasrymina@google.com>, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Nov 8, 2021 at 5:18 PM Dave Chinner <david@fromorbit.com> wrote:
>
[...]
>
> > If we are to have this for all filesystems, then let's do that properly
> > and make it generic functionality from its introduction.
>
> Fully agree.
>

Mina, I think supporting all filesystems might be a much cleaner
solution than adding fs specific code.

We need to:

1) Add memcg option handling in vfs_parse_fs_param() before fs
specific param handling.
2) Add a new page cache memcg charging interface (similar to swap).

With (1), no need to change any fs specific code.

With (2), fs codepaths will be free of memcg specific handling. This
new interface will be used in __filemap_add_folio(),
shmem_add_to_page_cache() and collapse_file().

thanks,
Shakeel
