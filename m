From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 16:33:27 +0800
Message-ID: <1fe17d13-4b63-93ab-e6b2-3c9d09da208e@bytedance.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
 <e444e0ca-a2ff-37f2-1f1a-032b9fd63235@bytedance.com>
 <ZC6DKM4LDOVgohpj@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680770012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGq/HKc5p+fcl8bqCho34sjFte/OlqchdCqQAXf81es=;
        b=Ee3AutziMDQ/oJmzOP3/Hymnbhk/Uy5Gy1BUXoVUuZmYeU/nyiZWcG2x3aWiTsPThI
         S7vFSb7eBMSpf6zEhOdh9io9ExkuAB7bmLFp2mYPb6AuMHKSeeAEfqLvuS0PYOHV5CXf
         wmfy3isyeLEUJURdjlzh2atawqt4HuXpPueZwxclZHJuFkBBhQMAgH4pDLj+F3yks5K1
         IKvzO7lo37kB80t7G82q/tTJ+etEbk7lacZMQepacriyPTRmDRcgpGwoxCIjWToAsCq2
         B05DldvPRu182tFJEmxH/M0mExfkZ6YK8cco1VZs+7/eJevseK7Mf0Hj+xh5cJ8zftCO
         O/wA==
Content-Language: en-US
In-Reply-To: <ZC6DKM4LDOVgohpj-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I see, then let's do this as you said.


On 2023/4/6 16:30, Michal Hocko wrote:
> 
> As I've said, I do not see any major concern having this behavior
> implicit, the behavior makes semantic sense and it is also much more
> likely that the selected oom victim will be a better choice than what we
> do currently. Especially on properly partitioned systems with large
> memory consumers in each partition (cpuset).
> 
> That being said, I would just not add any sysctl at this stage and
> rather document the decision. If we ever encounter usecase(s) which
> would regress based on this change we can introcuce the sysctl later.
> 
