From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix unsigned comparison with less than
 zero
Date: Tue, 8 Nov 2022 18:54:56 +0530
Message-ID: <62a98c8e-c471-dc02-58f4-63dd1361f92c@oracle.com>
References: <20221105110611.28920-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=zRKNtn5RScxF2H4DTysF0N3GLDhiObwB/9r8Ijyjdng=;
 b=0y0Gqhv5vpxBxkYWq6TtacScWEnWNVsjExEUmERZ75r+RTzQXax5q7vGEWl63flCiSOo
 ziaLnDg61kMNGmBmOXZAPLa8p0nI/IAwtk8ifC6cyiOt3YFKwNDhvlFa6Wt1DSnzML++
 3AScGeM1/B1zsWkT9EXo1A0SRggr4OUz4VpILdxGRUluofGvJSgD4ahU/8/PZ90f2qZC
 vZowtF/n+JlSj5SEPB0nK5P9mKv6BCsdjK3aLCC9SvXK0TNTdkgMyHhWVNLOjF1Q0jpv
 RVEFOgmR0Rw57WvyEt5Yx9esll4fT0EXPBTG3SXg9OI4bqe95P/6TPWMHVVzWgIISkWP lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRKNtn5RScxF2H4DTysF0N3GLDhiObwB/9r8Ijyjdng=;
 b=cWCGQokNyWhdLUrnHcEU2AexpDqRwenrPePj3HhF7z9aMJNuTCQlDQdjDZMUWNsFtrRt2SfhAlyYpo3VPjdbPlp7bh8015iU38ySCQbm25w5h6A/7JkAET/iz8Ff5HzSVWZdvNhooPjho204JNQ8bUISy45EQqF9ZSCp7J+9sM0=
Content-Language: en-US
In-Reply-To: <20221105110611.28920-1-yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 11/5/22 16:36, YueHaibing wrote:
> 'size' is unsigned, it never less than zero.
> 
> Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
> Signed-off-by: YueHaibing <yuehaibing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

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
>  	char path[PATH_MAX];
> +	ssize_t ret;
>  
>  	if (!pid)
>  		snprintf(path, sizeof(path), "/proc/%s/%s",
> @@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
>  	else
>  		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
>  
> -	size = read_text(path, buf, size);
> -	return size < 0 ? -1 : size;
> +	ret = read_text(path, buf, size);
> +	return ret < 0 ? -1 : ret;
>  }
>  
>  int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)

-- 
Thanks,
Kamalesh
