From: David Strauss <david-WnlvKBBViykE1dmCBd9WyQ@public.gmane.org>
Subject: Linux 3.3+ and memory cgroup kernel panics
Date: Fri, 21 Dec 2012 18:44:23 -0800
Message-ID: <CAKz8sYXcY9kP=QPVAWdP4a-6Nuq-04yDJNuvBojDTfKbvj=x9A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidstrauss.net; s=google;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=D/AgIO5BTa+k2IyxqT9P31d+qhJWxBqzPh8J7gcyAdw=;
        b=az7ANq8FNqr6St9AacEyrNbbLZ0D2rY39Hey0uerrJaC/rym8QNIPgQIr9UCauzqCg
         VD337qvDsW6aidBH3VsWWYa3VefuUfoQl5Yfyv/oSeAksk9h6ppxbVUOHoF1axOgVUOL
         aNYjfgEwAi2V/WjYLUOsT71gXhlRVda2McbKk=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The kernel seemed to replace the cgroups memory "charging" mechanism
in 3.3 with a more efficient implementation [1], but we think it may
be broken under Xen virtualization and load. We do not see any issue
in Linux 3.2 and earlier.

We have documented panics for Fedora kernels 3.3.4-5.fc17.x86_64,
3.3.5-2.fc16.x86_64, and 3.6.10-2.fc16.x86_64 but *not* on Fedora
kernels 3.1.0-7.fc16.x86_64 or 3.2.6-3.fc16.x86_64.

Many of our services use MemoryLimit= and similar systemd options that
create a memory cgroup for the service. This correlates with kernel
panics under the following call path (full listing here [2]):

[20488075.457394]  [<ffffffff811825e7>] ? mem_cgroup_charge_statistics+0x17/0x60
[20488075.457403]  [<ffffffff81184ade>] __mem_cgroup_uncharge_common+0xfe/0x330
[20488075.457410]  [<ffffffff8100632d>] ? xen_pte_val+0x1d/0x40
[20488075.457417]  [<ffffffff81188457>] mem_cgroup_uncharge_page+0x37/0x40
[20488075.457424]  [<ffffffff8115e6d1>] page_remove_rmap+0xb1/0x140

It culminates in this failure:

[20488075.457183] kernel BUG at arch/x86/mm/fault.c:396!
[20488075.457189] invalid opcode: 0000 [#1] SMP

There are also reports of similar failures [3] unrelated to systemd
use and on non-Fedora kernels.

It appears to be an issue with re-attributing the charge for a page to
a different cgroup. Any ideas why we would be seeing this with Linux
3.3+? I can generally reproduce the issue (often minutes after
booting) on any heavily loaded machine in order to collect any
additional data to help troubleshooting.

[1] https://lwn.net/Articles/443241/
[2] https://gist.github.com/raw/70afc901a73e427a0a71
[3] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073238/comments/6

--
David Strauss
   | david-WnlvKBBViykE1dmCBd9WyQ@public.gmane.org
   | +1 512 577 5827 [mobile]
