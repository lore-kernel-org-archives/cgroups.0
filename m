From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 11:35:54 +1100
Message-ID: <87fsaxnrqa.fsf@nvidia.com>
References: <Y/T+pw25oGmKqz1k@nvidia.com> <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com> <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com> <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com> <87k009nvnr.fsf@nvidia.com>
 <Y/at3iYz/xBSPPM+@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmNiOyhFz9DXx43kKHbLedhcqXbiD2keDGvvn4lrLkQ=;
 b=ccCeo35i/KGpkyBRMJz2hbnyIED9fU4v7FHELHC54QHHM1VXL7Z1vZYdoR7VU/8Nfy+ANGbWyrI0SVpjN8bV7agWTYjeSt+1VuRlUjAU8+PuxxkmBVsmaKE6eKunrmjpkcEjcRf4vlkZrNWXjyrlPrSFrZH+N8XQzrTKKsqRHzjGYe1QLus6svQlq+7i/7v4WdcXe3eAI0CA1bcv5KbK2TwtZYQeXNXbXOkWb60sJRQ8SAV5RkBa0azDhe+vt9SDhc0bgZtF3lHQDW/XDSxDn1srr0LKy2zXASd/4yaGVWACBePQow/gx6fn/k6H9tOfp/bkngiGD8ubw2j8VclYRw==
In-reply-to: <Y/at3iYz/xBSPPM+-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

> On Thu, Feb 23, 2023 at 09:59:35AM +1100, Alistair Popple wrote:
>> The idea was every driver already needs to allocate a pages array to
>> pass to pin_user_pages(), and by necessity drivers have to keep a
>> reference to the contents of that in one form or another. So
>> conceptually the equivalent of:
>> 
>> struct vm_account {
>>        struct list_head possible_pinners;
>>        struct mem_cgroup *memcg;
>>        struct pages **pages;
>>        [...]
>> };
>> 
>> Unpinnig involves finding a new owner by traversing the list of
>> page->memcg_data->possible_pinners and iterating over *pages[] to figure
>> out if that vm_account actually has this page pinned or not and could
>> own it.
>> 
>> Agree this is costly though. And I don't think all drivers keep the
>> array around so "iterating over *pages[]" may need to be a callback.
>
> Is pinning in this context referring to FOLL_LONGTERM pins or any
> FOLL_PIN?  In the latter case block based direct I/O does not keep
> the pages array around, and also is absolutely not willing to pay
> for the overhead.

Good point. I was primarily targeting FOLL_LONGTERM users. I'm not too
familiar with block based direct I/O but from what I can tell it
currently doesn't respect any kind of RLIMIT anyway so I guess the
requirment to limit pinned pages there isn't so revelant.
