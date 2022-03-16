From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Wed, 16 Mar 2022 09:13:00 -0700
Message-ID: <CAJD7tkYGXVX+ehGsOMidfaKCbjuB2HeAK=Up_2evg6iOZD1z-Q@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <CAPhsuW5qHSZNSEh8CQK3wYqtJ4XB+EwFEJWKA9SkA+wGFbvNCg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z02blqoxThuGkhi9wvej2czZDkzHuDmLTnoYf50M1uc=;
        b=cGZXSXrsgc31cO4Sk0bWUlfS1YHAUJEfGTBf5TIBee1N2O1v51N7loA1ZZpKIMLhQU
         ZL4G+LW3sc0mD2+VrXcSsn2ki9iK3vUoZBFy+e+ymKKFCYoQ+YANqSB0U4QAHY9uDFXB
         SafWbfwTRZGMBUkBvqQatRHY7TtVrEWAZlgYsjZQpgb3TmjgnxKesoFw28mzwz8qsMx3
         NyfJIBCq/S3dp8Nn2WH5a8J4Z0pUttEIw8/bVGsy6obvllTS6Lt/V7qPFQ8r+oGvrktt
         7x5mr0KfJ+CGeeCF427uudGKR4pMiwgAi/lgMMyclVWd9GIeS9bxCskxGnxeAA+7BFqV
         Ye+w==
In-Reply-To: <CAPhsuW5qHSZNSEh8CQK3wYqtJ4XB+EwFEJWKA9SkA+wGFbvNCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 15, 2022 at 11:05 PM Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Mar 9, 2022 at 12:27 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> [...]
> >
> > The map usage by BPF programs and integration with rstat can be as follows:
> > - Internally, each map entry has per-cpu arrays, a total array, and a
> > pending array. BPF programs and user space only see one array.
> > - The update interface is disabled. BPF programs use helpers to modify
> > elements. Internally, the modifications are made to per-cpu arrays,
> > and invoke a call to cgroup_bpf_updated()  or an equivalent.
> > - Lookups (from BPF programs or user space) invoke an rstat flush and
> > read from the total array.
>
> Lookups invoke a rstat flush, so we still walk every node of a subtree for
> each lookup, no? So the actual cost should be similar than walking the
> subtree with some BPF program? Did I miss something?
>

Hi Song,

Thanks for taking the time to read my proposal.

The rstat framework maintains a tree that contains only updated
cgroups. An rstat flush only traverses this tree, not the cgroup
subtree/hierarchy.

This also ensures that consecutive readers do not have to do any
traversals unless new updates happen, because the first reader will
have already flushed the stats.

>
> Thanks,
> Song
>
> > - In cgroup_rstat_flush_locked() flush BPF stats as well.
> >
> [...]
