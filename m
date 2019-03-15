From: David Howells <dhowells@redhat.com>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 11:44:45 +0000
Message-ID: <3476.1552650285@warthog.procyon.org.uk>
References: <20190315074307.GA31430@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315074307.GA31430@light.dominikbrodowski.net>
Content-ID: <3475.1552650285.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> [    0.839322] RIP: 0010:sysfs_init_fs_context+0x82/0xd0

Could you load your kernel into gdb and then do:

	i li *sysfs_init_fs_context+0x82

David
