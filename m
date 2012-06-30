From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Sat, 30 Jun 2012 14:13:02 +0800
Message-ID: <4FEE98EE.1050409@huawei.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com> <4FED10DB.7040500@huawei.com> <20120629165809.GB21048@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120629165809.GB21048-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 2012/6/30 0:58, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> Hey,
> 
> On Fri, Jun 29, 2012 at 10:20:11AM +0800, Li Zefan wrote:
>>> Can you please elaborate a bit?  I'm not really following?  Where does
>>> the last root->d_count-- come from?
>>
>>
>> From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
>> to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
>> after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.
>>
>> So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
>> dentry is still > 0.
> 
> Heh, yeah, I thought you found who was holding out on the refcnt. :)
> 


dput will drop both the subdir and the root's dentry refcnt, but kill_sb will be called
inbetween.

So it's bad to have dentry refcnts dangling after umount. I've made a patch so css will
pin cgroup instead of cgroup dentry.
