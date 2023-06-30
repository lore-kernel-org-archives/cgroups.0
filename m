From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Thu, 29 Jun 2023 17:59:07 -0700
Message-ID: <CAJuCfpH3JcwADEYPBhzUcunj0dcgYNRo+0sODocdhbuXQsbsUQ@mail.gmail.com>
References: <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner> <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner> <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner> <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com>
 <2023062845-stabilize-boogieman-1925@gregkh> <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
 <ZJyZWtK4nihRkTME@slm.duckdns.org> <CAJuCfpFKjhmti8k6OHoDHAu6dPvqP0jn8FFdSDPqmRfH97bkiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688086759; x=1690678759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fMmXmW0bN/OZjvRrmhsMCE2AbjOlvmuvYsM+l0kwu0=;
        b=5Yi2t8UJnMuttj4mjP+RoihhUwYozeForLZddQeb2UGwZ4aZLqwDAnBkQ2O5n2B0Zv
         61TlwP3Z99zgdWvNHZyETBcOeT3SyQ6kCVyYsQbM00SL9PlT3Q2S5o+662/8pAw6idgc
         pWHhWwpTqsq8yIFzvMFy2UGDaFtfMn5QkoirnFaZNY6y/qm2vEHHadkn87oEW7p/MPlb
         6YmCwGN6A3n7BFHzxQQBbfm4olW/PoxEvACOAoRsizcycVGGKB6B1iDCla//58lwQf6z
         2+r6N6E1D8AVAuDMne+dEPeEnp26bFTvdgLcs4zKTS7hwRGkHzSEfrzwrBMzZoryhxPi
         X3KA==
In-Reply-To: <CAJuCfpFKjhmti8k6OHoDHAu6dPvqP0jn8FFdSDPqmRfH97bkiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Jun 28, 2023 at 2:50=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Jun 28, 2023 at 1:34=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Hello, Suren.
> >
> > On Wed, Jun 28, 2023 at 01:12:23PM -0700, Suren Baghdasaryan wrote:
> > > AFAIU all other files that handle polling rely on f_op->release()
> > > being called after all the users are gone, therefore they can safely
> > > free their resources. However kernfs can call ->release() while there
> > > are still active users of the file. I can't use that operation for
> > > resource cleanup therefore I was suggesting to add a new operation
> > > which would be called only after the last fput() and would guarantee
> > > no users. Again, I'm not an expert in this, so there might be a bette=
r
> > > way to handle it. Please advise.
> >
> > So, w/ kernfs, the right thing to do is making sure that whatever is ex=
posed
> > to the kernfs user is terminated on removal - ie. after kernfs_ops->rel=
ease
> > is called, the ops table should be considered dead and there shouldn't =
be
> > anything left to clean up from the kernfs user side. You can add abstra=
ction
> > kernfs so that kernfs can terminate the calls coming down from the high=
er
> > layers on its own. That's how every other operation is handled and what
> > should happen with the psi polling too.
>
> I'm not sure I understand. The waitqueue head we are freeing in
> ->release() can be accessed asynchronously and does not require any
> kernfs_op call. Here is a recap of that race:
>
>                                                 do_select
>                                                       vfs_poll
> cgroup_pressure_release
>     psi_trigger_destroy
>         wake_up_pollfree(&t->event_wait) -> unblocks vfs_poll
>         synchronize_rcu()
>         kfree(t) -> frees waitqueue head
>                                                      poll_freewait() -> U=
AF
>
> Note that poll_freewait() is not part of any kernel_op, so I'm not
> sure how adding an abstraction kernfs would help, but again, this is
> new territory for me and I might be missing something.
>
> On a different note, I think there might be an easy way to fix this.
> What if psi triggers reuse kernfs_open_node->poll waitqueue head?
> Since we are overriding the ->poll() method, that waitqueue head is
> unused AFAIKT. And best of all, its lifecycle is tied to the file's
> lifecycle, so it does not have the issue that trigger waitqueue head
> has. In the trigger I could simply store a pointer to that waitqueue
> and use it. Then in ->release() freeing trigger would not affect the
> waitqueue at all. Does that sound sane?

I think this approach is much cleaner and I'm guessing that's in line
with what Tejun was describing (maybe it's exactly what he was telling
me but it took time for me to get it). Posted the patch implementing
this approach here:
https://lore.kernel.org/all/20230630005612.1014540-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

>
>
> >
> > Thanks.
> >
> > --
> > tejun
