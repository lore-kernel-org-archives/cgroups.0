From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Wed, 1 Mar 2023 15:07:50 -0500
Message-ID: <Y/+wlg5L8A1iebya@cmpxchg.org>
References: <20230301193403.1507484-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1677701272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EAcp6gwJPIpQSJ5evzEyfrtFkdf4nPPjMijC6R20IBI=;
        b=F3ZYH+5Px/N5yjWu3nYFhIw28OIIi3vK0lrj9VXXDVqd7nyUsmYzdUcZH15UNBaQ18
         P6d3947mCJmysie/OTvSpOzJur1L4DsVnRqK+EK3L/lF/5CYUVYe00hr51kzsp7jplxy
         kFNIZzjVOyU/3/NXzrYxkfKTvB0l2OxAO78e/pq9VctGhD8PQPdAAc5gMoQ5P43g//Q+
         WdSdzRPpLmumJRD5YsFiIFDMLyUDRZy2fhlbxZxoXeShB7UYoP4fVnfoWJeRtH8o2zXL
         oRn1MC0/8QMRNTvVSRsVqbt/Hwm831MREuiRJbleArO36wnUJHRYSvw/uyhNG04vl2t8
         Azqg==
Content-Disposition: inline
In-Reply-To: <20230301193403.1507484-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 01, 2023 at 11:34:03AM -0800, Suren Baghdasaryan wrote:
> Current 500ms min window size for psi triggers limits polling interval
> to 50ms to prevent polling threads from using too much cpu bandwidth by
> polling too frequently. However the number of cgroups with triggers is
> unlimited, so this protection can be defeated by creating multiple
> cgroups with psi triggers (triggers in each cgroup are served by a single
> "psimon" kernel thread).
> Instead of limiting min polling period, which also limits the latency of
> psi events, it's better to limit psi trigger creation to authorized users
> only, like we do for system-wide psi triggers (/proc/pressure/* files can
> be written only by processes with CAP_SYS_RESOURCE capability). This also
> makes access rules for cgroup psi files consistent with system-wide ones.
> Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> remove the psi window min size limitation.
> 
> Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 10 ++++++++++
>  kernel/sched/psi.c     |  4 +---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 935e8121b21e..b600a6baaeca 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
>  	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
>  }
>  
> +static int cgroup_pressure_open(struct kernfs_open_file *of)
> +{
> +	return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE)) ?
> +		-EPERM : 0;
> +}

I agree with the change, but it's a bit unfortunate that this check is
duplicated between system and cgroup.

What do you think about psi_trigger_create() taking the file and
checking FMODE_WRITE and CAP_SYS_RESOURCE against file->f_cred?
