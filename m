From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Use after free with BFQ and cgroups
Date: Tue, 30 Nov 2021 06:22:13 -1000
Message-ID: <YaZPtZcdMKwhzzy/@slm.duckdns.org>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
 <YaUKCoK39FlZK9m5@slm.duckdns.org>
 <20211130115010.GF7174@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gnE15tK2SlVmlypqM3RW5c3jzy7f6IwXtXXTaXhAYrU=;
        b=QUqWIHsgW8VZgRjl3ETtFZ9h1EaF+0J0+neEaUQmeCLl/WG/zEHT2o0TojSLjWTgm6
         wWNyB+FcdsJkpN11UGV/6BYPY8MlWTk5eW/7KGXbfaGY6xZXH1GGs0AdgIK0Pph7n+6A
         wkjg8aPKIkvJuHx13tI24PzSDu6bJFEyYvGywNqjnLjaJ2xoRY5aOVJkNf6cgINKkxYU
         /W0i9lhNXLRfZuozHGKFSOEth7mfxsfRcpyCoU5zHc5DxfgEQaU5fi1TTS2vst5B15cm
         lO/gTkDgDar7T1Ilv2ZGa+m92HSVhDB7C7gLMgg65xm+/OdJrpvNd3Jg6DBus5VRG3VB
         1UPg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211130115010.GF7174-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fvogdt-l3A5Bk7waGM@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Nov 30, 2021 at 12:50:10PM +0100, Jan Kara wrote:
> The problem is bfq_queue associated with a task effectively holds a
> reference to the potentially dead cgroup and the reference can stay there
> until the task (that itself got reparented to the root cgroup) exits. So I
> think we need to reparent these bfq_queue structures as well to avoid
> holding cgroup in zombie state excessively long.

Ah, I see. Yeah, that's not great. Agree that it'd be better to reparent
(probably just punt to the root cgroup).

Thanks.

-- 
tejun
