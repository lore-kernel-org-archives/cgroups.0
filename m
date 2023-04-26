From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup/cpuset: Iterate only if DEADLINE tasks are
 present
Date: Wed, 26 Apr 2023 13:58:55 +0200
Message-ID: <ZEkR/z2bj/LKmzmP@localhost.localdomain>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-7-juri.lelli@redhat.com>
 <20230404200611.smho7hd4sc2qwrgf@airbuntu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682510341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Ai5lSfKqZn05lKJiIckUsbQ62jwMUlauJMlWabJYbM=;
        b=AIQZJyyRkmITgeCpvcovYnqiSu5KY6qH3NMQZGLJJbBSs6E4OuMjTjxMZ+Ok89o7a7l+02
        rAdvSmd7/hHnKyJx2VqovA5LHQvhr9w1WYhnGT12/X9LDwScwqQfJgU/6dPCuQ6mUnUHP7
        j3xWveedecuZ57XW3+InVxjnlkhUs9o=
Content-Disposition: inline
In-Reply-To: <20230404200611.smho7hd4sc2qwrgf@airbuntu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AyHOaXKfS9Lw@public.gmane.org>

On 04/04/23 21:06, Qais Yousef wrote:
> On 03/29/23 14:55, Juri Lelli wrote:
> > update_tasks_root_domain currently iterates over all tasks even if no
> > DEADLINE task is present on the cpuset/root domain for which bandwidth
> > accounting is being rebuilt. This has been reported to introduce 10+ ms
> > delays on suspend-resume operations.
> > 
> > Skip the costly iteration for cpusets that don't contain DEADLINE tasks.
> > 
> > Reported-by: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
> > Link: https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org/
> > Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> Wouldn't this be better placed as patch 4? The two fixes from Dietmar look
> orthogonal to me to the accounting problem. But it seems the whole lot needs to
> go to stable anyway, so good to keep them together. Should Dietmar fixes be at
> the end instead of this?

That should be an easy fixing indeed. Dietmar is working on refreshig
his bits.

Thanks for your reviews and tests Qais!

Best,
Juri

