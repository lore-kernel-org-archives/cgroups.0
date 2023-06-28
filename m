From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Tue, 27 Jun 2023 20:09:46 -0700
Message-ID: <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
References: <20230626201713.1204982-1-surenb@google.com> <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
 <20230627-kanon-hievt-bfdb583ddaa6@brauner> <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner> <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com> <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687921798; x=1690513798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vagTGpTUaZlXydrigYBV1OCPnqllXVBPgX2++V6MWg4=;
        b=rCbJWy+WBhexAYaZLgCj2xNvXbG6ankNokcPs7WfRtizxvxmlQCUydEN2BRWtw6CAy
         E1MZltbxf1Hw34ZUjhZFgDXHsziHluQnJC0OVWvKwye6zbGatQJaDsAwqn9E5zsn+cHg
         SwbiS4iv6tv1+rbm6/8TGzQOeHm9wBMsu988u/UO+Ox8zwfg7dTa0BMgkXNGF7+Pys65
         qJA1LCbWbMFthy5uOg4iIYoTL31RL4VxwfXEQVerGDY/Q+P2TfDooDgl8XsQE2JI9ZVX
         C6XWcRIbPFgSQG5AfleMe4ztE2JcfaeBe4S3lr6TB8uCVl5TgFJF8MB5D7PZUAk+N7Mg
         l7cg==
In-Reply-To: <ZJuSzlHfbLj3OjvM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Tue, Jun 27, 2023 at 6:54=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Tue, Jun 27, 2023 at 02:58:08PM -0700, Suren Baghdasaryan wrote:
> > Ok in kernfs_generic_poll() we are using kernfs_open_node.poll
> > waitqueue head for polling and kernfs_open_node is freed from inside
> > kernfs_unlink_open_file() which is called from kernfs_fop_release().
> > So, it is destroyed only when the last fput() is done, unlike the
> > ops->release() operation which we are using for destroying PSI
> > trigger's waitqueue. So, it seems we still need an operation which
> > would indicate that the file is truly going away.
>
> If we want to stay consistent with how kernfs behaves w.r.t. severing, th=
e
> right thing to do would be preventing any future polling at severing and
> waking up everyone currently waiting, which sounds fine from cgroup behav=
ior
> POV too.

That's actually what we are currently doing for PSI triggers.
->release() is handled by cgroup_pressure_release() which signals the
waiters, waits for RCU grace period to pass (per
https://elixir.bootlin.com/linux/latest/source/include/linux/wait.h#L258)
and then releases all the trigger resources including the waitqueue
head. However as reported in
https://lore.kernel.org/all/20230613062306.101831-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
this does not save us from the synchronous polling case:

                                                  do_select
                                                      vfs_poll
cgroup_pressure_release
    psi_trigger_destroy
        wake_up_pollfree(&t->event_wait) -> unblocks vfs_poll
        synchronize_rcu()
        kfree(t) -> frees waitqueue head
                                                     poll_freewait()
-> uses waitqueue head


This happens because we release the resources associated with the file
while there are still file users (the file's refcount is non-zero).
And that happens because kernfs can call ->release() before the last
fput().

>
> Now, the challenge is designing an interface which is difficult to make
> mistake with. IOW, it'd be great if kernfs wraps poll call so that severi=
ng
> is implemented without kernfs users doing anything, or at least make it
> pretty obvious what the correct usage pattern is.
>
> > Christian's suggestion to rename current ops->release() operation into
> > ops->drain() (or ops->flush() per Matthew's request) and introduce a
> > "new" ops->release() which is called only when the last fput() is done
> > seems sane to me. Would everyone be happy with that approach?
>
> I'm not sure I'd go there. The contract is that once ->release() is calle=
d,
> the code backing that file can go away (e.g. rmmod'd). It really should
> behave just like the last put from kernfs users' POV.

I 100% agree with the above statement.

> For this specific fix,
> it's safe because we know the ops is always built into the kernel and won=
't
> go away but it'd be really bad if the interface says "this is a normal th=
ing
> to do". We'd be calling into rmmod'd text pages in no time.
>
> So, I mean, even for temporary fix, we have to make it abundantly clear t=
hat
> this is not for usual usage and can only be used if the code backing the =
ops
> is built into the kernel and so on.

I think the root cause of this problem is that ->release() in kernfs
does not adhere to the common rule that ->release() is called only
when the file is going away and has no users left. Am I wrong?
Thanks,
Suren.

>
> Thanks.
>
> --
> tejun
