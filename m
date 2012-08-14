From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] execute the whole memcg freeing in rcu callback
Date: Mon, 13 Aug 2012 21:27:27 -0700
Message-ID: <CAHH2K0bJumAy43BjP3XxfrZz6eMQFKzTY-dw26Aw17zFXehtfQ@mail.gmail.com>
References: <1344861970-9999-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:x-system-of-record;
        bh=93Akuq25k7924Mo825dgDPAmVhQhy/gZxi8TAB/YQWo=;
        b=ebPiA7pWbGvgq93xviSTebfnnqiLAuZBlTycJiCWemK5fE7La2y1N277eNr5r6JYiJ
         3b7YLNX9i32SBc9l9ltCh5MPdXIvaY6fRxRqnWqzIRLt9Fl87BenCY9oUG5QrGTGR43s
         8EPiKLQU1juFTQkZWMAPXx3bhpOTF9gBgAoac+c9mOJN1LM7e7p3W/OPmgeCSliL94Q2
         mlFmEX76WNQHc9VwBq+UoNQi6WInap42X1RxYkIwsswjS09nJRrKy0c99R1IwFFhNShm
         pIulUqBp8mn2qgkhud8UzdotNDCAVA5IJGNZrgj3KPhEAqzpIV1dQ2VLpr5g2Bm639YA
         Ibig==
In-Reply-To: <1344861970-9999-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Aug 13, 2012 at 5:46 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> A lot of the initialization we do in mem_cgroup_create() is done with
> softirqs enabled. This include grabbing a css id, which holds
> &ss->id_lock->rlock, and the per-zone trees, which holds
> rtpz->lock->rlock. All of those signal to the lockdep mechanism that
> those locks can be used in SOFTIRQ-ON-W context. This means that the
> freeing of memcg structure must happen in a compatible context,
> otherwise we'll get a deadlock.
>
> The reference counting mechanism we use allows the memcg structure to be
> freed later and outlive the actual memcg destruction from the
> filesystem. However, we have little, if any, means to guarantee in which
> context the last memcg_put will happen. The best we can do is test it
> and try to make sure no invalid context releases are happening. But as
> we add more code to memcg, the possible interactions grow in number and
> expose more ways to get context conflicts.
>
> Context-related problems already appeared for static branches
> destruction, since their locking forced us to disable them from process
> context, which we could not always guarantee. Now that we're trying to
> add kmem controller, the possibilities of where the freeing can be
> triggered from just increases.
>
> Greg Thelen reported a bug with that patchset applied that would trigger
> if a task would hold a reference to a memcg through its kmem counter.
> This would mean that killing that task would eventually get us to
> __mem_cgroup_free() after dropping the last kernel page reference, in an
> invalid IN-SOFTIRQ-W.
>
> We already moved a part of the freeing to a worker thread to be
> context-safe for the static branches disabling. Although we could move
> the new offending part to such a place as well, I see no reason not
> to do it for the whole freeing action. I consider this to be the safe
> choice.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Reported-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The problem I reported is fixed by this patch.  Thanks.

Tested-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
