From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Date: Mon, 21 Sep 2020 11:42:57 +0100
Message-ID: <20200921104257.GA632859@chrisdown.name>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mzDmB01mMTFr74qOHeLrNegprGQDAJ8oYYgiRLXCsfc=;
        b=O11nMckorO8RMfFQjnz4Yfr97uv13nR1YIQqRQMKzLSmqJpsduBq1wuChdnYF707Mt
         f/+wj7eFGyW12GAkCjm1muhOnRzjr3f5wjz14zI1gA1i+jm88cGKWNawNgUyFfmCT2kU
         8fNAJ+9t7L+udORk1K93NKpZp7DBuwsh4+SiY=
Content-Disposition: inline
In-Reply-To: <20200921081200.GE12990@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: zangchunxin@bytedance.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, tj@kernel.org, lizefan@huawei.com, corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

Michal Hocko writes:
>On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
>> From: Chunxin Zang <zangchunxin@bytedance.com>
>>
>> In the cgroup v1, we have 'force_mepty' interface. This is very
>> useful for userspace to actively release memory. But the cgroup
>> v2 does not.
>>
>> This patch reuse cgroup v1's function, but have a new name for
>> the interface. Because I think 'drop_cache' may be is easier to
>> understand :)
>
>This should really explain a usecase. Global drop_caches is a terrible
>interface and it has caused many problems in the past. People have
>learned to use it as a remedy to any problem they might see and cause
>other problems without realizing that. This is the reason why we even
>log each attempt to drop caches.
>
>I would rather not repeat the same mistake on the memcg level unless
>there is a very strong reason for it.

I agree with Michal. We already have ways to do best-effort memory release on 
cgroup v2, primarily with memory.high. Singling out a category of memory for 
reclaim has historically proved to be a fool's errand.
