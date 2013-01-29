From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 4/6] memcg: replace cgroup_lock with memcg specific
 memcg_lock
Date: Tue, 29 Jan 2013 09:16:16 +0900
Message-ID: <510714D0.2030206@jp.fujitsu.com>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com> <1358862461-18046-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358862461-18046-5-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/01/22 22:47), Glauber Costa wrote:
> After the preparation work done in earlier patches, the cgroup_lock can
> be trivially replaced with a memcg-specific lock. This is an automatic
> translation in every site the values involved were queried.
> 
> The sites were values are written, however, used to be naturally called
> under cgroup_lock. This is the case for instance of the css_online
> callback. For those, we now need to explicitly add the memcg lock.
> 
> With this, all the calls to cgroup_lock outside cgroup core are gone.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

