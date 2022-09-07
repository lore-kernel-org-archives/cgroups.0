From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove unreachable code
Date: Wed, 7 Sep 2022 05:32:16 -1000
Message-ID: <Yxi5gI1f2MxdC0c9@slm.duckdns.org>
References: <20220907040112.82030-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=2y84KoxHvAca0x2HYNXqxqJj776eiDbPEKIjReMrg0U=;
        b=RCPz9p+Nm7+WOSNmOPN1+QvBYB8EhdBwxeXR6gnhlbAts2QrkYbmNTYTpJZ98fgPPF
         PBl/6LoKGUlg+AcfZkjDU6xf7r8RtInGmJHbDUCjURuh+T2Vll6Praux5Orn4iaeDqwm
         jxV4YJvo9RbSCftdHfGjhMCV8QNHdXBUzVJ9lt9ijth/jwtdLgnIZtyD2tBora/s4YKV
         ChT9rFNyrRAFZc546muYP38fxNj7VYw4s7kDHXMvjcBWNOcDwGcVs0Y6TZP/A0ESSHFp
         B8cRLWxPlzfh0r+Vhc50oXUgfnsdNkI1V8eO1TF0YKSIopG3NCUBnN6VSmRDkQpeM3Ly
         hiTg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220907040112.82030-1-jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

(cc'ing Waiman and quoting the whole message)

On Wed, Sep 07, 2022 at 12:01:12PM +0800, Jiapeng Chong wrote:
> The function sched_partition_show cannot execute seq_puts, delete the
> invalid code.
> 
> kernel/cgroup/cpuset.c:2849 sched_partition_show() warn: ignoring unreachable code.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2087
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---

Applied to cgroup/for-6.1.

Thanks.

>  kernel/cgroup/cpuset.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6baa977a71ba..b474289c15b8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2846,8 +2846,6 @@ static int sched_partition_show(struct seq_file *seq, void *v)
>  		else
>  			seq_printf(seq, "%s invalid\n", type);
>  		break;
> -		seq_puts(seq, "isolated invalid\n");
> -		break;
>  	}
>  	return 0;
>  }
> -- 
> 2.20.1.7.g153144c
> 

-- 
tejun
