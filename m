From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Make cpuset_fork() handle
 CLONE_INTO_CGROUP properly
Date: Mon, 3 Apr 2023 13:29:57 -0400
Message-ID: <44843f08-b7c2-42e3-1951-a0c5688190a1@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
 <20230331145045.2251683-2-longman@redhat.com>
 <20230403165523.aphsec2epqi72k27@blackpad>
 <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680543001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1X5SC7LKhlLocmRueF17WE70pwm2bzlUhxp0ZwVzj8=;
        b=IahjsRdFSyItRmLJ+vFswwH48B7vpptoj0v2Q4yXRtFNJrqUUXm/xGzOpvhh2pzP5HFXml
        yFisx8JWHfaeh74pGmp2bb3VZxdvK06BjODSjGRmxR1MlBLTkZLUI+esJDJmhRTgF55Sb3
        ZGcATKjEb6QI6kIjFO1rz/aXD7C457s=
Content-Language: en-US
In-Reply-To: <d9f0005c-6825-b2a0-eac3-fcbad6e32b2f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


On 4/3/23 13:18, Waiman Long wrote:
>
> On 4/3/23 12:55, Michal Koutný wrote:
>> On Fri, Mar 31, 2023 at 10:50:43AM -0400, Waiman Long 
>> <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> By default, the clone(2) syscall spawn a child process into the same
>>> cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
>>> introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
>>> into cgroups"), the child will be spawned into a different cgroup which
>>> is somewhat similar to writing the child's tid into "cgroup.threads".
>>>
>>> The current cpuset_fork() method does not properly handle the
>>> CLONE_INTO_CGROUP case where the cpuset of the child may be different
>>> from that of its parent.  Update the cpuset_fork() method to treat the
>>> CLONE_INTO_CGROUP case similar to cpuset_attach().
>> Should .can_fork=cpuset_can_fork in analogy to cpuset_can_attach be also
>> devised? (Sorry if I missed that in the previous discussion.)
>
> I have thought about that too.
>
> However, the can_attach method checks only a couple of things:
>
> 1) PF_NO_SETAFFINITY flag - which won't be set in the case of fork() 
> as it is for kthread only.
> 2) DL bandwidth - Juri has a cpuset outstanding to modify the way this 
> check is being done. I want to wait until it is settled before 
> tackling this, if necessary.

BTW, even cloning without CLONE_INTO_CGROUP can be an issue WRT DL 
bandwidth. So I will let the scheduler folk figure out what to do with that.

Cheers,
Longman

