From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 12:18:13 +0000
Message-ID: <20190315121813.GY2217@ZenIV.linux.org.uk>
References: <20190315074307.GA31430@light.dominikbrodowski.net>
 <3476.1552650285@warthog.procyon.org.uk>
 <20190315115002.GA9055@light.dominikbrodowski.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190315115002.GA9055@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

On Fri, Mar 15, 2019 at 12:50:02PM +0100, Dominik Brodowski wrote:
> On Fri, Mar 15, 2019 at 11:44:45AM +0000, David Howells wrote:
> > Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> > 
> > > [    0.839322] RIP: 0010:sysfs_init_fs_context+0x82/0xd0
> > 
> > Could you load your kernel into gdb and then do:
> > 
> > 	i li *sysfs_init_fs_context+0x82
> 
> Doesn't seem necessary as per my mail to Al a few seconds ago:
> kobj_ns_grab_current(KOBJ_NS_TYPE_NET) returns NULL, so
> 
>         fc->user_ns = get_user_ns(netns->user_ns);
> 
> will try to dereference a null pointer.
> 
> Thanks,
> 	Dominik
> 

Charming...  It's netns being turned off, and the thing we'd missed
is that kobj_ns_current_may_mount() becomes constant true in that
setup.  IOW, ns_capable(..., CAP_SYS_ADMIN) is suppressed entirely
in that case (well, aside of what may_mount() has done in
do_mount/sys_fsmount).

So what we need is making that "change fc->user_ns" conditional
on netns != NULL, as in

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4cb21b558a85..1b56686ab178 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -71,9 +71,11 @@ static int sysfs_init_fs_context(struct fs_context *fc)
 	kfc->magic = SYSFS_MAGIC;
 	fc->fs_private = kfc;
 	fc->ops = &sysfs_fs_context_ops;
-	if (fc->user_ns)
-		put_user_ns(fc->user_ns);
-	fc->user_ns = get_user_ns(netns->user_ns);
+	if (netns) {
+		if (fc->user_ns)
+			put_user_ns(fc->user_ns);
+		fc->user_ns = get_user_ns(netns->user_ns);
+	}
 	fc->global = true;
 	return 0;
 }
