From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes
 with CAP_SYS_RESOURCE
Date: Wed, 1 Mar 2023 10:47:34 +0100
Message-ID: <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
References: <20230301014651.1370939-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677664055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEKtKRNyGCTC82UqNy25qgA9yJtw4/FHNoYTpB8MPsE=;
        b=FWR/kfwDEEyMKMXV8Gye36g2Sj6laW5ZfRc975dH6P4XVUiDv/Fp0FHeRZPoXF9hWKGd9v
        pJWJL3iNNvoRbcGInAFRztMuJVhweZ3mJaMZsXvZaJyvx9SBSBuiqzT7toNdLlZxODUvGB
        ZymHyxMMA3fQPYQmsUavp4kNAYHw4u8=
Content-Disposition: inline
In-Reply-To: <20230301014651.1370939-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-02-23 17:46:51, Suren Baghdasaryan wrote:
> Currently /proc/pressure/* files can be written only by processes with
> CAP_SYS_RESOURCE capability to prevent any unauthorized user from
> creating psi triggers. However no such limitation is required for
> per-cgroup pressure files. Fix this inconsistency by requiring the same
> capability for writing per-cgroup psi files.
> 
> Fixes: 6db12ee0456d ("psi: allow unprivileged users with CAP_SYS_RESOURCE to write psi files")

Is this really a regression from this commit? 6db12ee0456d is changing
permissions of those files to be world writeable with the
CAP_SYS_RESOURCE requirement. Permissions of cgroup files is not changed
and the default mode is 644 (with root as an owner) so only privileged
processes are allowed without any delegation.

I think you should instead construct this slightly differently. The
ultimate goal is to allow a reasonable delegation after all, no?

So keep your current patch and extend it by removing the min timeout
constrain and justify the change by the necessity of the granularity
tuning as reported by Sudarshan Rajagopala. If this causes any
regression then a revert would also return the min timeout constrain
back and we will have to think about a different approach.

The consistency with the global case is a valid point only partially
because different cgroups might have different owners which is not
usually the case for the global psi interface, right?

Makes sense?
-- 
Michal Hocko
SUSE Labs
