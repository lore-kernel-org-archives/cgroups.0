From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Mon, 5 Sep 2022 12:50:54 +0200
Message-ID: <YxXUjvWmZoG9vVNV@dhcp22.suse.cz>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
 <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662375055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jLtoVNiBT2iSspfGxmncgOVgViwjY/ew1M2VzEnJohU=;
        b=tuZx0thWhdDNLQb2iOtjt5nsAi8tSL9CQTYd6aMVNNn7Jqg9oia58Jq/f1/Sms2d4R34gW
        QbXNq3fv1IdAre7JAEgFELRSnd5gXYW7luDDTsw/ZANRbuHIjBY0zx6/uqDFGbNI7gKJ+O
        /yk03N/hMavkJrXpvO5kxs2pZgVdcUQ=
Content-Disposition: inline
In-Reply-To: <0e5f380b-9201-0f56-9144-ce8449491fc8-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Mon 05-09-22 18:30:55, Zhongkun He wrote:
> Hi Michal, thanks for your reply.
> 
> The current 'mempolicy' is hierarchically independent. The default value of
> the child is to inherit from the parent. The modification of the child
> policy will not be restricted by the parent.

This breaks cgroup fundamental property of hierarchical enforcement of
each property. And as such it is a no go.

> Of course, there are other options, such as the child's policy mode must be
> the same as the parent's. node can be the subset of parent's, but the
> interleave type will be complicated, that's why hierarchy independence is
> used. It would be better if you have other suggestions?

Honestly, I am not really sure cgroup cpusets is a great fit for this
usecase. It would be probably better to elaborate some more what are the
existing shortcomings and what you would like to achieve. Just stating
the syscall is a hard to use interface is not quite clear on its own.

Btw. have you noticed this question?

> > What is the hierarchical behavior of the policy? Say parent has a
> > stronger requirement (say bind) than a child (prefer)?
> > > How to use the mempolicy interface:
> > > 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
> > > 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
> > >          echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy
> > 
> > Am I just confused or did you really mean to combine all these
> > together?

-- 
Michal Hocko
SUSE Labs
