From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files to tmpfs
Date: Tue, 21 Jul 2020 12:12:58 -0700
Message-ID: <CALvZod6-sTBMzvo0ER+RkQ_OM7B4=PKUC-T9gXmQiB8mznunBg@mail.gmail.com>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
 <20200721174126.GA271870@cmpxchg.org> <20200721184959.GA8266@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1+MBynaOaFc+TQGQ/+zLUDlbfNpuxAiueoXbqW+mHQ=;
        b=CnYKPb1Xv2Oa9t8RxiLG8qh5LFd1tQ4x4f0WjwYFg0GeyKeD8WtsbrK0ptSPAvEwl2
         p5N38bdjZsT11squqkQ1pPFLR9OGUwiDyFO1XbXZvTeA+Phru4E2ctuap9k6B7ovdktM
         c1hj9ICibOXamyVTIL9p8vYpWBYTXMAm08B9cKvi34M8bs+ahrGlrDUCP/R2c1BueQFN
         vDKbKpW7kZ9rqKt+fNxsj407lyPTEGwfMi3MMK8QZsqwyq6YDDGlB6I7vYjAl7jTwHsB
         /AdU0ePREeL3IVkKswnAQ8Vc0ueP/mNPN2/leFB8tSv5ukqw0EhQ0veO+jKqLwnXzr6L
         9ROg==
In-Reply-To: <20200721184959.GA8266-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, caihaomin <caihaomin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Weiwei (N)" <wick.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, guro-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Tue, Jul 21, 2020 at 11:51 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Tue, Jul 21, 2020 at 01:41:26PM -0400, Johannes Weiner wrote:
> > On Tue, Jul 21, 2020 at 11:19:52AM +0000, jingrui wrote:
> > > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> ; Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > > Thanks.
> > >
> > > ---
> > > PROBLEM: cgroup cost too much memory when transfer small files to tmpfs.
> > >
> > > keywords: cgroup PERCPU/memory cost too much.
> > >
> > > description:
> > >
> > > We send small files from node-A to node-B tmpfs /tmp directory using sftp. On
> > > node-B the systemd configured with pam on like below.
> > >
> > > cat /etc/pam.d/password-auth | grep systemd
> > > -session     optional      pam_systemd.so
> > >
> > > So when transfer a file, a systemd session is created, that means a cgroup is
> > > created, then file saved at /tmp will associated with a cgroup object. After
> > > file transferred, session and cgroup-dir will be removed, but the file in /tmp
> > > still associated with the cgroup object. The PERCPU memory in cgroup/css object
> > > cost a lot(about 0.5MB/per-cgroup-object) on 200/cpus machine.
> >
> > CC Roman who had a patch series to free all this extended (percpu)
> > memory upon cgroup deletion:
> >
> > https://lore.kernel.org/patchwork/cover/1050508/
> >
> > It looks like it never got merged for some reason.
>
> The mentioned patchset can make the problem less noticeable, but can't solve it completely.
> It has never been merged, because the dying cgroup problem was mostly solved by other methods:
> slab memory reparenting and various reclaim fixes. So there was no more reason to complicate
> the code to release the memcg memory early.
>
> The overhead of creating and destroying a new memory cgroup for a transfer of a small
> file will be noticeable anyway. So IMO the solution is to use a single cgroup for all
> transfers. I don't know if systemd supports such mode out of the box, but it shouldn't
> be hard to add it.
>
> But also I wonder if we need a special tmpfs mount option, something like "noaccount".
> Not only for this specific case, but also for the case when tmpfs is extensively
> shared between multiple cgroups or if it's used to pass some data from one cgroup
> to another, or if we care about the performance more than about the accounting;
> in other words for cases where the accounting makes more harm than good.
>

Internally we actually have an tmpfs mount option "memcg=" which
charges all the memory of the tmpfs files on that mount to the given
memcg and the motivation is the shared tmpfs files between multiple
cgroups. One concrete use-case is the shared memory used for
communication between the application and the user space network
driver [1]. The "memcg=root" can be used as a "noaccount" option.

[1] https://sosp19.rcs.uwaterloo.ca/slides/marty.pdf
