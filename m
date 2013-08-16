From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Fri, 16 Aug 2013 12:09:50 -0400
Message-ID: <20130816160950.GH2505@htj.dyndns.org>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
 <20130815210937.GB10977@mtj.dyndns.org>
 <20130816152025.GC7878@redhat.com>
 <20130816154757.GG2505@htj.dyndns.org>
 <20130816160204.GE7878@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=g1lZgCoYEKk/eT/kkcEYt8p97ibWe1iNHf/1qlsoYq0=;
        b=YBRqlsl60zm+KvdhgM+4SGj365EHvk/UtwL4fkoyL0cvSF9dyPQAUa7YOoDjKWh06F
         23t3qFNY0YJOiixStU0nyZvGshqis+luKPpU1+ogiDZCRNyHSJJGTXwinXPbUuFnFzgH
         NYSIMYTBr4bscw89Fu7wf6CkxnhcdVOw0rmGs3QF6v49BAAK5AfxU7sA/HddYT8Gnlyy
         IxkXXMR+b5zGp4Mfqu50EeNTJJN3Uy6uBFJWhXU1PgOBndZ0sFu/8h5vaxltcXwM2yg8
         NjHuaP+YHjhe0xsFsCjFfN8HDygdoc5YW24TsM3fGCiwmFzMWrHHoBWS3VTu+Ie0GlqD
         pWog==
Content-Disposition: inline
In-Reply-To: <20130816160204.GE7878-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hello,

On Fri, Aug 16, 2013 at 12:02:04PM -0400, Aristeu Rozanski wrote:
> > Yeah, that's the correct behavior, if I'm not misunderstanding you,
> > but to be consistent we also need to allow creating rules which allow
> > devices which aren't allowed by ancestors.  It won't be applicable at
> > rule creation but may later become effective later on.
> 
> Oh, I see, it's just matter of allowing to set the desired set or rules
> locally even if they're not possible at the moment.

Yeah, otherwise, we'd get into situation where setting rules in place
isn't allowed but moving it out of hierarchy, setting it and then
moving it back would work, which doesn't make much sense.

> So, considering we drop in sane_behavior the allow + exceptions case,
> the interface in sane_behavior mode would look like:
> - policy: {allow_all,deny}
> 	writing either will clear the active aw
> - active_whitelist
> 	list of in effect rules, read only
> - whitelist
> 	list of locally set rules, read only
> - whitelist_add
> 	write only, adds rule to the local list and active lists
> - whitelist_remove
> 	write only, removes rule from the local and active lists
> 
> What you think?

Yeah, I think that should work although you might also need
active_policy and "effective" might be a better choice as prefix.
Kay, Lennart, what do you guys think?

Thanks.

-- 
tejun
