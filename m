From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 18 Oct 2013 11:57:46 +0200
Message-ID: <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
	<CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
	<5258E584.70500@huawei.com>
	<CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
	<525CB337.8050105@huawei.com>
	<CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:content-type;
        bh=V04QHxq0cZkTq0dCi5epN3zvalo2EkVsbGCZG/wn1Y4=;
        b=LpPSZgfbSvce2dlXYx8ri4mD5y7jSvHFpTIzvByPKi1+dv4qVcQ4GDTf0WDBIyfd85
         xjABIxvpTI4u1vDq4zr4PhGTGkqASRpEp7ljRoJJj6Hvm59gNdrK+V5UwjqfWmCeJN3D
         cnkvVm2EogzzbFaOWczNYiIhmVrNGGDvi6KvXLWsYF1oBEkxkmqjRnYVesdU5yUjuwii
         yEgeCqvDegapzRsarXe1IS5wGVa/t9kcSJhNc1YFZJV1XeWtZBFSoSgKD7lp4RfyK1As
         xRED1iXjUflMSzulchQ86P7PIeJHzAxSYBp2roHQ2+4outY6GKoyVhdzmzWk/3gDzvbr
         uBEg==
In-Reply-To: <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

My test-runs now reproduced the bug with tracing enabled. The mutex
holding thread is definitely the one I posted earlier, and with the
"-t" option the crash utility can also display the whole stack
backtrace. (Did only show the first 3 lines without this options,
which confused me earlier into thinking, that the worker thread was
idle). I will keep the test machine running in this state if you need
more information.

crash> bt 13115 -t
PID: 13115  TASK: ffff88082e34a050  CPU: 4   COMMAND: "kworker/4:0"
              START: __schedule at ffffffff813e0f4f
  [ffff88082f673ad8] schedule at ffffffff813e111f
  [ffff88082f673ae8] schedule_timeout at ffffffff813ddd6c
  [ffff88082f673af8] mark_held_locks at ffffffff8107bec4
  [ffff88082f673b10] _raw_spin_unlock_irq at ffffffff813e2625
  [ffff88082f673b38] trace_hardirqs_on_caller at ffffffff8107c04f
  [ffff88082f673b58] trace_hardirqs_on at ffffffff8107c078
  [ffff88082f673b80] __wait_for_common at ffffffff813e0980
  [ffff88082f673b88] schedule_timeout at ffffffff813ddd38
  [ffff88082f673ba0] default_wake_function at ffffffff8105a258
  [ffff88082f673bb8] call_rcu at ffffffff810a552b
  [ffff88082f673be8] wait_for_completion at ffffffff813e0a1c
  [ffff88082f673bf8] wait_rcu_gp at ffffffff8104c736
  [ffff88082f673c08] wakeme_after_rcu at ffffffff8104c6d1
  [ffff88082f673c60] __mutex_unlock_slowpath at ffffffff813e0217
  [ffff88082f673c88] synchronize_rcu at ffffffff810a3f50
  [ffff88082f673c98] mem_cgroup_reparent_charges at ffffffff810f6765
  [ffff88082f673d28] mem_cgroup_css_offline at ffffffff810f6b9f
  [ffff88082f673d58] offline_css at ffffffff8108b4aa
  [ffff88082f673d80] cgroup_offline_fn at ffffffff8108e112
  [ffff88082f673dc0] process_one_work at ffffffff810493b3
  [ffff88082f673dc8] process_one_work at ffffffff81049348
  [ffff88082f673e28] worker_thread at ffffffff81049d7b
  [ffff88082f673e48] worker_thread at ffffffff81049c37
  [ffff88082f673e60] kthread at ffffffff8104ef80
  [ffff88082f673f28] kthread at ffffffff8104eed4
  [ffff88082f673f50] ret_from_fork at ffffffff813e31ec
  [ffff88082f673f80] kthread at ffffffff8104eed4

On Fri, Oct 18, 2013 at 11:34 AM, Markus Blank-Burian
<burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org> wrote:
> I guess I found out, where it is hanging: While waiting for the
> test-runs to trigger the bug, I tried "echo w > /proc/sysrq-trigger"
> to show the stacks of all blocked tasks, and one of them was always
> this one:
>
> [586147.824671] kworker/3:5     D ffff8800df81e208     0 10909      2 0x00000000
> [586147.824671] Workqueue: events cgroup_offline_fn
> [586147.824671]  ffff8800fba7bbd0 0000000000000002 ffff88007afc2ee0
> ffff8800fba7bfd8
> [586147.824671]  ffff8800fba7bfd8 0000000000011c40 ffff8800df81ddc0
> 7fffffffffffffff
> [586147.824671]  ffff8800fba7bcf8 ffff8800df81ddc0 0000000000000002
> ffff8800fba7bcf0
> [586147.824671] Call Trace:
> [586147.824671]  [<ffffffff813c57e4>] schedule+0x60/0x62
> [586147.824671]  [<ffffffff813c374c>] schedule_timeout+0x34/0x11c
> [586147.824671]  [<ffffffff81053305>] ? __wake_up_common+0x51/0x7e
> [586147.824671]  [<ffffffff813c6a73>] ? _raw_spin_unlock_irqrestore+0x29/0x34
> [586147.824671]  [<ffffffff813c5097>] __wait_for_common+0x9c/0x119
> [586147.824671]  [<ffffffff813c3718>] ? svcauth_gss_legacy_init+0x176/0x176
> [586147.824671]  [<ffffffff8105790d>] ? wake_up_state+0xd/0xd
> [586147.824671]  [<ffffffff8109c237>] ? call_rcu_bh+0x18/0x18
> [586147.824671]  [<ffffffff813c5133>] wait_for_completion+0x1f/0x21
> [586147.824671]  [<ffffffff8104a8ee>] wait_rcu_gp+0x46/0x4c
> [586147.824671]  [<ffffffff8104a899>] ? __rcu_read_unlock+0x4c/0x4c
> [586147.824671]  [<ffffffff8109ad6b>] synchronize_rcu+0x29/0x2b
> [586147.824671]  [<ffffffff810ec34e>] mem_cgroup_reparent_charges+0x63/0x2fb
> [586147.824671]  [<ffffffff810ec75a>] mem_cgroup_css_offline+0xa5/0x14a
> [586147.824671]  [<ffffffff8108329e>] offline_css.part.15+0x1b/0x2e
> [586147.824671]  [<ffffffff81084f8b>] cgroup_offline_fn+0x72/0x137
> [586147.824671]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
> [586147.824671]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
> [586147.824671]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
> [586147.824671]  [<ffffffff8104cbec>] kthread+0x88/0x90
> [586147.824671]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
> [586147.824671]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
> [586147.824671]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
>
>
> On Tue, Oct 15, 2013 at 5:15 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> On 2013/10/14 16:06, Markus Blank-Burian wrote:
>>> The crash utility indicated, that the lock was held by a kworker
>>> thread, which was idle at the moment. So there might be a case, where
>>> no unlock is done. I am trying to reproduce the problem at the moment
>>> with CONFIG_PROVE_LOCKING, but without luck so far. It seems, that my
>>> test-job is quite bad at reproducing the bug. I'll let you know, if I
>>> can find out more.
>>>
>>
>> Thanks. I'll review the code to see if I can find some suspect.
>>
>> PS: I'll be travelling from 10/16 ~ 10/28, so I may not be able
>> to spend much time on this.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
