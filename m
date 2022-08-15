From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Mon, 15 Aug 2022 15:23:43 +0200
Message-ID: <20220815132343.GA22640@blackbody.suse.cz>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660569825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cHBCVrYF6PCd1Kfozii15caVkPvyJaqe6SVHf6nDFnY=;
        b=HMGy9EAP6+jcOvZN5k/wtqCrne3YQi9csqDNao8rsF5YSRTmZ6Rbab2gsZeg8D97ThDzG7
        NRx6qqjBQnQbeJmU0EXssWO2uNV7EEYZgSn7oqQdR0U3BtsBS741D8Ye1k40KbKH+WIB1q
        uEg5kck5difRZBcHEtu/zIYOT0gZQuI=
Content-Disposition: inline
In-Reply-To: <YvPN07UlaPFAdlet-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Wed, Aug 10, 2022 at 11:25:07AM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> cgroup.pressure.enable sounds good to me too. Or, because it's
> default-enabled and that likely won't change, cgroup.pressure.disable.

Will it not change?

I'd say that user would be interested in particular level or even just
level in subtree for PSI, so the opt-out may result in lots of explicit
disablements (or even watch for cgroups created and disable PSI there)
to get some performance back.

I have two suggestions based on the above:
1) Make the default globally configurable (mount option?)
2) Allow implicit enablement upon trigger creation

WDYT?

Michal
