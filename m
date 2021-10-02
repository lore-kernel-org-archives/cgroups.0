From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 2/3] mm, memcg: Remove obsolete memcg_free_kmem()
Date: Fri, 1 Oct 2021 22:03:05 -0400
Message-ID: <b45fd235-a454-360e-4853-d41db3213e9d@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-3-longman@redhat.com>
 <YVehP18mCcsXmFy1@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633140188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xnJIUH5y7lwCwatGp+cWMPbIzQqOwL1mXDf/k3O/iEg=;
        b=VuBmQv+yPUVXNyStFdEJAfJf6lLl8glx2+6pOVcdC2HUFFQURqrILzZzlU1Ltb7W/xTN3v
        0EJTiYF3DjTcyvlnC6jv4WjcjjTNZYzhJJkW2P/RED3dFXmvU0hHTCe8vTYks4ziDEgUgX
        TspCAzrae1h2xQ1emAWE0u5qnA0SW2U=
In-Reply-To: <YVehP18mCcsXmFy1@carbon.dhcp.thefacebook.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>

On 10/1/21 8:01 PM, Roman Gushchin wrote:
> On Fri, Oct 01, 2021 at 03:09:37PM -0400, Waiman Long wrote:
>> Since commit d648bcc7fe65 ("mm: kmem: make memcg_kmem_enabled()
>> irreversible"), the only thing memcg_free_kmem() does is to call
>> memcg_offline_kmem() when the memcg is still online. However,
>> memcg_offline_kmem() is only called from mem_cgroup_css_free() which
>> cannot be reached if the memcg hasn't been offlined first.
> Hm, is it true? What if online_css() fails?
I just realize that memcg_online_kmem() is called at css_create(). So 
yes, if css_online() fails (i.e. ENOMEM), we will need to do 
memcg_offline_kmem().
>> As this
>> function now serves no purpose, we should just remove it.
> It looks like we can just use memcg_offline_kmem() instead of
> memcg_free_kmem().

Right, memcg_free_kmem() isn't the right name for that. I agree that we 
should just change mem_cgroup_css_free() to call memcg_offline_kmem() 
directly. Will update the patch accordingly.

Thanks,
Longman

