From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcontrol: protect the memory in cgroup from
 being oom killed
Date: Fri, 9 Dec 2022 13:27:15 +0100
Message-ID: <Y5Mpo+X/rtr2D8Jr@dhcp22.suse.cz>
References: <Y5HzfLB7lu4+BOu1@dhcp22.suse.cz>
 <114DF8F0-3E68-4F2B-8E35-0943EC2F51AE@didiglobal.com>
 <Y5LxAbOB2AYp42hi@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670588836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SceSQ4zWov1ruMmU/Cx4LOSHMhOduLnCnMnnkM+gdgY=;
        b=Y/jTuZgZkRwDo3u6JvpxWmxiCzQ7i4pV50tHTktLt3Lv9PdTcSOmis4LHFLFclwTIcdd0f
        kPaux3bQGkvZRGxRDTM/8fMPG716dlC2ra5uhmQXUryrL9B93z2EHqhu0OH/x35juMIVqe
        83doSlhUIabdsyiPq/nkMFbIId+D7rA=
Content-Disposition: inline
In-Reply-To: <Y5LxAbOB2AYp42hi@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: chengkaitao <pilgrimtao@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, "haolee.swjtu@gmail.com" <haolee.swjtu@gmail.com>, "yuzhao@google.com" <yuzhao@google.com>

On Fri 09-12-22 09:25:38, Michal Hocko wrote:
> On Fri 09-12-22 05:07:15, 程垲涛 Chengkaitao Cheng wrote:
[...]
> > Here is a simple example. In a docker container, users can divide all processes 
> > into two categories (important and normal), and put them in different cgroups. 
> > One cgroup's oom.protect is set to "max", the other is set to "0". In this way, 
> > important processes in the container can be protected.
> 
> That is effectivelly oom_score_adj = OOM_SCORE_ADJ_MIN - 1 to all

Sorry that should have been OOM_SCORE_ADJ_MIN + 1

-- 
Michal Hocko
SUSE Labs
