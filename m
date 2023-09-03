From: "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: mainline build failure due to d1d4ff5d11a5 ("cgroup: put
 cgroup_tryget_css() inside CONFIG_CGROUP_SCHED")
Date: Sun, 3 Sep 2023 08:24:25 +0200
Message-ID: <1e546300-02e4-d861-b1f4-b1c73baea5a8@leemhuis.info>
References: <ZPMdTJ7zwrCkdMTu@debian>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US, de-DE
In-Reply-To: <ZPMdTJ7zwrCkdMTu@debian>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, regressions@lists.linux.dev

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 02.09.23 13:32, Sudip Mukherjee (Codethink) wrote:
> Hi All,
> 
> The latest mainline kernel branch fails to build mips sb1250_swarm_defconfig with
> the error:
> 
> kernel/cgroup/cgroup.c: In function 'cgroup_local_stat_show':
> kernel/cgroup/cgroup.c:3699:15: error: implicit declaration of function 'cgroup_tryget_css'; did you mean 'cgroup_tryget'? [-Werror=implicit-function-declaration]
>  3699 |         css = cgroup_tryget_css(cgrp, ss);
>       |               ^~~~~~~~~~~~~~~~~
>       |               cgroup_tryget
> kernel/cgroup/cgroup.c:3699:13: warning: assignment to 'struct cgroup_subsys_state *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>  3699 |         css = cgroup_tryget_css(cgrp, ss);
>       |             ^
> 
> 
> git bisect pointed to d1d4ff5d11a5 ("cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED").
> 
> Reverting the commit has fixed the build failure.
> 
> I will be happy to test any patch or provide any extra log if needed.
> 
> #regzbot introduced: d1d4ff5d11a5887a9c4cfc00294bc68ba03e7c16

#regzbot fix: 76be05d4fd6c91a3885298f1dc3efeef32846
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.




