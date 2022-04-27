From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix unsigned expression compared with
 zero
Date: Wed, 27 Apr 2022 06:18:42 -1000
Message-ID: <Ymls4pydYPMBtyCm@slm.duckdns.org>
References: <20220427061756.56893-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mqASqeNgn2MnRKKvwUc4ZQ7zeAhzxAmdAAXdF7mi3dg=;
        b=VPYVt0nOnYVYZR60ZA6lctKmm/WOzCKfgCNGoiZ4E9EYKXM3a8SzhPw7rwq3lmJ9Va
         p90WEIuEcSNY8OZWEnnOLx0GSm4nVQ93Elr89pi1oYOwDl8bS98H8WxP79KZj9PFHaRH
         nwIkbRDVgIbMuMxCi9PxMEa2Riru3C1Ohn2Fs3atKkNKXXgF4L2Ml7swXiVL6ttY4fFE
         53/lNcov94euEqSTnTw9eozsCNmF0YbJJeAiMFn+G+SvlMT77Q/gyoKTBTO6HKwi+VHL
         S1/FQNRSP/h+e6aUTaX3OSLFlxYLKYpeiS/yRqZbiz65EP5Vv3a+yaqEmUdmWvNs4Qns
         0ujQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220427061756.56893-1-jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On Wed, Apr 27, 2022 at 02:17:56PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/testing/selftests/cgroup/cgroup_util.c:566:8-12: WARNING:
> Unsigned expression compared with zero: size < 0.
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 2 +-
>  tools/testing/selftests/cgroup/cgroup_util.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 4c52cc6f2f9c..661e06b94a43 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -552,7 +552,7 @@ int proc_mount_contains(const char *option)
>  	return strstr(buf, option) != NULL;
>  }
>  
> -ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
> +ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, ssize_t size)

Converting input size parameter to ssize_t doesn't make sense. I don't see
where it's doing size < 0 either but that's probably where it should be
fixed.

-- 
tejun
