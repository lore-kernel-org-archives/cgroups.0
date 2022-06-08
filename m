From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: handle cset multiidentity issue when migration
Date: Wed, 8 Jun 2022 15:51:10 +0200
Message-ID: <20220608135110.GA19399@blackbody.suse.cz>
References: <1654187688-27411-1-git-send-email-shisiyuan@xiaomi.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654696271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EdG9PlC0R8OmQU19nk71zBCMMuRv8NZuw8mGqBcI480=;
        b=K2HoctTtt/KhX6+mXecsJdmxEuLMLk9zl0bFw6P8GQqwSvXX6slsZPsrN89QwI/uB+DzRk
        2rc7JqmJgkntQCiSgzz+t+cOxr+UxCJIiMua+TwkAugUiSC+51i12hZ9WImmy5T6lsX3QU
        4J2vUnC1M74rqwRGtY9bdo+zosQvGM8=
Content-Disposition: inline
In-Reply-To: <1654187688-27411-1-git-send-email-shisiyuan-95E7rUnPDLLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shisiyuan <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shisiyuan <shisiyuan-95E7rUnPDLLQT0dZR+AlfA@public.gmane.org>

Hello.

On Fri, Jun 03, 2022 at 12:34:48AM +0800, shisiyuan <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Bug code flow:
> cset X's initial refcount is 1.
> 1. cgroup_attach_task()
> 2. [For thread1]
>    cgroup_migrate_add_src()
>    [For thread2]
>    cgroup_migrate_add_src()
>      cset X is thread2's src_cset , ref->2,
>      and its mg_preload_node is added to
>      mgctx->preloaded_src_csets.
> 3. cgroup_migrate_prepare_dst()
>    [For thread1]
>    find_css_set()
>      cset X is thread1's dst_cset, ref->3
>    put_css_set()
>      ref->2 because cset X's mg_preload_node is not
>      empty(already in mgctx->preloaded_src_csets).
>    [For thread2]
>    find_css_cset()
>      cset X is also thread2's dst_cset, ref->3
>      then drop src_cset, ref->1
> [cgroup_free] ref->0
> 4. cgroup_migrate_execute
>    [For thread1]
>    ref -> 0xc0000000(UAF)

I'm trying to understand when this happens.
You migrate a process with two threads while one of them exits?

This should be properly synchronized with cgroup_threadgroup_rwsem, so I
don't understand where does the [cgroup_free] between 3. and 4. come
from.

Do you have a reproducer for this?

Thanks,
Michal
