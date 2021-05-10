From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: inline cgroup_task_freeze()
Date: Mon, 10 May 2021 15:03:19 -0700
Message-ID: <CALvZod6VaGu3CDSamCpjsj7m2uz9KSefjiaF8Ni4=wPY_6ewnQ@mail.gmail.com>
References: <20210510213946.1667103-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eF6mHXnyQO/5Hgp+d/GWBsHQqZJ5DW8+q46yqFcmkgU=;
        b=dIK3ZtfyVSK/2JyhHVbLHvpO175CBFwmAuHrOWRfTZFvJNS7aVPDYfvS8vsgzreQfo
         Tk8wzdEV9Ofvm+h6RH+61Aq2wfnsqh2F8uVLezaNiu4FQ1b4TErhFnznIrA/p4zCRTqu
         xEOpxTLeh6QuhQhHeYjI8rBnLkVmtcbpzioz0OAdKfaRLKau49CYRc3w1tkRITK0l37s
         ukasPeDm2Ycqv5nz4Ch8YoHUx87x0PlcbmoCH79UaeYz2qaDnqBU87H/87FrI4bwFBii
         Mhzxr93A8of7z71kPsEhBsucuYQXcWOXE/FHmcgO3muv2dsSvihJmlGDVhe2QokLfofZ
         j78g==
In-Reply-To: <20210510213946.1667103-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 10, 2021 at 2:40 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> After the introduction of the cgroup.kill there is only one call site
> of cgroup_task_freeze() left: cgroup_exit(). cgroup_task_freeze() is
> currently taking rcu_read_lock() to read task's cgroup flags, but
> because it's always called with css_set_lock locked, the rcu protection
> is excessive.
>
> Simplify the code by inlining cgroup_task_freeze().
>
> v2: fix build
>
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
