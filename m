From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Wed, 4 Jul 2012 14:19:15 +0800
Message-ID: <4FF3E063.5010604@huawei.com>
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com> <20120703225218.GF555@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120703225218.GF555-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 2012/7/4 6:52, Tejun Heo wrote:

> Hello,
> 
> Shyju, can you please test the following patch?
> 
> Sasha, can you please re-test your test case with this patch?  I don't
> think fa980ca87d "cgroup: superblock can't be released with active
> dentries" did anything useful.  cgroup always calls d_iput() and
> d_release() in succession from the same context.  It may just have
> stretched the timing a bit to hide the race.
> 
> Li, this patch reverts fa980ca87d and wraps dput() in css_dput_fn()
> with s_active refs.  Positive dentry ref means that we have active ref
> on sb, so wrapping the final dput() with extra s_active ref should
> avoid premature super destruction. 


> I think we're horridly broken for

> root cgroup tho - and it has been broken for very long time.  I think
> it's mostly hidden because most (all?) controllers short-circuit root
> cgroup.  Eh, well....
> 

Could you elaborate a bit on what's broken for root cgroup?
