From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 27 Aug 2021 11:27:44 -1000
Message-ID: <YSlY0H/qeXQIGOfk@slm.duckdns.org>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com>
 <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
 <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpHtTbp15HJh/ptbaGOZzKJv8NxAlmEFpkpJjglISck=;
        b=qybuEzO+6JTEALszutJES4QgB8s8ZfxvsPEDS5dKp4GuFf2drQOyt8uKwBrHhGx0SB
         R2BhAabUOtNe2U7JJceKd9zQwXKD7u1IAh1cG1TJZWQubnZ2szfDc9B5qYYtMY1AhotR
         LtppI2dvm4dNOacvJ+26YW0fOTtVXYyPCHWMqH14BdgZ5nqo2hxSJcwQtQETZNdJbjJ3
         cFWbwlcSrehlJphrGoOcJo8eo48Mxjb7gMBrgZDDhqc76JodkK9PwijKZpqYLiN/wv7p
         b48QkJBv/n1wysZ/o2lbJ2CztKr3d9IwKbgbDPAL7t/2FzD3EN6zWkcVZHVLIdid9nEX
         6vIw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Fri, Aug 27, 2021 at 05:19:31PM -0400, Waiman Long wrote:
> Well, that is a valid point. The cpus may have been offlined when a
> partition is being created. I can certainly relent on this check in forming
> a partition. IOW, cpus_allowed can contain some or all offline cpus and a
> valid (some are online) or invalid (all are offline) partition can be
> formed. I can also allow an invalid child partition to be formed with an
> invalid parent partition. However, the cpu exclusivity rules will still
> apply.
> 
> Other than that, do you envision any other circumstances where we should
> allow an invalid partition to be formed?

Now that most restrictions are removed from configuration side, just go all
the way? Given that the user must check the status afterwards anyway, I
don't see technical or even usability reasons for leaving some pieces
behind. Going all the way would be easier to use too - bang in the target
config and read the resulting state to reliably find out why a partition
isn't valid, especially if we list *all* the reasons so that the user can
tell whether the configuration is as intended immediately.

Thanks.

-- 
tejun
