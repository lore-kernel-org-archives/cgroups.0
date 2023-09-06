From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 2/5] bpf: Enable cgroup_array map on cgroup1
Date: Wed, 6 Sep 2023 12:54:30 -0700
Message-ID: <20230906195430.udj6suj32meoraju@MacBook-Pro-8.local>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <20230903142800.3870-3-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694030074; x=1694634874; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=78FtW2KEHALXSnzrqPSgIRmAweaQbL/r9j+Tz4zHoP0=;
        b=kN6gO2yekwMFtZOxyO8eNxTe+9aehaNg395ML2/jcgEpxq6B0OZkA69NH6bsxqyh1+
         GM38w3CsqQM8s+yYDghT2rU6uyQZ9496ZqIU2ILZ4DyIhBxPgCaSdUR79IcGjdhT4daa
         uhxNelSzB6XRq04xWBSXL8wbBrnHf46fvM39R05A6yqbqzmXYp2w4KFNU5EE+LuoYCGP
         P07U20S449mc0BoSkSVnK5KMERtbaSz7NDfVAknZxXSWTZEbt7R88aLZpHb6DJVQGTDj
         X6Xj4VyHp0Q/CZOzuXyfhrl+X242Kv8qXPIG8DvcNOay64kMska1PI7/Z0Owq9jMPIyc
         uHDw==
Content-Disposition: inline
In-Reply-To: <20230903142800.3870-3-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Sep 03, 2023 at 02:27:57PM +0000, Yafang Shao wrote:
> The cgroup_array map currently has support exclusively for cgroup2, owing
> to the fact that cgroup_get_from_fd() is only valid for cgroup2 file
> descriptors. However, an alternative approach is available where we can use
> cgroup_v1v2_get_from_fd() for both cgroup1 and cgroup2 file descriptors.
> 
> The corresponding cgroup pointer extracted from the cgroup file descriptor
> will be utilized by functions like bpf_current_task_under_cgroup() or
> bpf_skb_under_cgroup() to determine whether a task or socket buffer (skb)
> is associated with a specific cgroup. In a previous commit, we successfully
> enabled bpf_current_task_under_cgroup(), ensuring the safety of storing a
> cgroup1 pointer within the cgroup_array map.
> 
> Regarding bpf_skb_under_cgroup(), it is currently restricted to cgroup2
> functionality only. Nevertheless, it remains safe to verify a cgroup1
> pointer within this context as well, with the understanding that it will
> return a "false" result in such cases.
> 
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  kernel/bpf/arraymap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 2058e89..30ea57c 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -1291,7 +1291,7 @@ static void *cgroup_fd_array_get_ptr(struct bpf_map *map,
>  				     struct file *map_file /* not used */,
>  				     int fd)
>  {
> -	return cgroup_get_from_fd(fd);
> +	return cgroup_v1v2_get_from_fd(fd);

This part looks ok.
