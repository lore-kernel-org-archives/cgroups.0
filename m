From: Norbert Preining <preining@logic.at>
Subject: Re: occasional kernel hang on shutdown - kernel/cgroup_pids.c
Date: Fri, 11 Dec 2015 17:43:43 +0900
Message-ID: <20151211084343.GO15569@logic.at>
References: <20151207235352.GW15569@logic.at>
 <20151209132253.GB30912@dhcp22.suse.cz>
 <20151209160907.GL30240@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151209160907.GL30240@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, cgroups mailinglist <cgroups@vger.kernel.org>

Hi Tejun,

> Patches just got merged into mainline.  Please let me know if the
> current git master doesn't fix the issue.

Seems to have worked - I don't see the kernel hangs anymore. What remains
are problems with DRI/DRM, but I will report separately.

Thanks a lot

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
