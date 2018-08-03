From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Subject: Re: [PATCH v1] mm:memcg: skip memcg of current in mem_cgroup_soft_limit_reclaim
Date: Fri, 3 Aug 2018 14:11:26 +0800
Message-ID: <CAGWkznE_Z+eJ+81eZN_KT7KXSFyCxfoafeMFSzirT7OaL+vbRA@mail.gmail.com>
References: <1533275285-12387-1-git-send-email-zhaoyang.huang@spreadtrum.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=no/jOIE21X8Xkokb0gVPzfOsDFcu8RUDjm0Ga7io9Zk=;
        b=CXhm0CljIHNp3DHVN0JP+B2UimdHHtw/jxqq6WT1GXwlwjXTxQRQoK5QsiS+zP2zCE
         WsA+6Qlj/b0EuJ+5sNwP4pZHrmxO8kwrXW07P7W7e8zdEVRFg7xnTDPUoDR22jUwDDJS
         vDgKSkjh+oZ+U/NHBuWzzGv12dEoYC/d9Zat4NAis7koJxXvWQdxz5XiglaoVihZ0bOV
         RV/mUOKKEnokQQ4zkpZpUA7fnmFbMe36LRqZ+jOm1+FXi9cIsDwK0afnUD/9txSTR3K9
         nmHgPrZGITSTAtRGvKF9N6S+xgTZa6q/WkpmpVJ5QrGDy0YGtoNOaGgo7NZK7F30nduO
         vPAw==
In-Reply-To: <1533275285-12387-1-git-send-email-zhaoyang.huang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-patch-test@lists.linaro.org

On Fri, Aug 3, 2018 at 1:48 PM Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:
>
> for the soft_limit reclaim has more directivity than global reclaim, we40960
> have current memcg be skipped to avoid potential page thrashing.
>
The patch is tested in our android system with 2GB ram.  The case
mainly focus on the smooth slide of pictures on a gallery, which used
to stall on the direct reclaim for over several hundred
millionseconds. By further debugging, we find that the direct reclaim
spend most of time to reclaim pages on its own with softlimit set to
40960KB. I add a ftrace event to verify that the patch can help
escaping such scenario. Furthermore, we also measured the major fault
of this process(by dumpsys of android). The result is the patch can
help to reduce 20% of the major fault during the test.

> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@spreadtrum.com>
> ---
>  mm/memcontrol.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8c0280b..9d09e95 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2537,12 +2537,21 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>                         mz = mem_cgroup_largest_soft_limit_node(mctz);
>                 if (!mz)
>                         break;
> -
> +               /*
> +                * skip current memcg to avoid page thrashing, for the
> +                * mem_cgroup_soft_reclaim has more directivity than
> +                * global reclaim.
> +                */
> +               if (get_mem_cgroup_from_mm(current->mm) == mz->memcg) {
> +                       reclaimed = 0;
> +                       goto next;
> +               }
>                 nr_scanned = 0;
>                 reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
>                                                     gfp_mask, &nr_scanned);
>                 nr_reclaimed += reclaimed;
>                 *total_scanned += nr_scanned;
> +next:
>                 spin_lock_irq(&mctz->lock);
>                 __mem_cgroup_remove_exceeded(mz, mctz);
>
> --
> 1.9.1
>
