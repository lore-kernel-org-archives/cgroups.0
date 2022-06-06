From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] cgroup: serialize css kill and release paths
Date: Mon, 6 Jun 2022 14:39:10 +0200
Message-ID: <20220606123910.GF6928@blackbody.suse.cz>
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
 <20220603181321.443716-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654519151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S16O+A6T24T23c0/paG1pu0dx4tXfDlUNTS+nP+cphE=;
        b=U+4ZaQnCAkAGLVYgMbcQ8yOw2leTw/G6XgP0SWYOPzpKwuYpVOOYoLHknUOva5iMzb3EtS
        M85t36oJc92vhEOXG3fj8bROYoQennKsr8Ma34tiOlPA+RSMR/AT8JPnwEBnkHxlfSl30o
        ULznUdIGJrExqifnQZHozgX7CxQbDEI=
Content-Disposition: inline
In-Reply-To: <20220603181321.443716-1-tadeusz.struk@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

Hello.

On Fri, Jun 03, 2022 at 11:13:21AM -0700, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> In such scenario the css_killed_work_fn will be en-queued via
> cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
> cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
> cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
> css_release_work_fn for the same css instance, causing a list_add
> corruption bug, as can be seen in the syzkaller report [1].

This hypothesis doesn't add up to me (I am sorry).

The kill_css(css) would be a css associated with a subsys (css.ss !=
NULL) whereas css_put(&cgrp->self) is a different css just for the
cgroup (css.ss == NULL).

Michal
