From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcontrol: protect the memory in cgroup from
 being oom killed
Date: Thu, 8 Dec 2022 08:33:07 +0100
Message-ID: <Y5GTM5HLhGrx9zFO@dhcp22.suse.cz>
References: <20221208034644.3077-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670484787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JXDfWNY3Qbfl8rtTtlddtnpeaKhAduAL7p+BYr8IZ2k=;
        b=nDYXvrFzHssNJikFT/o1HPTD29lvSXSarooGqRFa9kKWHGxdsciSmZFTpedjC7WMaWFBAN
        3NkUZ+LYtt1ZA3o52N+KGeToMqt34WShBl8hgNMKmGxggv5/v4inFygp7VUzQs8Nwgr4HB
        sOfiPaSwz3k+ByjhpMiDeFZADJ63wqo=
Content-Disposition: inline
In-Reply-To: <20221208034644.3077-1-chengkaitao@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengkaitao <pilgrimtao@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, songmuchun@bytedance.com, chengkaitao@didiglobal.com, viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@oracle.com, chengzhihao1@huawei.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu 08-12-22 11:46:44, chengkaitao wrote:
> From: chengkaitao <pilgrimtao@gmail.com>
> 
> We created a new interface <memory.oom.protect> for memory, If there is
> the OOM killer under parent memory cgroup, and the memory usage of a
> child cgroup is within its effective oom.protect boundary, the cgroup's
> tasks won't be OOM killed unless there is no unprotected tasks in other
> children cgroups. It draws on the logic of <memory.min/low> in the
> inheritance relationship.
> 
> It has the following advantages,
> 1. We have the ability to protect more important processes, when there
> is a memcg's OOM killer. The oom.protect only takes effect local memcg,
> and does not affect the OOM killer of the host.
> 2. Historically, we can often use oom_score_adj to control a group of
> processes, It requires that all processes in the cgroup must have a
> common parent processes, we have to set the common parent process's
> oom_score_adj, before it forks all children processes. So that it is
> very difficult to apply it in other situations. Now oom.protect has no
> such restrictions, we can protect a cgroup of processes more easily. The
> cgroup can keep some memory, even if the OOM killer has to be called.
> 
> Signed-off-by: chengkaitao <pilgrimtao@gmail.com>
> ---
> v2: Modify the formula of the process request memcg protection quota.

The new formula doesn't really address concerns expressed previously.
Please read my feedback carefully again and follow up with questions if
something is not clear.
-- 
Michal Hocko
SUSE Labs
