From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 4/8] cgroup: Remove CGROUP_BUILTIN_SUBSYS_COUNT
Date: Tue, 11 Sep 2012 13:41:55 -0700
Message-ID: <20120911204155.GY7677@google.com>
References: <1347380774-9546-1-git-send-email-wagi@monom.org>
 <1347380774-9546-5-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iaMhqpEEHd+WhHgxZvZ+nF+VCGtou6HbE0LWZXkJu+8=;
        b=KD321ZaHCcmIaP4xGtPebQW25i+x+xp27o1fPNos2Qrm+GdMADqWxtVLLYX6HTta2n
         OIhXUy9bTORGP0j34cCLj1fkuz87C/FtyHimU1Xzxa1jLzUHHEN34D058biuTUXXqZID
         tHj6gMVxUsXadLI2UOR1LsiAWc26t+42QOAg5xa1D682o9Zw0osX4CcsIDMsQo4Y8Uor
         GqGWU/b9mTCVDoX6ZI4jITH4XDVxt7H2JjCZtBUGv3XTZezbdFe6uI/HYEyack2u0Xhs
         5/9WZtv/Rex0rMAue/226rZmtsRZNTyTmlMMvzYaw8OnBQRQwXn3GdPLIo1gRuiEYV/h
         keow==
Content-Disposition: inline
In-Reply-To: <1347380774-9546-5-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Hello, Daniel.

Just one nit.

On Tue, Sep 11, 2012 at 06:26:10PM +0200, Daniel Wagner wrote:
> @@ -4502,10 +4507,13 @@ int __init cgroup_init_early(void)
>  	for (i = 0; i < CSS_SET_TABLE_SIZE; i++)
>  		INIT_HLIST_HEAD(&css_set_table[i]);
>  
> -	/* at bootup time, we don't worry about modular subsystems */
> -	for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  		struct cgroup_subsys *ss = subsys[i];
>  
> +		/* at bootup time, we don't worry about modular subsystems */
> +		if (!ss || (ss && ss->module))
> +			continue;
> +

The middle "ss" test is unnecessary.  Control never gets there if
NULL.

> @@ -4538,9 +4546,12 @@ int __init cgroup_init(void)
>  	if (err)
>  		return err;
>  
> -	/* at bootup time, we don't worry about modular subsystems */
> -	for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  		struct cgroup_subsys *ss = subsys[i];
> +
> +		/* at bootup time, we don't worry about modular subsystems */
> +		if (!ss || (ss && ss->module))
> +			continue;

Ditto.

> @@ -4735,13 +4746,16 @@ void cgroup_fork_callbacks(struct task_struct *child)
>  {
>  	if (need_forkexit_callback) {
>  		int i;
> -		/*
> -		 * forkexit callbacks are only supported for builtin
> -		 * subsystems, and the builtin section of the subsys array is
> -		 * immutable, so we don't need to lock the subsys array here.
> -		 */
> -		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  			struct cgroup_subsys *ss = subsys[i];
> +
> +			/*
> +			 * forkexit callbacks are only supported for
> +			 * builtin subsystems.
> +			 */
> +			if (!ss || (ss && ss->module))
> +				continue;
> +

Ditto.

> @@ -4846,12 +4860,13 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  	tsk->cgroups = &init_css_set;
>  
>  	if (run_callbacks && need_forkexit_callback) {
> -		/*
> -		 * modular subsystems can't use callbacks, so no need to lock
> -		 * the subsys array
> -		 */
> -		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  			struct cgroup_subsys *ss = subsys[i];
> +
> +			/* modular subsystems can't use callbacks */
> +			if (!ss || (ss && ss->module))
> +				continue;
> +

Ditto.

> @@ -5037,13 +5052,17 @@ static int __init cgroup_disable(char *str)
>  	while ((token = strsep(&str, ",")) != NULL) {
>  		if (!*token)
>  			continue;
> -		/*
> -		 * cgroup_disable, being at boot time, can't know about module
> -		 * subsystems, so we don't worry about them.
> -		 */
> -		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  			struct cgroup_subsys *ss = subsys[i];
>  
> +			/*
> +			 * cgroup_disable, being at boot time, can't
> +			 * know about module subsystems, so we don't
> +			 * worry about them.
> +			 */
> +			if (!ss || (ss && ss->module))
> +				continue;
> +

Ditto.

Other than that,

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
