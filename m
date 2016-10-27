From: CAI Qian <caiqian@redhat.com>
Subject: local DoS - systemd hang or timeout with cgroup traces
Date: Thu, 27 Oct 2016 08:52:32 -0400 (EDT)
Message-ID: <1565579766.1600243.1477572752328.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <774397084.821469.1475260403929.JavaMail.zimbra@redhat.com> <20161003013737.GR19539@ZenIV.linux.org.uk> <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com> <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com> <20161004214219.GN4205@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161004214219.GN4205@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>

So this can still be reproduced in 4.9-rc2 by running trinity as a non-root
user within 30-minute on this machine on either ext4 or xfs. Below is the
trace on ext4 and the sysrq-w report.

http://people.redhat.com/qcai/tmp/dmesg-ext4-cgroup-hang

    CAI Qian

----- Original Message -----
> From: "tj" <tj@kernel.org>
> Sent: Tuesday, October 4, 2016 5:42:19 PM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> ...
> > Not sure if related, but right after this lockdep happened and trinity
> > running by a
> > non-privileged user finished inside the container. The host's systemctl
> > command just
> > hang or timeout which renders the whole system unusable.
> > 
> > # systemctl status docker
> > Failed to get properties: Connection timed out
> > 
> > # systemctl reboot (hang)
> > 
> ...
> > [ 5535.893675] INFO: lockdep is turned off.
> > [ 5535.898085] INFO: task kworker/45:4:146035 blocked for more than 120
> > seconds.
> > [ 5535.906059]       Tainted: G        W       4.8.0-rc8-fornext+ #1
> > [ 5535.912865] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> > this message.
> > [ 5535.921613] kworker/45:4    D ffff880853e9b950 14048 146035      2
> > 0x00000080
> > [ 5535.929630] Workqueue: cgroup_destroy css_killed_work_fn
> > [ 5535.935582]  ffff880853e9b950 0000000000000000 0000000000000000
> > ffff88086c6da000
> > [ 5535.943882]  ffff88086c9e2000 ffff880853e9c000 ffff880853e9baa0
> > ffff88086c9e2000
> > [ 5535.952205]  ffff880853e9ba98 0000000000000001 ffff880853e9b968
> > ffffffff817cdaaf
> > [ 5535.960522] Call Trace:
> > [ 5535.963265]  [<ffffffff817cdaaf>] schedule+0x3f/0xa0
> > [ 5535.968817]  [<ffffffff817d33fb>] schedule_timeout+0x3db/0x6f0
> > [ 5535.975346]  [<ffffffff817cf055>] ? wait_for_completion+0x45/0x130
> > [ 5535.982256]  [<ffffffff817cf0d3>] wait_for_completion+0xc3/0x130
> > [ 5535.988972]  [<ffffffff810d1fd0>] ? wake_up_q+0x80/0x80
> > [ 5535.994804]  [<ffffffff8130de64>] drop_sysctl_table+0xc4/0xe0
> > [ 5536.001227]  [<ffffffff8130de17>] drop_sysctl_table+0x77/0xe0
> > [ 5536.007648]  [<ffffffff8130decd>] unregister_sysctl_table+0x4d/0xa0
> > [ 5536.014654]  [<ffffffff8130deff>] unregister_sysctl_table+0x7f/0xa0
> > [ 5536.021657]  [<ffffffff810f57f5>]
> > unregister_sched_domain_sysctl+0x15/0x40
> > [ 5536.029344]  [<ffffffff810d7704>] partition_sched_domains+0x44/0x450
> > [ 5536.036447]  [<ffffffff817d0761>] ? __mutex_unlock_slowpath+0x111/0x1f0
> > [ 5536.043844]  [<ffffffff81167684>] rebuild_sched_domains_locked+0x64/0xb0
> > [ 5536.051336]  [<ffffffff8116789d>] update_flag+0x11d/0x210
> > [ 5536.057373]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
> > [ 5536.064186]  [<ffffffff81167acb>] ? cpuset_css_offline+0x1b/0x60
> > [ 5536.070899]  [<ffffffff810fce3d>] ? trace_hardirqs_on+0xd/0x10
> > [ 5536.077420]  [<ffffffff817cf61f>] ? mutex_lock_nested+0x2df/0x450
> > [ 5536.084234]  [<ffffffff8115a9f5>] ? css_killed_work_fn+0x25/0x220
> > [ 5536.091049]  [<ffffffff81167ae5>] cpuset_css_offline+0x35/0x60
> > [ 5536.097571]  [<ffffffff8115aa2c>] css_killed_work_fn+0x5c/0x220
> > [ 5536.104207]  [<ffffffff810bc83f>] process_one_work+0x1df/0x710
> > [ 5536.110736]  [<ffffffff810bc7c0>] ? process_one_work+0x160/0x710
> > [ 5536.117461]  [<ffffffff810bce9b>] worker_thread+0x12b/0x4a0
> > [ 5536.123697]  [<ffffffff810bcd70>] ? process_one_work+0x710/0x710
> > [ 5536.130426]  [<ffffffff810c3f7e>] kthread+0xfe/0x120
> > [ 5536.135991]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
> > [ 5536.142041]  [<ffffffff810c3e80>] ? kthread_create_on_node+0x230/0x230
> 
> This one seems to be the offender.  cgroup is trying to offline a
> cpuset css, which takes place under cgroup_mutex.  The offlining ends
> up trying to drain active usages of a sysctl table which apprently is
> not happening.  Did something hang or crash while trying to generate
> sysctl content?

