From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: always put cset in cgroup_css_set_put_fork
Date: Mon, 22 May 2023 14:57:43 -1000
Message-ID: <ZGwPhzm_Eh2Bx-5v@slm.duckdns.org>
References: <20230521192953.229715-1-jsperbeck@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684803466; x=1687395466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1yeqEL2YFpMCthAHwog2p9ezUJQgAe4nd/8yOnzMLc=;
        b=mKHau8NZ3Yfh1+Dl1mZTJ3fMqlAxuzxBvZBEcbcRmB+4MXlsrHFZxRkkSVizIiOk+2
         884tLTyi8cz3TFoBQOYDx7LyT1Cin+4VQSM6mebUsRyzPQS4/tEnm8ETaOu1a+rTHKQG
         ccvvmWNKW7FBJCpZ9ltt4n3kl+5lhEm9qSDVme3umGX9Q95ekxoN7PKRosfVZCtaUbK8
         EADZsG7lRqZ1ykzwADZT6gC6+1A8Db6ayB3WAhGTmtMT5bCPoXCwIaMpaMYCAgOr6GSP
         ormBpu2Wmxp4YXUXlpkjeheAy3sVKuF1wQrdwl+9iSYF5fVOrj6Lz5/nZ4TBuY5TjgPO
         td7w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230521192953.229715-1-jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Applied to cgroup/for-6.4-fixes w/ stable cc'd.

Thanks.

-- 
tejun
