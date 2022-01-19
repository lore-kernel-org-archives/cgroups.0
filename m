From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Question] set_cpus_allowed_ptr() call failed at cpuset_attach()
Date: Wed, 19 Jan 2022 14:02:22 +0100
Message-ID: <20220119130221.GA31037@blackbody.suse.cz>
References: <09ce5796-798e-83d0-f1a6-ba38a787bfc5@huawei.com>
 <4415cd09-6de3-bb2d-386d-8beb4927fb46@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642597343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RkiBdzpfXdOX7MXZnhxrmQteAOQNnX9ERhFe1qzjPU0=;
        b=lT7JXlp02MR/i1jZ/yNF3al5FTGadcBqD8X3i/eOVe6bqBYGMKowI3ZTW0wO8Vu4ifeqVB
        Xl+mDX1mPTcK98Eax6zG9jhbmxDlYLTGa6NRYXB/qLPkx7j3GLA7YoET3Dke19bp95HpUY
        Xgv+befEEnMmIw52lDoAhd0gD3wOCfQ=
Content-Disposition: inline
In-Reply-To: <4415cd09-6de3-bb2d-386d-8beb4927fb46-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 14, 2022 at 09:15:06AM +0800, Zhang Qiao <zhangqiao22-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
> 	I found the following warning log on qemu. I migrated a task from one cp=
uset cgroup to
> another, while I also performed the cpu hotplug operation, and got follow=
ing calltrace.

Do you have more information on what hotplug event and what error
(from set_cpus_allowed_ptr() you observe? (And what's src/dst cpuset wrt
root/non-root)?

> 	Can we use cpus_read_lock()/cpus_read_unlock() to guarantee that set_cpu=
s_allowed_ptr()
> doesn't fail, as follows:

I'm wondering what can be wrong with the current actors:

    cpuset_can_attach
      down_read(cpuset_rwsem)
        // check all migratees
      up_read(cpuset_rwsem)
                                      [ _cpu_down / cpuhp_setup_state ]
                                      schedule_work
                                      ...
                                      cpuset_hotplug_update_tasks
                                        down_write(cpuset_rwsem)
                                        up_write(cpuset_rwsem)
                                      ... flush_work
                                      [ _cpu_down / cpu_up_down_serialize_t=
rainwrecks ]
    cpuset_attach
      down_write(cpuset_rwsem)
        set_cpus_allowed_ptr(allowed_cpus_weird)
      up_write(cpuset_rwsem)

The statement in cpuset_attach() about cpuset_can_attach() test is not
so strong since task_can_attach() is mostly a pass for non-deadline
tasks. Still, the use of cpuset_rwsem above should synchronize (I may be
mistaken) the changes of cpuset's cpu masks, so I'd be interested about
the details above to understand why the current approach doesn't work.

The additional cpus_read_{,un}lock (when reordered wrt cpuset_rwsem)
may work but your patch should explain why (in what situation).

My .02=E2=82=AC,
Michal
