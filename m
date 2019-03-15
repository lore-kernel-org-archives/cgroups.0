From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 11:34:47 +0000
Message-ID: <20190315113447.GX2217@ZenIV.linux.org.uk>
References: <20190315074307.GA31430@light.dominikbrodowski.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190315074307.GA31430@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

On Fri, Mar 15, 2019 at 08:43:07AM +0100, Dominik Brodowski wrote:
> David, Al,
> 
> commit 23bf1b6be9c2 ("kernfs, sysfs, cgroup, intel_rdt: Support fs_context")
> seems to have introduced a bug; at least that's the commit I bisected the
> following oops down to:

> This occurs while trying to mount sysfs in initramfs
> 
> 	mount -n -t sysfs sysfs /sys
> 
> All this obviously runs in qemu; config and further information are available upon request.

.config, please?
