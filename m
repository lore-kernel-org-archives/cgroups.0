From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Tue, 12 Oct 2021 11:32:55 +0200
Message-ID: <20211012093255.GA14510@blackbody.suse.cz>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
 <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634031177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uUH2uniB3EQO3dwCrSFaoRzeR2U8u7SDS04Yd4v70+U=;
        b=YhyfbjO5nAw5bwwzh728WNI5DvAqHjJZFQzjmHA1K2+FdNCUYVxUjqsq9Ae4F6bDEzoqJQ
        EEwVGKESG8YU55NGTFA+CFcmsIM5Doln5oqhNIvnNKw5GzbJco1gWy+9X50dKiW+sFqa2K
        BV+UzYXo89KlPkPy75N9K1j65LCFY+I=
Content-Disposition: inline
In-Reply-To: <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Tue, Oct 12, 2021 at 02:22:13PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> Before this commit, percpu_ref is embedded in cgroup, it can be freed along
> with cgroup, so there is no memory leak. Since this commit, it causes the
> memory leak.
> Should I change it to "Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of
> cgroup_bpf from cgroup itself")"?

I see. The leak is a product so I'd tag both of them and explain it in
the commit message.

Thank you,
Michal
