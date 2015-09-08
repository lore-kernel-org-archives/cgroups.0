From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 8 Sep 2015 13:00:51 -0400
Message-ID: <20150908170051.GH13749@mtj.duckdns.org>
References: <20150828220158.GD11089@htj.dyndns.org>
 <20150828220237.GE11089@htj.dyndns.org>
 <20150904210011.GH25329@mtj.duckdns.org>
 <20150907113822.GB31800@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w2fMBw0C6q4oRd0pDclVxf5PdyHcB7bM8r0chWb/M+0=;
        b=ixuaTSeEZHPT51zVUifH6wCtZ520qx8baj0izKbBe5hbPVHs8e6BALk1wOv2FzVvj4
         F8N+MxlIefzQfRtLMZfmccMmh+g9bXlkPjP3aS4M6wx2rTI1Bkqh678GgaSOyQWAm17k
         Gt/kMvtS3eGpXsbALA+hLidY6kIuTBWt393JMmnKeAyBVAzhxaJ/iq3wRtUFvxfJwXjb
         jZ1Fwa2ipV1vYnD5rx/vCf58TArSPAf1Po85Ji5UOUEjJDcj1BSlVDHJPa4tIa84lRvR
         P88LjNscUKX0THvs8u8J9QtC4g2GxCF/bfTtbI4weSbivxQYk3Q7YHaHKpPN6ZFaeAWG
         F0YA==
Content-Disposition: inline
In-Reply-To: <20150907113822.GB31800@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Vladimir.

On Mon, Sep 07, 2015 at 02:38:22PM +0300, Vladimir Davydov wrote:
> > As long as kernel doesn't have a run-away allocation spree, this
> > should provide enough protection while making kmemcg behave more
> > consistently.
> 
> Another good thing about such an approach is that it copes with prio
> inversion. Currently, a task with small memory.high might issue
> memory.high reclaim on kmem charge with a bunch of various locks held.
> If a task with a big value of memory.high needs any of these locks,
> it'll have to wait until the low prio task finishes reclaim and releases
> the locks. By handing over reclaim to task_work whenever possible we
> might avoid this issue and improve overall performance.

Indeed, will update the patch accordingly.

Thanks.

-- 
tejun
