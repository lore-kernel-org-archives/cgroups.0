From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Skip subtree root in
 cgroup_update_dfl_csses()
Date: Thu, 28 Jul 2022 16:44:26 +0200
Message-ID: <20220728144426.GA26631@blackbody.suse.cz>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728005815.1715522-2-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659019468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpW4YToHW6w1TJ+JUui+ok8xn0F55KMcQkwdz3YZ6hI=;
        b=gr1imVX/+jT5GEcGtWZ8FbJVs2S+5goVZ3h54Klc/9rJIqVQc5zm9Io0oEppBZkpPdh/6p
        vBJUd2+893USnplUtxLe9m9SBOZYRw9hFoC11WwAfTE1LB4fL5sASnD2XsvlwN9GgP2Z6A
        0x0hKwuBnycqcXIaHuIFbuizv3oUn/I=
Content-Disposition: inline
In-Reply-To: <20220728005815.1715522-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 27, 2022 at 08:58:15PM -0400, Waiman Long <longman-H+wXaHxf7aLQ=
T0dZR+AlfA@public.gmane.org> wrote:
> The cgroup_update_dfl_csses() function updates css associations when a
> cgroup's subtree_control file is modified. Any changes made to a cgroup's
> subtree_control file, however, will only affect its descendants but not
> the cgroup itself.=20

I find this correct.

> So there is no point in migrating csses associated with that cgroup.
> We can skip them instead.

Alone it's not such a big win but it componds with the recent Tejun's
threadgroup_rwsem elision.

> ---
>  kernel/cgroup/cgroup.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Feel free to have
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
