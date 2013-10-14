From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 14 Oct 2013 10:06:13 +0200
Message-ID: <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
	<CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
	<5258E584.70500@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:content-type;
        bh=HNg7SxJGkcrVVIgn1HjwDY7rJBuSHGj07FazxNEQC7A=;
        b=RSS9II3Aquk5SND0c5njOwspH1ZM5u9tEkmVG9Yt/L/YGNQb2f6lmLKD6u4482UuRV
         ZakY3/UqEBKsKOSqgHM1RfMoIIAaKwZfvqMG+SBeutKTO7ZP9JloX0Gs0TvY/2Zm0pUV
         Lbipyg5ohTS8JF9kInNtm8a54QmqhJblV8WfCdlmGIJkh0AR0NP2N/EBxF/wbD5xs+bq
         yR0fzBLKEx0BJAgQDp7AynZYUT54kCjdrNrkJ2dPJSqdK1/VcR8UTOuu8Gz5LpQmTxaP
         imGGoKYmCfPQChuaicnQB6l8wev9dAgTAE9tW2SyVezYvMjG7kmeLMxdJxYINcRNCA2z
         pvNw==
In-Reply-To: <5258E584.70500-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The crash utility indicated, that the lock was held by a kworker
thread, which was idle at the moment. So there might be a case, where
no unlock is done. I am trying to reproduce the problem at the moment
with CONFIG_PROVE_LOCKING, but without luck so far. It seems, that my
test-job is quite bad at reproducing the bug. I'll let you know, if I
can find out more.


On Sat, Oct 12, 2013 at 8:00 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2013/10/12 0:05, Markus Blank-Burian wrote:
>> I rechecked the logs and found no information about who may be holding
>> the lock. I have only identified more different stack traces, waiting
>> for locks. These are for instance:
>>
> ...
>>
>> But i suppose, the lock is lost elsewhere. Are there any kernel
>> options i could activate for more debug output or some tools to find
>> out, who is holding the lock (or who forgot to unlock).
>>
>
> You may enable CONFIG_PROVE_LOCKING, and do this when deadlock happens:
>
> # echo d > /proc/sysrq-trigger
> # dmesg
> ...
> [ 3463.022386] 2 locks held by bash/10414:
> [ 3463.022388]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff813691d8>] __handle_sysrq+0x28/0x190
> [ 3463.022399]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff810b6d05>] debug_show_all_locks+0x45/0x280
>
> Or you don't have to enable PROVE_LOCKING, but use crash when the
> bug is triggered:
>
> # crash <your vmlinux> /proc/kcore
> crash> struct mutex cgroup_mutex
> struct mutex {
> ...
>   owner = 0xffff880619e04dc0,      <--- this is the thread holding the lock
> ...
> }
> crash> struct task_struct 0xffff880619e04dc0
> struct task_struct {
> ...
>   pid = 22201,
> ...
>   comm = "bash\000proc\000\000\000\000\000\000",
> ...
> }
> crash> bt 22201
> PID: 22201  TASK: ffff880619e04dc0  CPU: 0   COMMAND: "bash"
>  #0 [ffff880616d5fbe8] __schedule at ffffffff815602db
>  #1 [ffff880616d5fd30] schedule at ffffffff81560839
>  #2 [ffff880616d5fd40] schedule_timeout at ffffffff8155cb42
>  #3 [ffff880616d5fe00] schedule_timeout_uninterruptible at ffffffff8155cc5e
>  #4 [ffff880616d5fe10] msleep at ffffffff81069cc5
>  #5 [ffff880616d5fe20] cgroup_release_agent_write at ffffffff810f0f2d
>  #6 [ffff880616d5fe40] cgroup_write_string at ffffffff810f2e32
>  #7 [ffff880616d5fed0] cgroup_file_write at ffffffff810f2f60
>  #8 [ffff880616d5fef0] vfs_write at ffffffff811dfb6f
>  #9 [ffff880616d5ff20] sys_write at ffffffff811e0515
> #10 [ffff880616d5ff80] system_call_fastpath at ffffffff8156cfc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
