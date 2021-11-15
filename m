From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Mon, 15 Nov 2021 09:32:42 -0800
Message-ID: <CALvZod7+P-2JR=Wsi_eYDymabAt=DFz4eR4w2KNtC-k1+AUtBg@mail.gmail.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com> <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz> <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
 <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIZsV1tZ1zejKBLMIoMZpzHmx69X5V2FDPLBZdbpb4I=;
        b=I0XsVPB1FjfH1rhf3ncp0KEXwazjq2PIf6R5llK+ireA6WKRE5bO3s2q5dXEaBJirg
         YEYLAzgw4ei9euOlx+LKjVYERdtPvbKR51tBnmc02VDC6I6eXPtR2Nwot1iCYcb02ert
         AfJSWq9PE3c7BltHeWeZeZP/T1xtt0Q3fy37o4qC+tcObqJJB6uKfDoMRKylB4DSebuc
         Yty4EIwtGqQZ6wZp2zIpfxkCz5x6nqi0tAsY2milaXqCyhYjnqtSt77DsEiKnZqpWDc0
         CErK70dbfqIkSjJfcr2z14RsNvlkNnVX2qvpnShUPEtUoMtHp7FZxsiumXCEnZnkCB6V
         3WYw==
In-Reply-To: <YZI9ZbRVdRtE2m70-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 15, 2021 at 2:58 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> >
> > The behavior I saw returning ENOMEM for this edge case was that the
> > code was forever looping the pagefault, and I was (seemingly
> > incorrectly) under the impression that a suggestion to forever loop
> > the pagefault would be completely fundamentally unacceptable.
>
> Well, I have to say I am not entirely sure what is the best way to
> handle this situation. Another option would be to treat this similar to
> ENOSPACE situation. This would result into SIGBUS IIRC.
>
> The main problem with OOM killer is that it will not resolve the
> underlying problem in most situations. Shmem files would likely stay
> laying around and their charge along with them.

This and similar topics were discussed during LSFMM 2019
(https://lwn.net/Articles/787626/).

> Killing the allocating
> task has problems on its own because this could be just a DoS vector by
> other unrelated tasks sharing the shmem mount point without a gracefull
> fallback. Retrying the page fault is hard to detect. SIGBUS might be
> something that helps with the latest. The question is how to communicate
> this requerement down to the memcg code to know that the memory reclaim
> should happen (Should it? How hard we should try?) but do not invoke the
> oom killer. The more I think about this the nastier this is.
> --

IMHO we should punt the resolution to the userspace and keep the
kernel simple. This is an opt-in feature and the user is expected to
know and handle exceptional scenarios. The kernel just needs to tell
the userspace that this exceptional situation is happening somehow.

How about for remote ooms irrespective of page fault path or not, keep
the allocator looping but keep incrementing a new memcg event
MEMCG_OOM_NO_VICTIM? The userspace will get to know the situation
either through inotify or polling and can handle the situation by
either increasing the limit or by releasing the memory of the
monitored memcg.

thanks,
Shakeel
