From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fixed the cset refcnt leak when fork() failed
Date: Mon, 5 Jun 2023 22:32:40 -0400
Message-ID: <7cc82da3-04f6-55d4-6a0a-a88079de0e14@redhat.com>
References: <20230605130444.1421-1-zoucao@kuaishou.com>
 <ZH5V5S5InM6b1iK7@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686018770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aonkk/+CcrMShgRhSujmxagn3pRNh1VqOrcLFDrdbTU=;
        b=crBgY47RrRMP5/DmMlFlTjqvFGRGy0ktnOC0FsvsvYZTtm7Nj2jl3+1NSMqITgPfql/BGy
        nO3jocbbfS8Tt46uY/3rNlNmSmpcaCojAzduhluJQ17J9na2A5VOKlcL3ffrXiIWfV0KhY
        BYtzoXeUQP3ImtNpAZiGSSUYLrK5a6A=
Content-Language: en-US
In-Reply-To: <ZH5V5S5InM6b1iK7-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zou Cao <zoucaox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>


On 6/5/23 17:38, Tejun Heo wrote:
> On Mon, Jun 05, 2023 at 09:04:44PM +0800, Zou Cao wrote:
>> TeamID: B1486294
>>
>> when fork, cset will be increased by commit "ef2c41cf38a7", the refcnt will
>> be decrease by child exit, but when failed in fork(), this refcnt will
>> be lost decrease in cgroup_cancel_fork as follow:
>>
>> copy_process
>>       |
>> cgroup_can_fork    //  increase the css refcount
>>    ......
>>    spin_lock_irq(&css_set_lock);
>>    cset = task_css_setcurrent);
>>    get_css_set(cset);
>>    spin_unlock_irq&css_set_lock);
>>    ......
>>       |
>> goto cgroup_cancel_fork    // if failed in  copy_process
>>       |
>> cgroup_cancel_fork  // lost the decrease refcount if flag not CLONE_INTO_CGROUP
>>
>> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
>> Signed-off-by: Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
> Is this the same bug fixed by the following commit?
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/commit/?h=for-6.4-fixes&id=2bd110339288c18823dcace602b63b0d8627e520

I believe it is the same bug that this patch is trying to fix. I missed 
the part kargs->cset is cleared in cgroup_post_fork() so that the put 
can be done solely in cgroup_css_set_put_fork(). That is definitely the 
cleaner approach.

Cheers,
Longman

