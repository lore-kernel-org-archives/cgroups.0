From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 09:28:03 -0700
Message-ID: <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
References: <CAJuCfpECKqYiekDK6Zw58w10n1T4Q3R+2nymfHX2ZGfQVDC3VQ@mail.gmail.com>
 <20230627-ausgaben-brauhaus-a33e292558d8@brauner> <ZJstlHU4Y3ZtiWJe@slm.duckdns.org>
 <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org> <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner> <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687969695; x=1690561695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vk9Ma8PHjIe8nBHU9Tz+Dpnfhv6Qv1Z0Rq6xA0WYD24=;
        b=yHNTfrxGBFOW4I1D4j3xGL3prMRwB4VqrZd+oQbzt1v9GmVnxue/rRqQs9O5tG6Rma
         tqKm8ycmdeozHiG6UOV7DHESuhV0ulqz7wdASTj3Hk8K9J7Cxuf/s7+KCcwdYnveGcz3
         KkPuGlmOPY8D9qeejwYGmoGgpzJ1DckSn+hqQFBmPAqTRsotfF/xhT/JibQazLM26ylg
         16yF0gld2Z0BqJ1ojmeS4QVTWkmd3uktowgpuPeiNbjwTKZv+Oq7r1ECR62LcP2FGK5O
         Oy1YJ7VqlxQOiwsv7ocYP8d9jFYpUFWWpx2/BRm6kH9ISoLodtLpR8eqzqHhZ5AtFYQ7
         DTpg==
