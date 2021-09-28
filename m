From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] The usage of memory cgroup is not consistent with processes
 when using THP
Date: Tue, 28 Sep 2021 15:14:17 -0700
Message-ID: <CAHbLzkpjRV_32V3AGCsDku8JckeFKvEWd=w2-ZkQ2hbcOAChAA@mail.gmail.com>
References: <CAHKqYaa7H=M4E-=ObO0ecj+NE2KwZN5d7QSz4_b6tXz2vOo+VA@mail.gmail.com>
 <CAHbLzkpBCQp7UGK_WPJ-akdQ7HqkOEMtE6+9qX5ciu3DU-ZVrg@mail.gmail.com> <CAHKqYaZAnz4wiHksKSZMLNEbk9eUUQ1z8iQCLwFgNW40ejByYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x9zDwJRWIm139eLhv6Qo7TZGdOTE27JLM+druYyg5ZI=;
        b=qYa6jC0CPO7v3mfxhwIs9R3Pwvt+6UQsr/69yWr3RX8Q0Qy1yfDrgSUOJ6L0aCi5AH
         AWgvQKSfEkR9/nBtB3gJhn82TWy84/sbaRg2a0UIo9UHrpZf4jGRaGcZXf/fr4BKwigU
         XCciR7+dbBgdzzNvOxm2Oi4LXlbcYAgvEYSqyHxXSbUe184l4EFPk01aWIAWUFknnFJW
         cFgir3Hbv8hMcOLsfcDKgpuqNjyvvpCb63jHiZ7vw4MlX1av11n+wLVuVe+ZT1pOZ4g3
         /OJIQWe5OyFjz2vauklQqXnSN1DM9OZuVtTrO+1vWWam1kkYvWtY9ovmbPB13155558R
         7qBA==
In-Reply-To: <CAHKqYaZAnz4wiHksKSZMLNEbk9eUUQ1z8iQCLwFgNW40ejByYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?5Y+w6L+Q5pa5?= <yunfangtai09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Sep 28, 2021 at 12:15 AM =E5=8F=B0=E8=BF=90=E6=96=B9 <yunfangtai09@=
gmail.com> wrote:
>
> Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E4=BA=8E2021=E5=B9=B49=E6=9C=8828=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=881:28=E5=86=99=E9=81=93=EF=BC=9A
> > IMHO I don't think this is a bug. The disparity reflects the
> > difference in how the page life cycle is viewed between process and
> > cgroup. The usage of process comes from the rss_counter of mm. It
> > tracks the per-process mapped memory usage. So it is updated once the
> > page is zapped.
> >
> > But from the point of cgroup, the page is charged when it is allocated
> > and uncharged when it is freed. The page may be zapped by one process,
> > but there might be other users pin the page to prevent it from being
> > freed. The pin may be very transient or may be indefinite. THP is one
> > of the pins. It is gone when the THP is split, but the split may
> > happen a long time after the page is zapped due to deferred split.
> Thank you for reply. I agree that it reflects the difference between
> process and cgroup. The memory usage of cgroup is usually used to
> indicate the memory usage of the container. It can be used to avoid
> the OOM and etc. The disparity will cause that the memory usage of
> containers with the same processes are randomly different (we found
> more than 30GB different). It is hard to manage them. Of course,
> disable THP is a way to solve it. Can it have another way to solve it
> ?

I don't quite get what exactly you want to manage. If you want to get
rid of the disparity, I don't have good idea other than splitting THP
in place instead of using deferred split. But AFAIK it is not quite
feasible due to some locking problems.
