From: Michal Hocko <mhocko@kernel.org>
Subject: Re: occasional kernel hang on shutdown - kernel/cgroup_pids.c
Date: Wed, 9 Dec 2015 14:22:53 +0100
Message-ID: <20151209132253.GB30912@dhcp22.suse.cz>
References: <20151207235352.GW15569@logic.at>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151207235352.GW15569@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>

[CCing Tejun]

Seems to be the same issue as reported here?
http://lkml.kernel.org/r/20151208145851.GJ9837@bark

On Tue 08-12-15 08:53:52, Norbert Preining wrote:
> Dear all
> 
> (please Cc)
> 
> running 4.4-rc4 (written as rc3+ but only the tag commit is missing),
> but I think also earlier in the rc releases, I occasionally see hangs
> on shutdown. Nothing works anymore, but this time at least there
> was some output on the console.
> 
> Manually copied from screen:
> 
> WARNING: CPU: 1 PID: 14 at kernel/cgroup_pids.c:97 pids_cancel.constrprop.8+0x2a
> Modules linked in: ....
> ...
> CPU: 1 PID: 14 Comm: ksoftirqd/1 Tainted: G O 4.4.0-rc3+
> Hardware name: Sony Corporation SVP1322A1J/VAIO, BIOS R2092V7 04/24/2015
> ...
> 
> Does that help in any way?
> 
> All the best
> 
> Norbert
> 
> (please Cc)
> 
> ------------------------------------------------------------------------
> PREINING, Norbert                               http://www.preining.info
> JAIST, Japan                                 TeX Live & Debian Developer
> GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
> ------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
