From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup/cpuset: Allow only one active attach operation
 per cpuset
Date: Tue, 4 Apr 2023 10:12:48 -0400
Message-ID: <db9689cb-7d2b-8a76-06f4-271134dd1bfb@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-4-longman@redhat.com>
 <20230403164736.lpjdpzxxnjlpxrqv@blackpad>
 <24b67530-62ce-4f9c-7b74-d41d2ccc710e@redhat.com>
 <20230404090737.3g3uxga52bojgdu5@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680617575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHnav7rmFyKZwzKMs7eXEGCo+lHgh/MyPZc+xhNZR/U=;
        b=JCNXS+4l+0Ei1UeH67M6gWdNsxSw7u/YXFGrBymLVcx6ndZca13B89z3zzanKMWHu6feeP
        dj4xsWu6kmOTuGj0h2Pk1bL1WdKyxwyYSLwG1Pxsz/quVU2C13zcPN+OY5KG8Y5vM+aEzH
        P9OFvya3cMUeXciyqsEJaMF3sF3n5XU=
Content-Language: en-US
In-Reply-To: <20230404090737.3g3uxga52bojgdu5@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


On 4/4/23 05:07, Michal Koutn=C3=BD wrote:
> Hi.
>
> On Mon, Apr 03, 2023 at 01:41:33PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>> This patch is actually not related to the CLONE_INTO_GROUP problem in pa=
tch
>> 1. It is a generic problem when multiple users are moving threads into
>> cgroup.threads of the same or different cpusets simultaneously.
> I meant this:
> 	__cgroup_procs_write
> 	  cgroup_kn_lock_live
> 	    mutex_lock(&cgroup_mutex)
>
> and (more succintly)
> 	cgroup_update_dfl_csses
> 	  lockdep_assert_held(&cgroup_mutex)
>
> Even the threaded migrations should be synchronized here.
> Can you please explain in more detail what's the problematic case?

You are right. I missed the cgroup_mutex synchronization here. So this=20
patch isn't needed. I will drop it in the next version.

Cheers,
Longman

