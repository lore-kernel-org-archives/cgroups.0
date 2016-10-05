From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Add a allow_attach policy for Android
Date: Wed, 5 Oct 2016 12:10:56 -0700
Message-ID: <20161005191056.GB31873@dtor-ws>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <1475556090-6278-3-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n3fSGjXazFY6GzE/nFVzRBJzuYhGvferxIQxZ5ma21k=;
        b=zIa+FvG9eqvVyh/5yx6vKaEMAk4bNBWdRmv7Ba0yR8FfUQheJmSMk5/02Tx71HjSCF
         J/Fh8v5WYkraRXKRJ5kB2aw2v9Ran6Bkd7Pi17wshnbo7/jgunl15fOWCSAKMqr1CfJX
         kE9pmdmH/c0z93RpLsq6aG3kH3mmOSx202yE004IdAQeIY03IJ/mSptb+XtmoM+eIcEe
         Ow79ca9wmmQlFzK0N2phZTuV8RX0OdqQJWUCqrtt1AWIekaWwox+Ts9ODhWi3XekPLSW
         wNNaHGV9KNyi3YbFUkbGsyTTyc/7Hb2lUJsrY5BjVCON1XIXs1tUt9YVOOd1JPpi8Jsk
         QYcg==
Content-Disposition: inline
In-Reply-To: <1475556090-6278-3-git-send-email-john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Mon, Oct 03, 2016 at 09:41:30PM -0700, John Stultz wrote:
> +#ifdef CONFIG_CGROUP_NICE_ATTACH
> +int cgroup_nice_allow_attach(struct cgroup_taskset *tset)
> +{
> +	const struct cred *cred = current_cred(), *tcred;
> +	struct task_struct *task;
> +	struct cgroup_subsys_state *css;
> +
> +	if (capable(CAP_SYS_NICE))
> +		return 0;
> +
> +	cgroup_taskset_for_each(task, css, tset) {
> +		tcred = __task_cred(task);

__task_cred() requires RCU lock (courtesy Ricky Z).

> +
> +		if (current != task && !uid_eq(cred->euid, tcred->uid) &&
> +		    !uid_eq(cred->euid, tcred->suid))
> +			return -EACCES;
> +	}
> +
> +	return 0;
> +}
> +#endif

Thanks.

-- 
Dmitry
