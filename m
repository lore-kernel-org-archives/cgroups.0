From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Add the missing numa stat
 of anon and file for cgroup v2
Date: Fri, 11 Sep 2020 08:55:34 -0700
Message-ID: <CALvZod75aWLSFK5DnbbL+aX5bT=w_BgU_wWACqP2KONHbp0_3g@mail.gmail.com>
References: <20200910084258.22293-1-songmuchun@bytedance.com>
 <CALvZod5JQWGHUAPnj9S0pKFQreLPST441mZnp+h=fue_nnh1yQ@mail.gmail.com>
 <CAMZfGtUncFZZe2RDb54ALMt1DAVqBxAD1TQrpjei1H5nRbH6jg@mail.gmail.com>
 <CALvZod5_1nGJ2-QfSnYm4rCB+qvMEKAuVJrCeCyv_vQs7EoYfw@mail.gmail.com> <CAMZfGtX7UF7VSNbcutibLu7ZO-cn6jFYHURHG9ycEmkmnjB08Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/8h3iMEyFX6QewzjKstBqsXqbnz4eLSjULf7zqd77Io=;
        b=K5fRpESJbY0J2ZllnGRok9NGNm70giUMtrP8Frc6f8UWBaz4M8hpQ/5a2wWgh8XyzZ
         6rLN/sG5qBPy+9e03ECdD4AzRCmP9RaPn1m1/OsHh/hsH7AgbzvhgV1S2hZcBASCM/le
         CpwlEYVGVmnzFVsTdBULF39HA/kbL1x8w7NNyHi0kGf+XJx6MW5Jm04vrvFqqMUxCemV
         hFyNb8QBWvIKmfyFkNeKLNNuyot42p+XGAoJnXVd44yKZ2Ku2NIJa7Ai6NYhLY4SMCde
         4uaBKTDBABwPBRJ0n0BcZQa/xeDeqhxEWyZmhtGKA6pmxus2DRUtIIZRVqetwgndH0fV
         eOwQ==
In-Reply-To: <CAMZfGtX7UF7VSNbcutibLu7ZO-cn6jFYHURHG9ycEmkmnjB08Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 11, 2020 at 8:48 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
[snip]
>
> I got it, thanks. Because the "state" interface exposes the anon and
> file information. So I think that we also should expose the anon and
> file for "numa_stat" per node instead of the lru statistics. Maybe it is
> better that we expose both of all the information.
>

Sure, go ahead and please do update the doc file as well in the next version.
