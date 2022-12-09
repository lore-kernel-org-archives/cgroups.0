From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: protect the memory in cgroup from
 being oom killed
Date: Fri, 9 Dec 2022 09:25:37 +0100
Message-ID: <Y5LxAbOB2AYp42hi@dhcp22.suse.cz>
References: <Y5HzfLB7lu4+BOu1@dhcp22.suse.cz>
 <114DF8F0-3E68-4F2B-8E35-0943EC2F51AE@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670574338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yg8Dy91nslxvuXyFZO8v15npgrF13z71XGIrk7x/zmg=;
        b=Gnl1efSl8C1V561RAp72h3ej4lDX6Hv8yQ8w86HPJq65Ge6RaZnEvRYmYPoSJ9jiiv1NGv
        Fx9fSt/Cl1opw8apuCmh5dW02+cRgRM0sOsgUb5228e0NfEAvX3nWN0tgPL+Ob+UcDzKtb
        TWx/69xXPo0xOpP4HauT3GvHY0m9jyM=
Content-Disposition: inline
In-Reply-To: <114DF8F0-3E68-4F2B-8E35-0943EC2F51AE-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 09-12-22 05:07:15, 程垲涛 Chengkaitao Cheng wrote:
> At 2022-12-08 22:23:56, "Michal Hocko" <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
[...]
> >oom killer is a memory reclaim of the last resort. So yes, there is some
> >difference but fundamentally it is about releasing some memory. And long
> >term we have learned that the more clever it tries to be the more likely
> >corner cases can happen. It is simply impossible to know the best
> >candidate so this is a just a best effort. We try to aim for
> >predictability at least.
> 
> Is the current oom_score strategy predictable? I don't think so. The score_adj 
> has broken the predictability of oom_score (it is no longer simply killing the 
> process that uses the most mems).

oom_score as reported to the userspace already considers oom_score_adj
which means that you can compare processes and get a reasonable guess
what would be the current oom_victim. There is a certain fuzz level
because this is not atomic and also there is no clear candidate when
multiple processes have equal score. So yes, it is not 100% predictable.
memory.reclaim as you propose doesn't change that though.

Is oom_score_adj a good interface? No, not really. If I could go back in
time I would nack it but here we are. We have an interface that
promises quite much but essentially it only allows two usecases
(OOM_SCORE_ADJ_MIN, OOM_SCORE_ADJ_MAX) reliably. Everything in between
is clumsy at best because a real user space oom policy would require to
re-evaluate the whole oom domain (be it global or memcg oom) as the
memory consumption evolves over time. I am really worried that your
memory.oom.protection directs a very similar trajectory because
protection really needs to consider other memcgs to balance properly.

[...]

> > But I am really open
> >to be convinced otherwise and this is in fact what I have been asking
> >for since the beginning. I would love to see some examples on the
> >reasonable configuration for a practical usecase.
> 
> Here is a simple example. In a docker container, users can divide all processes 
> into two categories (important and normal), and put them in different cgroups. 
> One cgroup's oom.protect is set to "max", the other is set to "0". In this way, 
> important processes in the container can be protected.

That is effectivelly oom_score_adj = OOM_SCORE_ADJ_MIN - 1 to all
processes in the important group. I would argue you can achieve a very
similar result by the process launcher to set the oom_score_adj and
inherit it to all processes in that important container. You do not need
any memcg tunable for that. I am really much more interested in examples
when the protection is to be fine tuned.
-- 
Michal Hocko
SUSE Labs
