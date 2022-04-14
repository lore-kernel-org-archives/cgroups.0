From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Date: Thu, 14 Apr 2022 18:44:09 +0200
Message-ID: <20220414164409.GA5404@blackbody.suse.cz>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649954651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fAh1doWqdu+T5/UcndhANWk7kmOrXizHJ0CC+YKJ3Ek=;
        b=ItvkKqTJave9fRovg0ydCzfpuP8dusozKz3WSWTw4xyCZGYtm401PRaOw3A7tKtn195ttV
        70Iq3LASPYGaaQFBLo3dZiZFNeqlNkqtTdFBwMkiE/Frdb4DB0+Mp2kc/s0DQAGgLyu5/I
        Vu6vxdwLlPRhTE1WJ+UxARYAK7bzTjw=
Content-Disposition: inline
In-Reply-To: <20220412192459.227740-1-tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+e42ae441c3b10acf9e9d-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

Hello Tadeusz.

Thanks for analyzing this syzbot report. Let me provide my understanding
of the test case and explanation why I think your patch fixes it but is
not fully correct.

On Tue, Apr 12, 2022 at 12:24:59PM -0700, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Syzbot found a corrupted list bug scenario that can be triggered from
> cgroup css_create(). The reproduces writes to cgroup.subtree_control
> file, which invokes cgroup_apply_control_enable(), css_create(), and
> css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.

The reproducer code makes it hard for me to understand which function
fails with ENOMEM.
But I can see your patch fixes the reproducer and your additional debug
patch which proves that css->destroy_work is re-queued.

> In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
> work for an css->refcnt initialized with css_release() destructor,

Note that css_free_rwork_fn() utilizes css->destroy_*r*work.
The error path in css_create() open codes relevant parts of
css_release_work_fn() so that css_release() can be skipped and the
refcnt is eventually just percpu_ref_exit()'d.

> and there is a chance that the css_release() function will be invoked
> for a cgroup_subsys_state, for which a destroy_work has already been
> queued via css_create() error path.

But I think the problem is css_populate_dir() failing in
cgroup_apply_control_enable(). (Is this what you actually meant?
css_create() error path is then irrelevant, no?)

The already created csses should then be rolled back via 
	cgroup_restore_control(cgrp);
	cgroup_apply_control_disable(cgrp);
	   ...
	   kill_css(css)

I suspect the double-queuing is a result of the fact that there exists
only the single reference to the css->refcnt. I.e. it's
percpu_ref_kill_and_confirm()'d and released both at the same time.

(Normally (when not killing the last reference), css->destroy_work reuse
is not a problem because of the sequenced chain
css_killed_work_fn()->css_put()->css_release().)

> This can be avoided by adding a check to css_release() that checks
> if it has already been enqueued.

If that's what's happening, then your patch omits the final
css_release_work_fn() in favor of css_killed_work_fn() but both should
be run during the rollback upon css_populate_dir() failure.

So an alternative approach to tackle this situation would be to split
css->destroy_work into two work work_structs (one for killing, one for
releasing) at the cost of inflating cgroup_subsys_state.

Take my hypothesis with a grain of salt maybe the assumption (last
reference == initial reference) is not different from normal operation.

Regards,
Michal
