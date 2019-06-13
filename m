From: Joel Savitz <jsavitz@redhat.com>
Subject: Re: [PATCH v2] cpuset: restore sanity to cpuset_cpus_allowed_fallback()
Date: Thu, 13 Jun 2019 10:52:22 -0400
Message-ID: <CAL1p7m7T+ASfEd9dXEDg59XQEdp=eUE9fj5q-7hyEXat=_hL0A@mail.gmail.com>
References: <20190409204003.6428-1-jsavitz@redhat.com> <20190521143414.GJ5307@blackbody.suse.cz>
 <CAL1p7m6nfPkWoEEAjO+Gxq-ZiRY7+1jU_7dVcw2-hjC22xz-4A@mail.gmail.com>
 <20190528121036.GC31588@blackbody.suse.cz> <20190613120228.GA26668@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190613120228.GA26668@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Phil Auld <pauld@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

I just did a quick test on a patched kernel to check on that "no
longer affine to..." message:

# nproc
64

# taskset -p 4 $$
pid 2261's current affinity mask: ffffffffffffffff
pid 2261's new affinity mask: 4
# echo off > /sys/devices/system/cpu/cpu2/online
# taskset -p $$
pid 2261's current affinity mask: fffffffffffffffb
# echo on > /sys/devices/system/cpu/cpu2/online
# taskset -p $$
pid 2261's current affinity mask: ffffffffffffffff

# dmesg | tail -5
[  143.996375] process 2261 (bash) no longer affine to cpu2
[  143.996657] IRQ 114: no longer affine to CPU2
[  144.007472] IRQ 227: no longer affine to CPU2
[  144.013460] smpboot: CPU 2 is now offline
[  162.685519] smpboot: Booting Node 0 Processor 2 APIC 0x4

dmesg output is observably the same on patched and unpatched kernels
in this case.

The only difference in output is that on an unpatched kernel, the last
`taskset -p $$` outputs:
pid 2274's current affinity mask: fffffffffffffffb
Which is the behavior that this patch aims to modify

This case, which I believe is generalizable, demonstrates that we
retain the "no longer affine to..." output on a kernel with this
patch.

Best,
Joel Savitz



On Thu, Jun 13, 2019 at 8:02 AM Michal Koutný <mkoutny@suse.com> wrote:
>
> On Tue, May 28, 2019 at 02:10:37PM +0200, Michal Koutný  <MKoutny@suse.com> wrote:
> > Although, on v1 we will lose the "no longer affine to..." message
> > (which is what happens in your demo IIUC).
> FWIW, I was wrong, off by one 'state' transition. So the patch doesn't
> cause change in messaging (not tested though).
