From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: Security/cgroup suspicious RCU usage with v4.2-2744-g65a99597f044
Date: Tue, 1 Sep 2015 12:59:05 -0400
Message-ID: <CA+5PVA5YbwRy_5X-9rJidpCeyPefH67aBdjngL_HS2j1q9jM2w@mail.gmail.com>
References: <CA+5PVA7aWSiVD3UtpxWJ-PL0HZ2ufjPz_ZKC21ZHai_h6jYajA@mail.gmail.com>
	<CAHC9VhRYJcj7_frkdD+tyP7e=eUox8LfAJbdDSvXya3xbd6yWw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=TNqD6nLcyNW+Lbc0mw0s14+dvfr0RML8oELqi0bv0/k=;
        b=EZaEnlg0XnmCK80a8hk7HzJ2S1V5uuaWyNY2QyoPaMgVLh7nEVEy3mKFR44W2mJEGU
         maqIF2LkwvMoaSVPb7TS1s5ksVpefFgLF7A9Hj8JGgFw8OvebeXNj6Inn7nQleVsNG/5
         N1CgVrM8Q6h1Z3ur4c4O6w9nQvZeBj4ExOxLbkj4ep1YHt+JmSLLbQQz/A5GoPzY19Wl
         HZ8HN96P+eV0WKMQW4pqSE6QsZNG0SrfE/F1tEufFFsfyL5oo6Oyn0bnjLX5sqS+17Am
         JdbuxoeVJakwzwkG02uELqi3bjmgmDHMCtnft2AFIvtmGAVNXPtA8DDsmu8c58V1rTlX
         C0YQ==
In-Reply-To: <CAHC9VhRYJcj7_frkdD+tyP7e=eUox8LfAJbdDSvXya3xbd6yWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 1, 2015 at 12:37 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Tue, Sep 1, 2015 at 12:21 PM, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org> wrote:
>> Hi All,
>>
>> All of my test machines hit the backtrace below with Linus' tree as of
>> this morning.  Any ideas?
>
> It looks like you are seeing the same as below:
>
>  * https://lkml.org/lkml/2015/8/31/440

Indeed.  I'll keep an eye on that thread and see if another patch comes from it.

josh

>
>> [  +0.160966] ===============================
>> [  +0.000001] [ INFO: suspicious RCU usage. ]
>> [  +0.000002] 4.3.0-0.rc0.git1.1.fc24.x86_64 #1 Not tainted
>> [  +0.000001] -------------------------------
>> [  +0.000002] security/device_cgroup.c:405 device_cgroup:verify_new_ex
>> called without proper synchronization!
>> [  +0.000000]
>>               other info that might help us debug this:
>>
>> [  +0.000001]
>>               rcu_scheduler_active = 1, debug_locks = 0
>> [  +0.000002] 4 locks held by systemd/1:
>> [  +0.000010]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff81267f87>]
>> vfs_write+0x187/0x1a0
>> [  +0.000006]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812f3996>]
>> kernfs_fop_write+0x66/0x190
>> [  +0.000005]  #2:  (s_active#61){++++.+}, at: [<ffffffff812f399e>]
>> kernfs_fop_write+0x6e/0x190
>> [  +0.000007]  #3:  (devcgroup_mutex){+.+...}, at:
>> [<ffffffff813ada3c>] devcgroup_access_write+0x3c/0x6e0
>> [  +0.000000]
>>               stack backtrace:
>> [  +0.000003] CPU: 3 PID: 1 Comm: systemd Not tainted
>> 4.3.0-0.rc0.git1.1.fc24.x86_64 #1
>> [  +0.000001] Hardware name:                  /D34010WYK, BIOS
>> WYLPT10H.86A.0026.2014.0514.1714 05/14/2014
>> [  +0.000004]  0000000000000000 000000006dc9945a ffff88040ce73c68
>> ffffffff8184e49c
>> [  +0.000003]  0000000000000000 ffff88040cdd4000 ffff88040ce73c98
>> ffffffff81101437
>> [  +0.000003]  ffff880408646d00 ffff88040ce73d00 0000000000000002
>> 0000000000000001
>> [  +0.000001] Call Trace:
>> [  +0.000006]  [<ffffffff8184e49c>] dump_stack+0x4c/0x65
>> [  +0.000004]  [<ffffffff81101437>] lockdep_rcu_suspicious+0xd7/0x110
>> [  +0.000004]  [<ffffffff813ad6e8>] verify_new_ex+0xd8/0xe0
>> [  +0.000003]  [<ffffffff813addaf>] devcgroup_access_write+0x3af/0x6e0
>> [  +0.000005]  [<ffffffff81023999>] ? sched_clock+0x9/0x10
>> [  +0.000004]  [<ffffffff811599e4>] cgroup_file_write+0x44/0x1e0
>> [  +0.000003]  [<ffffffff812f3a71>] kernfs_fop_write+0x141/0x190
>> [  +0.000002]  [<ffffffff81267497>] __vfs_write+0x37/0x100
>> [  +0.000002]  [<ffffffff81267f87>] ? vfs_write+0x187/0x1a0
>> [  +0.000004]  [<ffffffff8138929d>] ? security_file_permission+0x3d/0xc0
>> [  +0.000002]  [<ffffffff81267ea9>] vfs_write+0xa9/0x1a0
>> [  +0.000003]  [<ffffffff81268bc8>] SyS_write+0x58/0xd0
>> [  +0.000004]  [<ffffffff818580ee>] entry_SYSCALL_64_fastpath+0x12/0x76
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> paul moore
> www.paul-moore.com
