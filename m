From: Krzysztof Kolasa <kkolasa-T7i8u+qs0czVItvQsEIGlw@public.gmane.org>
Subject: TrueCrypt hangs when unmounting disk partition
Date: Thu, 2 Jul 2015 11:53:53 +0200
Message-ID: <55950A31.10902@winsoft.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Kernel next, this is the first bad commit ( after bisect ):

e4bc13adfd016fc1036838170288b5680d1a98b0

Merge branch 'for-4.2/writeback' of git://git.kernel.dk/linux-block

After the command to unmount, partition will be unmounted, truecrypt hangs

Krzysztof
