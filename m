From: David Rientjes <rientjes@google.com>
Subject: Re: [v6 3/4] mm, oom: introduce oom_priority for memory cgroups
Date: Mon, 28 Aug 2017 13:54:20 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708281353080.9719@chino.kir.corp.google.com>
References: <20170823165201.24086-1-guro@fb.com> <20170823165201.24086-4-guro@fb.com> <20170824121054.GI5943@dhcp22.suse.cz> <20170824125113.GB15916@castle.DHCP.thefacebook.com> <20170824134859.GO5943@dhcp22.suse.cz>
 <20170824141108.GB21167@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=eRZeMWvgdlGguLDp7qYS2ekdcxpw5VvmwxwGxP2us0s=;
        b=utbMIGj0WjmlWlA4YypZzzID/78fjadL0baCu6qfcpFCIvVkjBVrAzPRcu1UPDEQdf
         eFnz6oGd7Jg2Mb/lh7eUytLl0q8+KorbXVjxE76aHJmbkxHY5u5wruNB/NZLJv3atdf3
         HOR5+FN3Y+hge1Ryt2rJraVejBjdiNFAhFi9tC6lZ28Zq1mHCUa+Zp+sSo5SgTSoDzvj
         aVXeudnv8GhukCyHaD89tBj50QCgcn8znQ5PNeySnZ8X5K5Fl9FqeTrkfellp9bu4iig
         COoOoeg5m/hIsz0FA7an/5D5g48GjTg/34rQRPdZFYurjVB4990qD6GaMECbq3Ter+8h
         myZA==
In-Reply-To: <20170824141108.GB21167@castle.DHCP.thefacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 24 Aug 2017, Roman Gushchin wrote:

> > > Do you have an example, which can't be effectively handled by an approach
> > > I'm suggesting?
> > 
> > No, I do not have any which would be _explicitly_ requested but I do
> > envision new requirements will emerge. The most probable one would be
> > kill the youngest container because that would imply the least amount of
> > work wasted.
> 
> I agree, this a nice feature. It can be implemented in userspace
> by setting oom_priority.
> 

Yes, the "kill the newest memory cgroup as a tiebreak" is not strictly 
required in the kernel and no cgroup should depend on this implementation 
detail to avoid being killed if it shares the same memory.oom_priority as 
another cgroup.  As you mention, it can be effectively implemented by 
userspace itself.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
