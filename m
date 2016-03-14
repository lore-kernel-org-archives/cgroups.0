From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: avoid false positive gcc-6 warning
Date: Tue, 15 Mar 2016 07:13:31 +0800
Message-ID: <201603150743.aoBp9zoQ%fengguang.wu@intel.com>
References: <1457994978-1057495-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457994978-1057495-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Arnd,

[auto build test WARNING on cgroup/for-next]
[also build test WARNING on v4.5 next-20160314]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/cgroup-avoid-false-positive-gcc-6-warning/20160315-063927
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> kernel/cgroup.c:262:9-10: WARNING: return of 0/1 in function 'cgroup_ssid_enabled' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
