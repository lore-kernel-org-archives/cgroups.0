From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with
 PF_KTHREAD
Date: Thu, 25 Oct 2012 10:20:16 -0700
Message-ID: <20121025172016.GF11442@htj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-5-git-send-email-tj@kernel.org>
 <20121022183453.GA24687@redhat.com>
 <20121022211822.GF5951@atj.dyndns.org>
 <20121023155533.GC16201@redhat.com>
 <20121024190651.GC12182@atj.dyndns.org>
 <20121025171236.GA6776@redhat.com>
 <20121025171256.GB6776@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DshS5joPjOvBGiRzcdya2vwFhnfgitkJbhwKe981NtY=;
        b=t3+oig9+zRStT5Ng0t32FDVxk2Bv8lxNeDzW4Dzr4vBVIV9uYTvjuqPI01nWLcppT7
         wCaqX1Q99uxGQKnXu+EDQ8F37GwwPGksfURybd7tQw4GblLWcYj7Ibbww7sBiIcEm3/U
         JKE2Vs7aZpoEB2Ld8PyumbVqz/sIM69u+gILIdf7iId1KhMj0HsV4y3QO3j3s5vMMCCj
         YkVX+9AT79kcmvFEutwhtf6n9J/On1a5jFupurRaKWm/g9HxkS/3ijANn4k/UeQkh1/Q
         uI6ZHpjcIEbfmjHAvH77EztQeubFeJq790PkY0Uk1msqEsaqbbeQ8rmlsb8uSXTK2QL3
         voBw==
Content-Disposition: inline
In-Reply-To: <20121025171256.GB6776-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Oct 25, 2012 at 07:12:56PM +0200, Oleg Nesterov wrote:
> flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.
> 
> Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Probably needs Cc: stable.

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

How should this be routed?  -mm?  Andrew, can you please pick this up?

Thanks.

> ---
>  fs/exec.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 8b9011b..0039055 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1083,7 +1083,8 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	bprm->mm = NULL;		/* We're using it now */
>  
>  	set_fs(USER_DS);
> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD);
> +	current->flags &=
> +		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
>  	flush_thread();
>  	current->personality &= ~bprm->per_clear;
>  
> -- 
> 1.5.5.1
> 
> 

-- 
tejun
