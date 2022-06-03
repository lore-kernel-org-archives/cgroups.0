From: Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] cgroup: serialize css kill and release paths
Date: Fri, 3 Jun 2022 11:17:23 -0700
Message-ID: <0c37c2b9-a89a-54d7-9fd3-f035f6816aa8@linaro.org>
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
 <20220603181321.443716-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Az2acnj16/aXPRCs4OX6YtuTWRNeGltXq9+PbmTT2go=;
        b=P+Blsdx7NzfX+tc3SEE3y7hR4zxwbKm4W2XIzjhNeSBoA+J3idLz4PKuU0Rgg4bqeT
         8lBP2muYp3hJexMlCEEKRnfjA8kkU7Ktpm+ktqsZzLj/Bps9oNU5lakmUmkSzZZvJbIw
         0qVv48vpCqMPKK6//GckvorWP4FKNyXfKRdKBPD2dx7i7608+Pyv7jcbzu4PhcIU7dL9
         jJ9Mhm1GemcsDHTmQh64GVr7Yiv0UXLF3ltn2JxNuZClpwltYgmNH6Wk0P7s3/watLWM
         9ucceQ8xk1cXq4I+OjOirraMAlWREjNJ1kYf8gOJHA86ZxrD0DrXqxCLe5WOy7pXbakk
         CQsA==
Content-Language: en-US
In-Reply-To: <20220603181321.443716-1-tadeusz.struk@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com

On 6/3/22 11:13, Tadeusz Struk wrote:
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
> set the CSS_REL_LATER flag for that css. This will cause the
> css_release_work_fn() work to be executed after css_killed_work_fn() is finished.
> 
> Two scc flags have been introduced to implement this serialization mechanizm:
> 
>   * CSS_KILL_ENQED, which will be set when css_killed_work_fn() is en-queued, and
>   * CSS_REL_LATER, which, if set, will cause the css_release_work_fn() to be
>     scheduled after the css_killed_work_fn is finished.
> 
> There is also a new lock, which will protect the integrity of the css flags.
> 
> [1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

This also fixes a similar, cgroup related list corrupt issue:
https://syzkaller.appspot.com/bug?id=3c7ff113ccb695e839b859da3fc481c36eb1cfd5

-- 
Thanks,
Tadeusz
