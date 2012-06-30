From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Sat, 30 Jun 2012 00:04:36 -0700
Message-ID: <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
	<20120627182903.GP15811@google.com>
	<4FEBF4B7.2070105@huawei.com>
	<20120628180712.GC22641@google.com>
	<4FED10DB.7040500@huawei.com>
	<20120629165809.GB21048@google.com>
	<4FEE98EE.1050409@huawei.com>
	<20120630064724.GC14083@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=SRmbq6W29ly4p6F/8+P6xc2dgnIc6Lf3e7kh2iOS0xM=;
        b=SAHx8S3qfGcYeeDAuyBm1wq3YwCbxMTZ2o4tP6efdk0ZkISXrusSXC0qDYMD6WOIrI
         cptEW9qrUf0eOhu8/jJ+uiRwRik0yeRuKhKQj/BjkF1iyUrYnK/G467XPkyO0ff0cCDQ
         VfPu4SrszTfKkuVANLbRYbjTzPYymJc5Yt9F5wIzvwnRqrr3T2OYvSLpawJex+w8Gw9O
         ikxkfJCV/BYu6W1hLUvTq3GFD/X9+FV6Gp/Opc8WC/3V5puOp8G3S9YhEnqGJywTBgdP
         Ln7xc1TAJo+bhaHag8vc+U0mEOSGicWTZehz3KggRKpOkqpRKsnJNSE0N4FrVT4fRHWZ
         FoSQ==
In-Reply-To: <20120630064724.GC14083-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Al.

On Fri, Jun 29, 2012 at 11:47 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wro=
te:
> On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:
>> So it's bad to have dentry refcnts dangling after umount.
>
> No shit. =A0Yes, it is bad. =A0What on the Earth is cgroup code doing=
 with
> those? =A0And what could it possibly want to do with dentry reference
> after the filesystem has been shut down, assuming it could hold one
> in the first place?

cgroup interface code was copied from sysfs back when it was
piggybacking internal data structures to dentries, so, unfortunately,
sysfs is still using dentries to manage internal data structures and
propagates internal refs to dentry refs. There seem to be several
places where dentry ref is held w/o active super ref triggering BUG on
umount. Longer term, it should be updated to share sysfs code, I
guess.

Thanks.

--=20
tejun
