From: Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH] selftests: cgroup: Fix unsigned comparison with less than
 zero
Date: Tue, 8 Nov 2022 11:59:34 +0530
Message-ID: <b123bd21-241c-de06-c3d7-e4505ee6e1e3@quicinc.com>
References: <20221105110611.28920-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1667888982; x=1699424982;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7xP5TpKUqB7egpe5bWLlRd8LPgmKi22LPe7NE5mGBqU=;
  b=BOfDYZbST6pvJGJoEFrFuQA6NEfAcuinZ6dOW8zjW2gJ3WaLalP/AfSZ
   4ZlD7677XYsttoTG0+kySNC3P7WvBggv5xlrorVK0CmMCvpiYwNnOlm0B
   D4GuXZXItuOyVfVQ5XxfosJ/SmaOz+9Cc1JCiSL8MvaAcKdylCJK8ZFYe
   k=;
Content-Language: en-US
In-Reply-To: <20221105110611.28920-1-yuehaibing@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: YueHaibing <yuehaibing@huawei.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, shuah@kernel.org, yosryahmed@google.com, roman.gushchin@linux.dev, shakeelb@google.com, rientjes@google.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On 11/5/2022 4:36 PM, YueHaibing wrote:
> 'size' is unsigned, it never less than zero.
> 
> Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

LGTM.
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
> ---
>   tools/testing/selftests/cgroup/cgroup_util.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 4c52cc6f2f9c..e8bbbdb77e0d 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -555,6 +555,7 @@ int proc_mount_contains(const char *option)
>   ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
>   {
>   	char path[PATH_MAX];
> +	ssize_t ret;
>   
>   	if (!pid)
>   		snprintf(path, sizeof(path), "/proc/%s/%s",
> @@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
>   	else
>   		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
>   
> -	size = read_text(path, buf, size);
> -	return size < 0 ? -1 : size;
> +	ret = read_text(path, buf, size);
> +	return ret < 0 ? -1 : ret;
>   }
>   
>   int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
