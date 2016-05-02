From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/2] cgroup: apply common ancestor cgroup.procs
 restriction in cgroupv1
Date: Mon, 2 May 2016 12:03:32 -0400
Message-ID: <20160502160332.GQ7822@mtj.duckdns.org>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-2-git-send-email-asarai@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wy/K9S3CUn0bsFY227CIX3HOxmXDKPRh2KqcCPiksxk=;
        b=w0SAGmBjdjA6T+vnw5gfqL78MqmjZ3XknGrY0l4jRHWijAfF4S4ARvsnaic8ZiN+It
         1EryqLDnUX5GH29jm2yD1S7R86Es5w1hj84VT9PsXlGpmwI7lfEnuPferG9fh/NMvhUY
         oxY9BKXCzheo2XyG8L58lSZoJHmKX59gTwfq07+5RP0tugL0+o1/BIseRPWkBckhdLet
         0OSMTlEgPFpmYHD4bfBfPGuDW38n1J+DNC5ZlGq8vl4u0ASeT+jutOYv/Pxe2y+AUrwY
         qLI7qkSeZOSmcPfswUvWfPwJ1K9Ize2MrEiTDQcudoB3lvdzppxTdI7JXBbLXsOGyEOL
         IuHw==
Content-Disposition: inline
In-Reply-To: <1462197681-6879-2-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

On Tue, May 03, 2016 at 12:01:20AM +1000, Aleksa Sarai wrote:
> The common ancestor restriction for moving tasks between cgroups (the
> process moving the task must have the right to write to cgroup.procs in
> both the destination and common ancestor cgroup) only applied for
> cgroupv2 (cgroups in the default hierarchy). This meant that there was a
> different policy for unprivileged users in the different cgroup
> hierarchies.
> 
> Update cgroup_procs_write_permission() to apply the cgroup.procs
> restriction regardless of the cgroup root of the destination cgroup.
> However, if the task doesn't have any association with the destination
> hierarchy, there's no permission check to be done. In addition, if the
> destination cgroup is a descendant of the task's current cgroup then
> there are no further permission checks. This is important for
> unprivileged processes creating subtrees.

So, you can't apply a new restriction like this retro-actively to
cgroup v1 hierarchies.

Thanks.

-- 
tejun
