From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/7] mm, oom: introduce oom_kill_all_tasks option
 for memory cgroups
Date: Sun, 4 Jun 2017 22:30:02 +0300
Message-ID: <20170604193002.GB19980@esperanza>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
 <1496342115-3974-5-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=orxBX4tRl/8GZKRdUC1Z+sP5PBeix0z49V30EsfiJiA=;
        b=WGXmNWn0djnf1anokRzSUu2U47yGar0VCjUJlO4n+eq0IVtGfrQQm6wUs8H9zn7mkO
         D3wfwxdnjf6Jddl3kNwwcTgmeQmQNRTNEcYi93Zu8xjBujHtB+7kaYdu4fC2IxRWrUZy
         13c5UrMNkY1762bnVMbrlxvXyk5wo6939Iu0gPSv2nwdU/+r+c50R13NjaBrILEi5eZI
         PszvrayBE8ebelYWBoXYflU6wpD4ZQYDwBxy8GZmRV9jV1wPbLFutwwLq1BBW1ZpCBJv
         nFRw4NOoAWiWiK9HVM9l+5rA2hwf4NLyqrdIm1PnWy0ERigDnJVpPOPO4FfUC5uuqW14
         iU1g==
Content-Disposition: inline
In-Reply-To: <1496342115-3974-5-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 01, 2017 at 07:35:12PM +0100, Roman Gushchin wrote:
> This option defines whether a cgroup should be treated
> as a single entity by the OOM killer.
> 
> If set, the OOM killer will compare the whole cgroup with other
> memory consumers (other cgroups and tasks in the root cgroup),
> and in case of an OOM will kill all belonging tasks.
> 
> Disabled by default.
> 
...
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> @@ -5265,6 +5292,12 @@ static struct cftype memory_files[] = {
>  		.write = memory_max_write,
>  	},
>  	{
> +		.name = "oom_kill_all_tasks",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.seq_show = memory_oom_kill_all_tasks_show,
> +		.write = memory_oom_kill_all_tasks_write,
> +	},
> +	{
>  		.name = "events",
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.file_offset = offsetof(struct mem_cgroup, events_file),

I don't really like the name of the new knob, but can't come up with
anything better :-( May be, drop '_tasks' suffix and call it just
'oom_kill_all'? Or perhaps we should emphasize the fact that this
cgroup is treated as a single entity by the OOM killer by calling it
'oom_entity' or 'oom_unit'? Dunno...
