From: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Thu, 28 Jun 2012 23:09:43 +0900
Message-ID: <CALLJCT2_BWSm6NOJoBp8j+5zoEoa-B=predDpei8-6aGO36xng@mail.gmail.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
	<20120627182903.GP15811@google.com>
	<20120627230230.GT15811@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=SXiFJG76DBcvsq9K4+GC9y+AgxQpmdQmsgr+OzYL4tM=;
        b=pUVTtqMNh2rDp78a0Hzqh0kD4CV1gzlaTKJZRS/AIQJEeiBo7dVmG/D5hSrtkRq2iZ
         uupnWTdAW64xHo+6HJm6J55ATvWDKeBt/7wVx3TrnoCL+0i202B2YA3gaqxlprP5Sw1x
         u28rk4RZME6Sx4ehqehcu2AXiPlajTZtJCJHfMwVyKda52zRwDWgphf9kDHVah8t7mGK
         /kH919wAixgkFq3ua3sffDMNWFmWOA6MInDAKr9TcGpBSjOxnGu7sZG9I46RILCU8hVF
         8NIyOYrd78FpuZYqAVuCkw7oW6EQEisJT4thuRzzMtCwO1z82e8d7dgvnIcKhtE2BmCU
         ICLA==
In-Reply-To: <20120627230230.GT15811-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello

I have applied this patch on 3.5-rc4, and tested.
It didn't fix the symptom. :(

Masanari


On Thu, Jun 28, 2012 at 8:02 AM, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> Does the following patch make the problem go away?
>
> Thank you.
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2097684..f9556cf 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3644,6 +3644,7 @@ static void cgroup_event_remove(struct work_str=
uct *work)
> =A0 =A0 =A0 =A0eventfd_ctx_put(event->eventfd);
> =A0 =A0 =A0 =A0kfree(event);
> =A0 =A0 =A0 =A0dput(cgrp->dentry);
> + =A0 =A0 =A0 deactivate_super(cgrp->root->sb);
> =A0}
>
> =A0/*
> @@ -3770,6 +3771,7 @@ static int cgroup_write_event_control(struct cg=
roup *cgrp, struct cftype *cft,
> =A0 =A0 =A0 =A0 * destroying subsystem state objects. Let's take refe=
rence to cgroup
> =A0 =A0 =A0 =A0 * directory dentry to do that.
> =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 atomic_inc(&cgrp->root->sb->s_active);
> =A0 =A0 =A0 =A0dget(cgrp->dentry);
>
> =A0 =A0 =A0 =A0spin_lock(&cgrp->event_list_lock);
