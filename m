From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Date: Wed, 7 Sep 2022 05:45:15 -1000
Message-ID: <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=2Bs5WeryLUwa4Em1EtgsOFsgucZrdl6s2s+rxtjCKv0=;
        b=GxZU/LPMUM2KaQzz22yGfVZ0We3v/2AvN6pejZw2UwV51PxFDYfmieeDwxAEIBEbCe
         FQ72oqE3rYDNlKuQBtdr6/CLx48G2JCzMLv/Sa0M9GDF54vR4yoAeJeHyrM7R86jGHa6
         2+w3e5Ntk8A04yteNqP3T/ta9icCvGnrcwvuI0UuKUcr2RGXcULYUEdOcHFphnDLPUsK
         GnbL5qo3awvEkIfiBOSJXiOfkERKwb9ES7IZLbTNMwFWimoAS1+h7t9SatGqjur9L5Ev
         GIDbpI9wn5g/vtaZeKua6lIh8BgDP+2yocrlNWS9DJ70hRjjf2vmPNSyNvV5Bnd9ld4g
         RMdg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yxi8I4fXXSCi6z9T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> ...
> > This patchset tries to resolve the above two issues by introducing a
> > selectable memcg to limit the bpf memory. Currently we only allow to
> > select its ancestor to avoid breaking the memcg hierarchy further. 
> > Possible use cases of the selectable memcg as follows,
> 
> As discussed in the following thread, there are clear downsides to an
> interface which requires the users to specify the cgroups directly.
> 
>  https://lkml.kernel.org/r/YwNold0GMOappUxc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org
> 
> So, I don't really think this is an interface we wanna go for. I was hoping
> to hear more from memcg folks in the above thread. Maybe ping them in that
> thread and continue there?

Ah, another thing. If the memcg accounting is breaking things right now, we
can easily introduce a memcg disable flag for bpf memory. That should help
alleviating the immediate breakage while we figure this out.

Thanks.

-- 
tejun
