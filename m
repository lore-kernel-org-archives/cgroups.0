From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in fsid
Date: Thu, 13 Jul 2023 14:34:18 -0700
Message-ID: <CABWYdi2fTLnQeZnLG2uTCHyQkBnr1Z9OtfYhnzp_TtqiXyYd9A@mail.gmail.com>
References: <20230710183338.58531-1-ivan@cloudflare.com> <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com>
 <CAOQ4uxiFhkSM2pSNLCE6cLz6mhYOvk5D7vDsghVTqy9cDqeqew@mail.gmail.com>
 <CABWYdi26iboFTFz+Vex3VO0fzmFzyfOxgr-qc964mLiC3En7=A@mail.gmail.com> <CAOQ4uxgLp+gwJPTWj9uwhncx8RD5-mZY7qOaD2C6pbu7c4+srw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1689284069; x=1691876069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Z9ExxShnMFQ+6I5uZ5HSYqKDhYmMF4V08BZ/iO202I=;
        b=h96b3lCadCzWegH3hy0ZB2qQb2VZ9g0nshLIbNVzMENhuzrBxLTtfdh7mmX90L1hwe
         RZfzF4Aa5SynwDTuf1h66O484szaN5D9Kl6XuazI2Ihx4qpiFs3t5c/PsFAPpgQJOIGL
         X0GmfjEclYmAKt73DrMFCY70GggFKLYn2hzgI=
In-Reply-To: <CAOQ4uxgLp+gwJPTWj9uwhncx8RD5-mZY7qOaD2C6pbu7c4+srw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, Jul 11, 2023 at 10:44=E2=80=AFPM Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> > > I agree. I think it was a good decision.
> > > I have some followup questions though.
> > >
> > > I guess your use case cares about the creation of cgroups?
> > > as long as the only way to create a cgroup is via vfs
> > > vfs_mkdir() -> ... cgroup_mkdir()
> > > fsnotify_mkdir() will be called.
> > > Is that a correct statement?
> >
> > As far as I'm aware, this is the only way. We have the cgroups mailing
> > list CC'd to confirm.
> >
> > I checked systemd and docker as real world consumers and both use
> > mkdir and are visible in fanotify with this patch applied.
> >
> > > Because if not, then explicit fsnotify_mkdir() calls may be needed
> > > similar to tracefs/debugfs.
> > >
> > > I don't think that the statement holds for dieing cgroups,
> > > so explicit fsnotify_rmdir() are almost certainly needed to make
> > > inotify/fanotify monitoring on cgroups complete.
> > >
> > > I am on the fence w.r.t making the above a prerequisite to merging
> > > your patch.
> > >
> > > One the one hand, inotify monitoring of cgroups directory was already
> > > possible (I think?) with the mentioned shortcomings for a long time.
> > >
> > > On the other hand, we have an opportunity to add support to fanotify
> > > monitoring of cgroups directory only after the missing fsnotify hooks
> > > are added, making fanotify API a much more reliable option for
> > > monitoring cgroups.
> > >
> > > So I am leaning towards requiring the missing fsnotify hooks before
> > > attaching a unique fsid to cgroups/kernfs.
> >
> > Unless somebody responsible for cgroups says there's a different way
> > to create cgroups, I think this requirement doesn't apply.
> >
>
> I was more concerned about the reliability of FAN_DELETE for
> dieing cgroups without an explicit rmdir() from userspace.

I checked the code and cgroups are destroyed in cgroup_destroy_locked,
which is only called from two places:

* In cgroup_mkdir (only on failure)
* In cgroup_rmdir

See: https://elixir.bootlin.com/linux/v6.5-rc1/A/ident/cgroup_destroy_locke=
d

We should be covered here.
