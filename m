From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 2 Sep 2015 14:45:18 +0300
Message-ID: <20150902114518.GA1237@esperanza>
References: <20150828220158.GD11089@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150828220158.GD11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Aug 28, 2015 at 06:01:58PM -0400, Tejun Heo wrote:
> task_struct->memcg_oom is a sub-struct containing fields which are
> used for async memcg oom handling.  Most task_struct fields aren't
> packaged this way and it can lead to unnecessary alignment paddings.
> This patch flattens it.
> 
> * task.memcg_oom.memcg          -> task.memcg_in_oom
> * task.memcg_oom.gfp_mask	-> task.memcg_oom_gfp_mask
> * task.memcg_oom.order          -> task.memcg_oom_order
> * task.memcg_oom.may_oom        -> task.memcg_may_oom
> 
> In addition, task.memcg_may_oom is relocated to where other bitfields
> are which reduces the size of task_struct.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
