From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: vmscan: memcontrol: remove mem_cgroup_select_victim_node()
Date: Tue, 29 Oct 2019 18:15:45 -0700
Message-ID: <CALvZod6DB0h93bDoTFdY9bU8fnxjBJphpf+AWr_u5r2SBo_isA@mail.gmail.com>
References: <20191029234753.224143-1-shakeelb@google.com> <20191029175459.b3bfed9326559e69acdd2e35@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LiqlPgdWNA9PRH5nALR1HXVaery8pdVvA3tw4kzK/YM=;
        b=ijhbZvY9UqNfl0f+NlEf8kzcArGh2+O1V9Qyky+fDyrgw8qLP+bg/s3HN8MX+NgmFB
         6ctonOUgLG+wTHzSpztuBoRdS0j54g1mHoCUILtMOFrbAxGLzGLHrSkzQUTAiFxmFkFj
         3K1QzMK204kj5hxRODEPadXlLDnQh7EhcScbGDIYs+Aaoen4DZ3FUeva+HtFFAwiJwXG
         tCSu1/ACld++aea1lShqC9oBbwZRFkDo+nMkk4b+hkKrL4ZjzXEo0hAkvRq4zJPNmxd/
         QpvtC5qB+hCjmQLyhrsoHmf1a/NJM5Lvb3kUurBZu4oxL07nAopxGqf9ctSUP1Y3WxaU
         JjMw==
In-Reply-To: <20191029175459.b3bfed9326559e69acdd2e35@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

On Tue, Oct 29, 2019 at 5:55 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 29 Oct 2019 16:47:53 -0700 Shakeel Butt <shakeelb@google.com> wrote:
>
> > Since commit 1ba6fc9af35b ("mm: vmscan: do not share cgroup iteration
> > between reclaimers"), the memcg reclaim does not bail out earlier based
> > on sc->nr_reclaimed and will traverse all the nodes. All the reclaimable
> > pages of the memcg on all the nodes will be scanned relative to the
> > reclaim priority. So, there is no need to maintain state regarding which
> > node to start the memcg reclaim from. Also KCSAN complains data races in
> > the code maintaining the state.
> >
> > This patch effectively reverts the commit 889976dbcb12 ("memcg: reclaim
> > memory from nodes in round-robin order") and the commit 453a9bf347f1
> > ("memcg: fix numa scan information update to be triggered by memory
> > event").
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: <syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com>
>
> I can't find the original sysbot email.  Help?
>
> iirc the incidentally-fixed issue is a rather theoretical data race and
> the patch isn't a high priority thing?
>

Let me check why the link is not working. However you are right that
the fix is for a theoretical data race and no need to be backported to
stable trees.

Shakeel
