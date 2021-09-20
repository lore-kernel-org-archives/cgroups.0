From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: KCSAN: data-race in cgroup_rstat_flush_locked /
 cgroup_rstat_updated
Date: Mon, 20 Sep 2021 20:09:56 +0200
Message-ID: <20210920180956.GA15043@blackbody.suse.cz>
References: <CACkBjsbPVdkub=e-E-p1WBOLxS515ith-53SFdmFHWV_QMo40w@mail.gmail.com>
 <20210917164123.GA13346@blackbody.suse.cz>
 <CACkBjsZnp8Kf26tR3anbcLQNiMJ9=bqYMJ66tKBvXO6tkV3qyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632161398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yj+rn7X7blaGJxKz6YARrP61pm4Y5j/vfBu3FSYFlDA=;
        b=qlehDK0CFFKnSnsii0H5002strjfvg/tJ9yr9Tlkpkwdvxv9Np/26+7aQvfmjvZ/f9kgOX
        DplAYbk5REraP/V+Ok0WeqY/SG46eO8MnmcRCksvswS4NoPhRzQ0bLuC6WvsEgRoT8RfSe
        wtlBzJtUDVCcAZBBkbpzKVbVXDL4wMo=
Content-Disposition: inline
In-Reply-To: <CACkBjsZnp8Kf26tR3anbcLQNiMJ9=bqYMJ66tKBvXO6tkV3qyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Sat, Sep 18, 2021 at 09:27:08AM +0800, Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Would it be better to add a `data_race` macro to the corresponding
> location so that the false report can be disabled?

Something like this

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -35,7 +35,7 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
         * instead of NULL, we can tell whether @cgrp is on the list by
         * testing the next pointer for NULL.
         */
-       if (cgroup_rstat_cpu(cgrp, cpu)->updated_next)
+       if (data_race(cgroup_rstat_cpu(cgrp, cpu)->updated_next))
                return;

        raw_spin_lock_irqsave(cpu_lock, flags);
?

Makes sense to me. Will you send a patch (if this resolves your KCSAN
noise)?

(IIUC, this becase more visible after commit aa48e47e3906 ("memcg:
infrastructure to flush memcg stats") v5.15-rc1 but it was present since
d8ef4b38cb69 ("Revert "cgroup: Add memory barriers to plug
cgroup_rstat_updated() race window"") v5.7.)

> See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt#n58
> for more details.

(Interesting, learning...)

Thanks,
Michal
