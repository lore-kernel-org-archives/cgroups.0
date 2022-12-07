From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix the invalid check in proc_read_text()
Date: Wed, 7 Dec 2022 00:40:18 -0800
Message-ID: <CAJD7tkbkNc671xP-s7KSzOzP6B_aKupTc_h-izWpTDiPh53xxA@mail.gmail.com>
References: <1670401989-8208-1-git-send-email-wangyufen@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=34x8LhKwP612H1FJN6oNMCWpQO3JP3IEEksN2msghRE=;
        b=U5Hmca3j3AA8CcH/P8E44nnzhv5v96G87rRQqTJ9gCAq3J1xsOxIuw8z/cI8JEFs8B
         FFlh+Az7SvRtuVkiqF+GWMQNSMdPK3+lVCn1HwrHbV1uURO4i96Gu6WtRRSKTKFTjVbs
         dwcIYWizZu+PL0BrwV8qUfQUSMb8QMclIO9kgiPefwZxlL5B0STQ+oFpbSZJC3tHcUCw
         P14uE6NmEagF6Cye9ntZ2zuqTJDW7GsRXjK/In/NJrz0Lgf1xEmSSY109lDT6z7VpqIq
         Pm0qV2XeJUssPkw2eQutDxSzFEmT8p28vd6cUjjU144JyCVQxA+6AUuk4nEfsKv+3kkL
         8nfQ==
In-Reply-To: <1670401989-8208-1-git-send-email-wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Wed, Dec 7, 2022 at 12:33 AM Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Unsigned variable cannot be lesser than zero, So the return check of read_text() is invalid.
> To fix, add a new ssize_t variable read for read_text() return value check.
>
> Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")

Thanks for sending this, but a fix was already sent recently (by YueHaibing):
https://lore.kernel.org/lkml/20221105110611.28920-1-yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

, and it currently lives in the mm-nomm-stable branch in Andrew's tree
AFAICT as commit e410f7aa641d ("selftests: cgroup: fix unsigned
comparison with less than zero").

> Signed-off-by: Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 4c52cc6..19137c0 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -555,6 +555,7 @@ int proc_mount_contains(const char *option)
>  ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
>  {
>         char path[PATH_MAX];
> +       ssize_t read;
>
>         if (!pid)
>                 snprintf(path, sizeof(path), "/proc/%s/%s",
> @@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
>         else
>                 snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
>
> -       size = read_text(path, buf, size);
> -       return size < 0 ? -1 : size;
> +       read = read_text(path, buf, size);
> +       return read < 0 ? -1 : read;
>  }
>
>  int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
> --
> 1.8.3.1
>
