From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix unsigned comparison with less than zero
Date: Sat, 5 Nov 2022 15:29:54 -0700
Message-ID: <CAJD7tkb06mjZ3bvoiR4U47+XknM4nTHY06RYZ8SULOxJ4mAOwQ@mail.gmail.com>
References: <20221105110611.28920-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CbBRCqYlzL5aIOV/FIaD3IiZ/MIQgFytQcTe8Ul9rWk=;
        b=PXiWAzVmOTq6MGJT16VHLmmAgF9HAeDaUY3bKDIRjX1G2Y65KvekkmTwB3jXjs7l8j
         3pwPXGGFlmVDhSaP9TQBDvvS6p+fAWGePMqqaRzzzDXHP3KJe6vIEtBlUYLCnWIeVYWH
         Ur3sBQPhqJ9Oxf9cpbNiQGJDIzJIItYtzHmtxg3clYTMzc4hOrUKhdgu8eInd8uXzmfA
         k95eZ9IVCthx6Phbt4Yks+3rpYJa3InS68hKNKmTwEALPL0g5Nml8gTVHzucq3y6Jb8G
         14nj2uu2GiE7DWFSSY89/Px2IvRk5FMIk9gai01Ied2ap6Bp2Jba4/6u5484C+uU7lis
         IzFQ==
In-Reply-To: <20221105110611.28920-1-yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Nov 5, 2022 at 4:06 AM YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> 'size' is unsigned, it never less than zero.
>
> Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
> Signed-off-by: YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks for fixing this!
FWIW,

Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>




> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 4c52cc6f2f9c..e8bbbdb77e0d 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -555,6 +555,7 @@ int proc_mount_contains(const char *option)
>  ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
>  {
>         char path[PATH_MAX];
> +       ssize_t ret;
>
>         if (!pid)
>                 snprintf(path, sizeof(path), "/proc/%s/%s",
> @@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
>         else
>                 snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
>
> -       size = read_text(path, buf, size);
> -       return size < 0 ? -1 : size;
> +       ret = read_text(path, buf, size);
> +       return ret < 0 ? -1 : ret;
>  }
>
>  int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
> --
> 2.17.1
>
