From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 09:43:43 -0800
Message-ID: <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
References: <20220111232309.1786347-1-surenb@google.com> <Yd7oPlxCpnzNmFzc@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eP5J8KdvwPTzx2Kh8QKLifNfox7/NjpkOpmG9av6VCk=;
        b=KOnNi/erjJKDmXshSZZv7C3gKcJm3IwJxMouUmE8kJwjg35FNi2J3VpRJJE/XQaq+f
         ouYLgnZDFAaNV/dqxDZDk6O3Fv6kndvxJTf9AH6O4akiYKs9CyjyX3pWSP26jU17VEXI
         6ErUlQZ3+TUb2xsmk1ccCDw9ox3MzN4DbY+Gik5rJVQOkCfjDDk7H1g7Yf66gTgdMZ0B
         xX7ItBjgp1QlQISrAdgTibHYblom3PdgqvpX8tr+VOTUf+X4TBASg+486PvrMw4KlZD7
         CYY5L51LKMZK8LUaHHFZsldW3arkrea20wfWQ0cJ5wMJObXD8DPKu+feJ+i17rNp84mq
         Jraw==
In-Reply-To: <Yd7oPlxCpnzNmFzc@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, kernel-team <kernel-team@android.com>, syzbot

)

On Wed, Jan 12, 2022 at 6:40 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Tue, Jan 11, 2022 at 03:23:09PM -0800, Suren Baghdasaryan wrote:
> > With write operation on psi files replacing old trigger with a new one,
> > the lifetime of its waitqueue is totally arbitrary. Overwriting an
> > existing trigger causes its waitqueue to be freed and pending poll()
> > will stumble on trigger->event_wait which was destroyed.
> > Fix this by disallowing to redefine an existing psi trigger. If a write
> > operation is used on a file descriptor with an already existing psi
> > trigger, the operation will fail with EBUSY error.
> > Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> > flag can be flipped after the trigger is created, leading to a memory
> > leak.
> >
> > Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> > Cc: stable@vger.kernel.org
> > Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> > Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Hmm. kernel test robot notified me of new (which are not really new)
warnings but I don't think this patch specifically introduced them:

kernel/sched/psi.c:1112:21: warning: no previous prototype for
function 'psi_trigger_create' [-Wmissing-prototypes]
   struct psi_trigger *psi_trigger_create(struct psi_group *group,
                       ^
   kernel/sched/psi.c:1112:1: note: declare 'static' if the function
is not intended to be used outside of this translation unit
   struct psi_trigger *psi_trigger_create(struct psi_group *group,
   ^
   static
>> kernel/sched/psi.c:1182:6: warning: no previous prototype for function 'psi_trigger_destroy' [-Wmissing-prototypes]
   void psi_trigger_destroy(struct psi_trigger *t)
        ^
   kernel/sched/psi.c:1182:1: note: declare 'static' if the function
is not intended to be used outside of this translation unit
   void psi_trigger_destroy(struct psi_trigger *t)
   ^
   static
   kernel/sched/psi.c:1249:10: warning: no previous prototype for
function 'psi_trigger_poll' [-Wmissing-prototypes]
   __poll_t psi_trigger_poll(void **trigger_ptr,
            ^
   kernel/sched/psi.c:1249:1: note: declare 'static' if the function
is not intended to be used outside of this translation unit
   __poll_t psi_trigger_poll(void **trigger_ptr,
   ^

This happens with the following config:

CONFIG_CGROUPS=n
CONFIG_PSI=y

With cgroups disabled these functions are defined as non-static but
are not defined in the header
(https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
since the only external user cgroup.c is disabled. The cleanest way to
fix these I think is by doing smth like this in psi.c:

struct psi_trigger *_psi_trigger_create(struct psi_group *group, char
*buf, size_t nbytes, enum psi_res res)
{
  // original psi_trigger_create code
}

#ifdef CONFIG_CGROUPS

struct psi_trigger *psi_trigger_create(struct psi_group *group, char
*buf, size_t nbytes, enum psi_res res)
{
    return _psi_trigger_create(group, buf, nbytes, res);
}

#else

static struct psi_trigger *psi_trigger_create(struct psi_group *group,
char *buf, size_t nbytes, enum psi_res res)
{
    return _psi_trigger_create(group, buf, nbytes, res);
}

#endif

Two questions:
1. Is this even worth fixing?
2. If so, I would like to do that as a separate patch (these warnings
are unrelated to the changes in this patch). Would that be ok?
Thanks,
Suren.
