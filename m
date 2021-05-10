From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/5] tests/cgroup: test cgroup.kill
Date: Mon, 10 May 2021 15:02:51 -0700
Message-ID: <CALvZod4mOdiPzHzCi3LKoNheKY7j4rDfYipeuXQa7tCUpDi1cQ@mail.gmail.com>
References: <20210508121542.1269256-1-brauner@kernel.org> <20210508121542.1269256-5-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xEEZ8t7f0Q20wXtDGcovj3/jFYFaAmR7f82EcXq4W5E=;
        b=Hf/Y6EU13veGHo0Ee/3Us0ThFP69fYhIWpWPeEAEnFGaowsbpvX0f3mNwLvfKkh5Cd
         GyWiWrN6TuNOaqFOq+H8VApUy0CL3ov965gx81tmgJ1z/21CSMMHodjtmOrHfV5o5JkU
         jjgez6QzICn/DZqYB8VEg16OonQiMpXhqDNebyVd4weEOVG78LhqJNPVpoCD7XBYa+uA
         Jpj2GT7mcB5er8odCcjADqa/835doJ3jp2st3CCnPnoayDiuWi9WOoPBCy34PVIaSsGm
         5P0eyqCAcykTddALOI2aBXjXNB+FNrjk36Hqt2pZKoPvHVAozX6CDSXrrD8nHFMy3p7N
         hCLQ==
In-Reply-To: <20210508121542.1269256-5-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Sat, May 8, 2021 at 5:16 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>
> Test that the new cgroup.kill feature works as intended.
>
> Link: https://lore.kernel.org/r/20210503143922.3093755-5-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
