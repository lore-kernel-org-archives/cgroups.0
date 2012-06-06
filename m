From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: make sure that decisions in __css_put are atomic
Date: Wed, 06 Jun 2012 15:31:19 +0800
Message-ID: <4FCF0747.7050000@huawei.com>
References: <20120605215019.4722.31817.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20120605215019.4722.31817.stgit-Oz2bD8w/QAX+Wsei8lUk51LMcqb5oVE02SarAXORi/o@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Salman Qazi wrote:

> __css_put is using atomic_dec on the ref count, and then
> looking at the ref count to make decisions.  This is prone
> to races, as someone else may decrement ref count between
> our decrement and our decision.  Instead, we should base our
> decisions on the value that we decremented the ref count to.
> 
> (This results in an actual race on Google's kernel which I
> haven't been able to reproduce on the upstream kernel.  Having
> said that, it's still incorrect by inspection).
> 
> Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Good catch! This patch should be backported for 3.4.

> ---
>  kernel/cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 0f3527d..18dc8aa 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4973,8 +4973,7 @@ void __css_put(struct cgroup_subsys_state *css)
>  	struct cgroup *cgrp = css->cgroup;
>  
>  	rcu_read_lock();
> -	atomic_dec(&css->refcnt);
> -	switch (css_refcnt(css)) {
> +	switch (atomic_dec_return(&css->refcnt)) {
>  	case 1:
>  		if (notify_on_release(cgrp)) {
>  			set_bit(CGRP_RELEASABLE, &cgrp->flags);
> 

