From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Wed, 22 Feb 2023 16:05:50 -0800
Message-ID: <Y/at3iYz/xBSPPM+@infradead.org>
References: <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SGz5nzrr6kl9XQ1Pjiut45xDaCZGappO0V2Hw2xCxOo=; b=Y32WBerE9lXfZSywGU2o8Xqhfu
        B54C6eYhk9WRm6mS49oYuznaXhzjq+W9GbNkfnBFw6Dlsvxra3TmcZ6krBqbr6R+rmZse3gGsc70W
        atJ36URTU6qbLRw4nbhCl1yBBW+oa5k1S51zib8X0je8tk60pud15Q/Ay9O1jUhWOO5V/TcjPNz6X
        PdC/gRekMkwnFTvVbRJGmpGlyIJRE6L+OgaKRwmu4mMx2TrxghBaIyk8xVNkcyeA6aKzE6nCvdhUX
        /UDH22TYGx6LGYGM/2HC3twxSMXDHi8IVScnXquQvTeAqXoFsHkInvrzalhHk45x5ld5F9qfSiYQ1
        Xx8uhgvw==;
Content-Disposition: inline
In-Reply-To: <87k009nvnr.fsf@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 23, 2023 at 09:59:35AM +1100, Alistair Popple wrote:
> The idea was every driver already needs to allocate a pages array to
> pass to pin_user_pages(), and by necessity drivers have to keep a
> reference to the contents of that in one form or another. So
> conceptually the equivalent of:
> 
> struct vm_account {
>        struct list_head possible_pinners;
>        struct mem_cgroup *memcg;
>        struct pages **pages;
>        [...]
> };
> 
> Unpinnig involves finding a new owner by traversing the list of
> page->memcg_data->possible_pinners and iterating over *pages[] to figure
> out if that vm_account actually has this page pinned or not and could
> own it.
> 
> Agree this is costly though. And I don't think all drivers keep the
> array around so "iterating over *pages[]" may need to be a callback.

Is pinning in this context referring to FOLL_LONGTERM pins or any
FOLL_PIN?  In the latter case block based direct I/O does not keep
the pages array around, and also is absolutely not willing to pay
for the overhead.

For FOLL_LONGTERM the schemes sounds vaguely reasonable to me.
