From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Fri, 12 Nov 2021 00:12:52 -0800
Message-ID: <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com> <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5kPBmCOcmFspVqwDgZJWVPQZeOyM/KG0MhndtiqdEc=;
        b=U2FZQm5zQOY88IbxrwbNkiPdB3B/wQ4eXF7J3PAIDxN9GQZbCs8E1k0ZwSlv1ScR1j
         fbH1eYVxb8RqPksQXmoIdAhf0TADb6wnzQbfxUkclgDCuwbx93P6i10BmRulValid+Aq
         L/mbamz5BrE87AlBoENcHa/+FU3neQPWrwjd5Ta7kkLSTkoOGZvpVRnYJrUrysuzUWA1
         Zr1kZDqhWI/U1TQVRTwv/5Nexd8+4+6Bf7s0Xyv7VFQoia//aN7mxMAoQ64UJ5eA2A78
         xBNVLp6eSz+Hlv9qn6b7uOxai7YvHPpzrEWvIVWekPZ2WSLlI5oeCPMQWI6FyaFFI8Hv
         BkXw==
In-Reply-To: <YY4dHPu/bcVdoJ4R-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 11, 2021 at 11:52 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 11-11-21 15:42:01, Mina Almasry wrote:
> > On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> > to find a task to kill in the memcg under oom, if the oom-killer
> > is unable to find one, the oom-killer should simply return ENOMEM to the
> > allocating process.
>
> This really begs for some justification.
>

I'm thinking (and I can add to the commit message in v4) that we have
2 reasonable options when the oom-killer gets invoked and finds
nothing to kill: (1) return ENOMEM, (2) kill the allocating task. I'm
thinking returning ENOMEM allows the application to gracefully handle
the failure to remote charge and continue operation.

For example, in the network service use case that I mentioned in the
RFC proposal, it's beneficial for the network service to get an ENOMEM
and continue to service network requests for other clients running on
the machine, rather than get oom-killed when hitting the remote memcg
limit. But, this is not a hard requirement, the network service could
fork a process that does the remote charging to guard against the
remote charge bringing down the entire process.

> > If we're in pagefault path and we're unable to return ENOMEM to the
> > allocating process, we instead kill the allocating process.
>
> Why do you handle those differently?
>

I'm thinking (possibly incorrectly) it's beneficial to return ENOMEM
to the allocating task rather than killing it. I would love to return
ENOMEM in both these cases, but I can't return ENOMEM in the fault
path. The behavior I see is that the oom-killer gets invoked over and
over again looking to find something to kill and continually failing
to find something to kill and the pagefault never gets handled.

I could, however, kill the allocating task whether it's in the
pagefault path or not; it's not a hard requirement that I return
ENOMEM. If this is what you'd like to see in v4, please let me know,
but I do see some value in allowing some callers to gracefully handle
the ENOMEM.

> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> > Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> --
> Michal Hocko
> SUSE Labs
