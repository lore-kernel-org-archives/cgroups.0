From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Tue, 19 Oct 2021 19:10:26 +0200
Message-ID: <YW78AohHqgqM9Cuw@blackbook>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634663428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eyKSX2/7swyCKXn7z9fVjzybvXll+tbtLpZFqDx1m8=;
        b=RVz/tL02sPQdjtNeumX2ZM+VtIFyIcTOEASFvv6I0/FVlHvZ4o9I/0RJ7QO2xcZDmai6xU
        4h/KSMw/yrIULI7jwk8EkRvwcpYQFzka8UE4eirJd7G1eClI5pV5rYNy+uIttiWykEFB+n
        aMD35+up03LH+YwZPGz6j/iIN4qa1fE=
Content-Disposition: inline
In-Reply-To: <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Hi.

On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
> different issues.

AFAIU, both the changes are needed to cause the leak, a single patch
alone won't cause the issue. Is that correct? (Perhaps not as I realize,
see below.)

But on second thought, the problem is the missing percpu_ref_exit() in
the (root) cgroup release path and percpu counter would allocate the
percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
visible. Is this correct?

I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
percpu_ref in fast path") alone did nothing wrong.

[On a related (but independent) note, there seems to be an optimization
opportunity in not dealing with cgroup_bpf at all on the non-default
hierarchies.]

Regards,
Michal
