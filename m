From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Wed, 30 Nov 2022 11:45:05 -0800
Message-ID: <CAHS8izPdKG0aNbfLK8=oUdsSSZ95i1nCaKs+4s5Kx1vCHMEOWw@mail.gmail.com>
References: <20221130020328.1009347-1-almasrymina@google.com> <7c5e0ca5-0ad1-452d-60b9-50dbb63d2dee@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d74Ux9XASnvU3YsAvcNYJRwNMvF0Ld8sCW80w/+NTE4=;
        b=j28NVgl4hCm++QbB7qCOUtkzWy/v59pO1/o+zat2KKRnzaBDA9auy79+yMFyfeHozY
         O8UmY73hAZaYuSwradcNQVtE4HbpFPjTDxkLSMq2YdoDkO1lcoXgQJTyH2fUudSZJgC5
         VBP5QabgJfTAUoei4mABHncJJGGGRi7anWkbVLpi0E+yzvQZdpwDlqKaUa4Q92t4IsZD
         o2C2j/dJoOSZ1dbwUISLxLapwtivpEougXjZlEMs1BWXkT5fhryOWhhCVvL25ogAsvfp
         ruTQESZWjtyVnOb/ieUzCNZaW6+5QIOKKytt/WwI2PjwBI2ERZzex4Em7IVovUebkd4c
         7J2w==
In-Reply-To: <7c5e0ca5-0ad1-452d-60b9-50dbb63d2dee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Nov 30, 2022 at 12:44 AM Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 11/30/22 09:03, Mina Almasry wrote:
> > -     This file accepts a single key, the number of bytes to reclaim.
> > -     No nested keys are currently supported.
> > +     This file accepts a string which contains the number of bytes to
> > +     reclaim.
> >
> Amount of memory to reclaim?
>

I want to have the word 'byte' in there somewhere to make that clear.
I guess maybe 'the amount of memory to reclaim in bytes'. Although as
written it seems more concise.

> > +     This file also allows the user to specify the nodes to reclaim from,
> > +     via the 'nodes=' key, example::
> > +
>
> "..., for example"
>

Will do in the next version. Thanks for taking a look, Bagas.

> > +       echo "1G nodes=0,1" > memory.reclaim
> > +
> > +     The above instructs the kernel to reclaim memory from nodes 0,1.
> > +
>
> Thanks.
>
> --
> An old man doll... just what I always wanted! - Clara
>
