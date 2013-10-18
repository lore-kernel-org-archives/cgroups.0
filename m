From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 18 Oct 2013 11:34:15 +0200
Message-ID: <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
	<CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
	<5258E584.70500@huawei.com>
	<CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
	<525CB337.8050105@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:content-type;
        bh=dOZgkdC4HJcIYEt4vvU83Si0ti1Tp+WboUqsLCoG+os=;
        b=sw0ZDirzVA50JeOqCV1LLagMZdDtLQmUZAj+cVCdQyraZKMEnrhFMIIIqIX3m9tii4
         OXX/BZ3W8OjZAzukpfPmenfifDWPm0loFW4xKlWa0qxFi8FZjt5i/INOXZ7CvJRsN4wb
         ork9Om2dNN9G+xefOUAwQ4ZPXz3hqQwr0cIBbMWNK87OMnPtiSEA5jlG4nOUCG+WrX3v
         6QvGN46x28EaYJFb39nUseVZ/bc9HvtfoL3GtOCcybSxBiSQ/dDOr5xOeWmuNg93njoQ
         N7rKW8hkTS44D5RHshFzOUpWcjSuxkVi6L+Tt2kTSrHlEqPabFaJtcKip8Qj4t9HVL0L
         3r6A==
In-Reply-To: <525CB337.8050105-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I guess I found out, where it is hanging: While waiting for the
test-runs to trigger the bug, I tried "echo w > /proc/sysrq-trigger"
to show the stacks of all blocked tasks, and one of them was always
this one:

[586147.824671] kworker/3:5     D ffff8800df81e208     0 10909      2 0x00000000
[586147.824671] Workqueue: events cgroup_offline_fn
[586147.824671]  ffff8800fba7bbd0 0000000000000002 ffff88007afc2ee0
ffff8800fba7bfd8
[586147.824671]  ffff8800fba7bfd8 0000000000011c40 ffff8800df81ddc0
7fffffffffffffff
[586147.824671]  ffff8800fba7bcf8 ffff8800df81ddc0 0000000000000002
ffff8800fba7bcf0
[586147.824671] Call Trace:
[586147.824671]  [<ffffffff813c57e4>] schedule+0x60/0x62
[586147.824671]  [<ffffffff813c374c>] schedule_timeout+0x34/0x11c
[586147.824671]  [<ffffffff81053305>] ? __wake_up_common+0x51/0x7e
[586147.824671]  [<ffffffff813c6a73>] ? _raw_spin_unlock_irqrestore+0x29/0x34
[586147.824671]  [<ffffffff813c5097>] __wait_for_common+0x9c/0x119
[586147.824671]  [<ffffffff813c3718>] ? svcauth_gss_legacy_init+0x176/0x176
[586147.824671]  [<ffffffff8105790d>] ? wake_up_state+0xd/0xd
[586147.824671]  [<ffffffff8109c237>] ? call_rcu_bh+0x18/0x18
[586147.824671]  [<ffffffff813c5133>] wait_for_completion+0x1f/0x21
[586147.824671]  [<ffffffff8104a8ee>] wait_rcu_gp+0x46/0x4c
[586147.824671]  [<ffffffff8104a899>] ? __rcu_read_unlock+0x4c/0x4c
[586147.824671]  [<ffffffff8109ad6b>] synchronize_rcu+0x29/0x2b
[586147.824671]  [<ffffffff810ec34e>] mem_cgroup_reparent_charges+0x63/0x2fb
[586147.824671]  [<ffffffff810ec75a>] mem_cgroup_css_offline+0xa5/0x14a
[586147.824671]  [<ffffffff8108329e>] offline_css.part.15+0x1b/0x2e
[586147.824671]  [<ffffffff81084f8b>] cgroup_offline_fn+0x72/0x137
[586147.824671]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
[586147.824671]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
[586147.824671]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
[586147.824671]  [<ffffffff8104cbec>] kthread+0x88/0x90
[586147.824671]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
[586147.824671]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
[586147.824671]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60


On Tue, Oct 15, 2013 at 5:15 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2013/10/14 16:06, Markus Blank-Burian wrote:
>> The crash utility indicated, that the lock was held by a kworker
>> thread, which was idle at the moment. So there might be a case, where
>> no unlock is done. I am trying to reproduce the problem at the moment
>> with CONFIG_PROVE_LOCKING, but without luck so far. It seems, that my
>> test-job is quite bad at reproducing the bug. I'll let you know, if I
>> can find out more.
>>
>
> Thanks. I'll review the code to see if I can find some suspect.
>
> PS: I'll be travelling from 10/16 ~ 10/28, so I may not be able
> to spend much time on this.
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
