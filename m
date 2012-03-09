From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Fri, 9 Mar 2012 13:20:16 +0900
Message-ID: <20120309132016.e372a2ef.kamezawa.hiroyu@jp.fujitsu.com>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com>
	<20120309124021.810f5267.kamezawa.hiroyu@jp.fujitsu.com>
	<4F598204.9030504@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F598204.9030504-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-2022-jp"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, 09 Mar 2012 12:07:32 +0800
Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 03/09/2012 11:40 AM, KAMEZAWA Hiroyuki wrote:
> > On Tue,  6 Mar 2012 20:13:24 +0800
> > Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
> >
> >> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>
> >> When the last event is unregistered, there is no need to keep the spare
> >> array anymore. So free it to avoid memory leak.
> >>
> >> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>
> >> ---
> >>   mm/memcontrol.c |    6 ++++++
> >>   1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 22d94f5..3c09a84 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
> >>   swap_buffers:
> >>   	/* Swap primary and spare array */
> >>   	thresholds->spare = thresholds->primary;
> >> +	/* If all events are unregistered, free the spare array */
> >> +	if (!new) {
> >> +		kfree(thresholds->spare);
> >> +		thresholds->spare = NULL;
> >> +	}
> >> +
> > Could you clear thresholds->primary ? I don't like a pointer points to freed memory.
> Do you meaning I should set ‘thresholds->primary = NULL‘ ？
> But the following rcu_assign_pointer will do this :
> 
> +	/* If all events are unregistered, free the spare array */
> +	if (!new) {
> +		kfree(thresholds->spare);
> +		thresholds->spare = NULL;
> +	}
> +
>   	rcu_assign_pointer(thresholds->primary, new);<---------*HERE*
> 

Hm, ok.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>


BTW, can memory cgroup be destroyed while there are registered events ?


