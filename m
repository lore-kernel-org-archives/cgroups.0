From: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/7] mm, oom: refactor select_bad_process() to
 take memcg as an argument
Date: Sun, 4 Jun 2017 22:25:54 +0300
Message-ID: <20170604192553.GA19980@esperanza>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
 <1496342115-3974-2-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=//o8dHrIJHctWYvZ9veBgVjRYQ7diQNEOqqSzIDmefQ=;
        b=XjPuFbtx/vS6jsQq9F3/TjKwV4NzZI5t+Wwd5OqxXXyXRhP7Hu4avDAMHpDz8MzoYS
         HCG7vQyuV4IPo/rA4L75HmuyRBgT1Ex3UFtAF0ankub1BB8u8yDSTnTxv70Xeh6OhKtl
         cxNCR7Hs26l0fa9yxg6Z1xihpNs5D7qrLvlrnSdz+XfRcr25wemc39TG7zcmI65OlPfP
         mfJtrEINa2Lyd2wd0uL7HLrKACmF1qtJLYQqbMCE5/xD/LD5acQYWWDAjmlVLovpqHrS
         hXp7OgiKd543baCpIAr1tfLqUfEJyGyfU0vpyC5ES3h14sLq6qhHD+jgOKQYilVUXdY8
         QONw==
Content-Disposition: inline
In-Reply-To: <1496342115-3974-2-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 01, 2017 at 07:35:09PM +0100, Roman Gushchin wrote:
> The select_bad_process() function will be used further
> to select a process to kill in the victim cgroup.
> This cgroup doesn't necessary match oc->memcg,
> which is a cgroup, which limits were caused cgroup-wide OOM
> (or NULL in case of global OOM).
> 
> So, refactor select_bad_process() to take a pointer to
> a cgroup to iterate over as an argument.

IMHO this patch, as well as patches 2-5, doesn't deserve to be submitted
separately: none of them make sense as a separate change; worse, patches
4 and 5 introduce user API that doesn't do anything without patch 6. All
of the changes are relatively small and singling them out doesn't really
facilitate review, so I'd merge them all in patch 6.
