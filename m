From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for triggers
Date: Thu, 2 Mar 2023 08:08:38 -0800
Message-ID: <CAJuCfpH+yuynm+8LDbcOyh-q_PFTOz-FygxO9aSg8=RUR3LT+Q@mail.gmail.com>
References: <20230301193403.1507484-1-surenb@google.com> <ZACrgV4f39P/2sZO@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677773329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o4oQ31BBWd17/OrBmaIYzd49tP3Dix54xt4VYG6efag=;
        b=c68m6eik+53s5ghZ8Wk6fDeh16+MIGLL2unfAA/ShiTQX81DA+PrcE8XnLQGzZCvZQ
         vN2XPVLbn1wfC/8NCIubij0nUZJqxKcCmBxWTOn6qAUtuflqTF9mZvIdkS3e3c0vzbH4
         qsMNWAQtrEFDCDscPFpvLxjJdM4HlDeWrxdj8WSt1tlECtIHKD1+HqjwILLeSnLzHibu
         bAOXTvREbnpopYu1ry3LZ8SS4rFApGoN7zpEEmt/iN5oxzI/PXgiH5odoJEZJ656yeRH
         /8tViM5OehqWujUVRORIpO0V2vnIVAPeaDw2AhQ8WpgPomB5qvQZvmUB/kQ0Db9oEprd
         zqMw==
In-Reply-To: <ZACrgV4f39P/2sZO-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 2, 2023 at 5:58 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 01-03-23 11:34:03, Suren Baghdasaryan wrote:
> > Current 500ms min window size for psi triggers limits polling interval
> > to 50ms to prevent polling threads from using too much cpu bandwidth by
> > polling too frequently. However the number of cgroups with triggers is
> > unlimited, so this protection can be defeated by creating multiple
> > cgroups with psi triggers (triggers in each cgroup are served by a single
> > "psimon" kernel thread).
> > Instead of limiting min polling period, which also limits the latency of
> > psi events, it's better to limit psi trigger creation to authorized users
> > only, like we do for system-wide psi triggers (/proc/pressure/* files can
> > be written only by processes with CAP_SYS_RESOURCE capability). This also
> > makes access rules for cgroup psi files consistent with system-wide ones.
> > Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> > remove the psi window min size limitation.
> >
> > Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> > Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
> > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
> with this to fix
> [...]
> > @@ -1278,8 +1277,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
> >       if (state >= PSI_NONIDLE)
> >               return ERR_PTR(-EINVAL);
> >
> > -     if (window_us < WINDOW_MIN_US ||
> > -             window_us > WINDOW_MAX_US)
> > +     if (window_us <= 0 || window_us > WINDOW_MAX_US)
> >               return ERR_PTR(-EINVAL);
>
> window_us is u32 sp the check for <= 0 doesn't make any sense.

Completely missed that. Will change to == 0 and post the new version.
window_us is later multiplied by NSEC_PER_USEC and then divided by
UPDATES_PER_WINDOW(10), so even the smallest value of 1 still results
in a positive poll_min_period. I think we should be fine with that
check.
Thanks!

>
> >
> >       /* Check threshold */
> > --
> > 2.40.0.rc0.216.gc4246ad0f0-goog
>
> --
> Michal Hocko
> SUSE Labs
