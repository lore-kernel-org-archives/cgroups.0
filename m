From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: handle cset multiidentity issue when migration
Date: Thu, 9 Jun 2022 12:00:31 +0200
Message-ID: <20220609100031.GA11537@blackbody.suse.cz>
References: <1654187688-27411-1-git-send-email-shisiyuan@xiaomi.com>
 <20220608135110.GA19399@blackbody.suse.cz>
 <CAC=y0uc7OERw7uaCtwkhv=OktxRhEifBvk0W-G40osn7AnCgWg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654768832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HgC272Pd9ho/7vBO6onIjh94FgZzaAHnEz7I9LIsXfA=;
        b=W00ihDeCz4lidD0CWe7uib7kxBcABEnZJ7TMl+N/nj4GBzuibU5MkYyhvZhPlPNKM95hx1
        /NZh0KtdasghNU7Mv7z1SnqWbsxmKoOg5qcBsP9yH0woTmWIFq9CbFjV9bS7iCG8+eZELH
        WBoipRD1p2w3+TId+bJDZ9f4qnHfjbY=
Content-Disposition: inline
In-Reply-To: <CAC=y0uc7OERw7uaCtwkhv=OktxRhEifBvk0W-G40osn7AnCgWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?5Y+y5oCd6L+c?= <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shisiyuan <shisiyuan-95E7rUnPDLLQT0dZR+AlfA@public.gmane.org>

Hello.

On Thu, Jun 09, 2022 at 11:49:38AM +0800, 史思远 <shisiyuan19870131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The process is like above photo, thread 2 exits
> between cgroup_migrate_prepare_dst() and cgroup_migrate_execute().
> Then the refcount of csetX turns to be 0 here, and UAF appears when thread1
> migrating.
> Thread2 exits asynchronously, can rwsem prevent it?

See the bailout in cgroup_migrate_add_task():

	if (task->flags & PF_EXITING)
	        return;

And cgroup_threadgroup_change_begin(tsk) in exit_signals().

> The purpose of my patch is to keep csetX's refcount still 1 after thread2
> exits, and make sure thread1 migrating successfully.

Why is not src_cset==dst_cset in cgroup_migrate_prepare_dst() not
sufficient?

Still, can this be reproduced in real world or is your reasoning based
on theory only?

Thanks,
Michal
