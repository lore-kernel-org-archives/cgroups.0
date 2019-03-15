From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 12:50:02 +0100
Message-ID: <20190315115002.GA9055@light.dominikbrodowski.net>
References: <20190315074307.GA31430@light.dominikbrodowski.net>
 <3476.1552650285@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3476.1552650285@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

On Fri, Mar 15, 2019 at 11:44:45AM +0000, David Howells wrote:
> Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> 
> > [    0.839322] RIP: 0010:sysfs_init_fs_context+0x82/0xd0
> 
> Could you load your kernel into gdb and then do:
> 
> 	i li *sysfs_init_fs_context+0x82

Doesn't seem necessary as per my mail to Al a few seconds ago:
kobj_ns_grab_current(KOBJ_NS_TYPE_NET) returns NULL, so

        fc->user_ns = get_user_ns(netns->user_ns);

will try to dereference a null pointer.

Thanks,
	Dominik

