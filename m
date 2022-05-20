From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Fri, 20 May 2022 09:29:44 +0200
Message-ID: <YodDaFVeU33bu7yQ@dhcp22.suse.cz>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
 <87zgjcg4xs.fsf@vajain21.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653031785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2FXv1dgsYTKaim0NgoOrpNGccWSrMRNDM5AkhS49DWs=;
        b=ICaJn67v2gF2PbSdCTsQnIvjMmEX8BOujrOgBrm1IrKejCLRT2BWNVjYuxOqMjlOka2Nqz
        7wtGCPO6Sxp1pEmkwsIMETuaaY6rFSzNG87SEhJVlW39uk3W3fStPgzu7TcgzJ3GUInpR/
        zvEq7wTmasM4aS/PdC3GaIQxnkBiT+4=
Content-Disposition: inline
In-Reply-To: <87zgjcg4xs.fsf-+lRoeRASfQgA+286u2LMdEEOCMrvLtNR@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri 20-05-22 10:45:43, Vaibhav Jain wrote:
> 
> Thanks for looking into this patch Michal,
> 
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
> 
> > On Thu 19-05-22 04:08:15, Vaibhav Jain wrote:
> >> [1] Provides a way for user-space to trigger proactive reclaim by introducing
> >> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
> >> of pages scanned and reclaimed is still not directly available to the
> >> user-space.
> >> 
> >> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
> >> readable which returns the number of pages scanned / reclaimed during the
> >> reclaim process from 'struct vmpressure' associated with each memcg. This should
> >> let user-space asses how successful proactive reclaim triggered from memcg
> >> 'memory.reclaim' was ?
> >> 
> >> With the patch following command flow is expected:
> >> 
> >>  # echo "1M" > memory.reclaim
> >> 
> >>  # cat memory.reclaim
> >>    scanned 76
> >>    reclaimed 32
> >
> > Why cannot you use memory.stat? Sure it would require to iterate over
> > the reclaimed hierarchy but the information about scanned and reclaimed
> > pages as well as other potentially useful stats is there.
> 
> Agree that "memory.stat" is more suitable for scanned/reclaimed stats as
> it already is exposing bunch of other stats.
> 
> The discussion on this patch however seems to have split into two parts:
> 
> 1. Is it a good idea to expose nr_scanned/nr_reclaimed to users-space
> and if yes how ?
> 
> IMHO, I think it will be better to expose this info via 'memory.stat' as it
> can be useful insight into the reclaim efficiency  and vmpressure.

We already do that with some more metrics
pgrefill 9801926
pgscan 27329762
pgsteal 22715987
pgactivate 250691267
pgdeactivate 9521843
pglazyfree 0
pglazyfreed 0
 
> 2. Will it be useful to provide feedback to userspace when it writes to
> 'memory.reclaim' on how much memory has been reclaimed ?
> 
> IMHO, this will be a useful feeback to userspace to better adjust future
> proactive reclaim requests via 'memory.reclaim'

How precise this information should be? A very simplistic approach would
be
cp memory.stat stats.before
echo $WHATEVER > memory.reclaim
cp memory.stat stats.after

This will obviously contain also activity outside of the explicitly
triggered reclaim (racing background/direct reclaim) but isn't that what
actually matters? Are there any cases where the only metric you care
about is the triggered reclaim in isolation?

-- 
Michal Hocko
SUSE Labs
