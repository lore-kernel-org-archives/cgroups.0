From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v4 03/21] fs: Allow sysfs and cgroupfs to share super blocks between user namespaces
Date: Wed, 18 May 2016 10:45:31 -0500
Message-ID: <8760ubs738.fsf@x220.int.ebiederm.org>
References: <1461699046-30485-1-git-send-email-seth.forshee@canonical.com>
	<1461699046-30485-4-git-send-email-seth.forshee@canonical.com>
	<87shxgxqai.fsf@x220.int.ebiederm.org>
	<20160517235834.GA104031@ubuntu-hedt>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160517235834.GA104031@ubuntu-hedt> (Seth Forshee's message of
	"Tue, 17 May 2016 18:58:34 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> writes:

> On Tue, May 17, 2016 at 05:39:33PM -0500, Eric W. Biederman wrote:
>> Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> writes:
>> 
>> > Both of these filesystems already have use cases for mounting the
>> > same super block from multiple user namespaces. For sysfs this
>> > happens when using criu for snapshotting a container, where sysfs
>> > is mnounted in the containers network ns but the hosts user ns.
>> > The cgroup filesystem shares the same super block for all mounts
>> > of the same hierarchy regardless of the namespace.
>> >
>> > As a result, the restriction on mounting a super block from a
>> > single user namespace creates regressions for existing uses of
>> > these filesystems. For these specific filesystems this
>> > restriction isn't really necessary since the backing store is
>> > objects in kernel memory and thus the ids assigned from inodes
>> > is not subject to translation relative to s_user_ns.
>> >
>> > Add a new filesystem flag, FS_USERNS_SHARE_SB, which when set
>> > causes sget_userns() to skip the check of s_user_ns. Set this
>> > flag for the sysfs and cgroup filesystems to fix the
>> > regressions.
>> 
>> So this one needs to be sget_userns(..., &init_user_ns, ...).
>> And not a new special case.
>
> This is actually what I wanted to do, but based on a previous discussion
> where I had suggested doing this (for a different reason) I came away
> thinking you did not want it that way. So I'm happy with that change.

Yeah.  Somedays it seems like there are a lot of pieces in play here.
The security labels on sysfs seems to be a very compelling case.

> But if we do that it violates some of the assumptions of the patch to
> rework MNT_NODEV on your testing branch (and also those behind patch 2
> in this series). Something will need to be changed there to prevent a
> regression in mount behavior when a user ns tries to mount without
> MNT_NODEV when the mount inherited from its parent has it set.

Thank you for pointing that out.  I will look into that.

I believe I know exactly what you are talking about.  Of the choices I
think it is better to a minor localized change in the fs_fully_visible
logic than it is to cause problems elsewhere.

>> Apologies for not catching this earlier.
>
> Actually this is a more recent patch, so you possibly hadn't seen it
> before.
>
>> I am looking at folding all of this into the patch that introduces
>> sget_userns so that even bisects won't have regresssions.
>
> That's fine with me.

And thank you for keeping everything as separate patches.  That is at
least helping me catch up.  Even if I don't agree that these things
should be separate come merge time.

Eric
