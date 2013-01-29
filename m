From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 1/6] memcg: prevent changes to move_charge_at_immigrate
 during task attach
Date: Tue, 29 Jan 2013 09:11:03 +0900
Message-ID: <51071397.2080908@jp.fujitsu.com>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com> <1358862461-18046-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358862461-18046-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/01/22 22:47), Glauber Costa wrote:
> Currently, we rely on the cgroup_lock() to prevent changes to
> move_charge_at_immigrate during task migration. However, this is only
> needed because the current strategy keeps checking this value throughout
> the whole process. Since all we need is serialization, one needs only to
> guarantee that whatever decision we made in the beginning of a specific
> migration is respected throughout the process.
> 
> We can achieve this by just saving it in mc. By doing this, no kind of
> locking is needed.
> 
> [ v2: change flag name to avoid confusion ]
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

