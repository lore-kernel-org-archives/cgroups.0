From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 14:50:59 -0700
Message-ID: <CAJuCfpFKjhmti8k6OHoDHAu6dPvqP0jn8FFdSDPqmRfH97bkiQ@mail.gmail.com>
References: <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner> <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner> <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner> <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com>
 <2023062845-stabilize-boogieman-1925@gregkh> <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
 <ZJyZWtK4nihRkTME@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687989073; x=1690581073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiU1ba44MUUFQMwv4R2LW1J18iVFXpq0u3lKLnpz3Xc=;
        b=yGSq9469ZtBk1ZalIinO4oHCn6+fl9Mioak3I3ItprNlBB2i5CG8SW2uaDJYBJ82CF
         peruRSwPdWE3ulMVZphVZF6Td9mBMDF2emMRSAaDIr4OkPG0hzUxwu759Prh9CPgykAx
         XRFojr8qVtzUt0+3h9YqMTuRkgvFqqhNGoo7jyIUzTMo9Fv/tcwxK7Pf509o/7+YAM/1
         tKV74JfZJ9/F1aCnWQNLG0fLkTUQjrmSCb3EA6ygUrlLtha+2T5pHZRJYeNdWPu6mZye
         XjSaajeSL6VnNlsmoOo7Wm/driYwl+iqhGitf5wrv0LKJ3PsUo+PeXq0IYSVgg2GDAX8
         73Ww==
In-Reply-To: <ZJyZWtK4nihRkTME@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, peterz@infradead.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Wed, Jun 28, 2023 at 1:34=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Suren.
>
> On Wed, Jun 28, 2023 at 01:12:23PM -0700, Suren Baghdasaryan wrote:
> > AFAIU all other files that handle polling rely on f_op->release()
> > being called after all the users are gone, therefore they can safely
> > free their resources. However kernfs can call ->release() while there
> > are still active users of the file. I can't use that operation for
> > resource cleanup therefore I was suggesting to add a new operation
> > which would be called only after the last fput() and would guarantee
> > no users. Again, I'm not an expert in this, so there might be a better
> > way to handle it. Please advise.
>
> So, w/ kernfs, the right thing to do is making sure that whatever is expo=
sed
> to the kernfs user is terminated on removal - ie. after kernfs_ops->relea=
se
> is called, the ops table should be considered dead and there shouldn't be
> anything left to clean up from the kernfs user side. You can add abstract=
ion
> kernfs so that kernfs can terminate the calls coming down from the higher
> layers on its own. That's how every other operation is handled and what
> should happen with the psi polling too.

I'm not sure I understand. The waitqueue head we are freeing in
->release() can be accessed asynchronously and does not require any
kernfs_op call. Here is a recap of that race:

                                                do_select
                                                      vfs_poll
cgroup_pressure_release
    psi_trigger_destroy
        wake_up_pollfree(&t->event_wait) -> unblocks vfs_poll
        synchronize_rcu()
        kfree(t) -> frees waitqueue head
                                                     poll_freewait() -> UAF

Note that poll_freewait() is not part of any kernel_op, so I'm not
sure how adding an abstraction kernfs would help, but again, this is
new territory for me and I might be missing something.

On a different note, I think there might be an easy way to fix this.
What if psi triggers reuse kernfs_open_node->poll waitqueue head?
Since we are overriding the ->poll() method, that waitqueue head is
unused AFAIKT. And best of all, its lifecycle is tied to the file's
lifecycle, so it does not have the issue that trigger waitqueue head
has. In the trigger I could simply store a pointer to that waitqueue
and use it. Then in ->release() freeing trigger would not affect the
waitqueue at all. Does that sound sane?


>
> Thanks.
>
> --
> tejun
