From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of failures
Date: Fri, 13 Aug 2021 18:16:49 -0700
Message-ID: <CAHVum0f7dWrLNuZXPFPit4UQvGkJYZxmneeSm+DHV0ot5k1tBw@mail.gmail.com>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5gPul7eijlOt8GM4HLCxObdd/V4u2qacMdjonsEqZ0=;
        b=tgcGAsU2GoR85//UtKVxI/9WfKebiunMzpWmqEY05kDZCGgdmO2+r7/fONX6wDxE7k
         4u5AidzGRRhww0AmSAlwvIvgPBeKH9Zld3SF3zxzGsdkhCmAf0Y7A9FHPyv9sDZ1X9+a
         A84KVQ9K8M0WnVKfuW5zkj88UblBELlVWWzzO3cN56OK4DHQrPOKUr5AzTZyKo0YseFF
         VJETA+asdK95vnpVVIbcCNadT3mxz6f/HqVtHGiX/713oB62TxhsTaXGs905sVHhr7zU
         o/21RxGxC7bzy22JU1AgS4fHfyNDA/RAod0B5+ldUOOj0U3d4PHheMxvp6iwP1tD5Jjs
         ZpuA==
In-Reply-To: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 13, 2021 at 5:15 PM brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>
> For a container, we only print an error log when the resource
> charge fails. There may be some problems here:
>
> 1. If a large number of containers are created and deleted,
>    there will be a lot of error logs.
> 2. According to an error log, we cannot better understand
>    the actual pressure of resources.
>
> Therefore, perhaps we should use a failcnt counter to count
> the number of failures, so that we can easily understand the
> actual pressure of resources and avoid too many error log..
>
> v2: rename failcnt to nr_fails.
>
> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> ---
>  include/linux/misc_cgroup.h |  4 ++--
>  kernel/cgroup/misc.c        | 37 ++++++++++++++++++++++++++++++-------
>  2 files changed, 32 insertions(+), 9 deletions(-)
>

Acked-by: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
