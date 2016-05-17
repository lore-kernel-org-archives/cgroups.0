From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4 03/21] fs: Allow sysfs and cgroupfs to share super blocks between user namespaces
Date: Tue, 17 May 2016 17:39:33 -0500
Message-ID: <87shxgxqai.fsf@x220.int.ebiederm.org>
References: <1461699046-30485-1-git-send-email-seth.forshee@canonical.com>
	<1461699046-30485-4-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1461699046-30485-4-git-send-email-seth.forshee@canonical.com>
	(Seth Forshee's message of "Tue, 26 Apr 2016 14:30:26 -0500")
Sender: linux-bcache-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> Both of these filesystems already have use cases for mounting the
> same super block from multiple user namespaces. For sysfs this
> happens when using criu for snapshotting a container, where sysfs
> is mnounted in the containers network ns but the hosts user ns.
> The cgroup filesystem shares the same super block for all mounts
> of the same hierarchy regardless of the namespace.
>
> As a result, the restriction on mounting a super block from a
> single user namespace creates regressions for existing uses of
> these filesystems. For these specific filesystems this
> restriction isn't really necessary since the backing store is
> objects in kernel memory and thus the ids assigned from inodes
> is not subject to translation relative to s_user_ns.
>
> Add a new filesystem flag, FS_USERNS_SHARE_SB, which when set
> causes sget_userns() to skip the check of s_user_ns. Set this
> flag for the sysfs and cgroup filesystems to fix the
> regressions.

So this one needs to be sget_userns(..., &init_user_ns, ...).
And not a new special case.

Apologies for not catching this earlier.

I am looking at folding all of this into the patch that introduces
sget_userns so that even bisects won't have regresssions.

We loose the ability to call mount -o remount and actually affect
these filesystems (which we don't have without s_user_ns) but we gain a
whole lot of simplicity, and we don't break the xattr and security label
on sysfs code.

Eric
