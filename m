From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v9 3/7] cgroup/cpuset: Refining features and constraints
 of a partition
Date: Thu, 16 Dec 2021 10:28:37 +0100
Message-ID: <20211216092837.GB46450@blackbody.suse.cz>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-4-longman@redhat.com>
 <20211215144944.GE16798@blackbody.suse.cz>
 <98887e63-51de-f5ad-8fb8-56269aaf4bcf@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639646918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fGxktS/Uc4QdkNKSXK/IVadOzTG1ebMs/QUmVV6nIcE=;
        b=Eh2Wx8s9jDwfC6jxKZuaZRo24mG2IrIk9796h9H2/iwEim4E06TJFI8j6yq9/wyc9rjpJo
        396WeJCIzR7D9qq7Fr4tJgnwzwqPCQ6m9OgWHc/zxKAv52j9ARDUZxGkKQjCS636XLM66F
        Tp76ek5AjK/Gkf8uXf/sx+eEV3Povs0=
Content-Disposition: inline
In-Reply-To: <98887e63-51de-f5ad-8fb8-56269aaf4bcf@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On Wed, Dec 15, 2021 at 11:29:41AM -0500, Waiman Long <longman@redhat.com> wrote:
> There are additional checks for the member to partition transition which
> requires that the target cpuset shouldn't have child cpuset.

Ah, I forgot the transition condition no. 4 will apply here. Clear.

So, currently full bottom up + top down walk is needed in (rare?) case
the switch from root partition to member and back.

> That prevents the recovering of a invalid partition root under a
> member cpuset. We could certainly remove that restriction by adding
> additional code as well as additional tests to verify it works. I
> haven't done that simply to avoid adding more complexity to the
> current code.

I agree this restriction can be lifted later independently when the rest
settles.  (It's not so different from controllers disabling on the
unified hierarchy after all.)


Thanks,
Michal

