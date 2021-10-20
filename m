From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Wed, 20 Oct 2021 19:28:40 +0200
Message-ID: <YXBRyJMru/RbUQK5@blackbook>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
 <YW98RTBdzqin+9Ko@T590>
 <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634750922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6iR1y/JL3F5bSNnhveF9tZ47D84ZakNWdr4w2O9FyR0=;
        b=puC+JrAjKBLfJWIbDTKsG+jqaPcCcX5u7U5/ZJPdJv9ua4KfXtLpGNpcZ6nDxuFX4QPk29
        tH5H30S6wh9+68I/f9eYApstnc7SF0fwjjwxQUWfmJo/sr8fbVEoANJKKaYLy1XOrjurZr
        3bFQZWUJbGW4YVvD6mjDX9KxSO3oXew=
Content-Disposition: inline
In-Reply-To: <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Wed, Oct 20, 2021 at 01:22:06PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> > If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
> > I thought cgroup_bpf_release() needs to release more for root cgroup, but
> > looks not true.
> For now, I can only observe that precpu_ref data is leaked when running ltp
> testsuite.

I assume you refer to ref->data. I considered the ref->percpu_count_ptr
allocated with __alloc_percpu_gfp(). Could it be that kmemleak won't
detect leaked percpu allocations?

(The patch you sent resolves this as well, I'm just curious.)

Michal
