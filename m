From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Date: Mon, 21 Nov 2011 15:07:09 -0800
Message-ID: <20111121230709.GR25776@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YI8sbwiDh8nStCsPbEiXW4FsCA2HmqqXV9qdHqQabD4=;
        b=qMA82i8bNFc4GJHzA0s3tbT+TfI73cfQEXysT8ZrcvcvJJ3SjNGAfTUqeGqZa+mUxZ
         qVdOtferYlycn+GjGpl31AticvTiym62iol/iOqfquzt8NjmcDDONzp7WadAjSQmyyQr
         yM7RKy4RKoU826Ls+ZGRWCrSI8/kZtu9nkN7M=
Content-Disposition: inline
In-Reply-To: <1321480234-29241-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Tomasz Buchert <tomasz.buchert-MZpvjPyXg2s@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Michal.

On Wed, Nov 16, 2011 at 10:50:34PM +0100, Michal Hocko wrote:
> +/* Task is frozen or will freeze immediately when next it gets woken */
> +static bool is_task_frozen_enough(struct task_struct *task)
> +{
> +	return frozen(task) ||
> +		(task_is_stopped_or_traced(task) && freezing(task));
> +}

Hmmm... w/ pending freezer updates, the above would always return
%true if there's freezing in progress, which can't be right.  Maybe
just test stopped/traced?

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/pm-freezer

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
