From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: always put cset in cgroup_css_set_put_fork
Date: Tue, 23 May 2023 11:58:35 +0200
Message-ID: <20230523-aphorismen-erzwingen-ae57f4fd33f2@brauner>
References: <20230521192953.229715-1-jsperbeck@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684835920;
        bh=tC/uWnb4vQv4X17V3g3ZMLWyWgfw32VJp0SADGWiBNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=do66W86rFkN3BQI1XPoprnXAQHmdGnIbxZvhY+YezuN0GoRrzGsoGbtynVrtSBxm7
         eWZaGniVXJdqt3Q37uFc89xhtbdRmsME+y4CvVIBaCSqbQnI+Hqk/ZTHq8vBuY+eiY
         G1eulwBQbYKOp7ZxV/7qzY2dTd7l17xod7WjEMZYqXKi7mFAUNFpnN/EKtgwoykWOM
         2saLgTyannYGaVal4xoDmSclmiZLZyc8RW6Qvp+xgMMUH7aWmoSmtdVfR4q09LRqzd
         aVP8Enusnvu/YLWUitwcrCA+c4Zug52dSCEWKenTOTUCArUFT65L574ZbFHxOaIpLq
         4iiKAUyLma5AQ==
Content-Disposition: inline
In-Reply-To: <20230521192953.229715-1-jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, May 21, 2023 at 07:29:53PM +0000, John Sperbeck wrote:
> A successful call to cgroup_css_set_fork() will always have taken
> a ref on kargs->cset (regardless of CLONE_INTO_CGROUP), so always
> do a corresponding put in cgroup_css_set_put_fork().
> 
> Without this, a cset and its contained css structures will be
> leaked for some fork failures.  The following script reproduces
> the leak for a fork failure due to exceeding pids.max in the
> pids controller.  A similar thing can happen if we jump to the
> bad_fork_cancel_cgroup label in copy_process().
> 
> [ -z "$1" ] && echo "Usage $0 pids-root" && exit 1
> PID_ROOT=$1
> CGROUP=$PID_ROOT/foo
> 
> [ -e $CGROUP ] && rmdir -f $CGROUP
> mkdir $CGROUP
> echo 5 > $CGROUP/pids.max
> echo $$ > $CGROUP/cgroup.procs
> 
> fork_bomb()
> {
> 	set -e
> 	for i in $(seq 10); do
> 		/bin/sleep 3600 &
> 	done
> }
> 
> (fork_bomb) &
> wait
> echo $$ > $PID_ROOT/cgroup.procs
> kill $(cat $CGROUP/cgroup.procs)
> rmdir $CGROUP
> 
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Signed-off-by: John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

Reviewed-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
