From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 09:59:35 +1100
Message-ID: <87k009nvnr.fsf@nvidia.com>
References: <Y+4lcq4Fge27TQIn@nvidia.com> <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com> <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com> <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com> <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEkgqc8O5bXpNrc9NPq8zjyGAtxzYq4xZ0g7ZP0VIYU=;
 b=K4ce+te2PjmL/TZR19WKv6RqyhnPZ2vtQhFLo6Mc2cPp6KGmH7/jxwRJRrMXVqbP1jKPYBMtOZKLiPlrebaXEQdg7X/bnRXTiSDZPswLcUXXbWi0dJDOFyTUzmn/qhXCtylnsmya3c+YDwIikyLyR0U+UOt6evaN2ZDU2C9YXlJBd0RpSs7bTpvPdJm9QSS5Wyl2TVU4tLzJ7d7i9zkW+awl6ut7ou+rjs/92oWMsZRTo5xILzhrLtBiv7lwhItkontTl+zbZp/wsAHcIMEVOrl9Ma7/MHRl3qJDixKKMqSVq9TVV8QT+ziZPpKP+euX1Lsour1OvBEaX1x//lGFjQ==
In-reply-to: <Y/YRJNwwvqp7nKKt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:

> On Wed, Feb 22, 2023 at 10:38:25PM +1100, Alistair Popple wrote:
>> When a driver unpins a page we scan the pinners list and assign
>> ownership to the next driver pinning the page by updating memcg_data and
>> removing the vm_account from the list.
>
> I don't see how this works with just the data structure you outlined??
> Every unique page needs its own list_head in the vm_account, it is
> doable just incredibly costly.

The idea was every driver already needs to allocate a pages array to
pass to pin_user_pages(), and by necessity drivers have to keep a
reference to the contents of that in one form or another. So
conceptually the equivalent of:

struct vm_account {
       struct list_head possible_pinners;
       struct mem_cgroup *memcg;
       struct pages **pages;
       [...]
};

Unpinnig involves finding a new owner by traversing the list of
page->memcg_data->possible_pinners and iterating over *pages[] to figure
out if that vm_account actually has this page pinned or not and could
own it.

Agree this is costly though. And I don't think all drivers keep the
array around so "iterating over *pages[]" may need to be a callback.

> Jason