In-Reply-To: <20230628-faden-qualvoll-6c33b570f54c@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Jun 28, 2023 at 1:41=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Wed, Jun 28, 2023 at 12:46:43AM -0700, Suren Baghdasaryan wrote:
> > On Wed, Jun 28, 2023 at 12:26=E2=80=AFAM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > On Tue, Jun 27, 2023 at 08:09:46PM -0700, Suren Baghdasaryan wrote:
> > > > On Tue, Jun 27, 2023 at 6:54=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> w=
rote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > On Tue, Jun 27, 2023 at 02:58:08PM -0700, Suren Baghdasaryan wrot=
e:
> > > > > > Ok in kernfs_generic_poll() we are using kernfs_open_node.poll
> > > > > > waitqueue head for polling and kernfs_open_node is freed from i=
nside
> > > > > > kernfs_unlink_open_file() which is called from kernfs_fop_relea=
se().
> > > > > > So, it is destroyed only when the last fput() is done, unlike t=
he
> > > > > > ops->release() operation which we are using for destroying PSI
> > > > > > trigger's waitqueue. So, it seems we still need an operation wh=
ich
> > > > > > would indicate that the file is truly going away.
> > > > >
> > > > > If we want to stay consistent with how kernfs behaves w.r.t. seve=
ring, the
> > > > > right thing to do would be preventing any future polling at sever=
ing and
> > > > > waking up everyone currently waiting, which sounds fine from cgro=
up behavior
> > > > > POV too.
> > > >
> > > > That's actually what we are currently doing for PSI triggers.
> > > > ->release() is handled by cgroup_pressure_release() which signals t=
he
> > > > waiters, waits for RCU grace period to pass (per
> > > > https://elixir.bootlin.com/linux/latest/source/include/linux/wait.h=
#L258)
> > > > and then releases all the trigger resources including the waitqueue
> > > > head. However as reported in
> > > > https://lore.kernel.org/all/20230613062306.101831-1-lujialin4@huawe=
i.com
> > > > this does not save us from the synchronous polling case:
> > > >
> > > >                                                   do_select
> > > >                                                       vfs_poll
> > > > cgroup_pressure_release
> > > >     psi_trigger_destroy
> > > >         wake_up_pollfree(&t->event_wait) -> unblocks vfs_poll
> > > >         synchronize_rcu()
> > > >         kfree(t) -> frees waitqueue head
> > > >                                                      poll_freewait(=
)
> > > > -> uses waitqueue head
> > > >
> > > >
> > > > This happens because we release the resources associated with the f=
ile
> > > > while there are still file users (the file's refcount is non-zero).
> > > > And that happens because kernfs can call ->release() before the las=
t
> > > > fput().
> > > >
> > > > >
> > > > > Now, the challenge is designing an interface which is difficult t=
o make
> > > > > mistake with. IOW, it'd be great if kernfs wraps poll call so tha=
t severing
> > > > > is implemented without kernfs users doing anything, or at least m=
ake it
> > > > > pretty obvious what the correct usage pattern is.
> > > > >
> > > > > > Christian's suggestion to rename current ops->release() operati=
on into
> > > > > > ops->drain() (or ops->flush() per Matthew's request) and introd=
uce a
> > > > > > "new" ops->release() which is called only when the last fput() =
is done
> > > > > > seems sane to me. Would everyone be happy with that approach?
> > > > >
> > > > > I'm not sure I'd go there. The contract is that once ->release() =
is called,
> > > > > the code backing that file can go away (e.g. rmmod'd). It really =
should
> > > > > behave just like the last put from kernfs users' POV.
> > > >
> > > > I 100% agree with the above statement.
> > > >
> > > > > For this specific fix,
> > > > > it's safe because we know the ops is always built into the kernel=
 and won't
>
> I don't know if this talks about kernfs_ops (likely) or talks about
> f_ops but fyi for f_ops this isn't a problem. See fops_get() in
> do_dentry_open() which takes a reference on the mode that provides the
> fops. And debugfs - a little more elaborately - handles this as well.
>
> > > > > go away but it'd be really bad if the interface says "this is a n=
ormal thing
> > > > > to do". We'd be calling into rmmod'd text pages in no time.
> > > > >
> > > > > So, I mean, even for temporary fix, we have to make it abundantly=
 clear that
> > > > > this is not for usual usage and can only be used if the code back=
ing the ops
> > > > > is built into the kernel and so on.
> > > >
> > > > I think the root cause of this problem is that ->release() in kernf=
s
> > > > does not adhere to the common rule that ->release() is called only
> > > > when the file is going away and has no users left. Am I wrong?
> > >
> > > So imho, ultimately this all comes down to rmdir() having special
> > > semantics in kernfs. On any regular filesystem an rmdir() on a direct=
ory
> > > which is still referenced by a struct file doesn't trigger an
> > > f_op->release() operation. It's just that directory is unlinked and
> > > you get some sort of errno like ENOENT when you try to create new fil=
es
> > > in there or whatever. The actual f_op->release) however is triggered
> > > on last fput().
> > >
> > > But in essence, kernfs treats an rmdir() operation as being equivalen=
t
> > > to a final fput() such that it somehow magically kills all file
> > > references. And that's just wrong and not supported.
> >
> > Thanks for the explanation, Christian!
> > If kernfs is special and needs different rules for calling
> > f_op->release() then fine, but I need an operation which tells me
> > there are no users of the file so that I can free the resources.
> > What's the best way to do that?
>
> Imho, if there's still someone with an fd referencing that file then
> there's still a user. That's unlink() while holding an fd in a nutshell.
>
> But generically, afaui what you seem to want is:
>
> (1) a way to shutdown functionality provided by a kernfs node on removal
>     of that node
> (2) a way to release the resources of a kernfs node
>
> So (2) is seemingly what kernfs_ops->release() is about but it's also
> used for (1). So while I initially thought about ->drain() or whatever
> it seems what you really want is for struct kernfs_ops to gain an
> unlink()/remove()/rmdir() method(s). The method can be implemented by
> interested callers and should be called when the kernfs node is removed.
>
> And that's when you can shutdown any functionality without freeing the
> resources.
>
> Imho, if you add struct gimmegimme_ops with same names as f_op you
> really to mirror them as close as possible otherwise you're asking for
> problems.

Thanks for the feedback!
To summarize my understanding of your proposal, you suggest adding new
kernfs_ops for the case you marked (1) and change ->release() to do
only (2). Please correct me if I misunderstood. Greg, Tejun, WDYT?
