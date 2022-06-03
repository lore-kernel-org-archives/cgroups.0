From: Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] cgroup: serialize css kill and release paths
Date: Fri, 3 Jun 2022 11:06:17 -0700
Message-ID: <79ec0073-2db7-a7a2-ec60-265a617d463a@linaro.org>
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=svaPePYVH4vz0O3T8xIGrC8HyL06d2NGhj+KphBzUno=;
        b=IwAVBHzgWS4dkVu/qLRjRhpRlO9tC9h6H0XLkm6gQfD1Ick+CmJZfRRii+FDxIWP85
         hVopm9iS326lYl/5DkMQNmUIOy3WxNkt5E/K3aft11XxaP4WWRGkqJL/FPEzDEXsD/Aa
         lJWuOyXQN903SYenOmP4skGdUxIanc1vk5022d8ALXUOepRz6Xi3cPbEvojIb8L2pnzj
         aIQBYZD/ZSr0dyb+LvspeTRRCXoBe7vxqIFyzMzxKIBK1t4ekpvPMHQuLfoH5YQw86Nk
         KhamVkfq0/4ejEwmXXosra2Zs+TQJrM/2JSLvZ5xtZYJ7RxKPZm48xOMMKtLpKt7sNlT
         Qthw==
Content-Language: en-US
In-Reply-To: <20220603173455.441537-1-tadeusz.struk@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

On 6/3/22 10:34, Tadeusz Struk wrote:
> Syzbot found a corrupted list bug scenario that can be triggered from
> cgroup_subtree_control_write(cgrp). The reproduces writes to
> cgroup.subtree_control file, which invokes:
> cgroup_apply_control_enable()->css_create()->css_populate_dir(), which
> then fails with a fault injected -ENOMEM.
> In such scenario the css_killed_work_fn will be en-queued via
> cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
> cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
> cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
> css_release_work_fn for the same css instance, causing a list_add
> corruption bug, as can be seen in the syzkaller report [1].
> 
> Fix this by synchronizing the css ref_kill and css_release jobs.
> css_release() function will check if the css_killed_work_fn() has been
> scheduled for the css and only en-queue the css_release_work_fn()
> if css_killed_work_fn wasn't already en-queued. Otherwise css_release() will
> set the CSS_REL_LATER flag for that css. This will cause the css_release_work_fn()
> work to be executed after css_killed_work_fn() is finished.
> 
> Two scc flags have been introduced to implement this serialization mechanizm:
> 
>   * CSS_KILL_ENQED, which will be set when css_killed_work_fn() is en-queued, and
>   * CSS_REL_LATER, which, if set, will cause the css_release_work_fn() to be
>     scheduled after the css_killed_work_fn is finished.
> 
> There is also a new lock, which will protect the integrity of the css flags.
> 
> [1]https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd
> 
> Cc: Tejun Heo<tj@kernel.org>
> Cc: Michal Koutny<mkoutny@suse.com>
> Cc: Zefan Li<lizefan.x@bytedance.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Christian Brauner<brauner@kernel.org>
> Cc: Alexei Starovoitov<ast@kernel.org>
> Cc: Daniel Borkmann<daniel@iogearbox.net>
> Cc: Andrii Nakryiko<andrii@kernel.org>
> Cc: Martin KaFai Lau<kafai@fb.com>
> Cc: Song Liu<songliubraving@fb.com>
> Cc: Yonghong Song<yhs@fb.com>
> Cc: John Fastabend<john.fastabend@gmail.com>
> Cc: KP Singh<kpsingh@kernel.org>
> Cc:<cgroups@vger.kernel.org>
> Cc:<netdev@vger.kernel.org>
> Cc:<bpf@vger.kernel.org>
> Cc:<stable@vger.kernel.org>
> Cc:<linux-kernel@vger.kernel.org>
> 
> Reported-and-tested-by:syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
> Fixes: 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu and work item")
> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>

I just spotted an issue with this. I'm holding invalid lock in css_killed_work_fn().
I will follow up with a v2 of the patch soon.

-- 
Thanks,
Tadeusz
