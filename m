From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 13:12:23 -0700
Message-ID: <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
References: <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org> <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner> <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner> <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner> <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com> <2023062845-stabilize-boogieman-1925@gregkh>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687983158; x=1690575158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4rTWpAfDqcdZDTILe7jmFb9qWXSX04H9q/bdDWrzoY=;
        b=U4zCCdk957gzYM+H+xsRYEONc6RfAPY01RFg1AsAiC76Nlrzfibh3F8apitW44iD4n
         RUHp1ewjwkT8/07gIW2yd2o6KWfoEsdQ1RsO1okZZ6nH2Mr5kwlGrby0vWUhM9ViRN7t
         13g9BOJ5WDeL79lOybkTWaiBVxSQg1laObVGeO5NhmQS1SQYJYNB5wjLMo1HO0fK6Gz5
         WdLKojwTtKjBN5QFGmMtZvkJreuEo/Brvnxn3Upo5JUokm0wI4OKMDq++dzzSY9+JFo0
         YW0LvwHCBuHdnHsKhCeaX5n+BThhzuEZo0yXHZ3GfqDOIG/IIy3NqjntHu24BBKEIPsN
         To+A==
In-Reply-To: <2023062845-stabilize-boogieman-1925@gregkh>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Jun 28, 2023 at 11:42=E2=80=AFAM Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG8Xa4x6EXUF0@public.gmane.org=
g> wrote:
>
> On Wed, Jun 28, 2023 at 11:18:20AM -0700, Suren Baghdasaryan wrote:
> > On Wed, Jun 28, 2023 at 11:02=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> > >
> > > On Wed, Jun 28, 2023 at 07:35:20PM +0200, Christian Brauner wrote:
> > > > > To summarize my understanding of your proposal, you suggest addin=
g new
> > > > > kernfs_ops for the case you marked (1) and change ->release() to =
do
> > > > > only (2). Please correct me if I misunderstood. Greg, Tejun, WDYT=
?
> > > >
> > > > Yes. I can't claim to know all the intricate implementation details=
 of
> > > > kernfs ofc but this seems sane to me.
> > >
> > > This is going to be massively confusing for vast majority of kernfs u=
sers.
> > > The contract kernfs provides is that you can tell kernfs that you wan=
t out
> > > and then you can do so synchronously in a finite amount of time (you =
still
> > > have to wait for in-flight operations to finish but that's under your
> > > control). Adding an operation which outlives that contract as somethi=
ng
> > > usual to use is guaranteed to lead to obscure future crnashes. For a
> > > temporary fix, it's fine as long as it's marked clearly but please do=
n't
> > > make it something seemingly widely useable.
> > >
> > > We have a long history of modules causing crashes because of this. Th=
e
> > > severing semantics is not there just for fun.
> >
> > I'm sure there are reasons things are working as they do today. Sounds
> > like we can't change the ->release() logic from what it is today...
> > Then the question is how do we fix this case needing to release a
> > resource which can be released only when there are no users of the
> > file? My original suggestion was to add a kernfs_ops operation which
> > would indicate there are no more users but that seems to be confusing.
> > Are there better ways to fix this issue?
>
> Just make sure that you really only remove the file when all users are
> done with it?  Do you have control of that from the driver side?

I'm a bit confused. In my case it's not a driver, it's the cgroup
subsystem and the issue is not that we are removing the file while
there are other users. The issue is that kernfs today has no operation
which is called when the last user is gone. I need such an operation
to be able to free the resources knowing that no users are left.

>
> But, why is this kernfs file so "special" that it must have this special
> construct?  Why not do what all other files that handle polling do and
> just remove and get out of there when done?

AFAIU all other files that handle polling rely on f_op->release()
being called after all the users are gone, therefore they can safely
free their resources. However kernfs can call ->release() while there
are still active users of the file. I can't use that operation for
resource cleanup therefore I was suggesting to add a new operation
which would be called only after the last fput() and would guarantee
no users. Again, I'm not an expert in this, so there might be a better
way to handle it. Please advise.
Thanks,
Suren.

>
> thanks,
>
> greg k-h
