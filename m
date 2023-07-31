From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in fsid
Date: Mon, 31 Jul 2023 11:49:24 -0700
Message-ID: <CABWYdi3s35QZXSeb95XUeLyOkM66po603-ows1n3np=Lt4g1nw@mail.gmail.com>
References: <20230710183338.58531-1-ivan@cloudflare.com> <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com>
 <CAOQ4uxiFhkSM2pSNLCE6cLz6mhYOvk5D7vDsghVTqy9cDqeqew@mail.gmail.com> <20230731134615.delje45enx3tkyco@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1690829375; x=1691434175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSrMC3+SJ0egYG0f2gwoLknFT0dgY+FAasCFfQTvvxk=;
        b=TPZP/yMbUeQTiuSSmHPaXqzypxoYzjL9bpLQpl0sY8BgdmcRkvH9tlSaOBGz+GX6Rw
         r7vFIC1zKA9ozOF6N2GPcB4UABRxXkHaRMY4XC4SVCpUl6dpAGWvWd5MVy3+9ZC0O4yV
         65rxWUeZOu5KUypxo2o9f9h4X+VtKC6wRMJ6U=
In-Reply-To: <20230731134615.delje45enx3tkyco@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, kernel-team@cloudflare.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>

On Mon, Jul 31, 2023 at 6:46=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> > I agree. I think it was a good decision.
> > I have some followup questions though.
> >
> > I guess your use case cares about the creation of cgroups?
> > as long as the only way to create a cgroup is via vfs
> > vfs_mkdir() -> ... cgroup_mkdir()
> > fsnotify_mkdir() will be called.
> > Is that a correct statement?
> > Because if not, then explicit fsnotify_mkdir() calls may be needed
> > similar to tracefs/debugfs.
> >
> > I don't think that the statement holds for dieing cgroups,
> > so explicit fsnotify_rmdir() are almost certainly needed to make
> > inotify/fanotify monitoring on cgroups complete.
>
> Yeah, as Ivan writes, we should already have all that is needed to
> generate CREATE and DELETE events for the cgroup filesystem. In theory
> inotify or fanotify for inodes could be already used with cgroupfs now.
> Thus I have no objection to providing fsid for it so that filesystem-wide
> notifications can be used for it as well. Feel free to add:
>
> Acked-by: Jan Kara <jack@suse.cz>
>
> to your patch.

Thank you, I just sent v2:

* https://lore.kernel.org/linux-fsdevel/20230731184731.64568-1-ivan@cloudfl=
are.com/
