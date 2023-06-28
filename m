From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 09:26:07 +0200
Message-ID: <20230628-meisennest-redlich-c09e79fde7f7@brauner>
References: <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner>
 <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner>
 <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
 <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687937175;
        bh=KKTVALnymNGJ+x0EEK73YI4pMPfmDEYV5K+7qO8CGUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GcS7JW5+a8i3+Z8giAru7YHmGUQvZNRoX56KWjc+y86DW90aKZvEtZfAe8F0tgTB6
         vODIPUXQFMnc7oyAgJHFtJ7WWUEOS8/xt+vtbj1Ec+jkkJhRb/33kVHz2LG8ACMbwf
         oX9ySoEp5rruTcNC78fWHKGMKVfWWMVSTRr6k2bJFZq64nMsR6Qb5uX/v266a97WQM
         Kmd8aSMjBU+2dR6lRv0NGfwBXFrrSU9iCVipztVIoJ+vAKGfzGkzrd46kPnt0Cve/x
         u0+00mGkMRvPE+GUMCKMwrLM0ey+apK3Gl7JoD4pYrdzGvsgTCWajYG0CMapDfdyOW
         lUeUocKXOHZdg==
Content-Disposition: inline
In-Reply-To: <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, gregkh@linuxfoundation.org, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Tue, Jun 27, 2023 at 08:09:46PM -0700, Suren Baghdasaryan wrote:
> On Tue, Jun 27, 2023 at 6:54=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Tue, Jun 27, 2023 at 02:58:08PM -0700, Suren Baghdasaryan wrote:
> > > Ok in kernfs_generic_poll() we are using kernfs_open_node.poll
> > > waitqueue head for polling and kernfs_open_node is freed from inside
> > > kernfs_unlink_open_file() which is called from kernfs_fop_release().
> > > So, it is destroyed only when the last fput() is done, unlike the
> > > ops->release() operation which we are using for destroying PSI
> > > trigger's waitqueue. So, it seems we still need an operation which
> > > would indicate that the file is truly going away.
> >
> > If we want to stay consistent with how kernfs behaves w.r.t. severing, =
the
> > right thing to do would be preventing any future polling at severing and
> > waking up everyone currently waiting, which sounds fine from cgroup beh=
avior
> > POV too.
>=20
> That's actually what we are currently doing for PSI triggers.
> ->release() is handled by cgroup_pressure_release() which signals the
> waiters, waits for RCU grace period to pass (per
> https://elixir.bootlin.com/linux/latest/source/include/linux/wait.h#L258)
> and then releases all the trigger resources including the waitqueue
> head. However as reported in
> https://lore.kernel.org/all/20230613062306.101831-1-lujialin4@huawei.com
> this does not save us from the synchronous polling case:
>=20
>                                                   do_select
>                                                       vfs_poll
> cgroup_pressure_release
>     psi_trigger_destroy
>         wake_up_pollfree(&t->event_wait) -> unblocks vfs_poll
>         synchronize_rcu()
>         kfree(t) -> frees waitqueue head
>                                                      poll_freewait()
> -> uses waitqueue head
>=20
>=20
> This happens because we release the resources associated with the file
> while there are still file users (the file's refcount is non-zero).
> And that happens because kernfs can call ->release() before the last
> fput().
>=20
> >
> > Now, the challenge is designing an interface which is difficult to make
> > mistake with. IOW, it'd be great if kernfs wraps poll call so that seve=
ring
> > is implemented without kernfs users doing anything, or at least make it
> > pretty obvious what the correct usage pattern is.
> >
> > > Christian's suggestion to rename current ops->release() operation into
> > > ops->drain() (or ops->flush() per Matthew's request) and introduce a
> > > "new" ops->release() which is called only when the last fput() is done
> > > seems sane to me. Would everyone be happy with that approach?
> >
> > I'm not sure I'd go there. The contract is that once ->release() is cal=
led,
> > the code backing that file can go away (e.g. rmmod'd). It really should
> > behave just like the last put from kernfs users' POV.
>=20
> I 100% agree with the above statement.
>=20
> > For this specific fix,
> > it's safe because we know the ops is always built into the kernel and w=
on't
> > go away but it'd be really bad if the interface says "this is a normal =
thing
> > to do". We'd be calling into rmmod'd text pages in no time.
> >
> > So, I mean, even for temporary fix, we have to make it abundantly clear=
 that
> > this is not for usual usage and can only be used if the code backing th=
e ops
> > is built into the kernel and so on.
>=20
> I think the root cause of this problem is that ->release() in kernfs
> does not adhere to the common rule that ->release() is called only
> when the file is going away and has no users left. Am I wrong?

So imho, ultimately this all comes down to rmdir() having special
semantics in kernfs. On any regular filesystem an rmdir() on a directory
which is still referenced by a struct file doesn't trigger an
f_op->release() operation. It's just that directory is unlinked and
you get some sort of errno like ENOENT when you try to create new files
in there or whatever. The actual f_op->release) however is triggered
on last fput().

But in essence, kernfs treats an rmdir() operation as being equivalent
to a final fput() such that it somehow magically kills all file
references. And that's just wrong and not supported.
