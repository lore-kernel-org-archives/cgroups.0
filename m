From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcontrol: protect the memory in cgroup from
 being oom killed
Date: Mon, 19 Dec 2022 13:06:51 +0100
Message-ID: <Y6Atfc8ijws/A/f5@dhcp22.suse.cz>
References: <395B1998-38A9-4A68-96F8-6EDF44686231@didiglobal.com>
 <BE56B09A-7C70-4152-B4D4-B8433A37465D@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671451611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vcYyeovvyeIUt7S0vbCFAC7dHaOjTv+mzzbe5d276WA=;
        b=cKH6lPcm6qTERFkgfs95izoDW3LTVijdvzrmfJn690l+1owObw0m+Kz7Y06qsjOaD6EqbN
        1nQu1wgzRFe45utSi3lZdgUiSHYfJhsXYSCl4AiM7stbZoFRgU5YJjZf7vof2Pl0jVnVap
        3Cb7KuvdLUWZo1lmVQy5c4TDx9dQfMk=
Content-Disposition: inline
In-Reply-To: <BE56B09A-7C70-4152-B4D4-B8433A37465D@didiglobal.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>
Cc: chengkaitao <pilgrimtao@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, "haolee.swjtu@gmail.com" <haolee.swjtu@gmail.com>, "yuzhao@google.com" <yuzhao@google.com>

On Mon 19-12-22 03:16:33, 程垲涛 Chengkaitao Cheng wrote:
> Hi Michal Hocko,
> Looking forward to your reply.

I am sorry, I do not have anything to add to my previous concerns. But
let me summarize. I think your way of mixing per memcg protection with
the per-process oom_score is very dubious. This is not an unfixable
problem. All you need to do is the discount all processes in the same
memcg equally. A bigger problem is, though, that I am not convinced the
memory protection based interface is really viable. Based on experiences
with the existing reclaim protection interface this is not really
trivial interface to use. You either have to have a good overview of the
working set size or you have to auto-tune it based on a feedback
mechanism (e.g. PSI). Auto-tuning based on oom which should be a
rare event is rather problematic I would say.

All that being said I am not convinced that the interface is practically
usable and you haven't really provided good examples to prove me wrong.
-- 
Michal Hocko
SUSE Labs
