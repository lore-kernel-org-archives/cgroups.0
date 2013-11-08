From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 8 Nov 2013 11:20:53 +0100
Message-ID: <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
References: <5270BFE7.4000602@huawei.com>
	<alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
	<20131031130647.0ff6f2c7@gandalf.local.home>
	<alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
	<20131031192732.2dbb14b3@gandalf.local.home>
	<CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
	<5277932C.40400@huawei.com>
	<CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
	<5278B3F1.9040502@huawei.com>
	<20131107235301.GB1092@cmpxchg.org>
	<20131108001437.GC1092@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=Z7hhyjH4DAArlGUaZF+nnvbtq2/HnFTmMxXAh6KWzdA=;
        b=BhOlnuKXSJnaQOCRzLxbwU9roVdCRVUQBpLvraeIPVdcs3le/18CP5TnXbzNEGEOm5
         /fIj9uB7k5XOLZm6NipYx9eoyyk7QvUAX2w8cTn33qW01mfVpWzlVx6f9Mx4F65VhH94
         5yUkvxn1VuLBSnecmXIHp8Z6QltlnXwNOT+qrtiTyuOewBDibm4dBkz9nAddzgH2Nsxg
         jXuBHXpTSDfFTprJJTFl0UhMSQZkYSN5wILoeMgPtfe60Nrc6NYzL6Y0UN1GvyBrfmEp
         /2NGDf2kqXKsDpgogZljjD+sbes/frRaK1518CcDbzAcKhdwCmLhFkq5TrnN4uWE0DNU
         zLoA==
In-Reply-To: <20131108001437.GC1092-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for the patch Johannes!

I tried tried it immediately, but it still hangs. But this time the
worker threads have a slightly different call stack. Most of them are
now waiting in css_killed_work_fn:

  [ffff880c31a33e18] mutex_lock at ffffffff813c1bb4
  [ffff880c31a33e30] css_killed_work_fn at ffffffff81080eba
  [ffff880c31a33e50] process_one_work at ffffffff8103f7db
  [ffff880c31a33e90] worker_thread at ffffffff8103fc7d
  [ffff880c31a33eb0] worker_thread at ffffffff8103fb39
  [ffff880c31a33ec8] kthread at ffffffff8104479c
  [ffff880c31a33f28] kthread at ffffffff81044714
  [ffff880c31a33f50] ret_from_fork at ffffffff813c503c
  [ffff880c31a33f80] kthread at ffffffff81044714

The other few workers hang at the beginning of proc_cgroupstats_show
and one in cgroup_rmdir:

  [ffff8800b7825e40] mutex_lock at ffffffff813c1bb4
  [ffff8800b7825e58] proc_cgroupstats_show at ffffffff8107f5f0
  [ffff8800b7825e78] seq_read at ffffffff81107953
  [ffff8800b7825ee0] proc_reg_read at ffffffff81135f73
  [ffff8800b7825f18] vfs_read at ffffffff810ed3ea
  [ffff8800b7825f48] sys_read at ffffffff810edad6
  [ffff8800b7825f80] tracesys at ffffffff813c52db

  [ffff880c308e1e40] mutex_lock at ffffffff813c1bb4
  [ffff880c308e1e58] cgroup_rmdir at ffffffff81081d25
  [ffff880c308e1e78] vfs_rmdir at ffffffff810f8bed
  [ffff880c308e1ea0] do_rmdir at ffffffff810f8d02
  [ffff880c308e1f18] user_exit at ffffffff8100aed1
  [ffff880c308e1f28] syscall_trace_enter at ffffffff8100c356
  [ffff880c308e1f70] sys_rmdir at ffffffff810f9a95
  [ffff880c308e1f80] tracesys at ffffffff813c52db

The looping thread is still this one:

  [ffff880c30049d50] mem_cgroup_reparent_charges at ffffffff810e637b
  [ffff880c30049de0] mem_cgroup_css_offline at ffffffff810e679d
  [ffff880c30049e10] offline_css at ffffffff8107f02f
  [ffff880c30049e30] css_killed_work_fn at ffffffff81080ec2
  [ffff880c30049e50] process_one_work at ffffffff8103f7db
  [ffff880c30049e90] worker_thread at ffffffff8103fc7d
  [ffff880c30049eb0] worker_thread at ffffffff8103fb39
  [ffff880c30049ec8] kthread at ffffffff8104479c
  [ffff880c30049f28] kthread at ffffffff81044714
  [ffff880c30049f50] ret_from_fork at ffffffff813c503c
  [ffff880c30049f80] kthread at ffffffff81044714
