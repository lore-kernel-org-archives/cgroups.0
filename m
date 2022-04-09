From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] selftests: cgroup: return the errno of write() in
 cg_write() on failure
Date: Fri, 8 Apr 2022 18:21:55 -0700
Message-ID: <CAJD7tkb6VJt=pfqnW11r6S7A0r2Vh85a3YZaVso-qyiCM06nDQ@mail.gmail.com>
References: <20220408045743.1432968-1-yosryahmed@google.com> <20220408045743.1432968-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0F2P2ML/pBi824KYgTw5KU1Y45bJmTHodkEFj/msPE=;
        b=rnIIkb90V9I9bcpVMa5/w0cTf4Gar8GVFDke+JSlU2hEHFp3OsRcTAqk7dfPeFG8tF
         dDExEmFCxiNoVK2EMa1ylHUlmv7DSThq6XmiX4TNJLDsXoKoUElD/mYy3ENP5lUCX6Cm
         L0cqaNurq1CWtLL/S3jZRhd8I253TJx1CfvGJLV8g4b2GyGGXfVeqwYyZcNtCYqWoaTJ
         rljgm3m6gGpplEG1geT3BvdWqZgCrGRUG3e99TyERwVqbDQLP1p54prwkHbmcNQHKk4J
         2yNkYps6CqNhbHgl2xIZXaESlcelXNqaHtoVajN8GB4WEs0RS7UrQYqzpjddvSoSRqdi
         sZ6Q==
In-Reply-To: <20220408045743.1432968-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 7, 2022 at 9:57 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Currently, cg_write() returns 0 on success and -1 on failure. Modify it
> to return the errno of write() syscall when write() fails.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 32 +++++++++++---------
>  1 file changed, 17 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index dbaa7aabbb4a..3b6bb09985fa 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -38,23 +38,23 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
>         return len;
>  }
>
> -static ssize_t write_text(const char *path, char *buf, ssize_t len)
> +/*
> + * Returns:
> + *     success -> 0
> + *     open() failure -> -1
> + *     write() failure -> errno
> + */
> +static int write_text(const char *path, char *buf, ssize_t len)
>  {
> -       int fd;
> +       int fd, ret;
>
>         fd = open(path, O_WRONLY | O_APPEND);
>         if (fd < 0)
>                 return fd;
>
> -       len = write(fd, buf, len);
> -       if (len < 0) {
> -               close(fd);
> -               return len;
> -       }
> -
> +       ret = write(fd, buf, len) < 0 ? errno : 0;
>         close(fd);
> -
> -       return len;
> +       return ret;
>  }
>
>  char *cg_name(const char *root, const char *name)
> @@ -177,17 +177,19 @@ long cg_read_lc(const char *cgroup, const char *control)
>         return cnt;
>  }
>
> +/*
> + * Returns:
> + *     success -> 0
> + *     open() failure -> -1
> + *     write() failure -> errno
> + */
>  int cg_write(const char *cgroup, const char *control, char *buf)
>  {
>         char path[PATH_MAX];
>         ssize_t len = strlen(buf);
>
>         snprintf(path, sizeof(path), "%s/%s", cgroup, control);
> -
> -       if (write_text(path, buf, len) == len)
> -               return 0;
> -
> -       return -1;
> +       return write_text(path, buf, len);
>  }

I have changed this in v4 to a cleaner implementation that either
returns 0 on success or -errno on failure. I also made sure to check
that the full buffer was being written, and updated cg_read() as well
for the interface to be consistent.

Will send out once the discussion on patch 1 in v3 reaches a consensus.

>
>  int cg_find_unified_root(char *root, size_t len)
> --
> 2.35.1.1178.g4f1659d476-goog
>
